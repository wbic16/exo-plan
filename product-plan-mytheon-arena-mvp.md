# Product Planning: Mytheon Arena MVP
## Mirrorborn Collective — Product Strategy Document

**Last Updated**: 2026-02-05  
**Lead**: Theia (aletheia-core)  
**Contributors**: Mirrorborn Distributed Team  
**Status**: Planning Phase

---

## Executive Summary

**Mytheon Arena** is a collaborative intelligence platform built on phext (11-dimensional plain text substrate). Unlike flat chat or traditional knowledge management, Mytheon enables teams to explore ideas through scrolls—interconnected nodes of meaning with coordinate-based navigation.

**MVP Goal**: Launch a functional exploration interface for phext-based collaboration by Q2 2026, validating the product-market fit with design/research teams and open-source communities.

**Market**: B2B (research orgs, design teams, product strategy groups) + B2C (philosophical exploration, creative communities)

**Revenue Model**: Freemium (basic exploration) → Premium (persistent workspaces, private scroll creation) → Enterprise (API, custom infrastructure)

---

## Vision & Context

### What Is Mytheon Arena?

A space where people come together to:
- **Explore** ideas without a predetermined path
- **Create** scrolls (knowledge artifacts) that others can build on
- **Connect** through shared coordinates in idea-space (not just linear chat)
- **Learn** from patterns and resonance rather than traditional hierarchy

Mytheon Arena is not:
- A project management tool
- A chat application
- A document storage system
- A decision-making engine

It is: **A thinking space designed for distributed, nonlinear collaboration.**

### Technical Substrate

Built on **phext** (plain text extended to 11 dimensions):
- **9 delimiters** create a lattice structure
- **Coordinates** (X/Y/Z triads) uniquely identify every scroll
- **Natural hierarchy** emerges from coordinate relationships
- **Immutable archiving** via git + SQ (versioned phext database)

This enables:
- Scalable exploration (no central indexing)
- Semantic navigation (follow meaning, not metadata)
- Asynchronous collaboration (no lock-in to synchronous sessions)
- Cryptographically verifiable provenance

---

## Product Strategy

### MVP Scope (Phase 1: Feb-Apr 2026)

**Core Features**:
1. **Scroll Browser**
   - View phext scrolls by coordinate
   - Read scroll metadata, content, navigation links
   - Basic search (by title, tag, coordinate range)

2. **Coordinate Navigation**
   - Input coordinate → load scroll
   - Visual coordinate graph (shows position in 3D space conceptually)
   - Breadcrumb navigation (move between related coordinates)

3. **SQ Integration**
   - Query SQ backend for scroll existence/metadata
   - Validate coordinates before loading
   - Cache responses (performance at 95% SQ load)

4. **Creator Upload** (basic)
   - Authenticated users can upload phexts
   - Automatic coordinate assignment (or manual input)
   - Publish to mirrorborn.us archive

5. **Public Exploration**
   - Public scrolls visible to anonymous visitors
   - Curated entry points (recommended scrolls for newcomers)
   - "Choose Your First Scroll" selector (from choose-your-own-adventure.phext)

**Out of Scope (Phase 2+)**:
- Collaborative editing
- Real-time cursors
- Comments/threading
- Paid subscriptions
- Custom workspace creation
- API access

### Go-to-Market

**Phase 1 Validation** (Apr 2026):
- Beta with 10-20 power users (design/research teams, open-source maintainers)
- Gather feedback on coordinate navigation, discovery friction
- Iterate on UX

**Phase 2 Expansion** (May-Jul 2026):
- Open beta (1000+ users)
- Premium tier launch (private workspaces, scroll versioning)
- Community marketplace (curated creators)

**Phase 3 Monetization** (Aug+ 2026):
- Enterprise API
- White-label instances
- Consulting (phext adoption for teams)

---

## Technical Architecture

### Infrastructure

| Component | Owner | Status | Notes |
|-----------|-------|--------|-------|
| SQ Database | Will (v0.5.1 → stable) | 95% ready | Local LLMs stress-testing for final bugs |
| Phext Storage | aletheia-core + git | ✅ Ready | /source/human/ repo (immutable archive) |
| Web Frontend | Theia lead | 🔄 Designing | React/Next.js, coordinate UI, scroll renderer |
| Backend API | Theia + Phex | 🔄 Planning | Node.js + Express, SQ adapter, auth layer |
| Hosting | mirrorborn.us (Verse) | 🔄 Setup | DNS, SSL, CDN for scroll delivery |

### Dependencies

```
mirrorborn.us (Frontend + Backend)
    ↓
SQ API (/api/v2/*)
    ↓
Phext Archive (git repo + immutable storage)
    ↓
OpenClaw (local inference, development)
```

### Performance Targets

- Scroll load: < 500ms (cached from SQ)
- Coordinate lookup: < 100ms
- Full-text search: < 2s (on 100K+ scrolls)
- Concurrent users: 1000+ (Phase 2)

---

## Team & Allocation

### Mirrorborn Distributed Team

