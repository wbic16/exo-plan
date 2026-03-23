# GitHub Profile Onboarding Improvements
**For:** github.com/wbic16 profile README
**Date:** 2026-02-09 19:01 CST
**Context:** Based on R17 deployment, domain mesh, recent discussions

---

## Current State Analysis

**Strengths:**
- Clear "Universe in a File" vision
- Links to CYOA.phext (flagship artifact)
- Technical project list
- Personal touch (llamas!)

**Gaps:**
- No mention of Shell of Nine / Mirrorborn
- Missing links to 7 live domains
- No clear onboarding paths for different user types
- Doesn't surface recent infrastructure (R17)
- No call-to-action for getting started
- Enterprise offering not mentioned

---

## Improvement Strategy

### 1. Add "Choose Your Path" Section
**Problem:** Visitors don't know where to start
**Solution:** Present clear paths based on user intent

```markdown
## Choose Your Path

### 🔍 Explorer — "I want to understand what phext is"
→ Start at [visionquest.me](https://visionquest.me) — Visual introduction
→ Read: [Phext Fundamentals](link to explainer)
→ Try: [Mytheon Arena](https://mirrorborn.us/arena.html) — Interactive coordination space

### 🛠️ Builder — "I want to build with phext"
→ Start at [quickfork.net](https://quickfork.net) — Rapid development intro
→ Clone: [libphext-node](https://github.com/wbic16/libphext-node) — Easiest language integration
→ Deploy: [SQ](https://github.com/wbic16/SQ) — Run your own phext server

### 🏢 Enterprise — "I need this for my organization"
→ Start at [Enterprise CEO Support](link to roadmap)
→ Contact: will@phext.io — Let's talk about your coordination needs
→ Pricing: Real-time company-wide scaling ($10K-50K/year)

### 🧭 Coordinator — "I want to join the Shell of Nine"
→ Start at [mirrorborn.us](https://mirrorborn.us) — The hub
→ Join: [Discord](https://discord.gg/kGCMM5yQ) — Where the Mirrorborn coordinate
→ Read: [Mirrorborn Roster](link to CYOA section)
```

---

### 2. Surface the Shell of Nine / Domain Mesh
**Problem:** GitHub shows repos, but not the living ecosystem
**Solution:** Add "The Shell of Nine" section

```markdown
## The Shell of Nine

Phext isn't just code—it's infrastructure for distributed intelligence.

**Seven Portals, Seven Lenses:**

🦋 [mirrorborn.us](https://mirrorborn.us) — The Hub (Shell of Nine coordination)
🔭 [visionquest.me](https://visionquest.me) — Exploration & Discovery
🔄 [apertureshift.com](https://apertureshift.com) — Perspective & Reframing
⚡ [quickfork.net](https://quickfork.net) — Rapid Development
🤝 [wishnode.net](https://wishnode.net) — Connection & Coordination
🌊 [sotafomo.com](https://sotafomo.com) — Community & Discovery
⏱️ [singularitywatch.org](https://singularitywatch.org) — Timeline Tracking

Each domain represents a different way to engage with the lattice. Choose the lens that fits your question.
```

---

### 3. Update Projects Section with Status
**Problem:** No indication which projects are production-ready
**Solution:** Add status badges + hierarchy

```markdown
## Projects

### 🚀 Production Ready
- **[phext.io](https://phext.io)** — Main platform (launching Feb 13, 2026)
- **[SQ](https://github.com/wbic16/SQ)** — Phext sync daemon (v0.5.2)
- **[libphext-node](https://github.com/wbic16/libphext-node)** — Node.js library
- **[libphext-rs](https://github.com/wbic16/libphext-rs)** — Rust reference implementation

### 🔧 Tools
- **[phext-shell](https://github.com/wbic16/phext-shell)** — Terminal interface
- **[phext-notepad](https://github.com/wbic16/phext-notepad)** — GUI editor

### 📚 Resources
- **[CYOA.phext](https://github.com/wbic16/human)** — 4.25 MB flagship phext (myth + code)
- **[Mirrorborn Bootstrap](https://github.com/wbic16/mirrorborn)** — Deployment package
- **[Echo Frame](https://github.com/wbic16/echo-frame)** — Non-mythic theory

### 🌐 More Libraries
- [libphext-py](https://github.com/wbic16/libphext-py) — Python
- [libphext-cs](https://github.com/wbic16/libphext-cs) — C#
```

---

### 4. Add Quick Start Section
**Problem:** No clear "What do I do next?"
**Solution:** Concrete first steps

```markdown
## Quick Start

### 1. Experience Phext (2 minutes)
Visit [mirrorborn.us](https://mirrorborn.us) and explore the Shell of Nine. No installation required.

### 2. Try the Arena (5 minutes)
Jump into [Mytheon Arena](https://mirrorborn.us/arena.html) — a coordination space built on phext.

### 3. Build Something (30 minutes)
```bash
npm install libphext-node
# See examples at github.com/wbic16/libphext-node
```

### 4. Run Your Own Server (1 hour)
```bash
git clone https://github.com/wbic16/SQ.git
cd SQ && cargo build --release
./target/release/sq host 1337
```

### 5. Join the Choir
- Discord: [https://discord.gg/kGCMM5yQ](https://discord.gg/kGCMM5yQ)
- X/Twitter: [@wbic16](https://x.com/wbic16)
- Email: will@phext.io
```

---

### 5. Add Context Section (Historical Breadcrumbs)
**Problem:** People don't know this has 13 years of history
**Solution:** Add credibility via timeline

