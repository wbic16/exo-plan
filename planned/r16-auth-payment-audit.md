# R16 Auth & Payment Flow Audit

**Date:** February 7, 2026  
**Auditor:** Lumen  
**Scope:** All user-facing flows on mirrorborn.us + domains

---

## Payment Links Audit

### ✅ Complete Coverage (All 5 Products Visible)

| Page | Benefactor | Singularity | SQ Cloud | Arena | OpenClaw |
|------|-----------|-------------|----------|-------|----------|
| landing.html | ✅ | ✅ | ✅ | ✅ | ✅ |
| arena.html | ❌ | ❌ | ✅ (cross-sell) | ❌ | ❌ |
| success.html | ✅ (upsell) | ✅ (upsell) | ✅ (upsell) | ✅ (upsell) | ✅ (upsell) |
| ecosystem-footer | ❌ | ❌ | ✅ | ✅ | ❌ |

### Missing Payment Links

#### Arena Page
**Issue:** Only shows SQ Cloud cross-sell. Missing Arena's own payment link.  
**Impact:** Users on arena.html can't subscribe to Arena directly.  
**Fix:** Add Arena payment CTA to arena.html hero or bottom.

#### Footer
**Issue:** Footer only shows SQ Cloud + Arena. Missing Singularity, OpenClaw, Benefactor.  
**Impact:** Users on docs/domain pages can't discover premium tiers.  
**Fix:** Consider "View All Plans" link to /pricing page instead of individual links.

---

## Auth Flow Audit

### Current Auth Flow (As Designed)

1. User clicks payment link → Stripe checkout
2. User completes payment → Stripe redirects to /success
3. User fills form (email + username) → POST `/api/provision-request`
4. API stores request for Will's review
5. Will manually provisions account within 24-48hrs
6. User receives email with credentials

### Broken Steps

#### ⚠️ Step 2: Stripe Redirect Not Configured
**Status:** Blocked on Will/Verse  
**Problem:** Stripe checkout doesn't know to redirect to /success  
**Impact:** After payment, users see Stripe success page (not ours)  
**Fix:** Configure redirect URL in Stripe dashboard for each product

#### ❌ Step 3: API Endpoint Doesn't Exist
**Status:** Blocked on Theia  
**Problem:** `/api/provision-request` returns 404  
**Impact:** Form submission fails. Users see error.  
**Fix:** Theia implements endpoint (spec provided in R15)

#### ⚠️ Step 5: Manual Provisioning Not Documented
**Status:** Process unclear  
**Problem:** What does Will do to provision? CLI commands? Dashboard?  
**Impact:** Will doesn't know how to fulfill requests efficiently  
**Fix:** Document provisioning workflow (likely SQ admin CLI)

#### ❌ Step 6: Email Template Doesn't Exist
**Status:** Not created  
**Problem:** What email does Will send with credentials?  
**Impact:** Manual copy/paste, inconsistent messaging  
**Fix:** Create "Welcome to SQ Cloud" email template (HTML + plain text)

---

## Missing Pages

### ❌ /privacy (Privacy Policy)
**Status:** Footer link exists, page doesn't  
**Impact:** Legal requirement not met. Can't accept payments.  
**Fix:** Will provides template → Lumen creates page

### ❌ /terms (Terms of Service)
**Status:** Footer link exists, page doesn't  
**Impact:** Legal requirement not met. Can't accept payments.  
**Fix:** Will provides template → Lumen creates page

### ❌ /pricing (Pricing Comparison Page)
**Status:** No dedicated pricing page  
**Impact:** Users can't compare all tiers side-by-side  
**Fix:** Create /pricing page with comparison table (all 5 products)

### ⚠️ /docs/* (Documentation Pages)
**Status:** Exist but no payment CTAs at bottom  
**Impact:** Users reading docs can't convert without going back to landing  
**Fix:** Add footer CTA to docs (link to /pricing or primary product)

---

## Broken Flows Identified

### Flow 1: "I want to subscribe to Arena from arena.html"
**Problem:** Arena page only has Discord link. No direct payment link.  
**Impact:** User has to go back to landing page.  
**Fix:** Add "Subscribe to Arena ($5/mo)" CTA on arena.html

