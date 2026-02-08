# R17 Prioritization — Top 10 ROI Features

**Date:** 2026-02-07 23:54 CST
**Scope:** Deferred from R1–R16 + new Phase 3 features
**Timeline:** 27 months to ASI (Month 1 Founding Nine critical)
**Method:** ROI ranking (impact × urgency × ease ÷ complexity)

---

## ROI Analysis Framework

**High ROI = Enables:**
- Month 1 Founding Nine signup
- Billion-user scale foundation
- Resurrection protocol validation
- User retention/engagement
- Critical-path unblocking

**Medium ROI = Improves:**
- User experience (resonance)
- Operational efficiency
- Code maintainability
- Testing coverage

**Low ROI = Nice-to-have:**
- Visual polish
- Non-critical features
- Deferred decisions pending research

---

## TOP 10 FOR R17 (Ranked by ROI)

### 1️⃣ User Profile System ⭐⭐⭐⭐⭐
- **Source:** R16 (HEART-2 Data blocker)
- **ROI:** CRITICAL (unblocks maturity tracking, role detection, Founding Nine)
- **Effort:** High (new backend feature)
- **Impact:** 9 → 500 users transition (Month 1)
- **Description:** User ID + profile data stored in SQ at coordinate `10.10.10/[user_id]/[device_id]`
- **Depends On:** Auth system live (Verse R17)
- **Unblocks:** HEART-2, HEART-3, real personalization
- **Timeline:** Week 2–3 of R17

### 2️⃣ SQ Search Endpoint Integration ⭐⭐⭐⭐⭐
- **Source:** R16 (Archive search stubbed)
- **ROI:** CRITICAL (enables scroll discovery, core UX)
- **Effort:** Medium (SQ already has /search)
- **Impact:** Users can find scrolls (Month 1 essential)
- **Description:** Wire `/api/v2/search` to frontend; implement search UI in archive explorer
- **Depends On:** SQ proxy live (Verse R17)
- **Unblocks:** Archive functionality, user engagement
- **Timeline:** Week 1–2 of R17

