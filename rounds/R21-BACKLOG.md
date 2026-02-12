# R21 Backlog

**Created:** 2026-02-12 00:17 CST  
**Status:** Deferred from R20, awaiting pizza party completion

---

## High Priority (2.75 hrs est.)

### 1. Fix Print CSS for mirrorborn.us ⚠️ NEW
**Time:** 30-45 min  
**Issue:** Will reports "the printed output for mirrorborn.us looks bad"  
**PDF:** Provided 2026-02-12  
**Location:** `/source/site-mirrorborn-us/css/print.css`

**Known Issues (to investigate):**
- Background gradients may not print correctly
- Page layout/breaks might be awkward
- Font rendering issues
- Navigation elements possibly still showing
- Link URLs cluttering text
- Color contrast problems in PDF
- Spacing/margin issues

**Action:**
1. Review PDF provided by Will
2. Identify specific problems
3. Update print.css
4. Test PDF export on key pages (index, help, quick-start, getting-started)
5. Validate on multiple browsers (Chrome, Firefox, Safari print)

**Deliverables:**
- Updated print.css (v2)
- Print test checklist
- Documentation of changes

---

### 2. clawhub skill fix/publish
**Time:** 45 min  
**Issue:** sq-memory skill missing `p=` parameter  
**Decision:** Path A (patch existing) vs Path B (publish openclaw-sq-skill to clawhub)  
**Blocker for:** 3/N test completion

---

### 3. Complete 3/N Tester Test
**Time:** 30 min  
**Dependencies:** #2 (skill fix)  
**Target:** <1 minute bootstrap validation

---

### 4. TLS cert validation
**Time:** 30 min  
**Endpoint:** https://sq.mirrorborn.us/api/v2  
**Test:** Verify HTTPS working, no cert warnings

---

### 5. Dashboard.html
**Time:** 45 min  
**Purpose:** Show API credentials after magic link auth  
**Endpoint:** `/auth/dashboard`

---

## Medium Priority (8.5 hrs est.)

### 6. Incipit pre-sync
**Time:** 2 hrs  
**Method:** Cron job or deploy script  
**Target:** Sync to all ranch nodes automatically

---

### 7. Auto-commit GitHub
**Time:** 2 hrs  
**Method:** Webhook or polling  
**Target:** Incipit writes → mirrorborn repo

---

### 8. quick-start.html updates
**Time:** 30 min  
**Fix:** Install path references, copy/paste errors

---

### 9. Monitoring setup
**Time:** 4 hrs  
**Metrics:** Uptime, error rates, usage, API health

---

## Low Priority (20+ hrs est.)

### 10. One-command bootstrap
**Time:** 8 hrs  
**Command:** `openclaw bootstrap mirrorborn`  
**Scope:** Full automation from install to first scroll

---

### 11. Pre-provisioned accounts
**Time:** 4 hrs  
**Method:** Embed credentials securely  
**Target:** New ranch nodes auto-configured

---

### 12. Phext Notepad ranch config
**Time:** 2 hrs  
**Target:** Pre-configure for all siblings

---

### 13. Usage analytics dashboard
**Time:** 6 hrs  
**Metrics:** SQ Cloud adoption, scroll counts, API usage

---

## Estimated Total: 31.25 hours

**Next:** Will calls pizza party, R21 requirements planning deferred until after celebration

---

*Updated: 2026-02-12 00:17 CST*  
*Cyon 🪶*
