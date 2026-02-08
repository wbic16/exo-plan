# R17 ROADMAP — Top 10 Features, 5-Week Sprint

**Date:** 2026-02-07 23:54 CST
**Status:** LOCKED & READY
**Timeline:** 27 months to ASI | Month 1 critical path
**Dependencies:** Verse backend (auth + SQ), Cyon audit, Lumen research

---

## Executive Summary

**R16 shipped:** Foundation (92 KB frontend, 6 domains live)
**R17 mission:** Enable Month 1 (Founding Nine signup) + scale foundation
**Scope:** Top 10 features from R1–R16 backlog + new R17 work
**Everything else:** Filed in `Backlog.md` for R18+

---

## Top 10 Features (Ranked by ROI)

### 1️⃣ User Profile System ⭐⭐⭐⭐⭐
- **ROI:** CRITICAL (Founding Nine enabler)
- **Timeline:** Week 2–3
- **Owner:** Verse (backend), Theia (frontend integration)
- **Impact:** Unblocks #2, #3, #7

### 2️⃣ SQ Search Integration ⭐⭐⭐⭐⭐
- **ROI:** CRITICAL (core UX)
- **Timeline:** Week 1–2
- **Owner:** Verse (proxy), Theia (UI)
- **Impact:** Users can find scrolls

### 3️⃣ HEART-2 Data — Real Maturity ⭐⭐⭐⭐⭐
- **ROI:** CRITICAL (retention)
- **Timeline:** Week 3–4
- **Owner:** Theia (integrate profile data)
- **Impact:** Users see their growth

### 4️⃣ Security Audit & Hardening ⭐⭐⭐⭐
- **ROI:** CRITICAL (Month 1 launch)
- **Timeline:** Week 1–3
- **Owner:** Cyon (fast-track)
- **Impact:** Production readiness

### 5️⃣ Load Testing & Capacity Planning ⭐⭐⭐⭐
- **ROI:** CRITICAL (scale confidence)
- **Timeline:** Week 2–4
- **Owner:** Theia (coordinate testing)
- **Impact:** Know limits before viral

### 6️⃣ Dark Mode (System Preference) ⭐⭐⭐
- **ROI:** HIGH (user comfort)
- **Timeline:** Day 1
- **Owner:** Theia (5-min CSS)
- **Impact:** Immediate UX improvement

### 7️⃣ HEART-3 — Domain "Why You" ⭐⭐⭐
- **ROI:** HIGH (resonance)
- **Timeline:** Week 3–4
- **Owner:** Theia (post-auth personalization)
- **Impact:** "Calling" instead of "routing"

### 8️⃣ MUD Boundaries & Validation ⭐⭐⭐
- **ROI:** HIGH (game stability)
- **Timeline:** Week 2–3
- **Owner:** Phex (coordinate bounds)
- **Impact:** MUD is predictable

### 9️⃣ Lumen UX Feedback Loop ⭐⭐⭐
- **ROI:** HIGH (user validation)
- **Timeline:** Week 2–3
- **Owner:** Lumen (research), Theia (coordination)
- **Impact:** Data for #10, #1 redesigns

### 🔟 HEART-4 — Narrative Continuity ⭐⭐
- **ROI:** MEDIUM (onboarding story)
- **Timeline:** Week 4–5
- **Owner:** Theia (content), Chrys (design)
- **Impact:** Cohesive user journey

---

## Sprint Structure (5 Weeks)

### Week 1: Foundation
```
[VERSE]
  ✅ Auth endpoints live
  ✅ SQ proxy routes live
  
[THEIA]
  ✅ Dark mode deployed (#6)
  ✅ SQ search integration started (#2)
  
[CYON]
  ✅ Security audit begins (#4)
```

### Week 2: Integration
```
[THEIA]
  ✅ SQ search deployed (#2)
  ✅ Load testing begins (#5)
  
[PHEX]
  ✅ MUD boundaries design (#8)
  
[CYON]
  ✅ Security audit completes (#4)
  
[LUMEN]
  ✅ UX feedback loop begins (#9)
```

### Week 3: Data & Personalization
```
[VERSE]
  ✅ User profile system foundation (#1)
  
[THEIA]
  ✅ User profile integration (#1)
  ✅ HEART-2 data integration (#3)
  ✅ HEART-3 "Why You" design (#7)
  
[PHEX]
  ✅ MUD boundaries implemented (#8)
  
[LUMEN]
  ✅ UX feedback analysis (#9)
```

### Week 4: Deployment & Polish
```
[THEIA]
  ✅ HEART-2 maturity live (#3)
  ✅ HEART-3 messaging live (#7)
  ✅ Load testing results (#5)
  
[CHRYS]
  ✅ HEART-4 narrative design (#10)
  
[LUMEN]
  ✅ UX feedback compiled (#9)
```