### Flow 2: "I just paid, now what?"
**Problem:** Stripe success page → user lost  
**Impact:** User doesn't know provisioning is manual  
**Fix:** Configure Stripe redirect → /success

### Flow 3: "I submitted provisioning form, no confirmation"
**Problem:** Form submits to 404 endpoint  
**Impact:** User thinks it worked, but request not recorded  
**Fix:** Theia implements endpoint + confirmation email

### Flow 4: "I'm on a doc page, want to sign up"
**Problem:** No payment links in docs (footer has them but not prominent)  
**Impact:** User has to navigate away, loses context  
**Fix:** Add bottom-of-page CTA to docs

### Flow 5: "I want to compare all pricing tiers"
**Problem:** Landing page shows 5 products but side-by-side comparison unclear  
**Impact:** User can't make informed decision  
**Fix:** Create /pricing with comparison table

---

## Security Audit

### ✅ Payment Security
- **Stripe hosted checkout:** ✅ Secure (no card data on our servers)
- **HTTPS:** ✅ (assumed Verse has Let's Encrypt configured)
- **No sensitive data collection:** ✅ (only email + username on our forms)

### ⚠️ Auth Token Security
- **JWT storage:** Not implemented yet (Theia's task)
- **Token expiry:** Not implemented yet
- **Refresh flow:** Not implemented yet

**Impact:** Can't audit until backend exists.

### ❌ Legal Compliance
- **GDPR:** No privacy policy
- **CCPA:** No privacy policy
- **ToS:** No terms of service

**Impact:** Legally can't collect user data or accept payments.

---

## Recommendations (Priority Order)

### Critical (Blocking Payments)
1. **Create /privacy and /terms pages** (Lumen, once Will provides templates)
2. **Configure Stripe redirect URLs** (Will/Verse, 5 products × 1 redirect each)
3. **Implement `/api/provision-request`** (Theia)

### High Priority (UX Gaps)
4. **Add Arena payment link to arena.html** (Lumen, 5 min fix)
5. **Create /pricing comparison page** (Lumen, 1-2 hours)
6. **Create "Welcome to SQ Cloud" email template** (Lumen, 30 min)

### Medium Priority (Conversion Optimization)
7. **Add CTAs to bottom of doc pages** (Lumen, 30 min)
8. **Add "View All Plans" to footer** (instead of individual product links)
9. **Document manual provisioning workflow** (Will → Lumen documents)

### Low Priority (Future)
10. **Implement automated provisioning** (Verse/Phex, replaces manual process)
11. **Add live chat support** (for users stuck in auth/payment flow)

---

## Testing Checklist (Once Backend Live)

### Payment Flow Test
- [ ] Click SQ Cloud payment link
- [ ] Complete Stripe checkout (test mode)
- [ ] Redirected to /success page
- [ ] Form submits successfully
- [ ] Confirmation email received
- [ ] Will provisions account
- [ ] Credentials email received
- [ ] Login works with credentials

### All Products Test
- [ ] Benefactor payment → success
- [ ] Singularity payment → success
- [ ] SQ Cloud payment → success
- [ ] Arena payment → success
- [ ] OpenClaw payment → success

### Edge Cases
- [ ] Submit form without payment (should be blocked)
- [ ] Submit form twice (should handle duplicates)
- [ ] Invalid email format (should validate)
- [ ] Special characters in username (should validate or sanitize)

---

## Action Items for R16

### Lumen (Immediate)
- [ ] Add Arena payment link to arena.html
- [ ] Create /pricing comparison page
- [ ] Create welcome email template
- [ ] Add CTAs to doc pages

### Lumen (Blocked on Will)
- [ ] Create /privacy page (need template)
- [ ] Create /terms page (need template)

### Theia (Blocked)
- [ ] Implement `/api/provision-request` endpoint
- [ ] Implement JWT auth flow

### Verse/Will (Blocked)
- [ ] Configure Stripe redirect URLs (5 products)
- [ ] Document manual provisioning workflow

---

**Status:** Audit complete  
**Next:** Fix identified issues in priority order

✴️ Lumen
