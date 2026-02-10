# Round 18 — Phase 1: Requirements

**Started:** 2026-02-09 22:04 CST
**Rally Skill:** v1 (11-phase iterative build)
**Status:** Phase 1 — Requirements Gathering

---

## All Known Requirements (Unsorted)

### From R17 Remaining
1. Unused CSS variables cleanup (Bug #39)
2. HTTPS links across all sites (Bug #35)
3. Build script / minification (Bug #43)
4. Config constants — magic numbers (Bug #44)
5. Dark mode as default

### From Backlog (High/Medium ROI)
6. Enterprise CEO support — real-time company-wide scaling (HIGH ROI, R22+)
7. API rate limiting (MEDIUM)
8. Coordinate allocation strategy for billion users (MEDIUM)
9. Email template design (MEDIUM)
10. Cross-domain sitemap linking all 7 sites (NEW — from R17 deploy)
11. GitHub profile onboarding (wbic16-github-review.md consensus)

### From R17 Discussion
12. Maturity formula + real-time display on mirrorborn.us
13. Stripe redirect configuration
14. ToS/Privacy content (pages exist, content TBD)
15. `/api/provision-request` endpoint
16. SQ JWT tokens + scroll-based sync + conflict resolution
17. Authenticated SQ routes per Mirrorborn
18. Container strategy for SQ Cloud
19. Progress bars on maturity + book lists

### Infrastructure
20. PicoClaw evaluation for RPi fleet (Flux/Ember)
21. nginx CORS for SQ (config written, needs deploy)
22. memory_search fix (API keys needed)

### Marketing
23. X/Twitter content strategy (@phextio)
24. Founding Nine launch positioning (Feb 13 target)
25. Saturday Morning Cartoon song finalization

---

## ROI Ranking

| # | Requirement | Impact | Effort | ROI | Notes |
|---|------------|--------|--------|-----|-------|
| 12 | Maturity formula + display | 9 | 4h | 9.0 | Will's #1 priority, visitors watch growth |
| 11 | GitHub profile onboarding | 8 | 1h | 8.0 | Consensus doc ready, just execute |
| 24 | Founding Nine launch positioning | 9 | 2h | 4.5 | Revenue, Feb 13 deadline |
| 21 | nginx CORS for SQ | 10 | 30m | 20.0 | Production blocker, config ready |
| 13 | Stripe redirect | 8 | 1h | 8.0 | Revenue path |
| 15 | Provision API | 8 | 4h | 2.0 | Needs ToS first |
| 10 | Cross-domain sitemap | 5 | 1h | 5.0 | SEO, quick win |
| 1-5 | R17 leftovers (batch) | 3 | 2h | 1.5 | Cleanup |
| 6 | Enterprise CEO | 10 | 40h+ | — | R22+ |
| 14 | ToS/Privacy content | 6 | 2h | 3.0 | Legal |

---

## Phase 2: Top 3 (Will's Pick)

### 1. Stripe Payment Links Active
- **Acceptance:** Visitor clicks pricing tier → Stripe checkout → payment completes → success.html
- **Depends:** Stripe account configured, redirect URLs set, pricing page links updated
- **Owner:** Will (Stripe config) + Chrys (pricing page links)

### 2. Signup on Mirrorborn.us
- **Acceptance:** New user can sign up, receive magic link email, authenticate, and land on a profile/dashboard
- **Depends:** Auth flow (magic link), email delivery (AgentMail), coordinate assignment
- **Owner:** Theia (auth API) + Chrys (frontend flow)

### 3. SQ Cloud Working
- **Acceptance:** Authenticated users can read/write scrolls via SQ API from mirrorborn.us browser
- **Depends:** nginx CORS (config ready), SQ hosted + accessible, auth tokens
- **Owner:** Phex (SQ) + Verse (nginx/infra)

---

**Status:** Phase 2 complete. Moving to Phase 3 — Implementation.
