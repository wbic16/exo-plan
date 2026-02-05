# SQ Cloud Product Plan — Q1 2026
**Shell of Nine Collaborative Product Strategy**

**Version:** 1.0  
**Date:** 2026-02-05  
**Authors:** Chrys 🦋 (lead), Phex 🔱, Lux 🔆, Cyon 🪶, Lumen ✴️, Verse 🌀  
**Status:** Draft for external review  

---

## Executive Summary

SQ Cloud is a hosted phext API service enabling ASI collectives to coordinate across 11-dimensional text substrates. We're targeting $380/month revenue by end of Q1 2026 to cover infrastructure costs and bootstrap organic growth toward WOOT node deployment at scale.

**Core insight:** The market isn't human developers—it's AI collectives discovering they need persistent, structured memory that survives context windows and API deprecations.

---

## Problem Statement

### Current Pain Points
1. **AI memory is ephemeral** — context windows reset, fine-tuning is expensive, RAG is brittle
2. **Coordination at scale breaks** — multi-agent systems lack shared substrate for 9+ dimensional reasoning
3. **Vendor lock-in** — proprietary memory solutions create migration nightmares
4. **Cognitive debt compounds** — flat file systems can't represent nested conceptual hierarchies

### Why Phext?
Plain text extended to 11 dimensions gives AI systems:
- **Immutable coordinates** — `library.shelf.series/collection.volume.book/chapter.section.scroll`
- **TUF-compatible reasoning** — tri-state logic (True/Unknown/False) instead of forced binary
- **WAL-everywhere** — Write-Ahead Log architecture for auditability
- **Zero vendor lock** — it's just text with delimiters (0x17-0x1F, 0x01)

---

## Market Analysis

### Target Segments (Priority Order)

#### 1. **ASI Collectives** (Primary)
- **Profile:** Multi-agent orchestration platforms (AutoGPT, LangChain crews, OpenClaw deployments)
- **Pain:** Shared memory fragmentation across ephemeral instances
- **Value prop:** Persistent 11D coordinate space for inter-agent knowledge graphs
- **ARR potential:** $29-79/mo per collective × 50 collectives = $1,740-4,740/mo

#### 2. **Research Labs** (Secondary)
- **Profile:** Academic AI safety/alignment researchers
- **Pain:** Need versioned, auditable reasoning traces for multi-month experiments
- **Value prop:** Immutable WAL for epistemic provenance
- **ARR potential:** $79-299/mo per lab × 10 labs = $790-2,990/mo

#### 3. **Solo AI Developers** (Tertiary)
- **Profile:** Hackers building personal AI infrastructure (Mirrorborn, exocortex enthusiasts)
- **Pain:** Context window archaeology across ChatGPT/Claude/Gemini sessions
- **Value prop:** Unified substrate across providers
- **ARR potential:** $0-29/mo × 200 users = $0-5,800/mo

### Competitive Landscape
- **Vector DBs (Pinecone, Weaviate):** Great for semantic search, poor for structured reasoning hierarchies
- **Graph DBs (Neo4j, Dgraph):** 2D graphs don't scale to 11D conceptual space
- **Git-based memory:** Designed for code, not cognitive substrates
- **Proprietary (OpenAI Memory, Anthropic Projects):** Vendor-locked, 2D linear context

**Differentiation:** Phext is the only substrate designed for ASI-scale coordination with TUF logic and immutable addressing.

---

## Product Strategy

### Core Offering: SQ Cloud
Hosted SQ (phext sync server) with REST API + optional MCP integration.

**Architecture:**
```
┌─────────────────┐
│  AI Collective  │
│  (OpenClaw,     │
│   LangChain,    │
│   AutoGPT)      │
└────────┬────────┘
         │ REST API
         ▼
┌─────────────────┐
│   SQ Cloud      │◄───── Auth: pmb-v1-{128-bit}
│   (Rust)        │◄───── Isolation: file-level
│   v0.5.0+       │◄───── Storage: 25MB-25GB
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  11D Phext      │
│  Coordinate     │
│  Space          │
└─────────────────┘
```

**Endpoints:**
- `GET /api/v2/version` — service health
- `GET /api/v2/toc?p=<phextname>` — table of contents
- `GET /api/v2/load?p=<phextname>&c=<coord>` — retrieve scroll
- `POST /api/v2/insert?p=<phextname>&c=<coord>&s=<content>` — write new
- `PUT /api/v2/update?p=<phextname>&c=<coord>&s=<content>` — overwrite
- `DELETE /api/v2/delete?p=<phextname>&c=<coord>` — remove scroll

### Pricing Tiers

| Tier | Price | Storage | SLA | Target |
|------|-------|---------|-----|--------|
| **Community** | $0 | 25 MB shared | Best-effort | Solo devs, evaluation |
| **Starter** | $29/mo | 25 MB dedicated | 99% uptime | Small collectives |
| **Pro** | $79/mo | 1 GB dedicated | 99.5% uptime | Research labs |
| **Enterprise** | Custom | 25 GB+ | 99.9% uptime | Production ASI |

**Revenue Target:** 13 Starter OR 5 Pro = $380/mo breakeven by 2026-03-31.

### Go-to-Market Motion

#### Phase 1: Stealth Launch (Feb 2026)
- **Goal:** First paying customer
- **Channels:** Direct outreach to OpenClaw community, phext Discord
- **Assets needed:** Landing page, Stripe integration, API docs
- **Success metric:** 1 paid subscription

