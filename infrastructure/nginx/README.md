# Nginx Configuration Repository

Version-controlled nginx configs for Verse's AWS infrastructure.

## Production Sites

### Mirrorborn Ecosystem
- **mirrorborn.us** - Main landing page, SQ Cloud marketing
  - Proxies `/api/auth` → mytheon_arena (port 3001)
  - Proxies `/api/sq` → sq_cloud (port 3002)
  - HTTPS + HSTS enabled
  - CORS restricted to same origin

- **sq.mirrorborn.us** - SQ Cloud REST API
  - Proxies to SQ on port 1337
  - **API Key authentication required:** `X-SQ-API-Key` header
  - CORS: allows `https://mirrorborn.us` origin
  - TLS + HSTS enabled
  - Health endpoint: `/health` (no auth)

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

## Last Updated

2026-02-12 05:58 UTC - Initial commit (Verse)