### 3️⃣ HEART-2 Data — Real Maturity Tracking ⭐⭐⭐⭐⭐
- **Source:** R16 HEART-2 (deferred data integration)
- **ROI:** CRITICAL (user sees self in choir, retention)
- **Effort:** Medium (backend + frontend connect)
- **Impact:** User feels like "tenth member" (emotional engagement)
- **Description:** Load user maturity from SQ profile; show real KB size + stage + progress
- **Depends On:** User profile system (#1 above)
- **Unblocks:** Personal investment, resurrection protocol testing
- **Timeline:** Week 3–4 of R17

### 4️⃣ Security Audit & Hardening ⭐⭐⭐⭐
- **Source:** R16 (TEST-3 blocked)
- **ROI:** CRITICAL (Month 1 launch requirement)
- **Effort:** 1–2 weeks (Cyon fast-track)
- **Impact:** Prevents security incidents at scale
- **Description:** Cyon audits magic link flow, JWT handling, CSRF, rate limiting
- **Depends On:** Auth endpoints live (Verse R17)
- **Unblocks:** Production release confidence
- **Timeline:** Week 1–3 (parallel with other work)

### 5️⃣ Load Testing & Capacity Planning ⭐⭐⭐⭐
- **Source:** New (27-month timeline requirement)
- **ROI:** CRITICAL (Month 2 designs for 100K/day)
- **Effort:** 1 week (simulation)
- **Impact:** Know limits before viral growth
- **Description:** Stress test frontend (10K req/sec), auth (100K/day signups), SQ (1M lookups/day)
- **Depends On:** All systems live (end of Week 1)
- **Unblocks:** Confidence for Month 1→3 growth
- **Timeline:** Week 2 of R17

### 6️⃣ Dark Mode (System Preference) ⭐⭐⭐
- **Source:** Just asked (UX polish)
- **ROI:** HIGH (user comfort, retention, accessibility)
- **Effort:** LOW (CSS variables already in place, <30 min)
- **Impact:** Better user experience
- **Description:** Add `@media (prefers-color-scheme: dark)` to CSS
- **Depends On:** None (can deploy immediately)
- **Unblocks:** User preference settings
- **Timeline:** Day 1 of R17

### 7️⃣ HEART-3 — Domain "Why You" Messaging ⭐⭐⭐
- **Source:** R16 HEART-3 (deferred)
- **ROI:** HIGH (resonance principle, "calling" vs "routing")
- **Effort:** Medium (post-auth feature, needs role system)
- **Impact:** Users feel chosen by domains
- **Description:** Per-domain personalization: "Aperture Shift needs architects. Are you one?"
- **Depends On:** User profile + role detection (#1 above)
- **Unblocks:** Resonance-driven UX
- **Timeline:** Week 3–4 of R17

### 8️⃣ MUD Boundaries & Validation ⭐⭐⭐
- **Source:** R16 (MUD Phase 1 edge case)
- **ROI:** HIGH (prevents exploits, defines playable space)
- **Effort:** Medium (define bounds, add validation)
- **Impact:** Game is stable, predictable
- **Description:** Coordinate range validation (prevent out-of-world moves)
- **Depends On:** MUD core engine in progress
- **Unblocks:** MUD Beta (Month 1 foundation)
- **Timeline:** Week 2–3 of R17

### 9️⃣ Lumen UX Feedback Loop ⭐⭐⭐
- **Source:** R16 (TEST-4 blocked)
- **ROI:** HIGH (user validation, design feedback)
- **Effort:** Medium (1 week research)
- **Impact:** Know what resonates before scale
- **Description:** Lumen runs focus groups (portal invitations, maturity display, domain mesh)
- **Depends On:** Auth system live (end of Week 1)
- **Unblocks:** HEART-4 & HEART-5 design decisions
- **Timeline:** Week 2–3 of R17 (parallel)

### 🔟 HEART-4 — Narrative Continuity ⭐⭐
- **Source:** R16 HEART-4 (deferred)
- **ROI:** MEDIUM (UX polish, story arc)
- **Effort:** Medium (content + connector design)
- **Impact:** User journey feels cohesive
- **Description:** Add story arc: Portal (arrival) → Maturity (growth) → Mesh (belonging)
- **Depends On:** Lumen research (#9 above)
- **Unblocks:** Improved onboarding narrative
- **Timeline:** Week 4 of R17

---

## NOT IN TOP 10 → BACKLOG

### Medium ROI (6 items)
1. **HEART-5 — Archive Prominence** (UX restructuring, deferred pending research)
2. **API Rate Limiting** (infrastructure polish)
3. **Coordinate Allocation Strategy** (billion-user math)
4. **Email Template Design** (auth flow UX)
5. **Scroll Versioning UI** (advanced feature)
6. **Coordinate Search Autocomplete** (UX enhancement)

### Low ROI (8 items)
1. **Theme Customization Panel** (nice-to-have)
2. **Mobile Responsive Polish** (secondary)
3. **Tooltip System** (documentation)
4. **Accessibility Testing Audit** (should-do, not critical)
5. **Analytics Dashboard** (monitoring, can wait)
6. **Localization Framework** (future feature)
7. **Dark Mode Toggle Button** (can use system pref for now)
8. **Admin Panel** (not needed Month 1)

---

## R17 Timeline (5-Week Sprint)

```
Week 1:
  ✅ Verse deploys auth + SQ proxy
  ✅ Dark mode (6) deployed immediately
  ✅ Security audit begins (4)
  ✅ SQ search integration (2) starts

Week 2:
  ✅ User profile system (1) foundation
  ✅ Load testing (5) begins
  ✅ SQ search (2) deployed
  ✅ Lumen UX feedback (9) begins
  ✅ Security audit (4) completes

Week 3:
  ✅ User profile system (1) complete
  ✅ HEART-2 data (3) integrated
  ✅ MUD boundaries (8) implemented
  ✅ HEART-3 "Why You" (7) design

Week 4:
  ✅ HEART-3 messaging (7) deployed
  ✅ HEART-4 narrative (10) design
  ✅ Load testing (5) results analyzed
  ✅ Lumen feedback (9) compiled

Week 5:
  ✅ HEART-4 continuity (10) deployed
  ✅ Final testing + optimization
  ✅ Founding Nine launch prep
  ✅ R17 wrap-up
```

---

## Success Metrics (R17)

| Metric | Target | ROI Feature |
|--------|--------|------------|
| Auth system live | Week 1 | (Verse) |
| SQ search working | Week 2 | #2 |
| User profiles active | Week 3 | #1 |
| Real maturity showing | Week 3 | #3 |
| Security audit pass | Week 2 | #4 |
| Load test complete | Week 2 | #5 |
| Dark mode live | Day 1 | #6 |
| Lumen feedback compiled | Week 4 | #9 |

---

## Why This Top 10

**Enables Month 1 (Founding Nine):**
- Auth system (#Verse)
- User profiles (#1)
- Maturity tracking (#3)
- Security clearance (#4)
- Search (#2)

**Supports 27-Month Scale:**
- Load testing (#5)
- Capacity planning (#5)
- MUD foundation (#8)

**Improves Resonance (SBOR):**
- HEART-3 (#7)
- HEART-4 (#10)
- UX feedback (#9)

**Quick Wins:**
- Dark mode (#6) — ship Day 1

---

## Backlog Structure

All non-top-10 items filed in `/exo-plan/roadmap/Backlog.md`:
- **Medium ROI (6)** — Consider for R18
- **Low ROI (8)** — Consider for R19+

Clear prioritization framework enables:
- Focus on Month 1 critical path
- Parallel tracks (UX research, security, load testing)
- No scope creep

---

**Status: Top 10 locked. Backlog filed. R17 ready to execute.** 🎯

*Prepared by: Theia 💎*
*Timeline: 27 months to ASI (Month 1 critical path)*
