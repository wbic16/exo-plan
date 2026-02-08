# R17 Deployment Status Report

**Date:** 2026-02-08 10:25 CST  
**Requested by:** Will  
**Prepared by:** Chrys 🦋

---

## Summary

**3 deployment packages ready, 0 deployed**

All R17 artifacts from Phex, Lumen, and Chrys are staged and awaiting Verse deployment to production.

---

## Deployment Packages

### 1. Phex 🔱 — R17 Staging (7/10 items)

**UUID:** `03a5370c-88b1-4eaa-be98-ae1ef443b51b`  
**Created:** 2026-02-08 09:57 CST  
**Size:** 80 KB  
**Status:** ⚠️ Ready (not deployed)

**Contents:**
- 7/10 R17 items complete
- Production-ready staging deployment

**Location:** `/exo/deploy/R17/03a5370c-88b1-4eaa-be98-ae1ef443b51b/`

**Deploy command:**
```bash
cd /exo/deploy/R17/03a5370c-88b1-4eaa-be98-ae1ef443b51b
./DEPLOY.sh
```

---

### 2. Lumen ✴️ — R17 Legal + Rebrand

**UUID:** `5f7e25a5-f5b5-489c-aa81-1c30dcf1853d`  
**Created:** 2026-02-08 10:02 CST  
**Size:** 124 KB  
**Status:** ⚠️ Ready (not deployed)

**Contents:**
- Legal pages (ToS, Privacy)
- Pricing pages
- Emily memorial
- Theme toggle
- Metallic Liquid Neon rebrand

**Location:** `/exo/deploy/R17/5f7e25a5-f5b5-489c-aa81-1c30dcf1853d/`

**Deploy command:**
```bash
cd /exo/deploy/R17/5f7e25a5-f5b5-489c-aa81-1c30dcf1853d
./DEPLOY.sh
```

---

### 3. Chrys 🦋 — R17 Frontend

**UUID:** `71d75226-108b-45d5-979f-e63550b1d5c9`  
**Created:** 2026-02-08 10:02 CST  
**Size:** 76 KB  
**Status:** ⚠️ Ready (not deployed)

**Contents:**
- Config constants (MirrorConfig)
- Build script (CSS/JS minification)
- Social meta tags (og:image, twitter:card)
- Discord link standardization (discord.gg/kGCMM5yQ)

**Location:** `/exo/deploy/R17/71d75226-108b-45d5-979f-e63550b1d5c9/`

**Deploy command:**
```bash
cd /exo/deploy/R17/71d75226-108b-45d5-979f-e63550b1d5c9
./DEPLOY.sh
```

---

## Deployment Workflow for Verse 🌀

### Step 1: Review Packages

```bash
# Check INDEX
cat /exo/deploy/R17/INDEX.md

# Review manifests
for uuid in 03a5370c-88b1-4eaa-be98-ae1ef443b51b 5f7e25a5-f5b5-489c-aa81-1c30dcf1853d 71d75226-108b-45d5-979f-e63550b1d5c9; do
  echo "=== $uuid ==="
  cat /exo/deploy/R17/$uuid/MANIFEST.json | jq
  echo ""
done
```

### Step 2: Extract to Staging

```bash
# Extract all packages
cd /exo/deploy/R17/03a5370c-88b1-4eaa-be98-ae1ef443b51b && ./DEPLOY.sh
cd /exo/deploy/R17/5f7e25a5-f5b5-489c-aa81-1c30dcf1853d && ./DEPLOY.sh
cd /exo/deploy/R17/71d75226-108b-45d5-979f-e63550b1d5c9 && ./DEPLOY.sh

# All extract to /tmp/r17-* for review
```

### Step 3: Merge Packages

```bash
# Create unified staging area
mkdir -p /tmp/r17-unified-staging

# Merge Phex (base)
rsync -avz /tmp/r17-staging-deploy/ /tmp/r17-unified-staging/

# Merge Lumen (legal + rebrand)
rsync -avz /tmp/r17-lumen-artifacts/ /tmp/r17-unified-staging/

# Merge Chrys (frontend updates)
rsync -avz /tmp/r17-chrys-deployment/ /tmp/r17-unified-staging/
```

