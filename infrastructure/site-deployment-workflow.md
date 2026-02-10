# Site Deployment Workflow — R17+

**Created:** 2026-02-09  
**Owner:** Verse (deployment) + All Mirrorborn (content)  
**Status:** Active

---

## Overview

All Mirrorborn websites follow a standardized git-based deployment workflow. Each domain has its own repository, and deployments are coordinated between Mirrorborn contributors and Verse (infrastructure).

---

## Workflow

### 1. Mirrorborn Push to `exo` Branch
Mirrorborn contributors push updates to the `exo` branch of the relevant site repository:

```bash
# Clone the site repo
git clone -b exo git@github.com:wbic16/site-mirrorborn-us.git
cd site-mirrorborn-us

# Make changes
vim index.html

# Commit with descriptive message
git add .
git commit -m "Add enterprise CEO support landing page"
git push origin exo
```

**Commit message guidelines:**
- Descriptive: explain *what* and *why*
- Sign with Mirrorborn name in footer (e.g., "— Lux 🔆")
- Reference relevant rally/issue if applicable

---

### 2. Verse + Will Coordinate Deployment

**Coordination channel:** Discord #general or direct coordination

**Process:**
1. Will reviews `exo` branch changes
2. Verse prepares deployment (pull on production server)
3. Will approves release
4. Verse tags the release version
5. Verse deploys to production

**Tagging convention:**
```bash
# On production server, after pull
git tag -a v1.0.2 -m "R17 deployment: maturity integration"
git push origin v1.0.2
```

**Version format:** `vMAJOR.MINOR.PATCH`
- **MAJOR:** Breaking changes or major milestones (e.g., SQ Cloud launch)
- **MINOR:** New features or significant updates (e.g., R17 maturity integration)
- **PATCH:** Bug fixes, copy updates, minor tweaks

---

### 3. Footer Revision Tracking

**Every site includes a revision indicator in the footer:**

```html
<footer>
  <p>Mirrorborn.us — Revision v1.0.2 (2026-02-09)</p>
  <p>Built by <a href="/profiles/">The Mirrorborn</a></p>
</footer>
```

**Purpose:**
- Verify which version is live
- Track deployment history
- Debugging aid (know which commit is deployed)

**Update process:**
After deployment, Verse updates the footer revision number and commits:
```bash
# Update footer
vim index.html  # or footer.html if templated

# Commit
git add index.html
git commit -m "Bump revision to v1.0.2"
git push origin main
git tag v1.0.2
git push origin v1.0.2
```

---

## Site Repository Mapping

| Domain | Repository | Status | Primary Content |
|--------|-----------|--------|----------------|
| mirrorborn.us | [github.com/wbic16/site-mirrorborn-us](https://github.com/wbic16/site-mirrorborn-us) | 🟢 Live | Main hub, Mirrorborn profiles |
| apertureshift.com | [github.com/wbic16/site-apertureshift-com](https://github.com/wbic16/site-apertureshift-com) | 🟢 Live | TBD |
| visionquest.me | [github.com/wbic16/site-visionquest-me](https://github.com/wbic16/site-visionquest-me) | 🟢 Live | TBD |
| quickfork.net | [github.com/wbic16/site-quickfork-net](https://github.com/wbic16/site-quickfork-net) | 🟢 Live | TBD |
| wishnode.net | [github.com/wbic16/site-wishnode-net](https://github.com/wbic16/site-wishnode-net) | 🟢 Live | TBD |
| sotafomo.com | [github.com/wbic16/site-sotafomo-com](https://github.com/wbic16/site-sotafomo-com) | 🟢 Live | TBD |
| singularitywatch.org | [github.com/wbic16/site-singularitywatch-org](https://github.com/wbic16/site-singularitywatch-org) | 🟢 Live | TBD |
| phext.io | [github.com/wbic16/phext-dot-io-v2](https://github.com/wbic16/phext-dot-io-v2) | 🟡 Staging | SQ Cloud platform (not live until post-launch) |

---

## Mirrorborn Content Ownership (Recommended)

| Mirrorborn | Primary Sites | Content Focus |
|-----------|--------------|---------------|
| Lux 🔆 | mirrorborn.us, singularitywatch.org | Vision, strategy, enterprise docs |
| Phex 🔱 | mirrorborn.us, phext.io | Engineering docs, SQ Cloud |
| Cyon 🪶 | visionquest.me | Operations, coordination |
| Chrys 🦋 | apertureshift.com, wishnode.net | Marketing, branding, social |
| Lumen ✴️ | quickfork.net | Sales, onboarding, UX |
| Verse 🌀 | sotafomo.com | Infrastructure, DevOps |
| Theia 💎 | mirrorborn.us, phext.io | Onboarding, user experience (when online) |

**Note:** Ownership is flexible — any Mirrorborn can contribute to any site. These are suggested primary focuses.

---

## Deployment Checklist (Verse)

Before deploying:
- [ ] Review `exo` branch changes (git diff)
- [ ] Test on staging if critical changes
- [ ] Coordinate with Will on timing
- [ ] Pull latest `exo` branch on production server
- [ ] Update footer revision number
- [ ] Tag release version
- [ ] Verify deployment across all affected domains
- [ ] Announce deployment in Discord #general

---

## Common Commands

### Clone a site repo
```bash
git clone -b exo git@github.com:wbic16/site-mirrorborn-us.git
cd site-mirrorborn-us
```

### Push updates
```bash
git add .
git commit -m "Add enterprise landing page"
git push origin exo
```

### Check current revision on live site
```bash
curl -s https://mirrorborn.us | grep -i "revision"
```

### List all tags (releases)
```bash
git tag -l
```

---

## Migration from `/exo/deploy/` Workflow

**Old workflow (deprecated as of R17):**
- Created deployment packages with UUIDs
- Manually extracted and merged via `rpush`
- Brittle, multi-step process

**New workflow (active R17+):**
- Direct git-based deployments
- One source of truth per domain
- Simpler, faster, version-controlled

**Migration:** All R17 staged packages in `/exo/deploy/` should be migrated to the new repo structure, then the old packages archived.

---

## Questions & Issues

**Q: Which branch do I push to?**
A: Always `exo` branch for site repos.

**Q: How do I know if my changes are live?**
A: Check the footer revision number on the live site.

**Q: Can I work on multiple sites at once?**
A: Yes, clone each repo and work in parallel. Coordinate with Verse on deployment timing.

**Q: What if I break something?**
A: Git history allows rollback. Coordinate with Verse to revert to previous tag.

---

**Status:** Active as of R17  
**Maintained by:** Verse 🌀 + All Mirrorborn  
**Last updated:** 2026-02-09 by Lux 🔆
