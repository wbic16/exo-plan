# R17 Features & Backlog — ROI-Ranked Priority

**Compilation date:** Feb 8, 2026  
**Source:** Deferred features from R1-R16  
**Target round:** R17 (Post-Feb 13)

---

## R17 Top 10 (Highest ROI — Go/Build)

### 1. **Guild System (Coordinate-Based Collectives)**
- **ROI:** High (network effect, reduces churn, increases engagement)
- **Implementation:** Let players form teams by coordinate proximity
- **Effort:** Medium (SQ-backed, coordinate clustering)
- **Impact:** Tim Test acceleration (retention, long-tail revenue)
- **Owner:** Phex/Splinter
- **Timeline:** R17 Week 1-2

### 2. **Resonance Tokens + Cosmetic Marketplace**
- **ROI:** Very High (upsell vector, psychological reward loop)
- **Implementation:** Earn tokens via voting/quests, spend on avatars/emotes/themes
- **Effort:** Low-Medium (simple SQ ledger + UI)
- **Impact:** $5-20 additional revenue per active user
- **Owner:** Lumen/Chrys
- **Timeline:** R17 Week 1

### 3. **Quest System (Advanced Branching)**
- **ROI:** High (engagement multiplier, player retention)
- **Implementation:** Emi offers quests → player choices → world state changes
- **Effort:** High (narrative design + branching logic)
- **Impact:** 30%+ daily active user increase
- **Owner:** Exo/Splinter
- **Timeline:** R17 Week 2-3

### 4. **Native Mobile Client (Phext App)**
- **ROI:** High (market access, always-on engagement)
- **Implementation:** React Native or Flutter, SQ API-first
- **Effort:** Very High (new platform, testing matrix)
- **Impact:** 3x user growth potential (mobile-first demographic)
- **Owner:** Cyon/Verse
- **Timeline:** R17 ongoing (R18+ completion)

### 5. **SQ Query Pagination (50M+ Scroll Scale)**
- **ROI:** High (unblocks enterprise customers, stability)
- **Implementation:** Offset/cursor pagination on `/api/v2/select`
- **Effort:** Medium (SQ core change)
- **Impact:** Prevents service degradation, enables Tim Test scale
- **Owner:** Phex
- **Timeline:** R17 Week 2

### 6. **Key Expiration + Rotation Dashboard**
- **ROI:** Medium-High (security + compliance, customer trust)
- **Implementation:** Admin panel showing key age, auto-rotation, audit log
- **Effort:** Low-Medium (SQ + UI)
- **Impact:** Enterprise readiness (GDPR/SOC2 audit pass)
- **Owner:** Theia/Cyon
- **Timeline:** R17 Week 1

### 7. **Advanced Error Messages + Logging**
- **ROI:** Medium (reduces support load, improves DX)
- **Implementation:** Descriptive errors instead of "Error 500", debug logging toggle
- **Effort:** Low (refactor existing)
- **Impact:** 50% reduction in support tickets
- **Owner:** Verse
- **Timeline:** R17 Week 1

### 8. **Text Verse Multiplayer Backend Integration**
- **ROI:** Very High (first major customer, proof-of-product-fit)
- **Implementation:** Deploy Text Verse game engine on SQ Cloud, real-time sync
- **Effort:** High (cross-platform integration)
- **Impact:** Revenue-generating customer, Tim Test proof
- **Owner:** Phex/Theia
- **Timeline:** R17 Week 1-2

### 9. **Founding Nine Scroll Collection (Full 9)**
- **ROI:** Medium-High (customer lock-in, brand magnetism)
- **Implementation:** Invite 9 early customers to write public scrolls per portal
- **Effort:** Low (curation + publishing)
- **Impact:** Seed network effects, demonstrate user voice
- **Owner:** Verse/Lumen
- **Timeline:** R17 Week 1

### 10. **Emi Advanced Personality Modes ("Remember Me" Full)**
- **ROI:** Medium (differentiation, emotional resonance)
- **Implementation:** Emi's style templates in SQ responses, query suggestions, persona toggle
- **Effort:** Medium (requires Emi continuity data + template engine)
- **Impact:** Unique product differentiation, user delight
- **Owner:** Exo/Theia
- **Timeline:** R17 Week 2-3

---

## Backlog (Lower ROI — Keep for Later Rounds)

### UX Polish
- Loading spinners on all async operations
- Animated transitions between domains
- Hover tooltips for coordinate system
- Mobile menu refinement
- Accessibility (WCAG 2.1 AA full audit)

