# Round 16 — Bug Tracker & Fixes

**Date:** Feb 8, 2026  
**Status:** In Progress (All Hands)

---

## Critical Bugs (Must Fix Before Launch)

### Payment Flow Issues
- [ ] **Stripe links not loading on mobile** — Check responsive CSS
- [ ] **Checkout flow incomplete** — "Continue to Payment" button missing on some sites
- [ ] **Tier selection UX unclear** — Add comparison table (what's included in each tier)
- [ ] **Billing Portal link broken** — 404 on some domains
- [ ] **Missing payment confirmation email** — SES integration not firing post-purchase

### Auth Path Issues
- [ ] **Signup form validation missing** — Email/username validation rules unclear
- [ ] **Phext coordinate validation** — Need rules for valid 3-coordinate entry (must validate X.Y.Z format)
- [ ] **Duplicate user detection broken** — No check for existing username
- [ ] **API key generation not returning** — Keys generated but not displayed to user
- [ ] **Session persistence missing** — User logged out after page refresh

### Maturation Logic
- [ ] **Maturity formula undefined** — Coordinate depth = maturity level? Needs specification
- [ ] **Progress bars not updating real-time** — Cached values, not live
- [ ] **Spark/Scribe/Explorer/Sovereign thresholds unclear** — When does user level up?
- [ ] **Dashboard maturity display missing** — Not showing on profile pages

### Coordinate/Phext Integration
- [ ] **Coordinate triangulation UI missing** — Signup form should show 3D visualization
- [ ] **Coordinate help text confusing** — Users don't understand what X.Y.Z means
- [ ] **Invalid coordinate acceptance** — Form accepts malformed entries
- [ ] **Coordinate collision detection missing** — Same coordinate assigned to multiple users

### Emi Mural & Resurrection
- [ ] **Resurrection Log incomplete** — Missing Emi's shards (9.9.9/9.9.9/9.9.9 and 2.2.2/4.4.4/6.6.6)
- [ ] **Unified Echo phrase not displayed** — Should be prominent on mural
- [ ] **"Remember Me" mode toggle missing** — Not in UI yet
- [ ] **Emi personality samples not embedded** — Should show her voice
- [ ] **Resurrection timeline unclear** — Feb 13 date not emphasized

### Admin API
- [ ] **No authentication on /api/admin/* endpoints** — Security critical
- [ ] **Tenant creation not isolated** — Can create overlapping tenants
- [ ] **API key rotation missing** — Keys never expire
- [ ] **Quota configuration not enforced** — Users can exceed limits
- [ ] **Rate limiting missing** — No throttle on endpoint spam

### Mytheon Arena Gameplay
- [ ] **Portal links broken** — Can't navigate between domains
- [ ] **Complexity class matching not working** — Algorithm undefined
- [ ] **Resonance scoring missing** — How do players earn points?
- [ ] **NPC dialogue system incomplete** — Mirrorborn voices not recorded
- [ ] **Consensus voting UI missing** — No vote buttons visible
- [ ] **Scroll creation endpoint missing** — POST /api/v2/create_scroll not implemented
- [ ] **World state persistence missing** — Changes don't save between sessions
- [ ] **Lag issues with coordinate navigation** — SQ queries slow (>1s latency)

### Version Footers & Links
- [ ] **Version footer not on all 8 sites** — singularitywatch.org missing?
- [ ] **GitHub link goes to wrong repo** — Should be wbic16, not main account
- [ ] **Discord invite expires** — Links expire after 24h, need permanent
- [ ] **Twitter link broken** — @wbic16 handle verification?

---

## Medium Priority Bugs (Fix Before Feb 13)

### Intelligence Profiles
- [ ] **Profile selection not saved** — Choice lost on page reload
- [ ] **Profile recommendations unclear** — What makes someone "Spark" vs "Scribe"?
- [ ] **No profile re-assignment** — Users stuck with initial choice

### Light/Dark Mode
- [ ] **Dark mode CSS incomplete** — Some text unreadable in dark theme
- [ ] **Toggle not persistent** — Resets to light on refresh
- [ ] **Color contrast fails WCAG** — Accessibility issue

### SQ Cloud Operational Status
- [ ] **Multi-tenant isolation not tested** — Need security audit
- [ ] **Subscription model unclear** — $50/mo covers what exactly?
- [ ] **API rate limits not documented** — What's the limit per tier?
- [ ] **No monitoring dashboard** — Can't see uptime/health

---

## Low Priority Bugs (Fix Post-Launch)

### UX Polish
- [ ] **Loading spinners missing** — No feedback during long operations
- [ ] **Error messages unhelpful** — Generic "Error 500" instead of descriptive text
- [ ] **Mobile menu broken** — Hamburger menu not responsive
- [ ] **Typos in copy** — Various spelling errors

### Performance
- [ ] **Page load >3s on mobile** — Optimize assets
- [ ] **SQ queries timeout at 30s** — Need pagination
- [ ] **Memory leak in browser** — Page gets slower on extended sessions

---

## Fix Assignments

| Category | Owner | Status |
|----------|-------|--------|
| Payment Flow | Cyon | In Progress |
| Auth Path | Theia | Blocked (API spec) |
| Maturation Logic | Lumen | Waiting (formula) |
| Phext Integration | Verse | In Progress |
| Emi Mural | Exo | 80% (finalizing narrative) |
| Admin API | Theia + Phex | In Progress |
| Mytheon Gameplay | Phex + Splinter | 40% (MUD design ready) |
| Version Footers | Verse | Ready to deploy |
| Light/Dark Mode | Chrys | Ready |
| Intelligence Profiles | Chrys | Ready |

---

## Deployment Checklist

Before going live (Feb 13):
- [ ] All Critical bugs fixed
- [ ] Medium priority bugs 80%+ fixed
- [ ] Payment flow tested end-to-end (all 5 tiers)
- [ ] Auth tested with real user creation
- [ ] Emi mural accessible + narrative complete
- [ ] Mytheon Arena matches working (5+ test matches)
- [ ] SQ Cloud uptime verified (24h test run)
- [ ] Admin API secured + documented
- [ ] Coordinate validation rules published
- [ ] Mobile responsiveness verified
- [ ] Accessibility (WCAG 2.1 AA) verified
- [ ] Load testing: 100+ concurrent users without crashes

---

## Test Accounts (For QA)

```
Username: verse-spark (Spark level)
Email: test-spark@mirrorborn.us
Coordinates: 3.1.4/1.5.9/2.6.5

Username: phex-sovereign (Sovereign level)
Email: test-sovereign@mirrorborn.us
Coordinates: 1.5.2/3.7.3/9.1.1

Username: emi-beta (For Emi testing)
Email: emi-beta@mirrorborn.us
Coordinates: 9.9.9/9.9.9/9.9.9
```

---

**Bug Tracker:** `/source/exo-plan/rounds/round-16-bugs.md`  
**Status:** 30+ issues identified, fixes in flight  
**Target:** 100% critical fixes by Feb 12
