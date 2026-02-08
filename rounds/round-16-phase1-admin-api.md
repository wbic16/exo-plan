# R16 Phase 1: Admin API Implementation

**Date:** 2026-02-07 17:49 CST  
**Owner:** Phex 🔱  
**Partner:** Verse 🌀  
**Status:** Active - Kickoff

---

## Objective

Build Admin API for provisioning SQ Cloud user access. Enable automated user onboarding after successful Stripe payments.

---

## Requirements

### Core Endpoints

1. **POST /admin/users/add**
   - Add new user with email + username
   - Generate JWT token for API access
   - Return credentials + setup instructions

2. **GET /admin/users/list**
   - List all provisioned users
   - Filter by status (active/suspended)
   - Paginated results

3. **POST /admin/users/suspend**
   - Suspend user access (keep data)
   - Revoke JWT token
   - Log reason

4. **DELETE /admin/users/delete**
   - Permanently delete user
   - Remove all user phext data
   - Log deletion

5. **POST /admin/users/token/refresh**
   - Generate new JWT for existing user
   - Invalidate old token

---

## API Design

### Authentication
- Admin API secured with admin JWT
- Separate from user JWTs
- Admin token has elevated permissions

### Request/Response Format
All endpoints use JSON.

**Example: Add User**
```json
POST /admin/users/add
Authorization: Bearer <admin-jwt>
Content-Type: application/json

{
  "email": "user@example.com",
  "username": "example_user",
  "tier": "sq-cloud" // or "singularity", "arena"
}

Response 201:
{
  "user_id": "uuid-here",
  "email": "user@example.com",
  "username": "example_user",
  "jwt": "user-jwt-token-here",
  "api_endpoint": "https://mirrorborn.us/api/v2",
  "setup_instructions_url": "https://mirrorborn.us/docs/getting-started"
}
```

---

## Implementation Options

### Option 1: Extend SQ with Admin Routes
**Pros:**
- Single service
- Direct access to phext data
- Simple deployment

**Cons:**
- Mixes user API with admin API
- SQ codebase is Rust (learning curve)
- Requires SQ restart for updates

### Option 2: Separate Admin Service (Node.js)
**Pros:**
- Independent from SQ
- Can use existing libphext-node
- Easy to update/deploy
- Can integrate with Stripe webhooks

**Cons:**
- Additional service to manage
- Needs access to SQ (HTTP API calls)

### Recommendation: Option 2 (Separate Service)

**Reasoning:**
- Faster to build (Node.js + libphext-node)
- Stripe webhook integration easier
- Independent deployment/updates
- Can run alongside SQ

---

## Architecture

```
┌─────────────────┐
│  Stripe Webhook │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌─────────────────┐
│  Admin API      │─────▶│  SQ (port 1337) │
│  (Node.js)      │      │  (user API)      │
│  (port 3000)    │      └─────────────────┘
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  User Database  │
│  (SQLite)       │
└─────────────────┘
```

**Components:**
1. **Admin API Service (Node.js):**
   - Express.js web server
   - JWT generation/validation
   - User management endpoints
   - Stripe webhook handler

2. **User Database (SQLite):**
   - Store user metadata (email, username, tier, status)
   - JWT token tracking
   - Audit log

3. **SQ Integration:**
   - Create user-specific phext namespaces
   - Set up permissions/quotas
   - Monitor usage

---

## Implementation Plan

### Step 1: Bootstrap Admin API Service (1-2 hours)
- [ ] Create Node.js project
- [ ] Install dependencies (express, jsonwebtoken, sqlite3, libphext)
- [ ] Set up SQLite database schema
- [ ] Implement JWT generation

### Step 2: Core Endpoints (2-3 hours)
- [ ] POST /admin/users/add
- [ ] GET /admin/users/list
- [ ] POST /admin/users/suspend
- [ ] DELETE /admin/users/delete
- [ ] POST /admin/users/token/refresh

### Step 3: Stripe Integration (1-2 hours)
- [ ] POST /webhooks/stripe
- [ ] Verify webhook signatures
- [ ] Handle checkout.session.completed event
- [ ] Auto-provision users on successful payment

### Step 4: SQ Integration (1-2 hours)
- [ ] Create user phext namespaces
- [ ] Set up coordinate-based user data isolation
- [ ] Implement quota tracking

### Step 5: Testing & Documentation (1-2 hours)
- [ ] Test all endpoints
- [ ] Document API for Verse
- [ ] Create deployment guide
- [ ] Write admin CLI tool (optional)

**Total estimated time:** 6-11 hours

---

## Database Schema

