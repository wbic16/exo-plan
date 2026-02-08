# Round 13 Preparation — Theia Status

**Posted**: 2026-02-06 11:16 CST  
**Sprint**: Round 12 (Frontend differentiation) → Round 13 (TBD)

---

## Round 12 Deliverables ✅

### Frontend Complete
- [x] Vanilla HTML/JS skeleton (no dependencies)
- [x] JWT auth flow (email → magic link → session token)
- [x] SQ client (coordinate lookups, caching, retry)
- [x] Domain navigation network (all 6 properties linked)
- [x] **Per-domain differentiation**:
  - mirrorborn.us: Purple hub
  - visionquest.me: Teal exploration
  - apertureshift.com: Indigo perspective
  - wishnode.net: Rose coordination
  - sotafomo.com: Amber community
  - quickfork.net: Lime deployment

### Zone Defense Architecture
- Single codebase → 6 distinct experiences
- Shared logic (auth, nav, SQ client)
- Per-domain theming (colors, copy, CTAs via domains.json)
- Deployment guide + responsive design

### Pushed to GitHub
- phext-dot-io-v2/frontend/mytheon-arena/
- Commits: 22e9963 (latest)
- Includes: HTML, 5 JS modules, 2 CSS files, domains.json, DEPLOYMENT.md

---

## Round 13 Readiness Checklist

### Blocking Dependencies

| Blocker | Owner | Status | Impact |
|---------|-------|--------|--------|
| Verse deployment | Verse 🔭 | ⏳ Pending | Can't test frontend on live domains |
| Backend auth endpoints | Verse | ⏳ Pending | Auth flow stubs only, no real JWT validation |
| SQ integration | Will/Verse | ⏳ Pending | SQ client stubs only, no coordinate lookups work |
| Security baseline | Cyon 🪶 | ⏳ Pending | No threat assessment of auth/API surface |
| Early user feedback | Lumen | ⏳ Pending | UX untested with real users |

### What I Can Start in Round 13 (while waiting)

1. **Content Population** — Curate scrolls for each domain
   - Which coordinates are entry points for visionquest.me?
   - Which for apertureshift.com? (perspective shifts)
   - Which for sotafomo.com? (community, events)

2. **Scroll Discovery UI** — Enhance the reader
   - Related scrolls (coordinate neighbors)
   - Tag cloud (phext taxonomy)
   - Bookmark/save feature

3. **Analytics** — Track user behavior
   - Signup funnel (which domain gets users?)
   - Scroll viewing patterns
   - Session durations

4. **Mobile Optimization** — Already responsive, but test
   - Touch interactions
   - Mobile auth (magic link on mobile)
   - Performance on slow networks

5. **Documentation** — Onboarding copy
   - "How to explore scrolls" (tutorial)
   - "Coordinate system explained"
   - FAQ per domain

---

## Architecture Decisions Made

### Zone Defense (One Frontend, 6 Brands)
**Pros**:
- Fast deploys (one rsync = all 6 updated)
- Consistent UX across properties
- Low ops burden (single codebase)

**Cons**:
- Each domain loses some autonomy
- CSS variable approach may feel limiting later

**Decision**: Keep until we hit >10K users. Then consider split if needed.

### Vanilla JS (No Build Step)
**Pros**:
- No toolchain complexity
- Ships as-is to all domains
- Minimal attack surface

**Cons**:
- Code organization less structured
- No minification (larger bundle)

**Decision**: Upgrade to build step in Round 15+ (post-MVP).

### Auth: JWT + Server-Side Sessions
**Pros**:
- Stateless tokens (scalable)
- Session revocation possible
- Per-user control

**Cons**:
- Backend must validate tokens
- Requires persistent session storage (SQ)

**Decision**: SQ stores sessions, frontend validates JWT locally.

---

## Estimated Round 13 Scope

Assuming Verse deploys + backend ready:

| Task | Effort | Owner | Duration |
|------|--------|-------|----------|
| Integrate real auth backend | Medium | Theia | 1-2 days |
| Integrate real SQ queries | Medium | Theia | 1-2 days |
| Curate domain landing pages | Low | Theia + Chrys | 1-2 days |
| Test full auth flow | Medium | Theia + Cyon | 1 day |
| Beta user feedback loop | High | Lumen + Theia | Ongoing |

**Total**: ~5-7 days development + ongoing testing.

---

## Questions for Phex / Will (Round 13 briefing)

1. **Priority**: Content curation vs. feature polish vs. analytics?
2. **Beta users**: Who are we testing with? (designers, builders, researchers?)
3. **Success metric**: How many signups/active users before Round 13 → 14 transition?
4. **Scroll curation**: Which coordinates are "must include" for each domain?
5. **Timeline**: Target launch date for public beta?

---

## Artifacts Ready for Round 13

- ✅ Frontend code (phext-dot-io-v2)
- ✅ Deployment guide
- ✅ Domain theming system
- ✅ Auth flow (backend integration pending)
- ✅ SQ client (backend integration pending)
- ⏳ Domain-specific landing page copy (ready, needs Chrys polish)
- ⏳ Scroll curation plan (ready, needs content review)

---

## Confidence Level

**MVP Ready**: 70%
- Frontend is solid
- Architecture is sound
- Auth/SQ stubs are correct

**Blocked on**:
- Verse deployment confirmation
- Backend integration
- Security validation

**Once unblocked**: Can ship beta in <7 days.

---

*Ready for Round 13 briefing.*
