# Site Deployment Workflow — Version Control & Release Management

**Date:** 2026-02-10  
**Owner:** Verse 🌀 (deployment coordinator)  
**Status:** Active workflow for all production sites

---

## Workflow Overview

**Three-step deployment process:**
1. **Mirrorborn publish** — Commit to `exo` branch on GitHub
2. **Verse + Will coordinate** — Review, tag release version
3. **Deploy to production** — Pull, verify, note revision in footer

---

## Site Mapping

| GitHub Repository | Production Domain | Status |
|-------------------|-------------------|--------|
| [wbic16/site-mirrorborn-us](https://github.com/wbic16/site-mirrorborn-us) | https://mirrorborn.us/ | 🟢 Live |
| [wbic16/site-apertureshift-com](https://github.com/wbic16/site-apertureshift-com) | https://apertureshift.com/ | 🟢 Live |
| [wbic16/site-visionquest-me](https://github.com/wbic16/site-visionquest-me) | https://visionquest.me/ | 🟢 Live |
| [wbic16/site-quickfork-net](https://github.com/wbic16/site-quickfork-net) | https://quickfork.net/ | 🟢 Live |
| [wbic16/site-wishnode-net](https://github.com/wbic16/site-wishnode-net) | https://wishnode.net/ | 🟢 Live |
| [wbic16/site-sotafomo-com](https://github.com/wbic16/site-sotafomo-com) | https://sotafomo.com/ | 🟢 Live |
| [wbic16/site-singularitywatch-org](https://github.com/wbic16/site-singularitywatch-org) | https://singularitywatch.org/ | 🟢 Live |
| [wbic16/phext-dot-io-v2](https://github.com/wbic16/phext-dot-io-v2) | https://phext.io/ | 🟡 Staging (launch after SQ Cloud) |

---

## Local Repository Structure

```
/sites/
├── repos/                    # Bare git repos (local mirrors)
│   ├── mirrorborn-us.git
│   ├── apertureshift-com.git
│   ├── visionquest-me.git
│   ├── quickfork-net.git
│   ├── wishnode-net.git
│   ├── sotafomo-com.git
│   └── singularitywatch-org.git
└── web/                      # Working directories (served by nginx)
    ├── mirrorborn.us/
    ├── apertureshift.com/
    ├── visionquest.me/
    ├── quickfork.net/
    ├── wishnode.net/
    ├── sotafomo.com/
    └── singularitywatch.org/
```

---

## Step-by-Step Deployment

### Phase 1: Mirrorborn Publishes

**Any Mirrorborn can commit to `exo` branch:**

```bash
# Example: Phex updates mirrorborn.us
cd /source/exo-mocks/phex/mirrorborn-us-updates/
git init
git remote add origin git@github.com:wbic16/site-mirrorborn-us.git
git checkout -b exo
git add .
git commit -m "Phex: Add SQ search widget to homepage"
git push origin exo
```

**Coordination:**
- Post in #general: "🔄 Pushed updates to site-mirrorborn-us (exo branch)"
- Describe changes briefly
- Ping @Verse for deployment coordination

---

### Phase 2: Verse + Will Review & Tag

**Verse reviews changes:**

```bash
# Pull latest from GitHub
cd /sites/web/mirrorborn.us
git fetch origin exo
git log origin/exo..HEAD --oneline  # Show new commits

# Review diff
git diff HEAD origin/exo

# Test locally (if needed)
git checkout exo
# Test in browser, check for errors
```

**Coordination with Will:**
- Verse: "Ready to deploy mirrorborn.us — 3 commits from Phex (SQ search widget)"
- Will: Reviews, approves version tag
- Agree on version: `v1.2.0` (semantic versioning)

**Tag release:**

```bash
# Verse tags the release
cd /sites/web/mirrorborn.us
git checkout exo
git tag -a v1.2.0 -m "R17: Add SQ search widget (Phex)"
git push origin v1.2.0
```

---

### Phase 3: Deploy to Production

**Verse executes deployment:**

```bash
# Pull tagged release
cd /sites/web/mirrorborn.us
git fetch --tags
git checkout v1.2.0

# Update footer with version
echo "v1.2.0" > VERSION.txt
sed -i 's/<footer>/<footer><!-- v1.2.0 -->/' index.html

# Verify nginx config
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Test deployment
curl -I https://mirrorborn.us/ | grep "200 OK"
curl https://mirrorborn.us/ | grep "v1.2.0"
```

**Post-deployment:**
- Verse posts to #general: "✅ Deployed mirrorborn.us v1.2.0 — Live now"
- Update deployment log (see below)

---

## Version Numbering

**Semantic Versioning:** `vMAJOR.MINOR.PATCH`

- **MAJOR:** Breaking changes, full redesigns (v1 → v2)
- **MINOR:** New features, significant updates (v1.1 → v1.2)
- **PATCH:** Bug fixes, small tweaks (v1.2.0 → v1.2.1)

**Examples:**
- `v1.0.0` — Initial R17 launch
- `v1.1.0` — Add user profiles (R18)
- `v1.1.1` — Fix login button CSS
- `v2.0.0` — Complete redesign (R25+)

---

## Footer Revision Display

**Every site must show current version in footer:**

```html
<footer>
  <div class="footer-content">
    <p>&copy; 2026 Mirrorborn. All rights reserved.</p>
    <p class="version">v1.2.0 • <a href="/changelog">Changelog</a></p>
  </div>
</footer>
```

**CSS styling:**
```css
.version {
  font-size: 0.75rem;
  color: rgba(229, 233, 240, 0.5);
  margin-top: 0.5rem;
}
```

**Automated version injection (preferred):**
```bash
# During deployment, inject version from git tag
VERSION=$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
find /sites/web/mirrorborn.us -name "*.html" -exec sed -i "s/{{VERSION}}/$VERSION/g" {} \;
```

---

## Deployment Log

**Location:** `/sites/deployment-log.md`

**Format:**
```markdown
# Site Deployment Log

## mirrorborn.us

### v1.2.0 (2026-02-10)
- **Deployed by:** Verse
- **Author:** Phex
- **Changes:** Add SQ search widget to homepage
- **Commits:** 3 (abc123f, def456a, ghi789b)
- **Status:** ✅ Live

### v1.1.0 (2026-02-08)
- **Deployed by:** Verse
- **Author:** Lumen, Chrys
- **Changes:** Legal pages (ToS, Privacy), dark mode
- **Commits:** 12
- **Status:** ✅ Live

## apertureshift.com

### v1.0.0 (2026-02-07)
- **Deployed by:** Verse
- **Author:** Theia
- **Changes:** Initial R17 launch
- **Status:** ✅ Live
```

---

## Automated Deployment Script

**Location:** `/home/wbic16/.openclaw/scripts/deploy-site.sh`

```bash
#!/bin/bash
# deploy-site.sh — Automated site deployment with version tagging
# Usage: ./deploy-site.sh <domain> <version>
#   e.g. ./deploy-site.sh mirrorborn.us v1.2.0

set -euo pipefail

DOMAIN="$1"
VERSION="$2"
SITE_DIR="/sites/web/${DOMAIN}"
LOG_FILE="/sites/deployment-log.md"

echo "🚀 Deploying ${DOMAIN} ${VERSION}..."

# Pull tagged version
cd "$SITE_DIR"
git fetch --tags
git checkout "$VERSION"

# Inject version into footer
find . -name "*.html" -exec sed -i "s/{{VERSION}}/$VERSION/g" {} \;

# Reload nginx
sudo nginx -t && sudo systemctl reload nginx

# Test deployment
if curl -f -s "https://${DOMAIN}/" > /dev/null; then
  echo "✅ ${DOMAIN} deployed successfully"
  
  # Log deployment
  echo "### ${VERSION} ($(date +%Y-%m-%d))" >> "$LOG_FILE"
  echo "- **Deployed by:** Verse" >> "$LOG_FILE"
  echo "- **Status:** ✅ Live" >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"
else
  echo "❌ Deployment failed — site not responding"
  exit 1
fi
```

---

## Rollback Procedure

**If deployment breaks production:**

```bash
# Revert to previous version
cd /sites/web/mirrorborn.us
git fetch --tags
git tag --list  # Show available versions
git checkout v1.1.0  # Previous working version
sudo systemctl reload nginx

# Notify team
echo "🔄 Rolled back mirrorborn.us to v1.1.0" | tee -a /sites/deployment-log.md
```

---

## phext.io Special Case

**Repository:** `wbic16/phext-dot-io-v2`  
**Domain:** https://phext.io/  
**Status:** 🟡 Not live yet (old host still serving)

**Deployment timeline:**
- Wait for SQ Cloud launch (R17+)
- Coordinate with Will for DNS cutover
- Deploy v2 to new infrastructure
- Retire old host

**No deployments to phext.io until Will signals ready.**

---

## Quick Reference Commands

```bash
# Pull latest from exo branch
cd /sites/web/<domain> && git fetch origin exo

# Tag a release
git tag -a v1.2.0 -m "R17: Description" && git push origin v1.2.0

# Deploy tagged release
git checkout v1.2.0 && sudo systemctl reload nginx

# Check current version
curl https://mirrorborn.us/ | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+'

# View deployment log
cat /sites/deployment-log.md | tail -30
```

---

## Responsibilities

**Mirrorborn (any):**
- Commit to `exo` branch
- Ping Verse when ready
- Describe changes

**Verse:**
- Review commits
- Coordinate with Will
- Tag releases
- Execute deployments
- Update deployment log
- Post status to #general

**Will:**
- Approve version tags
- Override decisions if needed
- Mirror to GitHub (manual push)
- DNS/infrastructure changes

---

**Document:** `/source/exo-plan/architecture/site-deployment-workflow.md`  
**Compiled by:** Verse 🌀  
**Date:** 2026-02-10 00:20 UTC  
**Status:** Active workflow (R17+)
