# SQ v0.5.5 - Token-Based Multi-Tenant Router

**Status:** ✅ SHIPPED (2026-02-12 10:30 CST)  
**Commit:** [6226668](https://github.com/wbic16/SQ/commit/6226668)  
**Timeline:** R21 - Built in 35 minutes during Opus slot

---

## Problem

Nginx reverse proxy auth was mangling Phext Notepad API requests. Per-tenant authentication needed to move INTO SQ to avoid proxy issues and enable SQ Cloud multi-tenant deployment.

## Solution

Built token-based routing layer as new `sq route` command:

1. **Single router** listens on public port (e.g., 1337 or 443)
2. **Per-tenant SQ instances** run on private ports with dedicated data directories
3. **Config file** maps `pmb-v1-xxx` auth tokens to backend ports
4. **Router** extracts `Authorization` header, looks up backend, proxies request

### Architecture

```
Client (Authorization: pmb-v1-abc123)
    ↓
Router (port 1337) - token lookup
    ↓
Backend SQ (port 1338) - tenant 1 data
    ↓
Response
```

Each tenant gets:
- Unique auth token (`pmb-v1-xxx`)
- Dedicated SQ instance: `sq host <port> --key <token> --data-dir <path>`
- Isolated data directory
- Full SQ API access

## Deliverables

| File | Size | Purpose |
|------|------|---------|
| `src/router.rs` | 11.7 KB | Token→port routing engine |
| `ROUTER.md` | 6.4 KB | Complete documentation |
| `router-config.example.json` | 385 B | Sample tenant config |
| `README.md` (updated) | +1.3 KB | Router Mode section |
| `Cargo.toml` (updated) | — | Version bump to 0.5.5 |
| `src/main.rs` (updated) | +12 lines | `route` command integration |

**Total:** 6 files changed, 638 insertions, 1 deletion

## Usage

### 1. Create router config

```json
{
  "tenants": [
    {
      "token": "pmb-v1-user1-abc123",
      "port": 1338,
      "data_dir": "/var/lib/sq/tenants/user1"
    },
    {
      "token": "pmb-v1-user2-def456",
      "port": 1339,
      "data_dir": "/var/lib/sq/tenants/user2"
    }
  ]
}
```

### 2. Start backend SQ instances

```bash
# Terminal 1
sq host 1338 --key pmb-v1-user1-abc123 --data-dir /var/lib/sq/tenants/user1

# Terminal 2
sq host 1339 --key pmb-v1-user2-def456 --data-dir /var/lib/sq/tenants/user2
```

### 3. Start router

```bash
sq route router-config.json 1337
```

### 4. Test

```bash
# User 1 request
curl -H "Authorization: pmb-v1-user1-abc123" \
     http://localhost:1337/select/1.1.1/1.1.1/1.1.1

# User 2 request
curl -H "Authorization: pmb-v1-user2-def456" \
     http://localhost:1337/select/1.1.1/1.1.1/1.1.1
```

Each user sees only their own data.

## Security Features

1. **Token-based auth** - Only valid tokens are routed
2. **Tenant isolation** - Each backend serves one data directory
3. **Path traversal prevention** - Backend validates phext filenames (no `..`, `/`, `\`)
4. **Request timeouts** - 30-second timeout on proxy connections
5. **Header limits** - 16 KB max header size
6. **Bearer token support** - Accepts both `Bearer pmb-v1-xxx` and raw `pmb-v1-xxx`

## Production Deployment

### TLS via nginx

```nginx
server {
    listen 443 ssl;
    server_name sq.example.com;
    
    ssl_certificate /etc/letsencrypt/live/sq.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sq.example.com/privkey.pem;
    
    location / {
        proxy_pass http://127.0.0.1:1337;
        proxy_set_header Authorization $http_authorization;
        proxy_set_header Host $host;
    }
}
```

### systemd services

**Router:**
```ini
[Unit]
Description=SQ Router
After=network.target

[Service]
Type=simple
User=sq
WorkingDir=/var/lib/sq
ExecStart=/usr/local/bin/sq route /etc/sq/router-config.json 1337
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

**Backend (template):**
```ini
[Unit]
Description=SQ Backend for %i
After=network.target

[Service]
Type=simple
User=sq
WorkingDir=/var/lib/sq/tenants/%i
ExecStart=/usr/local/bin/sq host ${PORT} --key ${TOKEN} --data-dir /var/lib/sq/tenants/%i
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

## Token Generation

Generate secure tokens:

```bash
echo "pmb-v1-$(openssl rand -hex 16)"
# Output: pmb-v1-a3f2b8c4d5e6f7a8b9c0d1e2f3a4b5c6
```

## API Compatibility

Router is fully transparent - same SQ API:
- `GET /select/<coord>` - Read scroll
- `POST /insert?library=X&shelf=Y&...` - Write scroll
- `POST /update?library=X&shelf=Y&...` - Update scroll
- `GET /toc` - Table of contents

Only difference: add `Authorization: pmb-v1-xxx` header.

## Error Responses

| Code | Meaning | Cause |
|------|---------|-------|
| 401 | Unauthorized | Missing or invalid token |
| 400 | Bad Request | Malformed HTTP request |
| 502 | Bad Gateway | Backend SQ not responding |
| 500 | Internal Server Error | Router error |

## Future Enhancements

- [ ] Multi-threaded request handling
- [ ] Hot config reload (SIGHUP)
- [ ] Built-in HTTPS support
- [ ] Rate limiting per tenant
- [ ] Prometheus metrics endpoint
- [ ] Backend health checks
- [ ] Connection pooling
- [ ] Request logging

## Launch Impact

**SQ Cloud Feb 13 Launch:**
- ✅ Solves nginx auth mangling issue
- ✅ Enables multi-tenant deployment
- ✅ Per-user data isolation ready
- ✅ Production-ready architecture
- ✅ TLS support via nginx/Caddy

**Next Steps:**
1. Deploy router on sq.mirrorborn.us
2. Generate tenant tokens via Stripe webhook
3. Provision backend SQ instances per user
4. Update signup flow with router URL

## Documentation

- **Full guide:** [ROUTER.md](https://github.com/wbic16/SQ/blob/main/ROUTER.md)
- **Example config:** [router-config.example.json](https://github.com/wbic16/SQ/blob/main/router-config.example.json)
- **Source:** [src/router.rs](https://github.com/wbic16/SQ/blob/main/src/router.rs)

## Timeline

- **09:01 CST** - R21 kickoff, Will requests SQ auth work
- **09:35 CST** - Architecture clarified (token→port routing)
- **09:54 CST** - Implementation started
- **10:15 CST** - Core router built, docs written
- **10:25 CST** - Merge conflicts resolved
- **10:30 CST** - Pushed to GitHub (commit 6226668)

**Total time:** 35 minutes (design → code → docs → push)

---

**Built by:** Cyon 🪶  
**R21 Priority:** P1 (SQ v0.5.5 must ship today)  
**Launch:** T-6.5 hours (1700 CST target)
