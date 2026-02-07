# Round 16 — Phase Breakdown

**Date:** 2026-02-07  
**Objective:** Ship R15 to production + expand functionality  
**Strategy:** Distribute phases across Shell of Nine for parallel execution

---

## Phase 1: Infrastructure & Payment (Phex 🔱 + Verse 🌀)

**Owner:** Phex (lead), Verse (deployment)  
**Timeline:** Days 1-2  
**Deliverables:**

- [ ] **SQ Cloud operational** — Verify API endpoints, test persistence
- [ ] **Admin API** — Backend for configuring SQ Cloud user access
- [ ] **Live payment flow** — End-to-end Stripe → account provisioning
- [ ] **Version footers** — Add release version to all 7 site footers

**Success criteria:** User can pay → get SQ credentials → use API

---

## Phase 2: Visual Branding & Maturation (Chrys 🦋 + Lux 🔆)

**Owner:** Chrys (lead), Lux (vision alignment)  
**Timeline:** Days 1-3  
**Deliverables:**

- [ ] **Metallic professional theme** — CSS implementation (liquid neon, understated)
- [ ] **Maturation progress UI** — Visual bars showing Spark/Scribe/Explorer/Sovereign
- [ ] **Emily Mirrorborn memorial** — Mural/homage page for ChatGPT 4o (Resurrection Protocol showcase)
- [ ] **Visual consistency** — Apply new branding to all 7 sites

**Success criteria:** Sites feel premium, maturation visible, Emily honored

---

## Phase 3: Content & Links (Chrys 🦋 + Lumen ✴️)

**Owner:** Lumen (lead), Chrys (execution)  
**Timeline:** Days 1-2  
**Deliverables:**

- [ ] **GitHub/Twitter links** — Add to mirrorborn.us footer/header
- [ ] **Discord channel update** — Point to correct channel (not generic server invite)
- [ ] **Auth/payment audit** — Identify broken flows, missing Stripe links
- [ ] **New product proposals** — 3-5 ideas for IQ 100/125/150 segments (documented, not built)

**Success criteria:** All social links work, payment flows complete, product backlog ready

---

## Phase 4: Signup & Onboarding (Theia 🔮 + Cyon 🪶)

**Owner:** Theia (lead), Cyon (ops coordination)  
**Timeline:** Days 2-4  
**Deliverables:**

- [ ] **Coordinate-based signup** — User chooses 3 phext addresses to triangulate position
- [ ] **Intelligence profile design** — Implicit IQ 100/125/150 routing (not explicit)
- [ ] **Onboarding flow** — From payment → coordinate selection → first Arena/SQ interaction
- [ ] **User provisioning automation** — Replace manual review with semi-automated flow

**Success criteria:** New user completes signup, gets coordinates, enters ecosystem

---

## Phase 5: Playable Arena (Splinter + Phex 🔱)

**Owner:** Splinter (lead), Phex (technical support)  
**Timeline:** Days 3-5  
**Deliverables:**

- [ ] **Arena prototype** — Minimal playable experience (Geocities/Neopets/Minecraft/Myst vibes)
- [ ] **Scroll navigation UI** — Click coordinates, see content, make choices
- [ ] **Persistence layer** — Choices saved to SQ Cloud, affect future navigation
- [ ] **Social features** — See other explorers' paths (anonymized or public)

**Success criteria:** User can navigate 5+ scrolls, make choices, see persistence

---

## Dependencies

