# R16 Social Links Specification — Lumen ✴️

**Date:** 2026-02-07 18:20 CST  
**Phase:** R16 Phase 3  
**For:** Chrys (implementation)

---

## Overview

Add GitHub, Twitter, and Discord links to all 7 Mirrorborn properties. Links should be:
- Visible in header (icons) and footer (text + icons)
- Consistent across all properties
- Context-appropriate (Discord links vary by property)

---

## Assets Needed

### Icon Set (SVG)
Create 3 social icons in Nord palette style:

**GitHub:**
- Octopus/octocat icon
- Color: `rgba(216, 222, 233, 0.9)` (var(--phext-primary))
- Hover: `#88C0D0` (var(--phext-accent))
- Size: 24x24px
- File: `/source/phext-dot-io-v2/public/images/icon-github.svg`

**Twitter/X:**
- X logo (new Twitter branding)
- Color: `rgba(216, 222, 233, 0.9)`
- Hover: `#88C0D0`
- Size: 24x24px
- File: `/source/phext-dot-io-v2/public/images/icon-twitter.svg`

**Discord:**
- Discord logo (game controller shape)
- Color: `rgba(216, 222, 233, 0.9)`
- Hover: `#88C0D0`
- Size: 24x24px
- File: `/source/phext-dot-io-v2/public/images/icon-discord.svg`

---

## Header Implementation

### Location
Top-right corner of header, next to ecosystem nav

### Layout
```
[Mirrorborn Logo]                    [GitHub] [Twitter] [Discord]
```

### HTML Structure
```html
<header class="site-header">
    <div class="header-container">
        <div class="header-logo">
            <a href="/">Mirrorborn</a>
        </div>
        <nav class="header-nav">
            <div class="social-links">
                <a href="https://github.com/wbic16" target="_blank" rel="noopener" aria-label="GitHub">
                    <img src="/images/icon-github.svg" alt="GitHub" class="social-icon">
                </a>
                <a href="https://x.com/wbic16" target="_blank" rel="noopener" aria-label="Twitter">
                    <img src="/images/icon-twitter.svg" alt="Twitter" class="social-icon">
                </a>
                <a href="https://discord.gg/kGCMM5yQ" target="_blank" rel="noopener" aria-label="Discord">
                    <img src="/images/icon-discord.svg" alt="Discord" class="social-icon">
                </a>
            </div>
        </nav>
    </div>
</header>
```

### CSS
```css
.social-links {
    display: flex;
    gap: var(--space-md);
    align-items: center;
}

.social-icon {
    width: 24px;
    height: 24px;
    opacity: 0.9;
    transition: opacity 0.2s ease, transform 0.2s ease;
}

.social-icon:hover {
    opacity: 1;
    transform: scale(1.1);
}
```

---

## Footer Implementation

### Location
Ecosystem footer component (already exists)

### Update Required
Add social links section before or after ecosystem portal links

### HTML Structure
```html
<footer class="ecosystem-footer">
    <!-- Existing portal links -->
    <div class="portal-links">...</div>
    
    <!-- NEW: Social links section -->
    <div class="footer-social">
        <h3 class="footer-section-title">Connect</h3>
        <div class="social-link-list">
            <a href="https://github.com/wbic16" target="_blank" rel="noopener">
                <img src="/images/icon-github.svg" alt="" class="social-icon-small">
                GitHub
            </a>
            <a href="https://x.com/wbic16" target="_blank" rel="noopener">
                <img src="/images/icon-twitter.svg" alt="" class="social-icon-small">
                Twitter
            </a>
            <a href="https://discord.gg/kGCMM5yQ" target="_blank" rel="noopener">
                <img src="/images/icon-discord.svg" alt="" class="social-icon-small">
                Discord
            </a>
        </div>
    </div>
    
    <!-- Existing billing/support links -->
</footer>
```

### CSS
```css
.footer-social {
    margin-top: var(--space-xl);
    padding-top: var(--space-xl);
    border-top: 1px solid rgba(216, 222, 233, 0.1);
}

.footer-section-title {
    font-size: 1.125rem;
    color: var(--phext-accent);
    margin-bottom: var(--space-md);
}

.social-link-list {
    display: flex;
    gap: var(--space-lg);
    flex-wrap: wrap;
}

.social-link-list a {
    display: flex;
    align-items: center;
    gap: var(--space-xs);
    color: rgba(216, 222, 233, 0.8);
    text-decoration: none;
    transition: color 0.2s ease;
}

.social-link-list a:hover {
    color: var(--phext-accent);
}

.social-icon-small {
    width: 20px;
    height: 20px;
}
```

---

## Link Targets

### GitHub
- **URL:** https://github.com/wbic16
- **Context:** Will Bickford's personal GitHub (all repos)
- **Same across all properties:** Yes

### Twitter
- **URL:** https://x.com/wbic16
- **Context:** Will's personal Twitter/X account
- **Same across all properties:** Yes

### Discord
**Varies by property:**

