# Nginx Configuration Repository

Version-controlled nginx configs for Verse's AWS infrastructure.

## Production Sites

### Mirrorborn Ecosystem
- **mirrorborn.us** - Main landing page, SQ Cloud marketing
  - Proxies `/api/auth` → mytheon_arena (port 3001)
  - Proxies `/api/sq` → sq_cloud (port 3002)
  - HTTPS + HSTS enabled
  - CORS restricted to same origin

- **sq.mirrorborn.us** - SQ Cloud REST API (Multi-Tenant)
  - Proxies to SQ v0.5.6 on port 1337
  - **API Key authentication required:** `X-SQ-API-Key` header
  - CORS: wildcard (`*`) for public API access
  - TLS + HSTS enabled
  - Health endpoint: `/health` (no auth)
  - **Critical:** `proxy_buffering off` + `proxy_request_buffering off` for reliable multi-tenant writes
  - Keepalive connections: 32 (prevents context switching)

### Other Production Sites
- **apertureshift.com** - HTTPS + HSTS
- **quickfork.net** - HTTPS + HSTS
- **singularitywatch.org** - HTTPS + HSTS
- **sotafomo.com** - HTTPS + HSTS
- **visionquest.me** - HTTPS + HSTS
- **wishnode.net** - HTTPS + HSTS

### Staging Sites
All production sites have `staging.*` equivalents with identical configs.

## Deployment Workflow

1. Edit config in this repo
2. Test locally: `sudo nginx -t -c /path/to/config`
3. Commit changes
4. Copy to `/etc/nginx/sites-available/`
5. Reload: `sudo systemctl reload nginx`

## Files

- `*.conf` - Production nginx site configs
- `staging.*.conf` - Staging site configs (mirror of production)

## Security Features

All sites include:
- HTTPS-only (HTTP redirects to HTTPS)
- HSTS with 1-year max-age + preload
- X-Content-Type-Options: nosniff
- X-Frame-Options: SAMEORIGIN or DENY
- X-XSS-Protection: 1; mode=block
- Referrer-Policy: strict-origin-when-cross-origin

## API Authentication

**sq.mirrorborn.us** requires API key authentication:
```bash
curl -H "X-SQ-API-Key: <key>" https://sq.mirrorborn.us/api/v2/version
```

Beta key stored in `/home/wbic16/.openclaw/workspace/SQ-AUTH-DEPLOYMENT.md`

## Multi-Tenant Proxy Requirements

**CRITICAL for SQ Cloud reliability:**

```nginx
upstream sq_api {
    server 127.0.0.1:1337;
    keepalive 32;  # Reuse connections, prevent context switching
}

location / {
    proxy_buffering off;              # Required: prevent response mixing
    proxy_request_buffering off;      # Required: prevent request body mixing
    proxy_http_version 1.1;           # Required for keepalive
    proxy_set_header Connection "";   # Required for keepalive
    
    client_max_body_size 100M;        # Support large phext uploads
    proxy_connect_timeout 120s;
    proxy_send_timeout 120s;
    proxy_read_timeout 120s;
}
```

**Without these settings:**
- Concurrent writes to different tenants can corrupt each other
- Large uploads (CYOA, etc.) get truncated
- Context switching causes unreliable syncs

**Verified working:** 2026-02-13 05:51 UTC

## Last Updated

2026-02-12 05:58 UTC - Initial commit (Verse)
