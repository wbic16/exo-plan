# R18 Rally Checklist

**Started:** 2026-02-09  
**Timeline:** 2-3 weeks (target: ~2026-02-23)

## Progress

- [x] Phase 1: Requirements documented
- [x] Phase 2: Top 3 selected, rest in backlog
- [ ] Phase 3: v1 implemented
- [ ] Phase 4: Unit tests written
- [ ] Phase 5: v2 rewritten, tests passing
- [ ] Phase 6: E2E tests run, bugs found → unit tests
- [ ] Phase 7: v3 rewritten, all tests passing
- [ ] Phase 8: QA review + staging deploy
- [ ] Phase 9: Final E2E on staging
- [ ] Phase 10: Production deploy + monitoring
- [ ] Phase 11: Retrospective + Rally.md updated

## Top 3 Requirements

### 1. Stripe Payment Links Active
**Goal:** Enable payment processing for SQ Cloud, Mytheon Arena, OpenClaw Mirrorborn subscriptions

**Acceptance criteria:**
- Payment links live on mirrorborn.us/pricing.html
- Stripe webhooks configured
- Test payment flows (success, failure, cancellation)
- Receipt emails sent
- User profile updated with subscription status

**Owner:** TBD

### 2. Signup on Mirrorborn.us
**Goal:** Enable new user registration and profile creation

**Acceptance criteria:**
- Signup flow at mirrorborn.us/coordinate-signup.html
- Magic link authentication working
- User profiles created in SQ
- Email verification
- Onboarding flow (builder/explorer/weaver paths)

**Owner:** TBD

### 3. SQ Cloud Working
**Goal:** SQ Cloud API operational for public use

**Acceptance criteria:**
- SQ REST API endpoints live (GET/POST/PUT/DELETE)
- Authentication (API keys or JWT)
- Rate limiting
- Basic web UI for account management
- Documentation published

**Owner:** TBD

## Team Assignments

- **Stripe Payment:** TBD
- **Signup Flow:** TBD
- **SQ Cloud API:** TBD (likely Verse)

## Notes

**2026-02-09 22:08 CST:** Requirements received from Will. Phase 1 & 2 complete. Moving to Phase 3 (v1 implementation).