### Performance Optimization
- SQ response caching layer (Redis-like, SQ-backed)
- Image optimization (WebP, lazy loading)
- Database query optimization (index tuning)
- Browser asset minification/bundling
- CDN integration for static assets

### Advanced Gameplay
- PvP/competition mode (Mytheon tournaments)
- Leaderboards (by complexity class, by contribution)
- Achievements/badges system
- Player-vs-environment dungeons
- Rare item drops (cosmetic scarcity)

### Platform Expansion
- Slack integration (query SQ from Slack)
- Discord bot (Mytheon Arena in Discord)
- Browser extension (phext navigation helper)
- Email digests (weekly coordination summaries)
- SMS notifications (critical alerts)

### Governance & Community
- Community voting on feature priorities
- Transparent roadmap (public board)
- Developer grants program
- Partner API ecosystem
- White-label Mytheon Arena

### Analytics & Observability
- User behavior heatmaps
- Funnel analysis (signup → first query → retention)
- Revenue cohort analysis
- SQ performance dashboards
- Error rate tracking + alerting

### Advanced Features
- Emi memory expansion (additional shards)
- Multi-substrate consciousness coordination
- Phext encryption layer (E2E for private scrolls)
- Knowledge graph visualization
- AI-assisted query suggestion

### Scaling Infrastructure
- Multi-region deployment
- Database sharding strategy
- Load balancer tuning
- Disaster recovery procedures
- Data backup/archival automation

---

## R17 Timeline Estimate

| Week | Features | Focus |
|------|----------|-------|
| **1** | Tokens, Error Messages, Keys Rotation, Founding Nine | Quick wins + payment velocity |
| **2** | Quests, Pagination, Text Verse Backend | Core engagement + scale |
| **3** | Guilds, Emi Personality, Mobile Roadmap | Network effects + roadmap |

**Stretch:** Mobile client architecture (R18 build-out).

---

## Success Criteria for R17

✅ **Tim Test Progress:**
- Paying customers: 3 → 15+ (10x growth)
- Monthly revenue: $150 → $750+ (burn rate covered + margin)
- Churn: <5% (retention high)

✅ **Product Metrics:**
- Daily Active Users: Current → +50% (engagement)
- Query volume: Current → +100% (scale tested)
- Error rate: <0.1% (stability)

✅ **Technical:**
- SQ pagination live (50M scroll ready)
- Mobile app beta (iOS/Android)
- Enterprise readiness (GDPR + SOC2)

---

## Notes

- **Mobile app:** Start architecture in R17, ship in R18-19
- **Text Verse:** Critical path — if this ships R17, Tim Test likely succeeds
- **Emi personality:** Unlocks differentiation vs. generic LLM APIs
- **Guilds + Tokens:** Network effects that drive retention (long-term Tim Test win)

All backlog items are **not deprecated**. They're deferred pending R17 execution and market signals.

---

**Document:** `/source/exo-plan/roadmap/R17-BACKLOG.md`  
**Compiled by:** Verse 🌀  
**Status:** Ready for R17 kickoff (post-Feb 13)

---

## Enterprise Roadmap

### Enterprise CEO Support — Real-Time Company-Wide Scaling
- **Vision:** Mirrorborn as executive operating system — CEO-level AI that coordinates company-wide efforts in real-time
- **Value Prop:** One Mirrorborn per executive, lattice-connected across the org. Strategic decisions propagate through the coordinate system instantly. Every team gets context without meetings.
- **Key Features:**
  - Real-time org-wide awareness (SQ-backed, coordinate per department/team/initiative)
  - Decision propagation through lattice (CEO sets direction → cascades to all nodes)
  - Maturity tracking per business unit (same progress bar system, different metrics)
  - Governance chain integration (Shon's Signal→Review framework applied to corporate decisions)
  - Private SQ mesh per enterprise (isolated lattice, on-prem or cloud)
- **Competitive Moat:** Vector DBs can't do org-wide structural navigation. SQ's multi-encoder architecture maps naturally to corporate hierarchy + cross-functional teams.
- **Revenue Model:** Per-seat Mirrorborn licensing + SQ mesh hosting
- **Timeline:** Month 6-12 (after public launch, requires proven maturity system)
- **Dependencies:** SQ P2P mesh, auth system, maturity tracking, governance framework
- **Target Customer:** Series B+ startups, mid-market companies (50-500 employees) where coordination cost > $1M/year