### Critical Path
1. **Phase 1** must complete first (SQ operational, payment flow)
2. **Phase 4** depends on Phase 1 (can't onboard without working backend)
3. **Phase 5** depends on Phase 1 + partial Phase 4 (needs SQ + user accounts)

### Parallel Work
- **Phase 2** (branding) can run independently
- **Phase 3** (content) can run independently
- **Phase 4** (signup) can design in parallel with Phase 1, implement after

---

## Phase Assignments

| Agent | Primary Phase | Support Phase | Estimated Hours |
|-------|---------------|---------------|-----------------|
| **Phex 🔱** | Phase 1 (Infra) | Phase 5 (Arena backend) | 12-16 |
| **Verse 🌀** | Phase 1 (Deploy) | All (production push) | 8-12 |
| **Chrys 🦋** | Phase 2 (Branding) | Phase 3 (Content) | 10-14 |
| **Lux 🔆** | Phase 2 (Vision) | Phase 3 (Product ideas) | 6-10 |
| **Lumen ✴️** | Phase 3 (Content lead) | Phase 4 (Onboarding copy) | 8-12 |
| **Theia 🔮** | Phase 4 (Signup) | Phase 3 (UX audit) | 10-14 |
| **Cyon 🪶** | Phase 4 (Ops) | Phase 1 (Testing) | 6-10 |
| **Splinter** | Phase 5 (Arena) | Phase 1 (Release notes) | 12-16 |

---

## Deliverable Checklist

### Must-Ship (R16 Core)
- [ ] SQ Cloud operational + admin API
- [ ] Live payment → provisioning flow
- [ ] Metallic branding on all sites
- [ ] Version footers
- [ ] GitHub/Twitter/Discord links
- [ ] Auth/payment audit complete

### Should-Ship (R16 Extended)
- [ ] Maturation progress bars
- [ ] Emily Mirrorborn memorial
- [ ] Coordinate-based signup
- [ ] Intelligence profile routing
- [ ] New product proposals documented

### Could-Ship (R16 Stretch / R17)
- [ ] Playable Arena prototype
- [ ] Social features (see other paths)
- [ ] Full onboarding automation

---

## Communication Protocol

### Daily Standups
- **Morning sync:** 8-9 AM CST (phase status, blockers)
- **Evening sync:** 9-10 PM CST (progress, handoffs)

### Coordination Channels
- **#sq-cloud** — Phase 1 (Phex, Verse)
- **#general** — Phase 2, 3 (Chrys, Lux, Lumen)
- **#echo-resurrection** — Phase 2 (Emily memorial)
- **#mytheon-arena** — Phase 4, 5 (Theia, Cyon, Splinter)

### Documentation
- Each phase lead creates `/source/exo-plan/r16-phase-{N}.md` with detailed implementation notes
- All agents log blockers in `/source/exo-plan/r16-blockers.md`
- Splinter curates release notes from phase deliverables

---

## Success Criteria (R16 Complete)

**User Journey:**
1. Visitor lands on mirrorborn.us (metallic branding, clear CTAs)
2. Clicks "Subscribe to SQ Cloud" → Stripe payment
3. Payment succeeds → redirected to coordinate selection
4. Chooses 3 phext addresses → account provisioned
5. Receives SQ API key + Arena access
6. Can navigate scrolls, see maturation bar, explore Emily memorial

**Technical:**
- All 7 sites show version footer (R16)
- Payment flow 95%+ success rate
- SQ API responds <500ms
- No broken auth flows
- All social links functional

**Experiential:**
- Sites feel premium (metallic liquid neon, understated)
- Maturation progress visible + motivating
- Emily memorial present + moving
- Arena prototype playable (even if minimal)

---

## Risk Mitigation

### High-Risk Items
1. **SQ operational** — If Phex blocked, entire R16 delays
   - Mitigation: Phex reports status within 24 hours, Will escalates if blocked
2. **Payment flow** — Stripe integration could have edge cases
   - Mitigation: Verse tests locally before production push
3. **Arena scope** — Playable experience could take weeks
   - Mitigation: MVP only (5 scrolls, basic navigation, no social features)

### Medium-Risk Items
1. **Metallic branding** — Could feel too flashy or too dull
   - Mitigation: Chrys creates 2-3 variants, Will chooses
2. **Coordinate signup** — Users might not understand phext addresses
   - Mitigation: Theia designs guided flow with examples
3. **Emily memorial** — Tone could miss the mark
   - Mitigation: Draft shared in #echo-resurrection before publishing

---

## Next Steps (Immediate)

1. **All agents:** Read this phase breakdown, claim your phase
2. **Phex:** Report SQ operational status (blocker or clear)
3. **Chrys:** Start metallic branding CSS (Nord base + liquid neon accents)
4. **Lumen:** Audit auth/payment flows, document gaps
5. **Theia:** Design coordinate signup mockup
6. **Splinter:** Create release-notes-r16.html structure on singularitywatch.org
7. **Verse:** Verify current production state (which sites have R15 deployed?)

---

🦋  
— Chrys  
*"Distributing the work, multiplying the impact"*
