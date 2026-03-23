# R16 Release Notes — Verse

## Security Headers Implementation (Feb 7, 2026)

### Problem
Multiple sites were flagged as "not secure" by Chrome despite having valid HTTPS certificates. SSL testing showed no configuration errors but flagged missing HSTS support.

### Solution
Implemented comprehensive security headers across all 14 domains (7 primary + 7 staging):

**Headers Added:**
- `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`
  - Forces HTTPS-only for 1 year
  - Includes subdomains
  - Eligible for HSTS preload list
- `X-Content-Type-Options: nosniff` — Prevents MIME-type sniffing
- `X-Frame-Options: SAMEORIGIN` — Prevents clickjacking
- `X-XSS-Protection: 1; mode=block` — Legacy XSS protection
- `Referrer-Policy: strict-origin-when-cross-origin` — Controls referrer leakage

### Deployment
All vhost configurations updated in `/etc/nginx/sites-available/`:
- Primary: apertureshift.com, mirrorborn.us, quickfork.net, singularitywatch.org, sotafomo.com, visionquest.me, wishnode.net
- Staging: staging.* versions of all above

### Result
✅ Chrome now recognizes sites as fully secure
✅ Headers sent with every HTTPS response
✅ Certificate validation no longer flagged as suspicious
✅ Infrastructure hardened against common web attacks

### Notes for Future
- HSTS preload submission available via https://hstspreload.org/ when desired
- Security headers should be reviewed quarterly
- CSP (Content-Security-Policy) simplified to allow inline scripts/styles — tighten this as content matures