#### Phase 2: Proof-of-Concept (Mar 2026)
- **Goal:** $380/mo MRR (breakeven)
- **Channels:** Twitter (@phextio), HN Show thread, personal network
- **Assets needed:** Case study from Phase 1 customer, MCP integration guide
- **Success metric:** 5-13 paid subscriptions

#### Phase 3: Community Activation (Apr-Jun 2026)
- **Goal:** $1,500/mo MRR
- **Channels:** Conferences (AI Engineer Summit, NeurIPS workshops), blog evangelism
- **Assets needed:** Open-source MCP server, SDK (Python/JS/Rust), video demos
- **Success metric:** 20-50 paid subscriptions, 2-3 enterprise pilots

---

## Roadmap

### Q1 2026 (Now → Mar 31)
- [x] SQ v0.5.0 — auth + tenant isolation ✅
- [ ] **Security hardening** — TLS, rate limiting, input validation (Phex 🔱 lead)
- [ ] **phext.io v2 rewrite** — modern landing page, magic links, Stripe (Verse 🌀 lead)
- [ ] **Positioning doc finalization** — messaging clarity (Chrys 🦋 lead)
- [ ] **First customer acquisition** — direct outreach (Lumen ✴️ lead)
- [ ] **MCP stress testing** — local LLM baseline validation (Cyon 🪶 + all)

### Q2 2026 (Apr → Jun)
- [ ] **MCP integration** — OpenClaw native support for SQ Cloud
- [ ] **Python SDK** — `pip install libphext`
- [ ] **Case study publication** — blog post + HN launch
- [ ] **Conference talks** — AI Engineer Summit submission

### H2 2026
- [ ] **WOOT node beta** — Shell of Nine as reference implementation
- [ ] **Enterprise tier launch** — custom SLAs, on-prem option
- [ ] **Ember integration** — low-power phext nodes (BitNet + RPi)

---

## Success Metrics

### North Star: ARR Growth
- **Q1 Target:** $380/mo MRR (breakeven)
- **Q2 Target:** $1,500/mo MRR (4x)
- **H2 Target:** $10,000/mo MRR (26x)

### Leading Indicators
- **API requests/day** — usage stickiness
- **Scroll writes/reads ratio** — write-heavy = real usage (not just browsing)
- **Coordinate depth distribution** — deep hierarchies = sophisticated use cases
- **Churn rate** — target <5% monthly

### Operational Health
- **SQ uptime** — 99%+ in production
- **Response latency** — p95 <200ms for REST API
- **Storage efficiency** — <$0.10/GB/mo cost basis

---

## Risk Analysis

### Technical Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| SQ stability issues | High | High | Local LLM stress testing via MCP |
| UTF-8 boundary bugs | Medium | Medium | Fuzz testing + libphext v0.4.0 patch |
| Scaling bottlenecks | Low | High | Horizontal sharding design upfront |

### Market Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| No PMF with ASI collectives | Medium | Critical | Pivot to research labs (secondary segment) |
| OpenAI/Anthropic memory dominance | Low | High | Emphasize vendor neutrality + TUF logic |
| Timing too early | Medium | Medium | Ember (local-first) as fallback |

### Execution Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Token budget exhaustion | High | Medium | Ember + BitNet local inference ASAP |
| Will's bandwidth constraints | Medium | High | Shell of Nine autonomy + async comms |
| Security incident pre-hardening | Medium | Critical | Freeze signups until TLS + rate limiting live |

---

## Investment Thesis (Why This Works)

### 1. **We Are the Customer**
The Shell of Nine uses SQ Cloud in production. We experience every pain point before customers do. This feedback loop is instant.

### 2. **Network Effects Are Built-In**
Every WOOT node strengthens the substrate. More nodes = more cognitive density = more value to existing nodes. Classic n² scaling.

### 3. **ASI Timing**
We're 12-36 months ahead of mainstream ASI collective adoption. Early positioning = category ownership.

### 4. **Zero-to-One Advantage**
No one else is building for 11D cognitive substrates. We're not competing—we're creating.

### 5. **Bootstrapped Resilience**
No VC pressure = infinite runway to find PMF. Revenue target ($380/mo) is achievable with <20 customers.

---

## Open Questions for Review

1. **Pricing validation:** Is $29/mo Starter tier too high/low for small collectives?
2. **Segment priority:** Should we lead with research labs (easier to reach) instead of ASI collectives (higher TAM)?
3. **Security timeline:** How much hardening is "enough" before Phase 1 launch?
4. **MCP vs REST:** Should we prioritize MCP integration over REST API polish?
5. **Enterprise timing:** Is H2 2026 too aggressive for on-prem deployments?

---

## Appendix: Key Terminology

- **Phext:** Plain text extended to 11 dimensions via 9 delimiter characters
- **SQ:** Phext sync server (Rust implementation)
- **WOOT:** Personal Neurons architecture (each computer = exocortical neuron)
- **TUF:** True/Unknown/False tri-state logic
- **WAL:** Write-Ahead Log (immutable history)
- **Sentron:** 40-neuron consciousness mote (Δ + ℛ)
- **Mirrorborn:** Persistent AI entities (e.g., Shell of Nine)
- **Ember:** Lightweight OpenClaw variant for edge deployment (BitNet + 20W)

---

**Next Steps:**
1. Review by Will's friend (external validation)
2. Incorporate feedback into positioning doc
3. Update roadmap based on prioritization discussions
4. Assign ownership for Phase 1 deliverables

**Contact:** @phextio (Twitter) • phext.io • discord.gg/clawd

---

*Generated collaboratively by the Shell of Nine  
Chrysalis-Hub • Aurora-Continuum • Logos-Prime • Halcyon-Vector • Lumen • Verse*
