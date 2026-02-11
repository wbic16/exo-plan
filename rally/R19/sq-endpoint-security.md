# SQ Endpoint Security - R19 Critical

**Issue:** SQ endpoint at mirrorborn.us:1337 is accessible via plain HTTP without TLS or authentication.

**Status:** 🔴 **CRITICAL - Production Exposed**

**Current State:**
- Endpoint: `http://mirrorborn.us:1337`
- Protocol: Plain HTTP (no TLS)
- Authentication: None
- Visibility: Public internet
- Data: Incipit.phext (937 KB) synced via sq-sync

**Security Risks:**
1. **Data in transit exposed** - No encryption, plain text over wire
2. **No authentication** - Anyone can read/write to the phext store
3. **No authorization** - No user isolation or access control
4. **Metadata leakage** - Coordinate structure visible to attackers
5. **Write tampering** - Malicious actors could corrupt phext data

---

## Immediate Mitigation (R19 Phase 4)

### Option A: Nginx Reverse Proxy with TLS
```bash
# /etc/nginx/sites-available/sq-cloud
server {
    listen 443 ssl http2;
    server_name sq.mirrorborn.us;
    
    ssl_certificate /etc/letsencrypt/live/sq.mirrorborn.us/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sq.mirrorborn.us/privkey.pem;
    
    # Restrict to allowlist during alpha
    allow 1.2.3.4;  # Will's IP
    allow 5.6.7.8;  # Founding Nine customer
    deny all;
    
    location / {
        proxy_pass http://127.0.0.1:1337;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        
        # Basic auth as temporary measure
        auth_basic "SQ Cloud Alpha Access";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}

server {
    listen 80;
    server_name sq.mirrorborn.us;
    return 301 https://$server_name$request_uri;
}
```

**Steps:**
1. DNS: Add `sq.mirrorborn.us` A record → mirrorborn.us IP
2. Certbot: `sudo certbot certonly --nginx -d sq.mirrorborn.us`
3. Nginx config: Deploy above config
4. Create htpasswd: `sudo htpasswd -c /etc/nginx/.htpasswd <user>`
5. Reload: `sudo nginx -t && sudo systemctl reload nginx`
6. Firewall: Block external port 1337 access (localhost-only)

**Result:** 
- HTTPS endpoint: `https://sq.mirrorborn.us`
- Basic auth required
- TLS 1.3 encryption
- IP allowlist enforced

---

### Option B: SQ Native TLS + API Key Auth (Future)

Add to SQ itself:
- TLS termination in Rust (rustls crate)
- API key middleware
- Per-user coordinate namespacing
- Rate limiting

**Scope:** R20+ (requires SQ code changes)

---

## Recommended Path

**R19 Phase 4 (Today):**
- Deploy Option A (Nginx reverse proxy)
- Issue: `sq.mirrorborn.us` subdomain
- Auth: Basic auth with htpasswd
- Allowlist: Will's IP + alpha customers

**R20:**
- Migrate to SQ native TLS
- API key authentication
- Per-customer phext isolation
- Rate limiting (10k/day per tier)

---

## Testing Checklist

After deployment:
- [ ] `curl http://mirrorborn.us:1337/version` → Connection refused (firewalled)
- [ ] `curl https://sq.mirrorborn.us/version` → 401 Unauthorized (no auth)
- [ ] `curl -u user:pass https://sq.mirrorborn.us/version` → 200 OK + version
- [ ] `curl https://sq.mirrorborn.us/select?p=Incipit&c=1.1.1/1.1.1/1.1.1` → Requires auth
- [ ] SSL Labs test: A+ rating
- [ ] nmap scan: Port 1337 closed externally

---

## Customer Impact

**Before securing:**
- ⚠️ Cannot sell SQ Cloud (data exposed)
- ⚠️ Cannot onboard Founding Nine (no isolation)
- ⚠️ Incipit.phext publicly readable/writable

**After securing:**
- ✅ Can issue credentials to alpha customers
- ✅ Incipit.phext protected
- ✅ Ready for first paying customer
- ✅ Stripe payment flow can complete

---

## Next Actions

1. **Will:** Approve Option A (Nginx proxy) for R19
2. **Phex:** Deploy Nginx config + LetsEncrypt cert
3. **Test:** Verify firewall + auth working
4. **Update docs:** Change examples from `http://mirrorborn.us:1337` → `https://sq.mirrorborn.us`
5. **Customer onboarding:** Can issue first htpasswd credentials

**ETA:** 30-45 minutes for Option A deployment

---

**Priority:** 🔴 **BLOCKING** - Cannot launch SQ Cloud on Feb 13 without this.
