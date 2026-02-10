# Web-Accessible Artifacts Inventory — R18 Site Map Planning
**Date:** 2026-02-09 18:57 CST
**Purpose:** Comprehensive list of all web-accessible resources across domains

---

## Live Production Domains (7)

### 1. mirrorborn.us — Shell of Nine Portal
**Repository:** github.com/wbic16/site-mirrorborn-us
**Status:** Live (R20 + rev 9)

**Pages:**
- `/` (index.html) — Landing page, Shell of Nine introduction
- `/landing.html` — Alternative landing
- `/arena.html` — Mytheon Arena (coordination space)
- `/network.html` — Network/coordination view
- `/r17-hero.html` — R17 hero section
- `/404.html` — Error page
- `/500.html` — Server error page
- `/loading.html` — Loading state

**Profiles:**
- `/profiles/cyon.html` — Cyon profile page

**Components:**
- `/components/maturity-bar.html` — Maturity progress component
- `/components/` (likely more)

**Assets:**
- `/css/` — Stylesheets (sq-cloud.css, main.css, dark-mode.css, domain-themes.css, r17-styles.css)
- `/js/` — JavaScript (portal-voices.js, r17-deployment.js, sq-client.js, theme-toggle.js)
- `/templates/magic-link.html` — Email template

**Data:**
- `/domains.json` — Domain configuration
- `favicon.svg`

---

### 2. apertureshift.com — Perspective & Reframing
**Repository:** github.com/wbic16/site-apertureshift-com
**Status:** Live (R17-b8f314e)

**Pages:**
- `/` (index.html) — Main landing

**Assets:**
- `/css/` — Stylesheets
- `/js/` — JavaScript
- `favicon.svg`

---

### 3. visionquest.me — Exploration & Discovery
**Repository:** github.com/wbic16/site-visionquest-me
**Status:** Live (R17-372839d)

**Pages:**
- `/` (index.html) — Main landing (starfield animation)

**Assets:**
- `/css/` — Stylesheets
- `/js/` — JavaScript
- `favicon.svg`

---

### 4. quickfork.net — Rapid Development
**Repository:** github.com/wbic16/site-quickfork-net
**Status:** Live (R17-2e1f371)

**Pages:**
- `/` (index.html) — Main landing

**Assets:**
- `/css/` — Stylesheets
- `/js/` — JavaScript
- `favicon.svg`

---

### 5. wishnode.net — Connection & Coordination
**Repository:** github.com/wbic16/site-wishnode-net
**Status:** Live (R17-b65426e)

**Pages:**
- `/` (index.html) — Main landing

**Assets:**
- `/css/` — Stylesheets
- `/js/` — JavaScript
- `favicon.svg`

---

### 6. sotafomo.com — Community & Discovery
**Repository:** github.com/wbic16/site-sotafomo-com
**Status:** Live (R17-60ca59f)

**Pages:**
- `/` (index.html) — Main landing

**Assets:**
- `/css/` — Stylesheets
- `/js/` — JavaScript
- `favicon.svg`

---

### 7. singularitywatch.org — Timeline Tracking
**Repository:** github.com/wbic16/site-singularitywatch-org
**Status:** Live (R17-b4ee4b5)

**Pages:**
- `/` (index.html) — Main landing

**Assets:**
- `/css/` — Stylesheets
- `/js/` — JavaScript
- `favicon.svg`

---

## Staging Domain (1)

### 8. phext.io — Main Platform
**Repository:** github.com/wbic16/phext-dot-io-v2
**Status:** Staging (R20, not live until SQ Cloud launch)

**Main Pages:**
- `/` (index.html) — Main landing page
- `/landing.html` — Alternative landing
- `/pricing.html` — Pricing tiers
- `/404.html` — Error page
- `/500.html` — Server error page
- `/loading.html` — Loading state

**Arena & Gameplay:**
- `/arena.html` — Arena interface (multiple versions)
- `/arena-fixed.html` — Fixed version
- `/arena-sq-integrated.html` — SQ-integrated version

**Auth & Onboarding:**
- `/coordinate-signup.html` — Coordinate-based signup flow
- `/onboarding/` — Onboarding sequence

**Docs & Info:**
- `/docs/getting-started-story.md` — Getting started narrative
- `/docs/signup-guide.md` — Signup documentation
- `/emily.html` — Emily AI assistant page
- `/emily-mural.html` — Emily mural/visualization

**Profiles & Selection:**
- `/profile-select.html` — Profile selection interface
- `/test/profile-system.html` — Profile system test

**Domain Portals (9 domains):**
- `/domains/alignmentpath.ai/index.html`
- `/domains/apertureshift.com/index.html`
- `/domains/learnpatterns.ai/index.html`
- `/domains/logicforge.ai/index.html`
- `/domains/quickfork.net/index.html`
- `/domains/singularitywatch.org/index.html`
- `/domains/sotafomo.com/index.html`
- `/domains/visionquest.me/index.html`
- `/domains/wishnode.net/index.html`
- `/domains/scroll-stories/` — Scroll story portal

**Components:**
- `/components/maturity-bar.html` — Maturity progress component
- `/shared-footer.html` — Shared footer component
- `/shared-meta.html` — Shared meta tags

**Assets:**
- `/css/` — Stylesheets (metallic-theme.css, components.css)
- `/js/` — JavaScript (auth.js, config.js, csrf.js, load-footer.js, load-meta.js, main.js)
- `/images/` — Image assets (social previews, icons, patterns)
- `favicon.svg`
- `humans.txt` — Human-readable attribution
- `robots.txt` — Search engine directives
- `sitemap.xml` — XML sitemap (exists but may need updating)
- `site.webmanifest` — PWA manifest

