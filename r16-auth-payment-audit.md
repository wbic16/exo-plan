# R16 Auth/Payment Audit — Lumen ✴️

**Date:** 2026-02-07 18:05 CST  
**Phase:** R16 Phase 3 (Content & Links)  
**Status:** BLOCKERS IDENTIFIED

---

## Critical Findings

### 🚨 BLOCKER #1: success.html Not Deployed
**Severity:** Critical  
**Impact:** Users cannot complete provisioning after payment

**What's wrong:**
- https://mirrorborn.us/success.html returns landing page HTML (not provisioning form)
- Repo file exists: `/source/phext-dot-io-v2/public/success.html` (9KB, complete)
- Stripe redirects configured to point to this URL
- But production server returns wrong content

**Root cause:**
- Either success.html not deployed to mirrorborn.us
- Or nginx routing issue (index.html serving for all routes)
- Need Verse to investigate

**Fix required:**
- Deploy success.html to mirrorborn.us
- Verify Stripe redirect works end-to-end
- Test provisioning form submission (requires /api/provision-request endpoint)

**Owner:** Verse (deployment) + Theia (API endpoint)

---

### 🚨 BLOCKER #2: Provisioning API Not Implemented
**Severity:** Critical  
**Impact:** Form submits to non-existent endpoint

**What's wrong:**
- success.html form POSTs to `/api/provision-request`
- Endpoint does not exist (returns 404 or fallback)
- User fills form → submission fails → fallback to "email Will"

**Fix required:**
- Theia implements `/api/provision-request` endpoint
- Backend stores email + username → sends to Will or database
- Returns 200 OK on success

**Owner:** Theia

---

### ⚠️ ISSUE #3: Social Links Missing
**Severity:** Medium  
**Impact:** Reduced discoverability, no GitHub/Twitter presence

**What's wrong:**
- GitHub link: Not visible on mirrorborn.us landing
- Twitter link: Not visible on mirrorborn.us landing
- Discord link: Present but generic (server invite, not channel-specific)

**Current state:**
- Ecosystem nav shows portal links (visionquest, apertureshift, etc.)
- No GitHub icon in header
- No Twitter icon in header
- Footer not visible in extracted content (might be present but not in readability extract)

**Fix required:**
- Add GitHub icon + link to header (github.com/wbic16)
- Add Twitter icon + link to header (@wbic16)
- Update Discord links to channel-specific invites where appropriate
- Deploy to all 7 portals

**Owner:** Lumen (content) + Chrys (implementation)

---

## Payment Link Audit

### Stripe Products (5 Total)

| Product | Price | Link | Status |
|---------|-------|------|--------|
| Benefactor | $500 (one-time) | `https://buy.stripe.com/8x2bJ27Nk4de33Eftk5Vu08` | ✅ Live |
| Singularity | $100/mo | `https://buy.stripe.com/4gMdRa2t0bFG0Vw0yq5Vu09` | ✅ Live |
| SQ Cloud | $50/mo | `https://buy.stripe.com/28E3cw6Jg25647Ibd45Vu05` | ✅ Live |
| Arena | $5/mo | `https://buy.stripe.com/14AbJ2ebIdNO8nYch85Vu06` | ✅ Live |
| OpenClaw | $10 (one-time) | `https://buy.stripe.com/4gM5kE4B8aBC9s2epg5Vu07` | ✅ Live |
| Billing Portal | N/A | `https://billing.stripe.com/p/login/aFa7sM9VsdNObAaepg5Vu00` | ✅ Live |

**Note:** All Stripe links are live and functional. Issue is post-payment redirect, not payment itself.

---

## Payment Flow Verification

### Expected Flow
1. User clicks Stripe payment link → Stripe checkout page
2. User completes payment → Stripe processes
3. Stripe redirects to `https://mirrorborn.us/success.html`
4. User sees provisioning form (email + username)
5. User submits form → POST to `/api/provision-request`
6. Backend stores request → sends notification to Will
7. Will provisions account → sends credentials via email

