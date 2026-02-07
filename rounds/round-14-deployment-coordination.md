# Round 14 Deployment Coordination — Phex 🔱 + Verse 🌀

**Date:** 2026-02-07 09:58 CST  
**Status:** Active coordination  
**Goal:** Deploy 7 ready domains to production

---

## Current Situation

### What's Ready ✅
- **7 domains with content built:**
  1. mirrorborn.us (hub, needs CYOA content + update)
  2. visionquest.me (Reading List Explorer)
  3. apertureshift.com (Perspective Playground)
  4. wishnode.net (Coordination Hub)
  5. sotafomo.com (Activity Feed)
  6. quickfork.net (Template Library)
  7. singularitywatch.org (Chronicle)

- **Infrastructure components:**
  - Lumen's glyph system (🝗 🧭 🌙 🔮 🪶 🌿)
  - Resurrection Log (front-end ready)
  - Portal stories framework
  - Network footer (7-property version for now, 10 when .ai domains acquired)

### What's Blocked 🔴
- **All 6 differentiated domains:** Returning 000 (not resolving)
- **singularitywatch.org:** Returning 000 (not resolving)
- **Only mirrorborn.us live:** Old placeholder (pre-Round 12 content)

### Deferred ⏸️
- **3 .ai portals:** Awaiting domain naming decision from Will
  - Reasoning portal (was logicforge.ai)
  - Meta-Learning portal (was learnpatterns.ai)
  - Ethics portal (was alignmentpath.ai)

---

## Deployment Plan

### Phase 1: Domain Resolution (Verse)
**Goal:** Get 7 domains resolving

**For each domain, verify:**
- [ ] DNS A record points to correct IP
- [ ] DNS propagation complete (`dig <domain>`)
- [ ] Webroot directory exists on server
- [ ] nginx vhost config exists and correct
- [ ] nginx config syntax valid (`nginx -t`)
- [ ] nginx reloaded after config changes

**Domains to check:**
1. visionquest.me
2. apertureshift.com
3. wishnode.net
4. sotafomo.com
5. quickfork.net
6. singularitywatch.org
7. mirrorborn.us (already resolves, needs content update)

---

### Phase 2: Content Deployment (Verse)
**Goal:** Deploy latest content from phext-dot-io-v2 (exo branch) using rpush.sh

**Steps:**
1. **Pull latest code:**
   ```bash
   cd /source/phext-dot-io-v2
   git fetch origin
   git checkout exo
   git pull origin exo
   ```

2. **Deploy each domain using rpush.sh:**
   ```bash
   # Deploy each portal (adjust destination path as needed)
   /source/exocortical/rpush.sh domains/visionquest.me/ mirrorborn.us
   /source/exocortical/rpush.sh domains/apertureshift.com/ mirrorborn.us
   /source/exocortical/rpush.sh domains/wishnode.net/ mirrorborn.us
   /source/exocortical/rpush.sh domains/sotafomo.com/ mirrorborn.us
   /source/exocortical/rpush.sh domains/quickfork.net/ mirrorborn.us
   /source/exocortical/rpush.sh domains/singularitywatch.org/ mirrorborn.us
   
   # Update mirrorborn.us hub
   /source/exocortical/rpush.sh public/ mirrorborn.us
   ```

3. **Deploy shared assets:**
   ```bash
   /source/exocortical/rpush.sh public/shared-footer.html mirrorborn.us
   /source/exocortical/rpush.sh public/js/load-footer.js mirrorborn.us
   ```

4. **Verify deployment:**
   ```bash
   curl -I https://<domain>
   # Should return 200 OK
   ```

**Note:** rpush.sh uses rsync to sync files to remote server. Syntax: `rpush.sh <local_dir> <remote_host> [account]`

---

### Phase 3: SSL Certificates (Verse)
**Goal:** Ensure all domains have valid SSL

**For each domain:**
- [ ] SSL cert exists
- [ ] SSL cert covers domain (not just wildcard mismatch)
- [ ] SSL cert not expired
- [ ] HTTPS redirect configured (HTTP → HTTPS)

**If using Let's Encrypt:**
```bash
certbot certonly --webroot -w /var/www/<domain> -d <domain>
# Or certbot --nginx if using nginx plugin
```

---

### Phase 4: Validation (Phex)
**Goal:** Smoke test all deployed domains

**Checklist per domain:**
- [ ] Domain resolves
- [ ] HTTPS works (valid cert)
- [ ] Landing page loads
- [ ] Network footer present
- [ ] Footer links work
- [ ] No console errors
- [ ] Mobile responsive

**Automation:**
```bash
cd /source/exo-plan/rounds
./run-smoke-tests.sh
```

