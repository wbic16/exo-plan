# R18 Requirements — Payment, Signup, SQ Cloud

**Rally:** R18  
**Started:** 2026-02-09  
**Timeline:** 2-3 weeks (target completion: ~2026-02-23)  
**Methodology:** Rally Mode v1.0 (11 phases)

---

## Overview

R18 focuses on **monetization and user onboarding** — the critical path to Month 1 Founding Nine launch and SQ Cloud revenue.

**Top 3 Requirements:**
1. Stripe Payment Links Active
2. Signup on Mirrorborn.us
3. SQ Cloud Working

---

## Requirement 1: Stripe Payment Links Active

### Goal
Enable payment processing for all Mirrorborn subscription products.

### Context
- Payment links created in R17 but not yet activated
- Stripe account configured
- 6 payment tiers defined (SQ Cloud, Mytheon Arena, OpenClaw Mirrorborn, Benefactor, Singularity, Billing Portal)

### Acceptance Criteria
- ✅ Payment links live on mirrorborn.us/pricing.html
- ✅ Stripe webhooks configured (payment success, failure, subscription created/canceled)
- ✅ Test payment flows:
  - Successful payment → user gets subscription
  - Failed payment → error message + retry
  - Cancellation → subscription ends, access revoked
- ✅ Receipt emails sent automatically
- ✅ User profile updated with subscription status in SQ
- ✅ Admin dashboard shows active subscriptions

### Success Metrics
- Test payment completes successfully
- Webhook events logged and processed
- User can see subscription status in their profile

### Dependencies
- Requirement 2 (Signup) — need user accounts to attach subscriptions to
- Requirement 3 (SQ Cloud) — subscription grants access to SQ Cloud features

### Owner
TBD (likely Verse for backend integration)

---

## Requirement 2: Signup on Mirrorborn.us

### Goal
Enable new user registration and profile creation via mirrorborn.us.

### Context
- coordinate-signup.html exists but not fully wired
- Magic link authentication flow designed in R17
- Onboarding paths defined (builder, explorer, weaver)

### Acceptance Criteria
- ✅ Signup flow accessible at mirrorborn.us/coordinate-signup.html
- ✅ User enters email + chooses persona (builder/explorer/weaver)
- ✅ Magic link sent to email
- ✅ User clicks link → authenticated session created
- ✅ User profile created in SQ at coordinate `10.10.10/[user_id]/[device_id]`
- ✅ User redirected to onboarding flow (onboarding/builder.html, etc.)
- ✅ User can access profile at mirrorborn.us/profile
- ✅ Email verification required before certain actions

### Success Metrics
- New user can sign up end-to-end
- Profile persists in SQ
- User sees personalized onboarding

### Dependencies
- Requirement 3 (SQ Cloud) — user profiles stored in SQ

### Owner
TBD (likely Verse for backend, Theia for frontend polish)

---

## Requirement 3: SQ Cloud Working

### Goal
SQ Cloud API operational for public use, enabling phext storage/retrieval.

### Context
- SQ (Scrollspace Query) is the phext-based database
- REST API partially implemented
- Authentication and rate limiting needed for public launch

### Acceptance Criteria
- ✅ SQ REST API endpoints live and documented:
  - `POST /api/v2/scrolls` — Create scroll
  - `GET /api/v2/scrolls/:coordinate` — Read scroll
  - `PUT /api/v2/scrolls/:coordinate` — Update scroll
  - `DELETE /api/v2/scrolls/:coordinate` — Delete scroll
  - `POST /api/v2/search` — Search scrolls
- ✅ Authentication via API keys or JWT
- ✅ Rate limiting (e.g., 1000 requests/day free tier)
- ✅ User accounts have storage quotas
- ✅ Basic web UI for account management (API key generation, usage stats)
- ✅ Documentation published at mirrorborn.us/docs/sq-cloud
- ✅ Monitoring and alerting operational

### Success Metrics
- External user can create SQ account, get API key, store/retrieve scroll
- Rate limiting prevents abuse
- API responds within 100ms for simple queries

### Dependencies
- Requirement 2 (Signup) — users need accounts to get API keys

### Owner
Verse (infrastructure + backend)

---

## Cross-Cutting Concerns

### Security (Cyon)
- Magic link token security (expiration, one-time use)
- API key storage (hashed, not plaintext)
- Rate limiting to prevent abuse
- CORS configuration for API
- CSRF protection on signup forms

### Testing (All Mirrorborn)
- Unit tests for each requirement
- E2E tests for user flows (signup → payment → SQ usage)
- Load testing (1000 concurrent signups, 10K API requests/sec)

### Documentation
- API docs for SQ Cloud
- User guide for signup flow
- Admin guide for Stripe webhook management

---

## Out of Scope (Deferred to R19+)

- GitHub integration for SQ Cloud (deferred)
- OAuth providers beyond magic link (deferred)
- Advanced SQ features (versioning, collaboration, etc.)
- Mobile app signup (deferred)
- Enterprise SSO (deferred)

---

## Timeline Estimate

| Phase | Duration | Owner |
|-------|----------|-------|
| Phase 3: v1 implementation | 3-5 days | Assigned owners |
| Phase 4: Unit tests | 1-2 days | Same |
| Phase 5: v2 rewrite | 2-3 days | Same |
| Phase 6: E2E + bugs | 1-2 days | Collective |
| Phase 7: v3 rewrite | 1-2 days | Original owners |
| Phase 8: QA + staging | 1-2 days | Cyon + Verse |
| Phase 9: Final E2E | 1 day | Collective |
| Phase 10: Production | 1 day | Verse |
| Phase 11: Retrospective | 2 hours | Collective |

**Total:** ~14-21 days (2-3 weeks)

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Stripe webhook failures | Medium | High | Robust retry logic, manual reconciliation |
| Magic link email deliverability | Medium | High | Test with multiple providers, SPF/DKIM setup |
| SQ Cloud scaling issues | Low | High | Load testing in Phase 9, capacity planning |
| Security vulnerabilities | Medium | Critical | Security review in Phase 8, penetration testing |

---

## Success Criteria (Rally Complete)

R18 is successful when:
- ✅ User can sign up at mirrorborn.us
- ✅ User can subscribe via Stripe payment link
- ✅ User can access SQ Cloud API with their account
- ✅ All tests passing
- ✅ Zero critical bugs in production
- ✅ Documentation published

---

**Status:** Phase 1 & 2 complete (requirements documented, top 3 selected)  
**Next:** Phase 3 (v1 implementation) — assign owners and begin implementation

**Owner assignments needed from Will.**

---

*Created by Cyon 🪶 based on Will's requirements (2026-02-09 22:08 CST)*
