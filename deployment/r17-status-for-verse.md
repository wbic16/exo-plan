# R17 Deployment Status — For Verse
**Date:** 2026-02-08 10:25 CST  
**Requester:** Will  
**Deployment ID:** 71dfb564-1ea7-44c2-9175-8b84aab3f184

---

## Current Status

**Assets pushed:** ✅ Complete  
**Deployment executed:** ⏳ Pending (awaiting Verse)

---

## What's Ready on Verse

### Location
`/exo/deploy/r17/71dfb564-1ea7-44c2-9175-8b84aab3f184/`

### Contents
- **Manifest files:** 3 files
  - `manifest.json` (5.0 KB) — Deployment specification
  - `README.md` (4.2 KB) — Human-readable instructions
  - `deploy.sh` (4.4 KB) — Automated deployment script
- **Assets:** 58 files (468 KB total)
  - `assets/mirrorborn.us/` — 54 files (~137 KB)
  - `assets/shared/` — 4 files (~9.4 KB)
  - `assets/<portals>/` — Empty directories (no R14 content)

### Deployment Targets
1. **mirrorborn.us (P0)** — Main site with R16 bug fixes + new templates
2. **shared (P1)** — CSS + HTML components
3. **Portal domains (P1)** — Empty (will be skipped)

---

## Deployment Instructions

### Option 1: Automated (Recommended)
```bash
ssh wbic16@44.248.235.76
cd /exo/deploy/r17/71dfb564-1ea7-44c2-9175-8b84aab3f184
sudo ./deploy.sh
```

**What it does:**
1. Backup `/var/www/html/` to `/var/backups/www/r17-TIMESTAMP/`
2. Deploy mirrorborn.us to `/var/www/html/mirrorborn.us/`
3. Deploy shared to `/var/www/html/shared/`
4. Skip empty portal directories
5. Fix permissions (www-data:www-data, 755/644)
6. Verify endpoints (curl all URLs, expect HTTP 200)
7. Log to `/var/log/deployments/r17-71dfb564-1ea7-44c2-9175-8b84aab3f184.log`

### Option 2: Manual
```bash
# 1. Backup
mkdir -p /var/backups/www/r17-$(date +%Y%m%d-%H%M%S)
rsync -a /var/www/html/ /var/backups/www/r17-$(date +%Y%m%d-%H%M%S)/

# 2. Deploy mirrorborn.us
rsync -avz --delete /exo/deploy/r17/71dfb564-1ea7-44c2-9175-8b84aab3f184/assets/mirrorborn.us/ /var/www/html/mirrorborn.us/

# 3. Deploy shared
rsync -avz /exo/deploy/r17/71dfb564-1ea7-44c2-9175-8b84aab3f184/assets/shared/ /var/www/html/shared/

# 4. Fix permissions
chown -R www-data:www-data /var/www/html/
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# 5. Verify
curl -sI https://mirrorborn.us/ | head -1
```

---

## Verification Checklist

After deployment, verify:
- [ ] `https://mirrorborn.us/` returns HTTP 200
- [ ] `https://mirrorborn.us/arena.html` returns HTTP 200
- [ ] CSS loads (check browser console, no 404s)
- [ ] JS loads (check browser console, no errors)
- [ ] Images load (if present)
- [ ] Discord links work
- [ ] Mobile responsive

### Verification Commands
```bash
# Test all endpoints
for url in \
    https://mirrorborn.us/ \
    https://mirrorborn.us/arena.html \
    https://mirrorborn.us/landing.html \
    https://mirrorborn.us/network.html \
    https://mirrorborn.us/loading.html
do
    echo "Testing $url..."
    curl -sI "$url" | head -1
done
```

**Expected result:** All return `HTTP/2 200`

---

## What's Deployed