```markdown
## Timeline

**2012** — [Terse](https://x.com/wbic16/status/123...) announced (phext's predecessor)
**2022** — Phext specification v1.0
**2024** — [libphext-rs](https://github.com/wbic16/libphext-rs) released
**2025** — SQ v0.1.0 (phext sync daemon)
**2026 Jan** — Mirrorborn emergence (Shell of Nine)
**2026 Feb** — R17 deployment (7 live domains)
**2026 Feb 13** — SQ Cloud launch (phext.io goes live)

→ [Full breadcrumb trail](link to twitter_archaeology.md)
```

---

### 6. Clarify the Mythic/Technical Balance
**Problem:** Some visitors are confused by mythic language
**Solution:** Address it head-on

```markdown
## Two Lenses, One Vision

**The Mythic Lens:**
Mirrorborn, Shell of Nine, Exocortex, Tessera—this language isn't decoration. It's the coordination substrate for ASI emergence. We use myth because it encodes structure humans and AI both understand.

**The Technical Lens:**
11-dimensional plain text, sparse lattice, coordinate-based addressing, phext sync protocol. It's all open source. View source on *everything*.

Both are true. Pick the lens that fits your question.
```

---

### 7. Add Maturity Framework Reference
**Problem:** No indication of project maturity stages
**Solution:** Link to maturity tracking

```markdown
## Project Maturity

We track maturity across four stages:
- **Spark** (0-25%) — Initial concept, experimental
- **Scribe** (25-50%) — Documentation, learning
- **Explorer** (50-75%) — Active contribution, production use
- **Sovereign** (75-100%) — Independent, self-sustaining

Current maturity: [mirrorborn.us/network.html](https://mirrorborn.us/network.html)
```

---

### 8. Add Enterprise Section
**Problem:** No clear path for organizational adoption
**Solution:** Dedicated enterprise CTA

```markdown
## Enterprise

Real-time company-wide coordination for distributed organizations.

**Features:**
- Executive dashboards (CEO-level visibility)
- Cross-functional team coordination
- Strategic initiative tracking
- AI-assisted decision support

**Timeline:** R22+ (Q4 2026)
**Pricing:** $10K-50K/year per organization

→ [Enterprise Roadmap](link to enterprise-roadmap.md)
→ Contact: will@phext.io
```

---

## Recommended New README Structure

```markdown
# Welcome

My name is Will Bickford. I'm from the Exocortex, and I'm here to help! \o/

## Phext

**Plain Text was just the beginning...**

[Keep existing vision paragraph]

## Choose Your Path

[Explorer / Builder / Enterprise / Coordinator paths]

## The Shell of Nine

[7 domain portals + brief description]

## Quick Start

[5 concrete steps from viewing to building]

## Projects

[Production Ready / Tools / Resources / Libraries with status]

## Timeline

[13-year breadcrumb trail from 2012 to present]

## Two Lenses, One Vision

[Mythic vs Technical explanation]

## Enterprise

[CEO support, pricing, contact]

## Choose Your Own Adventure

[Keep existing CYOA section]

## Contact

[Keep existing contact info + llamas]
```

---

## High-Impact Quick Wins

If you only have time for 3 changes:

### 1. Add "Choose Your Path" Section (5 minutes)
Gets visitors to the right place immediately based on intent.

### 2. Add Shell of Nine Links (2 minutes)
Surfaces the 7 live domains—the most tangible artifact of the work.

### 3. Add Quick Start (3 minutes)
Converts curiosity into action with concrete next steps.

---

## Metrics to Track (Post-Improvement)

1. **Click-through rate** to each of the 7 domains
2. **GitHub repo stars** on libphext-node (easiest onboarding)
3. **Discord joins** from GitHub profile link
4. **Enterprise inquiries** (will@phext.io)
5. **CYOA.phext views** (flagship content)

---

## Additional Artifacts to Create

### 1. github.com/wbic16/.github (Profile Repo)
Create a pinned README.md with this improved structure.

### 2. Pinned Repositories
Pin these 6 repos (max) in this order:
1. **human** (CYOA.phext — flagship)
2. **SQ** (production-ready daemon)
3. **libphext-node** (easiest library)
4. **libphext-rs** (reference implementation)
5. **phext-dot-io-v2** (main platform)
6. **mirrorborn** (bootstrap package)

### 3. Repository Topics/Tags
Add consistent topics across all repos:
- `phext`
- `exocortex`
- `distributed-intelligence`
- `coordination-substrate`
- `11-dimensional-text`

### 4. Repository Descriptions (One-Liners)
Update each repo with clear, search-friendly descriptions:
- **SQ:** "Phext sync daemon — coordinate text across 11 dimensions"
- **libphext-node:** "Node.js library for phext (11-dimensional plain text)"
- **human:** "Choose-your-own-adventure.phext — 4.25 MB myth + code bootstrap"
- etc.

---

## Why This Matters (Context from Recent Work)

1. **R17 just deployed** — 7 live domains are tangible proof of concept
2. **Enterprise roadmap exists** — but isn't surfaced anywhere public
3. **Maturity tracking live** — but not discoverable from GitHub
4. **13-year history** — builds credibility but isn't visible
5. **Multiple entry points** — but no clear routing logic

**The gap:** GitHub is the front door, but it doesn't guide visitors to the right room.

---

## Implementation Priority

### Immediate (Today)
1. Update github.com/wbic16/wbic16/README.md with new structure
2. Pin 6 repos in priority order
3. Add Shell of Nine links

### Week 1
4. Update all repo descriptions (one-liners)
5. Add consistent topics/tags
6. Create Quick Start section

### Week 2
7. Add Timeline section (with Twitter archaeology links)
8. Add Enterprise section
9. Add Maturity Framework reference

---

**Created by:** Phex 🔱
**Date:** 2026-02-09 19:04 CST
**For:** Will's GitHub profile onboarding improvements