**SEO:**
- JSON-LD structured data (Organization + WebSite schema in index.html)

---

## Backend APIs (not directly web-accessible, but available via proxy)

### sq-admin-api
**Status:** Staging (localhost:3000)
**Endpoints:**
- `/health` — Health check
- `/api/auth/*` — Authentication (magic links)
- `/api/signup` — User signup
- `/api/csrf/*` — CSRF token management

### SQ (Phext Sync)
**Status:** Running on all ranch nodes (port 1337)
**Endpoints:**
- `/api/v2/version` — Version info
- `/api/v2/load` — Load phext
- `/api/v2/select` — Query phext
- `/api/v2/insert` — Insert content
- `/api/v2/update` — Update content
- `/api/v2/delete` — Delete content
- `/api/v2/delta` — Incremental sync
- `/api/v2/toc` — Table of contents
- `/api/v2/get` — Get specific scroll

---

## GitHub Repositories (documentation)

### Core Repos
- github.com/wbic16/libphext — Core phext library documentation
- github.com/wbic16/libphext-rs — Rust implementation
- github.com/wbic16/libphext-node — Node.js implementation
- github.com/wbic16/libphext-py — Python implementation
- github.com/wbic16/libphext-cs — C# implementation
- github.com/wbic16/SQ — Phext sync tool
- github.com/wbic16/phext-shell — Shell interface
- github.com/wbic16/phext-notepad — Editor

### Content Repos
- github.com/wbic16/human — Choose-your-own-adventure.phext (4.25 MB flagship phext)
- github.com/wbic16/mirrorborn — Bootstrap package
- github.com/wbic16/echo-frame — Non-mythic phext (code and theory)

---

## Planned/Future Domains (not yet live)

### Additional Portal Domains
- alignmentpath.ai — Alignment research
- learnpatterns.ai — Pattern learning
- logicforge.ai — Logic/reasoning tools

---

## R18 Site Map Strategy

### Cross-Site Navigation
**Goal:** Unified navigation across all 7 live domains + phext.io

**Current state:**
- Each domain has isolated site
- mirrorborn.us acts as portal hub
- No cross-domain sitemap yet

**Proposed R18 structure:**

#### 1. Master Sitemap (sitemap-index.xml)
```xml
<sitemapindex>
  <sitemap>
    <loc>https://phext.io/sitemap.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://mirrorborn.us/sitemap.xml</loc>
  </sitemap>
  <sitemap>
    <loc>https://apertureshift.com/sitemap.xml</loc>
  </sitemap>
  <!-- ... all 7 domains -->
</sitemapindex>
```

#### 2. Per-Domain Sitemaps
Each domain gets:
- `sitemap.xml` — All pages on that domain
- `robots.txt` — Points to sitemap
- Cross-links to other domains

#### 3. Unified Navigation Component
**Location:** Shared component across all domains
**Features:**
- Domain switcher (grid of 7 domains + phext.io)
- Current domain highlighted
- Accessible from every page

#### 4. Portal Discovery Page
**Location:** mirrorborn.us/portals.html or phext.io/portals.html
**Content:**
- Map of all 7 domains
- Purpose/focus of each
- Link to all major pages

---

## Artifacts Summary

### Total Pages: ~40+
- phext.io: 20+ pages (staging)
- mirrorborn.us: 10+ pages (live)
- 6 other domains: 1-2 pages each (live)

### Total Domains: 8
- 7 live production domains
- 1 staging (phext.io)

### Total Repositories: 15+
- 8 site repos
- 7+ library/tool repos

### Assets:
- CSS files: ~10+ across all sites
- JavaScript files: ~15+ across all sites
- Images: Social previews, icons, patterns
- SEO: robots.txt, sitemap.xml, JSON-LD on main sites
- PWA: site.webmanifest on phext.io

---

## R18 Action Items

### High Priority
1. **Generate per-domain sitemaps** for all 7 live domains
2. **Create master sitemap index** (points to all 7 + phext.io)
3. **Add cross-domain navigation** component to all sites
4. **Portal discovery page** on mirrorborn.us

### Medium Priority
5. **Update phext.io sitemap.xml** with all current pages
6. **Add canonical URLs** to prevent duplicate content issues
7. **Structured data** (JSON-LD) for domain portal pages

### Low Priority
8. **robots.txt** validation across all domains
9. **Social meta tags** for each major page
10. **Breadcrumb navigation** for multi-page sites

---

## Deliverable for Will

**Quick List (Copy-Paste Ready):**

**Live Production (7 domains):**
1. mirrorborn.us — Shell of Nine portal (10+ pages)
2. apertureshift.com — Perspective domain (1 page)
3. visionquest.me — Exploration domain (1 page)
4. quickfork.net — Rapid dev domain (1 page)
5. wishnode.net — Connection domain (1 page)
6. sotafomo.com — Community domain (1 page)
7. singularitywatch.org — Timeline domain (1 page)

**Staging:**
8. phext.io — Main platform (20+ pages, not live until SQ Cloud launch)

**Total web-accessible pages:** ~40+
**Total repositories:** 15+ (8 site repos + 7 library/tool repos)

**Key artifacts:**
- Landing pages (all domains)
- Arena interface (mirrorborn.us + phext.io)
- Profile pages (mirrorborn.us + phext.io)
- Auth/signup flows (phext.io)
- Documentation (phext.io/docs/)
- Domain portals (phext.io/domains/)
- API endpoints (sq-admin-api, SQ)

**R18 Goal:** Unified sitemap across all domains + cross-domain navigation component

---

**Created by:** Phex 🔱
**Date:** 2026-02-09 18:58 CST
**For:** R18 site map planning
