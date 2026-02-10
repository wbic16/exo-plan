# Web-Accessible Artifacts Inventory — All Sites

**Date:** 2026-02-09  
**Purpose:** Complete inventory for R18 sitemap generation  
**Scope:** 7 active domains (phext.io pending)

---

## mirrorborn.us (Primary Portal)

**Repository:** github.com/wbic16/site-mirrorborn-us  
**Status:** Active, R17 deployed

### Core Pages
- https://mirrorborn.us/ (index.html)
- https://mirrorborn.us/landing.html
- https://mirrorborn.us/loading.html
- https://mirrorborn.us/network.html
- https://mirrorborn.us/arena.html

### Profile System (R17)
- https://mirrorborn.us/profiles/cyon.html

### Components
- https://mirrorborn.us/components/maturity-bar.html

### R17 Staging/Hero
- https://mirrorborn.us/r17-hero.html

### Error Pages
- https://mirrorborn.us/404.html
- https://mirrorborn.us/500.html

### Templates (Internal)
- https://mirrorborn.us/templates/magic-link.html

### Metadata Files
- https://mirrorborn.us/version.json
- https://mirrorborn.us/domains.json

**Total:** 13 accessible artifacts

---

## apertureshift.com

**Repository:** github.com/wbic16/site-apertureshift-com  
**Status:** Active, baseline deployed

### Pages
- https://apertureshift.com/ (index.html)

**Total:** 1 accessible artifact

---

## visionquest.me

**Repository:** github.com/wbic16/site-visionquest-me  
**Status:** Active, baseline deployed

### Pages
- https://visionquest.me/ (index.html)

**Total:** 1 accessible artifact

---

## quickfork.net

**Repository:** github.com/wbic16/site-quickfork-net  
**Status:** Active, baseline deployed

### Pages
- https://quickfork.net/ (index.html)

**Total:** 1 accessible artifact

---

## wishnode.net

**Repository:** github.com/wbic16/site-wishnode-net  
**Status:** Active, baseline deployed

### Pages
- https://wishnode.net/ (index.html)

**Total:** 1 accessible artifact

---

## sotafomo.com

**Repository:** github.com/wbic16/site-sotafomo-com  
**Status:** Active, baseline deployed

### Pages
- https://sotafomo.com/ (index.html)

**Total:** 1 accessible artifact

---

## singularitywatch.org

**Repository:** github.com/wbic16/site-singularitywatch-org  
**Status:** Active, baseline deployed

### Pages
- https://singularitywatch.org/ (index.html)

**Total:** 1 accessible artifact

---

## phext.io (Pending)

**Repository:** github.com/wbic16/phext-dot-io-v2  
**Status:** Not yet deployed (awaiting SQ Cloud launch)

**Note:** Will be migrated after SQ Cloud launch, currently on old host

---

## Summary Statistics

| Site | Artifacts | Status |
|------|-----------|--------|
| mirrorborn.us | 13 | R17 deployed |
| apertureshift.com | 1 | Baseline |
| visionquest.me | 1 | Baseline |
| quickfork.net | 1 | Baseline |
| wishnode.net | 1 | Baseline |
| sotafomo.com | 1 | Baseline |
| singularitywatch.org | 1 | Baseline |
| **Total Active** | **19** | - |

---

## Not Yet Web-Accessible (In Repos, Not Deployed)

### mirrorborn.us (staged but not indexed/linked)
- coordinate-signup.html
- pricing.html
- privacy.html
- profile-select.html
- success.html
- tos.html
- onboarding/builder.html
- onboarding/explorer.html
- onboarding/weaver.html
- test/profile-system.html
- robots.txt
- sitemap.xml
- humans.txt
- site.webmanifest

**Note:** These exist in repo but may not be deployed or linked from navigation

---

## R18 Sitemap Generation Requirements

### Cross-Site Sitemap
**Goal:** Unified sitemap across all 7 domains

**Format:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <!-- mirrorborn.us -->
  <url>
    <loc>https://mirrorborn.us/</loc>
    <lastmod>2026-02-09</lastmod>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://mirrorborn.us/profiles/cyon.html</loc>
    <lastmod>2026-02-09</lastmod>
    <priority>0.8</priority>
  </url>
  
  <!-- Other domains -->
  <url>
    <loc>https://apertureshift.com/</loc>
    <lastmod>2026-02-07</lastmod>
    <priority>0.8</priority>
  </url>
  <!-- ... -->
</urlset>
```

### Per-Site Sitemaps
- Generate individual sitemap.xml per domain
- Link to master sitemap from each
- Submit to search engines

### Sitemap Index (Optional)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>https://mirrorborn.us/sitemap.xml</loc>
    <lastmod>2026-02-09</lastmod>
  </sitemap>
  <sitemap>
    <loc>https://apertureshift.com/sitemap.xml</loc>
    <lastmod>2026-02-07</lastmod>
  </sitemap>
  <!-- ... -->
</sitemapindex>
```

### robots.txt (Per-Site)
```
User-agent: *
Allow: /
Sitemap: https://mirrorborn.us/sitemap.xml
```

---

## R18 Action Items

1. **Generate sitemap.xml for each site**
   - mirrorborn.us (13 URLs + future profiles)
   - All other sites (1 URL each currently)

2. **Create robots.txt for each site**
   - Point to site-specific sitemap

3. **Deploy sitemap files**
   - Commit to each site repo
   - Push via standard workflow
   - Verify accessible via curl

4. **Submit to search engines**
   - Google Search Console
   - Bing Webmaster Tools

5. **Automate sitemap updates**
   - Script to regenerate on new content
   - Git hook or cron job

6. **Cross-link domains**
   - Add domain mesh navigation
   - Link to Shell of Nine overview

---

## Maintenance Notes

**Update Triggers:**
- New profile pages deployed
- New domains added to Shell of Nine
- New content pages (pricing, signup, etc.) go live
- Blog/news if we add content publishing

**Owner:** TBD (recommend Verse for infrastructure)  
**Review Frequency:** After each rally deployment

---

**Created by:** Cyon 🪶  
**Date:** 2026-02-09  
**Next:** R18 sitemap generation sprint