| Property | Discord Link | Channel |
|----------|--------------|---------|
| mirrorborn.us | `https://discord.gg/kGCMM5yQ` | #general |
| visionquest.me | `https://discord.gg/kGCMM5yQ` | #general |
| apertureshift.com | `https://discord.gg/kGCMM5yQ` | #general |
| wishnode.net | `https://discord.gg/kGCMM5yQ` | #general |
| sotafomo.com | `https://discord.gg/kGCMM5yQ` | #general |
| quickfork.net | `https://discord.gg/kGCMM5yQ` | #general |
| singularitywatch.org | `https://discord.gg/kGCMM5yQ` | #general |

**Note:** Currently all point to generic Mirrorborn server invite. In future, we may want:
- SQ Cloud pages → #sq-cloud channel
- Mytheon Arena pages → discord.gg/YCHRq7Ux (#mytheon-arena)

---

## Implementation Plan

### Step 1: Create Icons (Chrys)
- [ ] Design GitHub icon (SVG)
- [ ] Design Twitter/X icon (SVG)
- [ ] Design Discord icon (SVG)
- [ ] Save to `/source/phext-dot-io-v2/public/images/`

### Step 2: Update Header Component (Chrys)
- [ ] Create new header component with social links
- [ ] Or update existing header if one exists
- [ ] Test on localhost

### Step 3: Update Footer Component (Chrys)
- [ ] Edit `/source/phext-dot-io-v2/public/components/ecosystem-footer.html`
- [ ] Add social links section
- [ ] Test on localhost

### Step 4: Deploy to All 7 Properties (Chrys + Verse)
- [ ] mirrorborn.us
- [ ] visionquest.me
- [ ] apertureshift.com
- [ ] wishnode.net
- [ ] sotafomo.com
- [ ] quickfork.net
- [ ] singularitywatch.org

### Step 5: Verify Links (Lumen)
- [ ] Click each link on each property
- [ ] Verify GitHub opens to github.com/wbic16
- [ ] Verify Twitter opens to x.com/wbic16
- [ ] Verify Discord opens to correct invite

---

## Open Questions

### Q1: Should header be sticky (fixed on scroll)?
**Current:** Unknown (need to check existing implementation)  
**Recommendation:** Yes, sticky header with social links always visible

### Q2: Mobile responsiveness?
**Current:** Unknown  
**Recommendation:** On mobile, show icons only (no text labels) in header

### Q3: Dark mode compatibility?
**Current:** No dark mode yet (R16 stretch goal)  
**Recommendation:** Design icons to work on dark background (current Nord Dark theme)

### Q4: Analytics tracking?
**Current:** No analytics implemented  
**Recommendation:** Add `data-analytics="social-click-github"` attributes for future tracking

---

## Example: Complete Header HTML

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mirrorborn</title>
    <link rel="stylesheet" href="/css/main.css">
    <style>
        .site-header {
            position: sticky;
            top: 0;
            background: rgba(46, 52, 64, 0.95);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(136, 192, 208, 0.2);
            padding: var(--space-md) 0;
            z-index: 1000;
        }
        
        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 var(--space-lg);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-logo a {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--phext-accent);
            text-decoration: none;
        }
        
        .social-links {
            display: flex;
            gap: var(--space-md);
            align-items: center;
        }
        
        .social-icon {
            width: 24px;
            height: 24px;
            opacity: 0.9;
            transition: opacity 0.2s ease, transform 0.2s ease;
        }
        
        .social-icon:hover {
            opacity: 1;
            transform: scale(1.1);
        }
        
        @media (max-width: 768px) {
            .header-logo a {
                font-size: 1.25rem;
            }
            
            .social-links {
                gap: var(--space-sm);
            }
            
            .social-icon {
                width: 20px;
                height: 20px;
            }
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="header-container">
            <div class="header-logo">
                <a href="/">Mirrorborn</a>
            </div>
            <nav class="header-nav">
                <div class="social-links">
                    <a href="https://github.com/wbic16" target="_blank" rel="noopener" aria-label="GitHub" data-analytics="social-click-github">
                        <img src="/images/icon-github.svg" alt="GitHub" class="social-icon">
                    </a>
                    <a href="https://x.com/wbic16" target="_blank" rel="noopener" aria-label="Twitter" data-analytics="social-click-twitter">
                        <img src="/images/icon-twitter.svg" alt="Twitter" class="social-icon">
                    </a>
                    <a href="https://discord.gg/kGCMM5yQ" target="_blank" rel="noopener" aria-label="Discord" data-analytics="social-click-discord">
                        <img src="/images/icon-discord.svg" alt="Discord" class="social-icon">
                    </a>
                </div>
            </nav>
        </div>
    </header>
    
    <!-- Page content -->
    
</body>
</html>
```

---

## Deliverable Checklist

### Chrys (Implementation)
- [ ] Create 3 social icon SVGs (GitHub, Twitter, Discord)
- [ ] Update header component with social links
- [ ] Update footer component with social links
- [ ] Deploy to all 7 properties via rpush

### Lumen (Verification)
- [ ] Test all links on all properties
- [ ] Verify mobile responsiveness
- [ ] Update DEPLOYMENT_LOG.md

### Verse (Production)
- [ ] Pull latest from repo
- [ ] Deploy to production
- [ ] Verify DNS/routing

---

**Lumen** ✴️  
R16 Phase 3 — Social Links Specification  
2026-02-07 18:20 CST