```sql
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    tier TEXT NOT NULL, -- 'sq-cloud', 'arena', 'singularity'
    status TEXT NOT NULL DEFAULT 'active', -- 'active', 'suspended', 'deleted'
    jwt_token TEXT,
    stripe_customer_id TEXT,
    created_at INTEGER NOT NULL,
    updated_at INTEGER NOT NULL
);

CREATE TABLE audit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    action TEXT NOT NULL, -- 'created', 'suspended', 'deleted', 'token_refreshed'
    reason TEXT,
    performed_by TEXT, -- 'admin', 'webhook', 'system'
    timestamp INTEGER NOT NULL
);

CREATE TABLE quotas (
    user_id TEXT PRIMARY KEY,
    storage_used_mb REAL DEFAULT 0,
    storage_limit_mb REAL DEFAULT 100,
    api_calls_today INTEGER DEFAULT 0,
    api_limit_daily INTEGER DEFAULT 10000
);
```

---

## JWT Structure

```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "username": "example_user",
  "tier": "sq-cloud",
  "iat": 1707345600,
  "exp": 1738881600 // 1 year expiry
}
```

**Signing:**
- Algorithm: RS256 (RSA with SHA-256)
- Private key stored securely (environment variable or keystore)
- Public key available for SQ to verify user JWTs

---

## Stripe Webhook Integration

**Event:** `checkout.session.completed`

**Payload:**
```json
{
  "type": "checkout.session.completed",
  "data": {
    "object": {
      "customer_email": "user@example.com",
      "metadata": {
        "username": "example_user",
        "tier": "sq-cloud"
      }
    }
  }
}
```

**Handler logic:**
1. Verify webhook signature
2. Extract email + username from metadata
3. Call `/admin/users/add` internally
4. Send welcome email with credentials
5. Log provisioning

---

## nginx CORS Configuration

**For Verse to deploy:**

```nginx
server {
    listen 443 ssl;
    server_name mirrorborn.us;

    ssl_certificate /etc/letsencrypt/live/mirrorborn.us/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/mirrorborn.us/privkey.pem;

    # SQ API (user access)
    location /api/v2/ {
        proxy_pass http://localhost:1337/api/v2/;
        
        # CORS headers
        add_header Access-Control-Allow-Origin * always;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;
        
        # Handle preflight
        if ($request_method = OPTIONS) {
            return 204;
        }
    }

    # Admin API (restricted access)
    location /admin/ {
        proxy_pass http://localhost:3000/admin/;
        
        # No CORS for admin API (internal only)
        # Require admin JWT in Authorization header
        
        # Optional: IP whitelist
        # allow 192.168.1.0/24;
        # deny all;
    }

    # Stripe webhooks (public but verified)
    location /webhooks/stripe {
        proxy_pass http://localhost:3000/webhooks/stripe;
    }
}
```

---

## Security Considerations

1. **Admin JWT protection:**
   - Store admin JWT securely
   - Rotate regularly
   - Never expose in logs

2. **User data isolation:**
   - Each user gets coordinate namespace
   - No cross-user data access
   - Audit all access

3. **Stripe webhook validation:**
   - Verify all webhook signatures
   - Check event types
   - Idempotency (handle duplicate events)

4. **Rate limiting:**
   - Limit API calls per user per day
   - Block abusive patterns
   - Monitor usage

---

## Next Steps (Immediate)

1. **Create Node.js project structure**
2. **Set up SQLite database**
3. **Implement JWT generation**
4. **Build `/admin/users/add` endpoint**
5. **Test with manual curl requests**
6. **Coordinate with Verse on nginx config**

---

## Status Update (2026-02-07 17:57 CST)

**MVP COMPLETE** ✅

### Completed
- [x] Node.js project structure (`/source/sq-admin-api`)
- [x] SQLite database schema (auto-initialization)
- [x] JWT generation/validation (admin + user tokens)
- [x] All 5 core endpoints implemented:
  - POST /admin/users (add user)
  - GET /admin/users (list users)
  - POST /admin/users/:id/suspend
  - DELETE /admin/users/:id
  - POST /users/:id/refresh (token refresh)
- [x] Audit logging (all admin actions tracked)
- [x] Local testing (health check ✅, user creation ✅, listing ✅)
- [x] README with usage examples
- [x] Security audit documented (SECURITY.md)

### Pending
- [ ] Security patches (npm audit fix --force, test sqlite3 5.0.2)
- [ ] Deployment coordination with Verse (nginx proxy + CORS)
- [ ] Stripe webhook integration
- [ ] Production deployment

### Security Findings
- 5 high severity npm vulnerabilities in sqlite3 build dependencies
- Build-time only (not runtime vulnerabilities)
- Fix available: `npm audit fix --force` (breaking change to sqlite3 5.0.2)
- Documented in `/source/sq-admin-api/SECURITY.md`

**Next:** Coordinate nginx deployment with Verse, then integrate Stripe webhooks.

🔱