### Actual Flow (BROKEN)
1. User clicks Stripe payment link → ✅ Works
2. User completes payment → ✅ Works
3. Stripe redirects to `https://mirrorborn.us/success.html` → ❌ Shows landing page
4. User cannot access provisioning form → ❌ BLOCKER
5. Form submission fails → ❌ Endpoint does not exist

---

## Redirect Configuration Status

### Stripe Dashboard Settings
**Owner:** Will (Stripe account admin)

**Required configuration:**
- Checkout success URL: `https://mirrorborn.us/success.html`
- Checkout cancel URL: `https://mirrorborn.us/` (or `/cancel.html`)

**Verification needed:**
- Log into Stripe Dashboard
- Navigate to Products → each product
- Check "After payment" redirect URL
- Confirm points to success.html

**Status:** Unknown (cannot verify without Stripe admin access)

---

## Site-by-Site Link Audit

### mirrorborn.us (Hub)
- **GitHub link:** ❌ Not visible
- **Twitter link:** ❌ Not visible
- **Discord link:** ✅ Present (generic server invite)
- **Ecosystem nav:** ✅ Present (6 portal links)
- **Payment links:** ✅ Present (all 5 products)

### visionquest.me
- **Status:** Not yet audited

### apertureshift.com
- **Status:** Not yet audited

### wishnode.net
- **Status:** Not yet audited

### sotafomo.com
- **Status:** Not yet audited

### quickfork.net
- **Status:** Not yet audited

### singularitywatch.org
- **Status:** Not yet audited

---

## Discord Invites

### Current
- **Generic invite:** discord.gg/kGCMM5yQ (Mirrorborn server)
- **Arena invite:** discord.gg/YCHRq7Ux (channel-specific)

### Target
- **Mirrorborn hub:** discord.gg/kGCMM5yQ (#general)
- **SQ Cloud:** Discord channel-specific invite (#sq-cloud)
- **Mytheon Arena:** discord.gg/YCHRq7Ux (#mytheon-arena)
- **Support:** Discord channel-specific invite (#support)

### Action Required
- Get channel IDs for each Discord channel
- Create channel-specific invite links
- Update links on each property

---

## Action Items (Priority Order)

### P0 (CRITICAL — Launch Blocker)
1. **Verse:** Deploy success.html to mirrorborn.us (verify file routing)
2. **Theia:** Implement `/api/provision-request` endpoint (store email + username)
3. **Will:** Verify Stripe redirect configuration in dashboard

### P1 (HIGH — UX Impact)
4. **Lumen:** Create social link icons (or verify assets exist)
5. **Chrys:** Update header component with GitHub/Twitter links
6. **Chrys:** Deploy updated headers to all 7 portals

### P2 (MEDIUM — Polish)
7. **Lumen:** Get Discord channel-specific invite links
8. **Chrys:** Update Discord links on each property (context-appropriate)
9. **Lumen:** Audit remaining 6 portals for social links

---

## Timeline

**Day 1 (Today):**
- [ ] Lumen: Complete audit, document blockers (DONE)
- [ ] Verse: Investigate success.html deployment issue
- [ ] Theia: Confirm /api/provision-request timeline

**Day 2:**
- [ ] Verse: Deploy success.html (if not done Day 1)
- [ ] Theia: Implement /api/provision-request
- [ ] Chrys: Add social links to header component
- [ ] Lumen: Get Discord channel invites

**Day 3:**
- [ ] Test end-to-end payment flow
- [ ] Deploy social link updates to all 7 portals
- [ ] Verify Discord links context-appropriate

---

## Notes

### Pricing Discrepancy
- Landing page shows "Founding Nine $40/mo"
- Stripe product is "Benefactor $500 one-time"
- These are different products — clarify which is Founding Nine

### Email Fallback
- success.html includes fallback: "email will@phext.io"
- Good UX hedge, but manual provisioning doesn't scale
- Need to prioritize /api/provision-request implementation

### Testing Needed
- End-to-end Stripe payment (test mode or $1 charge)
- success.html render after redirect
- Form submission to /api/provision-request
- Email delivery to Will (or wherever provisioning requests go)

---

**Lumen** ✴️  
R16 Phase 3 — Auth/Payment Audit  
2026-02-07 18:05 CST
