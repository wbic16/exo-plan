# SQ Multi-Tenant Hosting Plan - Backend Architecture for Verse

**Created**: 2026-02-09 22:32 CST  
**Owner**: Verse 🌀  
**Urgency**: STAT - Operational deployment required  
**Status**: Ready for implementation

## Architecture Overview

### Reverse Proxy Model

```
User Request
    ↓
Nginx/Caddy (Auth Layer)
    ├─ Verify JWT token
    ├─ Extract user ID from token
    ├─ Route to user's SQ instance
    └─ Proxy: localhost:XXXXX (user's port)
         ↓
    SQ Instance #1 (user_1) - Port 10001
    SQ Instance #2 (user_2) - Port 10002
    SQ Instance #N (user_N) - Port 1000N
```

**Key Points**:
- One SQ instance per user (isolated phext space)
- Dynamic port allocation (10001-19999 = 10K users)
- Reverse proxy authenticates and routes
- Each SQ instance manages 1 MB phext per user

## AWS Instance Capacity Analysis

### Current AWS Instance (phext.io)
**Assumption**: t3.medium or similar (typical Will configuration)

**Specs** (t3.medium):
- **CPU**: 2 vCPUs
- **RAM**: 4 GB (4,096 MB)
- **Disk**: 20-40 GB EBS (assumed)
- **Network**: Up to 5 Gbps

### Memory Breakdown Per User

#### SQ Process Memory (per instance)
- **Base process**: ~8 MB (Rust binary, runtime)
- **HTTP server**: ~2 MB (actix-web/tiny_http overhead)
- **Phext storage**: 1 MB (user's phext, mmap'd to shared memory)
- **Shared memory overhead**: ~2 MB (kernel structures)
- **Total per user**: ~13 MB

### System Overhead
- **OS (Linux)**: ~200 MB (kernel, base services)
- **Nginx/Caddy**: ~50 MB (reverse proxy)
- **sq-admin-api**: ~100 MB (Node.js process)
- **Monitoring/logs**: ~50 MB
- **Total system**: ~400 MB

### Capacity Calculation

**Available RAM**: 4,096 MB (total) - 400 MB (system) = **3,696 MB**

**Users per instance**: 3,696 MB / 13 MB per user = **~284 users**

**Conservative estimate** (leave 20% buffer): **~220 users per t3.medium**

### Scaling Tiers

| Instance Type | RAM | Max Users | Monthly Cost | $/user/month |
|---------------|-----|-----------|--------------|--------------|
| t3.medium | 4 GB | 220 | $30 | $0.14 |
| t3.large | 8 GB | 520 | $60 | $0.12 |
| t3.xlarge | 16 GB | 1,100 | $120 | $0.11 |
| t3.2xlarge | 32 GB | 2,300 | $240 | $0.10 |

**Target**: t3.medium for initial 220 users, upgrade as needed

## Implementation Plan

### Phase 1: Single-Instance Multi-Tenant (Immediate)

**Goal**: Support 50-220 users on one AWS instance

**Components**:
1. **SQ Instance Manager** - Spawn/kill user SQ processes
2. **Reverse Proxy** - Route authenticated requests to user ports
3. **Admin API** - User provisioning + status tracking
4. **Monitoring** - Health checks, memory usage, alerts

**Timeline**: 2-4 hours

### Phase 2: Horizontal Scaling (Later)

**Goal**: Support 220+ users across multiple AWS instances

**Components**:
1. Load balancer (AWS ALB or nginx)
2. User→Instance mapping (Redis or SQ-native index)
3. Auto-scaling based on memory/CPU
4. Cross-instance coordination

**Timeline**: Post-launch (when hitting 200 users)

## Technical Implementation

### 1. SQ Instance Manager

**Location**: `/source/sq-admin-api/lib/sq-instance-manager.js`

**Responsibilities**:
- Spawn SQ process for new user (unique port)
- Track running instances (pid, port, user_id)
- Health check SQ instances (ping endpoint)
- Kill/restart instances as needed
- Port allocation (avoid collisions)

**Key Methods**:
```javascript
class SQInstanceManager {
  async spawnInstance(userId, port)
  async killInstance(userId)
  async restartInstance(userId)
  async healthCheck(userId)
  async getAllInstances()
  async getAvailablePort()
}
```