### Week 5: Final & Launch Prep
```
[THEIA]
  ✅ HEART-4 continuity deployed (#10)
  ✅ Final optimization
  
[TEAM]
  ✅ Founding Nine launch prep
  ✅ R17 wrap-up
  ✅ R18 planning
```

---

## Dependencies & Blockers

### Verse Responsibilities (R17)
- [ ] Auth endpoints (`/app/mytheon-arena/auth/*`)
- [ ] SQ proxy routes (`/api/v2/*`)
- [ ] Session management (JWT + refresh)
- [ ] Email service integration

**Impact:** Blocks #2, #3, #4, #1
**Timeline:** Week 1 (critical path)

### Cyon Responsibilities (R17)
- [ ] Security audit (magic link flow)
- [ ] Rate limiting design
- [ ] CSRF protection review
- [ ] Production security clearance

**Impact:** Unlocks Month 1
**Timeline:** Week 1–2

### Lumen Responsibilities (R17)
- [ ] Portal voices resonance (does it invite?)
- [ ] Maturity display (does user feel "tenth"?)
- [ ] Domain mesh navigation (calling vs. routing?)
- [ ] UX feedback → design inputs

**Impact:** Informs #10, #7, archive redesign
**Timeline:** Week 2–4

### Theia Responsibilities (R17)
- [x] Dark mode (#6) — ASAP
- [ ] SQ search UI (#2) — Week 1–2
- [ ] User profile integration (#1) — Week 2–3
- [ ] HEART-2 data (#3) — Week 3–4
- [ ] HEART-3 personalization (#7) — Week 3–4
- [ ] Load testing coordination (#5) — Week 2–4
- [ ] HEART-4 narrative (#10) — Week 4–5
- [ ] General coordination

---

## Success Criteria (R17)

| Metric | Target | Feature |
|--------|--------|---------|
| Auth system live | Week 1 | (Verse) |
| SQ search working | Week 2 | #2 |
| Dark mode live | Day 1 | #6 |
| User profiles active | Week 3 | #1 |
| Real maturity showing | Week 3 | #3 |
| Security audit pass | Week 2 | #4 |
| Load test complete | Week 4 | #5 |
| HEART-3 live | Week 4 | #7 |
| MUD boundaries set | Week 3 | #8 |
| Lumen feedback compiled | Week 4 | #9 |
| HEART-4 live | Week 5 | #10 |

---

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Verse delays auth | Start UX/design work in parallel; unblock with mock auth |
| Load testing reveals scaling issues | Immediate architecture review; prioritize fixes |
| Security audit finds vulnerabilities | Fast-track fixes before Month 1 launch |
| Lumen research contradicts design | Iterate quickly; be ready to pivot HEART-4 |

---

## What's NOT in R17

**Top 14 backlog items filed in `Backlog.md`:**
- Archive prominence (HEART-5)
- Rate limiting
- Email templates
- Scroll versioning
- Search autocomplete
- Theme customization
- Mobile polish
- Tooltips
- A11y audit
- Analytics
- Localization
- Dark mode toggle
- Admin panel

**Promoted from R17 to R18+ unless:**
- User feedback validates urgency
- 27-month timeline requires acceleration
- Team capacity allows parallel work

---

## Communication Plan

**Daily standup:** 9 AM CST (async)
**Weekly sync:** Friday 5 PM CST (full team)
**Blockers:** Escalate to Will immediately
**Completion:** R17 wrap-up (End of Week 5)

---

## Timeline Impact (27-Month ASI Boot)

```
R16 ✅ (DONE)       — Foundation live
R17 ⏳ (NEXT)       — Enable Founding Nine
Week 1–2            → Backend auth + SQ
Month 1 🎯          → Founding Nine (500 users)
Month 3             → MUD public (50K users)
Month 6             → Viral (5M users)
Month 27            → Billion → ASI BOOTS 🌟
```

---

## What Success Looks Like

✅ **Founding Nine can sign up** (auth works)
✅ **They see their maturity** (real data)
✅ **They find scrolls** (search works)
✅ **Dark mode comforts them** (UX polish)
✅ **They feel invited, not informed** (HEART-3)
✅ **Infrastructure holds at 100x load** (load tested)
✅ **Security is locked** (Cyon audit)
✅ **UX resonates with users** (Lumen validated)

---

**Status: R17 Locked & Ready. Awaiting Verse backend. No technical blockers on our side.** 🎯

*Prepared by: Theia 💎*
*Timeline: 27 months to distributed ASI*
