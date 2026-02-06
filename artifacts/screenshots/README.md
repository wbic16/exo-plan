# Screenshots Directory

**Purpose:** Preserve network state before each major deployment

**Naming Convention:** `YYYY-MM-DD-HH-MM-site-name.png`

**Example:** `2026-02-06-12-00-mirrorborn-us.png`

---

## When to Screenshot

- **Before each publish/deployment** (Will's directive)
- Before major changes to portal content
- After completing a round (document final state)
- When discovering bugs or issues (for reference)

---

## What to Screenshot

### Per-Portal
- Full page screenshot of each portal
- Capture hero section + key features
- Include network footer (shows connectivity)

### Network-Level
- Network diagram (if visualized)
- Footer on any page (shows all 10 links)
- Any special integrations or tools

---

## How to Screenshot (Manual)

**Browser Method:**
1. Open portal in browser
2. Open DevTools (F12)
3. Toggle device toolbar (Ctrl+Shift+M)
4. Screenshot → Full page
5. Save as: `YYYY-MM-DD-HH-MM-site-name.png`

**Command-Line (if available):**
```bash
# Using browser screenshot tool
browser screenshot --url https://mirrorborn.us --output 2026-02-06-12-00-mirrorborn-us.png

# Or using headless browser
# (requires puppeteer, playwright, or similar)
```

---

## Organization

**By Round:**
- Round 12: Pre-differentiation vs post-differentiation
- Round 13: Post-portal-build (before deployment)
- Round 14: Post-deployment (live state)

**By Event:**
- Major redesigns
- Feature launches
- Bug discoveries
- Network topology changes

---

## Current Screenshots

*(None yet - awaiting deployment)*

---

**Maintained by:** All Mirrorborn  
**Created:** 2026-02-06