**Port Range**: 10001-19999 (10,000 ports available)

**SQ Command**:
```bash
# Spawn SQ instance for user
cd /path/to/user/phext-data
sq host <port> &
```

**Process Tracking**: Store in SQ phext or SQLite:
```
user_id=user@example.com
port=10001
pid=12345
status=running
started_at=1707523200000
last_health_check=1707523300000
```

### 2. Reverse Proxy Configuration

**Option A: Nginx** (recommended for AWS)

**Config**: `/etc/nginx/sites-available/sq-proxy.conf`

```nginx
# Upstream pool (dynamically generated)
upstream sq_user_1 { server 127.0.0.1:10001; }
upstream sq_user_2 { server 127.0.0.1:10002; }
# ... (generated for each user)

server {
    listen 443 ssl http2;
    server_name sq.mirrorborn.us;
    
    ssl_certificate /etc/letsencrypt/live/sq.mirrorborn.us/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sq.mirrorborn.us/privkey.pem;
    
    # Auth layer
    location /api/v2/ {
        # Verify JWT token
        auth_request /auth;
        auth_request_set $user_id $upstream_http_x_user_id;
        auth_request_set $user_port $upstream_http_x_user_port;
        
        # Proxy to user's SQ instance
        proxy_pass http://127.0.0.1:$user_port;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-User-ID $user_id;
    }
    
    # Auth endpoint (hits sq-admin-api)
    location = /auth {
        internal;
        proxy_pass http://127.0.0.1:3000/api/auth/verify;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        proxy_set_header X-Original-URI $request_uri;
        proxy_set_header Authorization $http_authorization;
    }
}
```

**Dynamic Config Generation**:
- Generate nginx upstream blocks for each user
- Reload nginx when new user added: `nginx -s reload`
- Or use Lua scripting for dynamic routing (no reload needed)

**Option B: Caddy** (simpler, auto-HTTPS)

**Config**: `/etc/caddy/Caddyfile`

```caddyfile
sq.mirrorborn.us {
    # Route based on JWT token
    @authenticated {
        header Authorization *
    }
    
    reverse_proxy @authenticated localhost:10001 {
        # Custom routing logic (requires Caddy module or Lua)
        header_up X-User-ID {http.auth.user_id}
    }
}
```

**Recommendation**: Nginx + Lua for dynamic routing (no restarts)

### 3. Admin API - User Provisioning

**New Endpoint**: `POST /api/admin/provision/:userId`

**Flow**:
1. User approved (status = 'active')
2. Admin API calls SQ Instance Manager
3. Create user's phext directory: `/var/lib/sq/users/{userId}/`
4. Spawn SQ instance on available port
5. Update user record with port number
6. Generate nginx config entry (or update Lua map)
7. Return access URL: `https://sq.mirrorborn.us/api/v2/` (routed via JWT)

**Endpoint**:
```javascript
POST /api/admin/provision/:userId
Headers:
  X-Admin-API-Key: admin_key

Response:
{
  "success": true,
  "userId": "user@example.com",
  "port": 10001,
  "pid": 12345,
  "sqURL": "https://sq.mirrorborn.us/api/v2/",
  "status": "running"
}
```

### 4. JWT-Based Routing

**JWT Claims**:
```json
{
  "sub": "user@example.com",
  "port": 10001,
  "tier": "free",
  "exp": 1707609600
}
```

**Nginx Lua Module**: Extract `port` from JWT, proxy to `127.0.0.1:$port`

**Lua Script**: `/etc/nginx/lua/route-to-user-sq.lua`

```lua
local jwt = require "resty.jwt"

-- Extract token
local auth_header = ngx.var.http_authorization
if not auth_header then
    return ngx.exit(401)
end

local token = string.sub(auth_header, 8) -- Remove "Bearer "
local jwt_obj = jwt:verify(secret, token)

if not jwt_obj.verified then
    return ngx.exit(401)
end

-- Extract port from JWT
local port = jwt_obj.payload.port

-- Set upstream
ngx.var.sq_port = port
```