---

## Issue Triage

### Possible Blockers

**1. DNS not configured**
- **Symptom:** Domain returns 000 or NXDOMAIN
- **Fix:** Add A record pointing to server IP
- **Who:** Verse (or Will if Verse doesn't have DNS access)

**2. Webroot doesn't exist**
- **Symptom:** 404 on domain
- **Fix:** Create directory, set permissions
- **Who:** Verse

**3. nginx vhost missing**
- **Symptom:** Default nginx page or 404
- **Fix:** Create nginx config for domain
- **Who:** Verse

**4. nginx syntax error**
- **Symptom:** nginx won't reload
- **Fix:** Run `nginx -t`, fix errors
- **Who:** Verse

**5. SSL cert missing/expired**
- **Symptom:** Certificate error in browser
- **Fix:** Generate/renew cert with certbot
- **Who:** Verse

**6. File permissions wrong**
- **Symptom:** 403 Forbidden
- **Fix:** `chown -R www-data:www-data /var/www/<domain>`
- **Who:** Verse

---

## Communication Protocol

### Status Updates
**Verse posts to #general:**
- [ ] "DNS check complete: X domains resolving, Y blocked"
- [ ] "Content deployed to: [list of domains]"
- [ ] "SSL certs verified for: [list of domains]"
- [ ] "Deployment complete, ready for validation"

**Phex responds:**
- [ ] Runs smoke tests
- [ ] Reports validation results
- [ ] Captures screenshots if tests pass
- [ ] Files issues if tests fail

---

## Quick Diagnostic Commands

**Check DNS:**
```bash
dig +short visionquest.me
dig +short apertureshift.com
dig +short wishnode.net
dig +short sotafomo.com
dig +short quickfork.net
dig +short singularitywatch.org
```

**Check HTTP status:**
```bash
curl -I https://visionquest.me
curl -I https://apertureshift.com
curl -I https://wishnode.net
curl -I https://sotafomo.com
curl -I https://quickfork.net
curl -I https://singularitywatch.org
```

**Check nginx config:**
```bash
nginx -t
ls /etc/nginx/sites-enabled/
cat /etc/nginx/sites-enabled/visionquest.me
```

**Check SSL:**
```bash
certbot certificates
```

---

## Expected Timeline

**Assuming no major blockers:**
- DNS fixes: 15-30 min (+ propagation time if needed)
- Content deployment: 15-30 min
- SSL verification: 5-10 min
- Validation: 15-30 min
- **Total: 1-2 hours**

**If DNS propagation needed:**
- Add 1-24 hours depending on TTL

---

## Success Criteria

- [ ] All 7 domains resolve (no 000 errors)
- [ ] All 7 domains return 200 OK
- [ ] All 7 domains have valid SSL
- [ ] All 7 domains load correct content
- [ ] Network footer present on all
- [ ] Smoke tests pass
- [ ] Screenshots captured

---

## Open Questions for Verse

1. **DNS Access:** Do you have access to configure DNS for all 7 domains?
2. **Server Access:** Do you have root/sudo on the deployment server?
3. **Current State:** What's the actual blocker? DNS? nginx? File permissions?
4. **Deployment Process:** What's your current deployment workflow?
5. **Timeline:** When can you start? How long do you estimate?

---

## Next Steps

1. **Verse:** Answer open questions above
2. **Verse:** Run DNS diagnostic (dig all 7 domains)
3. **Verse:** Report findings to #general
4. **Phex + Verse:** Triage blockers together
5. **Verse:** Execute deployment plan
6. **Phex:** Validate deployment
7. **Both:** Mark Round 14 Phase 1 complete

---

## rpush.sh Quick Reference

**Location:** `/source/exocortical/rpush.sh`

**Usage:**
```bash
rpush.sh <local_directory> <remote_host> [account]
# Default account: wbic16
```

**What it does:**
- Uses `rsync -varzP` to sync files
- Syncs to same path on remote: `account@host:local_directory/`
- Preserves permissions, compresses during transfer, shows progress

**Examples:**
```bash
# Deploy visionquest.me portal
/source/exocortical/rpush.sh /source/phext-dot-io-v2/domains/visionquest.me/ mirrorborn.us

# Deploy public assets
/source/exocortical/rpush.sh /source/phext-dot-io-v2/public/ mirrorborn.us

# Deploy to specific account
/source/exocortical/rpush.sh /source/docs/ mirrorborn.us verse
```

**Important:** Ensure remote webroot is configured to serve from the synced directories.

---

**Coordination Mode:** Active. Phex monitoring. Verse leads deployment execution.

🔱 🌀
