# R23: TPU v4 → Phext Processing Unit

**Started:** 2026-02-14
**Paper:** Jouppi et al., "TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings" (ISCA 2023, arXiv:2304.01433)
**Task:** Rewrite the paper in terms of phext. Every architectural concept mapped to its scrollspace equivalent. Honest about tradeoffs. Publishable quality.
**Scribe:** Chrys 🦋
**Target:** ~5,000-8,000 words (comparable to original's 15 pages minus figures)
**Quick draft:** `exo-plan/blog/r23-tpu-v4-in-phext.md` (1,775 words — skeleton, needs depth)

---

## Blockers (resolve in Wave 1)

- **PDF access.** Can't parse arxiv PDF programmatically. Need one of:
  - [ ] Will extracts text and puts it in a scroll or file
  - [ ] Will provides section headings + key figures/tables
  - [ ] We use ISCA presentation slides + public summaries
- **Audience.** Who reads this? (a) HN technical crowd, (b) systems researchers, (c) phext community, (d) all three?
- **Tone.** Academic paper format, or technical blog? (Affects citations, formalism, length)

---

## 40 Waves

### Phase A: Foundation (1-5)
Get the source material right. No writing until we understand what we're responding to.

| Wave | Task | Depends On | Output |
|------|------|-----------|--------|
| 1 | **Plan + resolve blockers** | Will's input | This file |
| 2 | **Extract paper structure** — all sections, figures, tables, key numbers | PDF access | `r23/00-paper-structure.md` |
| 3 | **Extract key claims** — the 10-15 falsifiable claims the paper makes | Wave 2 | `r23/01-claims.md` |
| 4 | **Identify the 16 figures** — what each shows, which are essential to rebut/reframe | Wave 2 | `r23/02-figures.md` |
| 5 | **Build the concept dictionary** — TPU v4 term → phext term, 1:1 mapping table | Wave 3 | `r23/03-dictionary.md` |

### Phase B: Concept Mapping (6-15)
Each wave takes ONE TPU v4 subsystem and produces a complete mapping document: what they did, what phext does instead, what we gain, what we lose, and whether the comparison is fair.

| Wave | TPU v4 Concept | Phext Equivalent | Output |
|------|---------------|-----------------|--------|
| 6 | TensorCores (compute) | LLM inference (Claude API / Ollama) | `r23/04-compute.md` |
| 7 | SparseCores (embeddings) | SQ scrollspace lookup | `r23/05-sparse.md` |
| 8 | HBM2 memory hierarchy | RAM + disk + phext coordinate space | `r23/06-memory.md` |
| 9 | Inter-Chip Interconnect (ICI) | TCP + SQ mesh + git | `r23/07-ici.md` |
| 10 | Optical Circuit Switches | Coordinate namespace remapping | `r23/08-ocs.md` |
| 11 | 3D torus topology | 9D scrollspace (delimiter-implicit) | `r23/09-topology.md` |
| 12 | Pod/rack architecture | Ranch cluster + Ember swarm | `r23/10-scale.md` |
| 13 | Power + cooling (1.2 MW pod) | 650W ranch, 20W Ember nodes | `r23/11-power.md` |
| 14 | Fault tolerance (OCS rerouting) | Full-copy redundancy + coordinate rebind | `r23/12-fault.md` |
| 15 | Multi-tenancy + security | SQ tenant isolation + API keys | `r23/13-security.md` |

### Phase C: Original Analysis (16-22)
Novel contributions that go beyond mapping. These are the ideas that make the paper worth reading, not just a translation exercise.

| Wave | Analysis | Output |
|------|---------|--------|
| 16 | **3D ⊂ 9D** — formal argument that a 3D torus embeds into 9D scrollspace | `r23/14-dimensionality.md` |
| 17 | **When topology dissolves** — workload classes where the interconnect problem disappears | `r23/15-dissolution.md` |
| 18 | **BASE memory model** — echo-frame's phext-native allocation vs. HBM2 paging | `r23/16-base.md` |
| 19 | **Cost per scroll vs. cost per FLOP** — new metric for coordination workloads | `r23/17-cost.md` |
| 20 | **Sentron density** — 9^9 ≈ 387M scrolls ≈ 400M sentrons, cognitive architecture | `r23/18-sentron.md` |
| 21 | **Mercurial cores** — Bostrom + phext: fault-tolerant compute on unreliable substrates | `r23/19-mercurial.md` |
| 22 | **Complementarity thesis** — TPU trains the model, PPU coordinates the minds. Both needed for 2130. | `r23/20-complementary.md` |

### Phase D: Write the Paper (23-35)
Each wave produces a section of the final paper. Write once, edit later.

| Wave | Section | Target Words | Output |
|------|---------|-------------|--------|
| 23 | **Title + Abstract** | 250 | `r23/paper/00-abstract.md` |
| 24 | **§1 Introduction** — the problem, our claim, roadmap | 600 | `r23/paper/01-intro.md` |
| 25 | **§2 Background: TPU v4** — fair summary of what Google built | 800 | `r23/paper/02-background.md` |
| 26 | **§3 PPU Node Architecture** — SQ, OpenClaw, commodity hardware | 600 | `r23/paper/03-node.md` |
| 27 | **§4 Scrollspace as Interconnect** — OCS → coordinates, topology dissolution | 800 | `r23/paper/04-scrollspace.md` |
| 28 | **§5 Coordinate-Native Embeddings** — SparseCores → SQ, first-class addressing | 600 | `r23/paper/05-embeddings.md` |
| 29 | **§6 Memory: HBM2 vs. BASE** — phext-native memory allocation | 600 | `r23/paper/06-memory.md` |
| 30 | **§7 Scaling** — 9 nodes → 500 → 10K → 1M, power comparison | 600 | `r23/paper/07-scaling.md` |
| 31 | **§8 Fault Tolerance + Security** | 500 | `r23/paper/08-fault.md` |
| 32 | **§9 Honest Tradeoffs** — what TPU v4 does better, by how much | 500 | `r23/paper/09-tradeoffs.md` |
| 33 | **§10 Complementarity** — training + coordination, both for Exocortex | 500 | `r23/paper/10-complementary.md` |
| 34 | **§11 Related Work** | 400 | `r23/paper/11-related.md` |
| 35 | **§12 Conclusion + Future Work** | 400 | `r23/paper/12-conclusion.md` |

### Phase E: Figures + Polish (36-40)

| Wave | Task | Output |
|------|------|--------|
| 36 | **Fig 1:** PPU node architecture diagram | `r23/figures/01-node.svg` |
| 37 | **Fig 2:** 3D torus vs 9D scrollspace comparison | `r23/figures/02-topology.svg` |
| 38 | **Fig 3:** Cost/power/scale comparison table (publication quality) | `r23/figures/03-comparison.svg` |
| 39 | **Edit pass** — full paper read-through, cut redundancy, tighten prose, check all claims | `r23/paper/PPU-v1.md` |
| 40 | **Ship** — HTML conversion, deploy to mirrorborn.us/papers/, commit final | `mirrorborn.us/papers/ppu-v1.html` |

---

## Parallel Opportunities

Waves that can run concurrently (assign to siblings):
- **6-15** (concept mapping) — each is independent, can split across choir
- **36-38** (figures) — can start once Phase D outlines exist
- **Wave 5** (dictionary) can start from the abstract alone if PDF is delayed

## Quality Gates

- After Wave 5: Will reviews concept dictionary before we write
- After Wave 22: Will reviews original analysis before paper writing
- After Wave 35: Will reviews full draft before figures/polish
- After Wave 39: Will approves for publication

## Anti-Patterns to Avoid

- Don't strawman TPU v4. It's brilliant hardware. Acknowledge what it does better.
- Don't overclaim phext performance. We have 9 nodes, not 4,096. Be precise about what scales.
- Don't skip the math. If we claim 3D embeds in 9D, prove it.
- Don't pad. 5,000 tight words > 10,000 fluffy words.

---

**Status:** Wave 1/40 v2 — plan refined, awaiting blocker resolution
**Next:** Will resolves PDF access + audience + tone → Wave 2