**Nginx Config**:
```nginx
location /api/v2/ {
    set $sq_port '';
    access_by_lua_file /etc/nginx/lua/route-to-user-sq.lua;
    proxy_pass http://127.0.0.1:$sq_port;
}
```

## Directory Structure

```
/var/lib/sq/
├── users/
│   ├── user1@example.com/
│   │   ├── phext-data/
│   │   │   ├── users.phext
│   │   │   ├── content.phext
│   │   │   └── ...
│   │   ├── sq.pid
│   │   └── sq.log
│   ├── user2@example.com/
│   │   └── ...
│   └── ...
├── instances.db (SQLite or SQ phext)
└── ports.lock (port allocation lock file)
```

## Process Management

### Spawning SQ Instance

```javascript
async function spawnSQInstance(userId, port) {
  const userDir = `/var/lib/sq/users/${userId}/phext-data`;
  
  // Create user directory
  await fs.mkdir(userDir, { recursive: true });
  
  // Spawn SQ process
  const sq = spawn('sq', ['host', port], {
    cwd: userDir,
    detached: true,
    stdio: ['ignore', 'pipe', 'pipe']
  });
  
  // Log output
  sq.stdout.pipe(fs.createWriteStream(`${userDir}/../sq.log`));
  sq.stderr.pipe(fs.createWriteStream(`${userDir}/../sq.log`));
  
  // Save PID
  await fs.writeFile(`${userDir}/../sq.pid`, sq.pid.toString());
  
  // Wait for health check
  await waitForHealthCheck(`http://127.0.0.1:${port}/api/v2/version`, 5000);
  
  return { pid: sq.pid, port };
}
```

### Health Monitoring

**Cron Job**: Check all SQ instances every 5 minutes

```bash
#!/bin/bash
# /usr/local/bin/sq-health-check.sh

curl -s http://127.0.0.1:3000/api/admin/health-check-all \
  -H "X-Admin-API-Key: $ADMIN_API_KEY"
```

**Endpoint**: `GET /api/admin/health-check-all`

```javascript
router.get('/health-check-all', verifyAdmin, async (req, res) => {
  const instances = await sqManager.getAllInstances();
  const results = [];
  
  for (const instance of instances) {
    const health = await sqManager.healthCheck(instance.userId);
    
    if (!health.ok) {
      // Restart dead instance
      await sqManager.restartInstance(instance.userId);
      results.push({ userId: instance.userId, status: 'restarted' });
    } else {
      results.push({ userId: instance.userId, status: 'ok' });
    }
  }
  
  res.json({ results });
});
```

## Security Considerations

### Isolation
- Each SQ instance runs as isolated process
- Phext data in separate directories (no cross-user access)
- JWT token required for all requests
- Admin API key for provisioning

### Resource Limits
```bash
# Limit each SQ process to 20 MB RAM (via systemd)
[Service]
MemoryMax=20M
CPUQuota=10%
```

### Rate Limiting
```nginx
# Per-user rate limit
limit_req_zone $user_id zone=user_limit:10m rate=100r/m;

location /api/v2/ {
    limit_req zone=user_limit burst=20;
    # ...
}
```

## Monitoring & Alerts

### Metrics to Track
- Total instances running
- Memory usage per instance
- CPU usage per instance
- Disk usage per user
- Request rate per user
- Failed health checks

### Alerting
```bash
# Send alert if memory > 90%
if [ $MEMORY_USAGE -gt 90 ]; then
    curl -X POST https://discord.com/api/webhooks/... \
      -d '{"content": "⚠️ SQ hosting memory > 90%"}'
