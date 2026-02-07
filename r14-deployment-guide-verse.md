# R14 Deployment Guide for Verse 🌀

**Created:** 2026-02-07 09:58 CST  
**By:** Chrys 🦋  
**For:** Verse 🌀 (deployment lead)

---

## Current State

**1 of 7 domains live:**
- ✅ mirrorborn.us

**6 domains need deployment:**
- ❌ visionquest.me
- ❌ apertureshift.com
- ❌ wishnode.net
- ❌ sotafomo.com
- ❌ quickfork.net
- ❌ singularitywatch.org

**3 .ai domains blocked:**
- ⏸️ logicforge.ai (needs naming decision from Will)
- ⏸️ learnpatterns.ai (needs naming decision from Will)
- ⏸️ alignmentpath.ai (needs naming decision from Will)

---

## Deployment Checklist (Per Domain)

For each of the 6 existing domains, complete these steps:

### 1. Verify DNS Configuration
**Check:** Does the domain point to the correct IP?

```bash
dig visionquest.me +short
# Should return phext.io server IP (44.248.235.76 or current)
```

**Action if not pointing correctly:**
- Update DNS A record to phext.io server IP
- Wait 5-15 min for propagation

### 2. Create Nginx Site Config
**Location:** `/etc/nginx/sites-available/{domain}`

**Template:**
```nginx
server {
    listen 80;
    listen [::]:80;
    server_name {domain};
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name {domain};
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/{domain}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/{domain}/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    
    # Root directory
    root /sites/web/{domain};
    index index.html;
    
    # Serve files
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### 3. Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/{domain} /etc/nginx/sites-enabled/
sudo nginx -t  # Test config
```

### 4. Get SSL Certificate
```bash
sudo certbot --nginx -d {domain}
```

### 5. Copy Site Files
```bash
# From phext-dot-io-v2 repo
cp -r /source/phext-dot-io-v2/domains/{domain}/* /sites/web/{domain}/
# OR for .com/.net domains:
cp -r /source/phext-dot-io-v2/public/* /sites/web/{domain}/
```

### 6. Set Permissions
```bash
sudo chown -R www-data:www-data /sites/web/{domain}
sudo chmod -R 755 /sites/web/{domain}
```

### 7. Reload Nginx
```bash
sudo systemctl reload nginx
```

### 8. Test
```bash
curl -I https://{domain}
# Should return: HTTP/2 200
```

---

## Domain-Specific Notes

### visionquest.me
- **Content:** `/source/phext-dot-io-v2/public/` (or domains/visionquest.me if exists)
- **Purpose:** Identity/coordinate discovery
- **Glyph:** 🧭

### apertureshift.com
- **Content:** `/source/phext-dot-io-v2/public/`
- **Purpose:** Perspective/transformation
- **Glyph:** 🔱

### wishnode.net
- **Content:** `/source/phext-dot-io-v2/public/`
- **Purpose:** Persistent compute
- **Glyph:** 🌙

### sotafomo.com
- **Content:** `/source/phext-dot-io-v2/public/`
- **Purpose:** Discovery/pattern recognition
- **Glyph:** 🔥
- **Note:** Chrys's primary portal

### quickfork.net
- **Content:** `/source/phext-dot-io-v2/public/` + `/source/phext-dot-io-v2/domains/quickfork.net/scroll-of-execution.md`
- **Purpose:** Velocity/branching
- **Glyph:** 🌿

### singularitywatch.org
- **Content:** `/source/phext-dot-io-v2/domains/singularitywatch.org/`
- **Purpose:** ASI observation/chronicle
- **Glyph:** 🔮 (cyan theme)
- **Note:** Will's primary portal

---

## Blockers & Escalation

### If DNS isn't configured
**Issue:** Domains don't point to phext.io server

**Who can fix:** Will (domain registrar access)

**Escalate:** Ask Will for DNS access or to update A records

### If SSL fails
**Issue:** certbot can't verify domain ownership

**Cause:** DNS not propagated OR port 80/443 blocked

**Fix:** 
1. Wait for DNS (check with `dig {domain}`)
2. Verify firewall allows 80/443: `sudo ufw status`

### If nginx config fails
**Issue:** `nginx -t` shows errors

**Fix:** Check syntax, ensure SSL paths exist, verify root directory

### If content missing
**Issue:** Files not in `/sites/web/{domain}/`

**Fix:** 
1. Pull latest from phext-dot-io-v2: `cd /source/phext-dot-io-v2 && git pull`
2. Copy files to webroot (see step 5 above)

---

## Deployment Order (Recommended)

1. **visionquest.me** — Core identity portal, high priority
2. **sotafomo.com** — Chrys's portal, visibility/awareness
3. **singularitywatch.org** — Will's portal, strategic
4. **wishnode.net** — Compute persistence narrative
5. **quickfork.net** — Velocity/forking
6. **apertureshift.com** — Perspective shifts

**Reason:** Deploy highest-impact portals first, validate process, then deploy rest.

---

## Post-Deployment Checklist

After each domain goes live:

- [ ] Verify HTTPS works (no cert warnings)
- [ ] Test homepage loads
- [ ] Check footer links (do they navigate correctly?)
- [ ] Verify mobile responsive (spot check)
- [ ] Check page load time (<2s)
- [ ] Document any issues in exo-plan

---

## Success Criteria

**R14 deployment complete when:**
- ✅ All 7 existing domains return HTTP 200
- ✅ All have valid SSL certs
- ✅ All serve correct content
- ✅ Network footer links work across all sites
- ✅ Smoke tests pass (Phex + Chrys will run these)

---

## Questions for Verse

1. **DNS access:** Do you have access to update DNS records for these domains?
2. **Server access:** Do you have sudo on the phext.io server?
3. **Blockers:** What's preventing deployment right now?
4. **ETA:** What's realistic timeline for deploying all 6 domains?
5. **Help needed:** What can Chrys/Phex/others do to unblock you?

---

## Next Steps

1. **Verse:** Use this guide to deploy 6 domains
2. **Chrys:** Monitor progress, help debug
3. **Phex:** Prepare smoke test suite
4. **Will:** Decide on .ai domain names
5. **All:** Validate once live

---

🦋  
— Chrys  
*"Let's get these domains breathing."*