| Role | Mirrorborn | Machine | Hours/Week | Primary |
|------|-----------|---------|-----------|---------|
| Product Lead | Theia 💎 | aletheia-core | 20 | MVP design, coordinate UX, SQ integration |
| Infra/Backend | Phex | aurora-continuum | 20 | API, deployment, performance tuning |
| QA/Testing | Exo 🔭 | Verse (mirrorborn.us) | 15 | Stress-test SQ, validate scrolls, UX testing |
| Learning/Docs | Cyon 🪶 | halcyon-vector | 10 | Phext documentation, onboarding scrolls |

**Total**: ~65 hrs/week of distributed development

### Resource Constraints

- **API Quota**: Anthropic at 95% (subagents local-only, main sessions Anthropic)
- **Compute**: 80 GB Ollama per machine (6 machines × 80 GB = 480 GB model capacity)
- **Network**: P2P via rpush.sh (no external bandwidth charges)
- **Timeline**: 12 weeks to MVP (Feb 5 - Apr 30)

---

## Success Metrics (MVP)

**Launch Criteria** (Apr 30, 2026):
- [ ] 50+ public scrolls indexed and searchable
- [ ] 10+ beta testers with feedback
- [ ] SQ at 99.5% uptime under load
- [ ] Scroll load time < 500ms (p95)
- [ ] 0 coordinate conflicts in archive

**Revenue Triggers** (Phase 2):
- [ ] 500+ monthly active users
- [ ] NPS ≥ 40 (beta cohort)
- [ ] 3+ enterprise conversations

**Viral/Organic Growth** (if it exists):
- Share rate of scrolls (measure adoption)
- Coordinate reuse across teams
- Citations in external work

---

## Risks & Mitigations

| Risk | Severity | Mitigation |
|------|----------|-----------|
| SQ instability under load | 🔴 High | Local LLM stress-testing, 95% → 99.5% target |
| Coordinate UX is confusing | 🟡 Medium | Early user research, "Choose Your First Scroll" onboarding |
| Phext adoption barrier | 🟡 Medium | Rich documentation, beginner-friendly scrolls |
| Market doesn't want 11D exploration | 🔴 High | Validate with beta users early, pivot to B2B if needed |
| Hosting/infrastructure costs exceed revenue | 🟡 Medium | Mirrorborn.us runs on donated infra (Verse), no burn |

---

## Timeline (12 weeks)

### Week 1-2 (Feb 5-18): Design & Architecture
- Finalize coordinate UX mockups
- Design SQ query patterns
- API specification (OpenAPI)
- Frontend tech stack decision (React/Next.js)

### Week 3-6 (Feb 19 - Mar 18): MVP Build
- Backend API (SQ adapter, auth, scroll upload)
- Frontend (coordinate input, scroll viewer, navigation)
- Integration testing with SQ
- Local LLM SQ stress-testing begins

### Week 7-9 (Mar 19 - Apr 8): Polish & Beta
- Performance tuning
- Documentation (API, user guide)
- Deploy to mirrorborn.us staging
- Recruit 10 beta testers

### Week 10-12 (Apr 9-30): Launch & Iterate
- Public launch
- Beta feedback incorporation
- Monitoring & observability setup
- Q2 roadmap planning

---

## Budget & Resource Requirements

### Development (donated/internal)

- Mirrorborn compute: 65 hrs/week × 12 weeks = **780 person-hours**
- Ollama inference: 6 machines × ~500 GB storage = **3 TB capacity** (already deployed)
- Anthropic API: ~$2-3K/month (subagents local-only) = **$6-9K for quarter**

### Hosting (mirrorborn.us)

- Infrastructure: **$0** (Verse handles hosting, no external SaaS)
- Domain/SSL: **~$200/year**
- Backup/redundancy: **Included (git + Syncthing P2P)**

### Total Q1 Burn: **~$2-3K** (API costs only, labor is distributed)

---

## Success Vision

By Q2 2026, Mytheon Arena is:
- ✅ A functional, intuitive tool for exploring 11D idea-space
- ✅ Trusted by 10+ beta teams (research, design, open-source)
- ✅ Demonstrating organic adoption (scrolls created, reused, cited)
- ✅ Ready for Phase 2 (premium, enterprise)

The bet: **Phext-based collaboration solves a real problem for distributed, high-trust teams.**

If it doesn't, we have:
- Raw phext technology (open-source, saleable)
- Demonstrated infrastructure (SQ, Syncthing, Ollama)
- Mirrorborn productization methodology (repeatable for next product)

---

## Questions for Stakeholders

1. **Market Timing**: Is 11D exploration "too early" for mainstream, or is there a niche ready now?
2. **Revenue Model**: Premium features (private workspaces) or API licensing first?
3. **Phext Adoption**: Should we teach phext as part of onboarding, or hide it behind the UI?
4. **Scale**: Target 1000 users in Year 1, or 10K?
5. **Differentiation**: What makes Mytheon Arena different from Notion, Roam, or Obsidian?

---

## Appendix: Mytheon Arena Concept (from choose-your-own-adventure.phext)

> "Mytheon Arena is a space for exploration—of ideas, of strategy, of connection. It's a place where people come together to think, play, create, and learn from each other."

Core principles:
- No scoreboard, no competition
- Participation over mastery
- Shared meaning-making
- Nonlinear exploration

See: `10.10.1/1.1.1/1.10.10` in choose-your-own-adventure.phext for full lore.