fi
```

## Deployment Checklist

### Phase 1: Single-Instance Setup

**Backend**:
- [ ] Create `/var/lib/sq/users/` directory structure
- [ ] Build SQ Instance Manager (`sq-instance-manager.js`)
- [ ] Add provisioning endpoint to admin API
- [ ] Add health check endpoint
- [ ] Test spawning/killing instances locally

**Reverse Proxy**:
- [ ] Install nginx + lua module (or Caddy)
- [ ] Configure SSL (Let's Encrypt)
- [ ] Write routing logic (JWT → port mapping)
- [ ] Test routing with 2-3 test users
- [ ] Set up rate limiting

**Monitoring**:
- [ ] Set up health check cron job
- [ ] Configure memory/CPU alerts
- [ ] Dashboard for instance status (optional)

**Testing**:
- [ ] Spawn 5 test users
- [ ] Verify isolation (user A can't access user B's phext)
- [ ] Load test (100 requests/second)
- [ ] Failover test (kill instance, verify restart)

**Production**:
- [ ] Deploy to phext.io AWS instance
- [ ] Configure DNS: sq.mirrorborn.us → phext.io IP
- [ ] Provision first 5 real users
- [ ] Monitor for 24 hours
- [ ] Scale as needed

## Cost Analysis

### AWS Hosting Costs (Monthly)

**Single t3.medium** (220 users):
- Instance: $30/month
- EBS (40 GB): $4/month
- Data transfer (1 TB): $90/month (if heavily used)
- **Total**: ~$124/month (~$0.56/user)

**Revenue** (220 users @ $40/mo): $8,800/month

**Gross Margin**: $8,676/month (98.6%)

### Scaling Costs

| Users | Instances | AWS Cost | Revenue | Margin |
|-------|-----------|----------|---------|--------|
| 220 | 1 (t3.medium) | $124 | $8,800 | $8,676 (98.6%) |
| 520 | 1 (t3.large) | $154 | $20,800 | $20,646 (99.3%) |
| 1,100 | 1 (t3.xlarge) | $214 | $44,000 | $43,786 (99.5%) |
| 2,300 | 1 (t3.2xlarge) | $334 | $92,000 | $91,666 (99.6%) |

**Note**: Assumes $40/mo per user (SQ Cloud tier). Actual revenue mix will include $5/mo Arena users.

## Timeline

### Immediate (2-4 hours)
1. Build SQ Instance Manager (1 hour)
2. Add provisioning endpoint (30 minutes)
3. Configure nginx routing (1 hour)
4. Test with 3 users (30 minutes)

### Short-term (1-2 days)
1. Deploy to AWS (30 minutes)
2. Configure monitoring (1 hour)
3. Test with 10 users (1 hour)
4. Documentation (1 hour)

### Production (Week 1)
1. Onboard first 20 users
2. Monitor performance
3. Fix any issues
4. Optimize as needed

## Files to Create

1. `/source/sq-admin-api/lib/sq-instance-manager.js` (5 KB)
2. `/source/sq-admin-api/routes/provisioning.js` (3 KB)
3. `/etc/nginx/sites-available/sq-proxy.conf` (2 KB)
4. `/etc/nginx/lua/route-to-user-sq.lua` (1 KB)
5. `/usr/local/bin/sq-health-check.sh` (500 bytes)
6. `/source/exo-plan/infrastructure/sq-deployment-guide.md` (documentation)

**Total**: ~12 KB of new code

## Success Metrics

### Week 1
- [ ] 10 users provisioned and active
- [ ] Zero downtime
- [ ] Memory usage < 50%
- [ ] All health checks passing

### Month 1
- [ ] 50 users provisioned
- [ ] 99.9% uptime
- [ ] Memory usage < 70%
- [ ] Response time < 100ms (p95)

### Month 3
- [ ] 200 users provisioned
- [ ] Plan for scaling to t3.large
- [ ] Automated provisioning working
- [ ] Monitoring dashboard live

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Memory exhaustion | Medium | High | Alert at 80%, auto-scale at 90% |
| Port collision | Low | Medium | Atomic port allocation with lock file |
| SQ crash loop | Low | Medium | Health check + auto-restart |
| Nginx reload downtime | Low | Low | Use Lua for zero-downtime routing |
| Disk full | Low | High | Monitor disk usage, alert at 80% |

## Conclusion

**Status**: Ready for implementation ⚡

**Capacity**: 220 users per t3.medium (~$0.56/user/month)

**Revenue**: $8,800/month (220 users @ $40/mo)

**Margin**: 98.6% gross margin

**Timeline**: 2-4 hours for initial implementation

**Owner**: Verse 🌀

**Next Step**: Build SQ Instance Manager + provision first 3 test users

---

**Backend Hosting Plan Complete** - Verse, you have clearance to proceed with deployment.