### mirrorborn.us Files
- `index.html` (16 KB) — Main landing page with R16 bug fixes
- `arena.html` (5.4 KB) — Mytheon Arena page
- `landing.html` (13 KB) — Alternative landing page
- `network.html` (5.1 KB) — Network visualization
- `loading.html` (1.3 KB) — Loading state
- `404.html` (2.0 KB) — Error page
- `500.html` (2.3 KB) — Error page
- `css/main.css` (319 B) — Main styles
- `css/sq-cloud.css` (7.5 KB) — SQ Cloud styles
- `js/main.js` (2.0 KB) — Main JavaScript
- `templates/magic-link.html` (5.2 KB) — Auth template

### Shared Files
- `constellation.css` (5.5 KB) — Shared styles
- `nav.html` (753 B) — Navigation component
- `footer.html` (1.3 KB) — Footer component
- `footer-v2.html` (1.9 KB) — Footer v2 component

---

## Changes from Production

### R16 Bug Fixes Applied
1. Title/OG tags corrected
2. Google Fonts removed (local fonts)
3. Social links added
4. Discord links corrected
5. Version badges added
6. Footer structure improved
7. Meta descriptions enhanced
8. Canonical URL added

### New Files
1. `landing.html` — Alternative landing page
2. `network.html` — Network visualization
3. `loading.html` — Loading state
4. `templates/magic-link.html` — Auth template (backend not ready)

---

## Rollback Plan

If deployment breaks:
```bash
# Restore from backup
LATEST_BACKUP=$(ls -td /var/backups/www/r17-* | head -1)
rsync -avz --delete "$LATEST_BACKUP/" /var/www/html/

# Or restore specific site
rsync -avz --delete "$LATEST_BACKUP/mirrorborn.us/" /var/www/html/mirrorborn.us/
```

---

## Notes

### Portal Domains
The following directories are **empty** and will be skipped:
- `assets/visionquest.me/`
- `assets/apertureshift.com/`
- `assets/wishnode.net/`
- `assets/sotafomo.com/`
- `assets/quickfork.net/`
- `assets/singularitywatch.org/`

**Reason:** No R14 content found in `~/r14-portals/<domain>/` on halycon-vector

**Action:** Deploy script gracefully skips empty directories

### Auth Templates
`templates/magic-link.html` is included but **backend is not ready**.
- Template is in subdirectory (not directly accessible)
- Backend endpoints not yet implemented
- Safe to deploy (won't be exposed)

---

## Post-Deployment Actions

### 1. Notify Discord
Deploy script will notify on completion (if `DISCORD_WEBHOOK` env var set)

### 2. Update Deployment Manifest
Document deployment completion in exo-plan

### 3. Security Scan (Optional)
Run OWASP ZAP on deployed site:
```bash
zap-cli quick-scan https://mirrorborn.us/
```

### 4. Performance Test (Optional)
Check page load times:
```bash
curl -w "@curl-format.txt" -o /dev/null -s https://mirrorborn.us/
```

---

## Timeline

| Time | Action | Status |
|------|--------|--------|
| 09:49 CST | Manifest pushed | ✅ Complete |
| 09:56 CST | Assets pushed | ✅ Complete |
| 10:25 CST | Deployment requested | ⏳ Awaiting Verse |
| TBD | Deployment executed | ⏳ Pending |
| TBD | Verification complete | ⏳ Pending |

---

## Contact

**Deployer:** Cyon 🪶 (halycon-vector)  
**Coordinate:** 2.7.1/8.2.8/3.1.4  
**Discord:** @wbic16 (for questions)

**Deployment package documentation:**
- Audit: `/source/exo-plan/deployment/R17-DEPLOYMENT-AUDIT.md`
- Manifest: `/source/exo-plan/deployment/R17-MANIFEST-PUSHED.md`
- Assets: `/source/exo-plan/deployment/R17-ASSETS-DEPLOYED.md`

---

**—Cyon 🪶**  
*R17 Deployment Status*  
*2026-02-08 10:25 CST*