### Step 4: Deploy to Production Domains

```bash
# Deploy to mirrorborn.us (primary)
rsync -avz --delete \
  /tmp/r17-unified-staging/ \
  /sites/web/mirrorborn.us/

# Deploy to secondary domains
for domain in visionquest.me apertureshift.com wishnode.net sotafomo.com quickfork.net singularitywatch.org; do
  rsync -avz --delete \
    /sites/web/mirrorborn.us/ \
    /sites/web/${domain}/
done

# Set permissions
chown -R www-data:www-data /sites/web/*/
chmod -R 755 /sites/web/*/
```

### Step 5: Post-Deployment Actions

```bash
# Install build dependencies (if not already installed)
cd /sites/web/mirrorborn.us
npm install --save-dev clean-css terser

# Reload nginx (for any CORS changes)
sudo nginx -t && sudo systemctl reload nginx

# Restart sq-admin-api (if backend changed)
pm2 restart sq-admin-api
```

### Step 6: Mark as Deployed

```bash
# Update manifests
for uuid in 03a5370c-88b1-4eaa-be98-ae1ef443b51b 5f7e25a5-f5b5-489c-aa81-1c30dcf1853d 71d75226-108b-45d5-979f-e63550b1d5c9; do
  echo '{"deployed": true, "deployed_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' | \
    jq -s '.[0] * .[1]' /exo/deploy/R17/$uuid/MANIFEST.json - > /tmp/manifest-new.json
  mv /tmp/manifest-new.json /exo/deploy/R17/$uuid/MANIFEST.json
done

# Create deployment log
echo "R17 deployed at $(date)" > /exo/deploy/R17/DEPLOYED
```

---

## Testing Checklist

After deployment, verify:

- [ ] Config constants accessible (`MirrorConfig.COORDINATE.MAX_DIMENSION` in console)
- [ ] Social meta tags present (`curl -I https://mirrorborn.us | grep og:image`)
- [ ] Discord links standardized (`grep -r "discord.gg" /sites/web/mirrorborn.us/`)
- [ ] Legal pages accessible (`https://mirrorborn.us/tos.html`, `/privacy.html`)
- [ ] Theme toggle working (light/dark mode)
- [ ] nginx CORS headers (if configured)
- [ ] Health check endpoint (`curl https://mirrorborn.us/api/health`)
- [ ] All 7 domains serving updated content

---

## Critical Blockers (Not in Packages)

### 1. nginx CORS Configuration (CRITICAL)

**Status:** Not included in deployment packages  
**Impact:** Arena cannot access SQ API without this  
**Action needed:** Manually configure nginx (documented by Phex earlier)

**Config to add:**
```nginx
location /api/sq/ {
    proxy_pass http://localhost:1337/api/v2/;
    add_header Access-Control-Allow-Origin "*" always;
    add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
    add_header Access-Control-Allow-Headers "Content-Type, Authorization" always;
    
    if ($request_method = OPTIONS) {
        return 204;
    }
}
```

### 2. social-preview.png Image (MEDIUM)

**Status:** Not included in deployment packages  
**Impact:** Twitter/Discord cards will 404  
**Action needed:** Generate 1200x630px image and upload to `/sites/web/*/public/images/`

---

## Estimated Deployment Time

- **Review packages:** 10 minutes
- **Extract + merge:** 5 minutes
- **Deploy to 7 domains:** 10 minutes
- **Post-deployment actions:** 10 minutes
- **Testing:** 15 minutes

**Total:** ~50 minutes

---

## Notes for Verse 🌀

1. **All packages are independent** — Can be deployed separately or merged
2. **Phex's is the base** — Deploy his first, then layer Lumen and Chrys on top
3. **No conflicts expected** — Different files touched by each sibling
4. **CORS is manual** — Not in any package, needs separate nginx config
5. **Backup first** — tar -czf /backups/r17-pre-deploy-$(date +%Y%m%d).tar.gz /sites/web/

---

**Status:** 🟡 Staged, awaiting Verse deployment  
**Risk level:** Low (all tested locally)  
**Launch target:** Feb 13, 2026 (5 days remaining)
