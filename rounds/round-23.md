# R23: TPU v4 → Phext Processing Unit

**Started:** 2026-02-14
**Paper:** Jouppi et al., "TPU v4" (ISCA 2023, arXiv:2304.01433)
**Source text:** `r23/tpu-v4-full-text.txt` (1,720 lines, extracted ✅)
**Task:** Rewrite in terms of phext. Rigorous concept mapping. Honest tradeoffs.
**Scribe:** Chrys 🦋
**Target:** ~6,000-8,000 words
**Quick draft:** `blog/r23-tpu-v4-in-phext.md` (1,775 words — superseded by this plan)

---

## Paper's 3 Claims (our 3 responses)

| TPU v4 Claim | Phext Response |
|-------------|---------------|
| 1. First production OCS in supercomputer | Scrollspace coordinates make topology reconfiguration unnecessary |
| 2. First embedding accelerator (SparseCore) | Coordinate-native addressing makes ALL data an embedding |
| 3. ML co-optimization of topology+model | The 9D address space IS the topology — no optimization needed |

---

## 40 Waves

### Phase A: Extract (Waves 1-8)
Deep read of each paper section. One wave per major section. Extract claims, numbers, figures.

| Wave | Paper Section | Status | Output |
|------|-------------|--------|--------|
| 1 | Plan + paper structure + resolve blockers | ✅ Done | This file + `r23/00-paper-structure.md` |
| 2 | §1 Introduction — 3 claims, Table 1 workload evolution | Ready | `r23/01-introduction.md` |
| 3 | §2.1-2.2 OCS architecture + supercomputer construction | Ready | `r23/02-ocs-architecture.md` |
| 4 | §2.3-2.6 OCS benefits: availability, deployment, scheduling, security | Ready | `r23/03-ocs-benefits.md` |
| 5 | §2.7-2.10 Topology tailoring, twisted torus, cost | Ready | `r23/04-ocs-topology.md` |
| 6 | §3.1-3.4 Embeddings + recommendation models + distributed training | Ready | `r23/05-embeddings.md` |
| 7 | §3.5-3.6 SparseCore architecture + performance | Ready | `r23/06-sparsecore.md` |
| 8 | §4-9 Co-optimization, benchmarks, discussion, related work | Ready | `r23/07-benchmarks-and-rest.md` |

### Phase B: Map (Waves 9-18)
Each wave takes ONE TPU v4 concept and writes the complete phext mapping.
Format: What They Did → What Phext Does → What We Gain → What We Lose → Is The Comparison Fair?

| Wave | TPU v4 Concept | Phext Equivalent |
|------|---------------|-----------------|
| 9 | 3D MEMS OCS (Palomar) | Coordinate namespace (zero hardware) |
| 10 | 4³ building block (64 chips/rack) | Single node (1 machine = 1 mind) |
| 11 | 3D torus topology | 9D scrollspace (delimiter-implicit) |
| 12 | Twisted torus (bisection bandwidth) | Sparse 9D (most coordinates empty = no congestion) |
| 13 | TensorCore (128×128 MXU) | LLM inference engine (Claude API / Ollama) |
| 14 | SparseCore (embedding accelerator) | SQ coordinate lookup (every scroll = embedding) |
| 15 | HBM2 (32 GiB/chip) + CMEM + VMEM | RAM + disk + phext coordinate space |
| 16 | ICI links (inter-chip interconnect) | TCP + SQ mesh + git push/pull |
| 17 | Slice scheduling (non-contiguous allocation) | Coordinate assignment (any node, any coordinate) |
| 18 | Multi-tenant security (air-gapped OCS) | SQ tenant isolation (API key → data directory) |

### Phase C: Originate (Waves 19-26)
Novel analysis. These are the ideas that make the paper worth reading beyond translation.

| Wave | Original Contribution |
|------|----------------------|
| 19 | **3D ⊂ 9D proof** — any 3D torus coordinate maps into 9D scrollspace. Formal embedding. |
| 20 | **Topology dissolution thesis** — workload classes where interconnect topology is irrelevant |
| 21 | **Cost per scroll vs. cost per FLOP** — new metric for coordination workloads |
| 22 | **BASE memory model** — echo-frame's phext-native allocation vs. HBM2 hierarchy |
| 23 | **Sentron density** — 9^9 ≈ 387M ≈ brain's sentron count. Cognitive architecture implications. |
| 24 | **Mercurial cores** — Bostrom + phext: fault tolerance on unreliable substrates (Mercury CPUs) |
| 25 | **Power law** — 650W ranch vs. 1.2 MW pod. When does commodity beat custom? |
| 26 | **Complementarity thesis** — TPU trains, PPU coordinates. Both needed for 2130. |

### Phase D: Write (Waves 27-37)
One section per wave. Word targets enforce discipline.

| Wave | Paper Section | Words | Depends On |
|------|-------------|-------|-----------|
| 27 | Title + Abstract | 250 | Waves 9-26 |
| 28 | §1 Introduction — problem, claim, roadmap | 500 | Wave 27 |
| 29 | §2 Background: What Google Built | 700 | Waves 2-8 |
| 30 | §3 The Phext Processing Unit | 600 | Waves 10, 13, 15 |
| 31 | §4 Scrollspace Replaces the Interconnect | 800 | Waves 9, 11, 12, 19 |
| 32 | §5 Every Scroll Is an Embedding | 600 | Waves 14, 6, 7 |
| 33 | §6 Memory: HBM2 vs. BASE | 500 | Waves 15, 22 |
| 34 | §7 Scaling and Power | 500 | Waves 10, 17, 25 |
| 35 | §8 Honest Tradeoffs | 500 | All mapping waves |
| 36 | §9 Complementarity + Future Work | 500 | Waves 26, 23, 24 |
| 37 | §10 Related Work + Conclusion | 400 | All |

**Total: ~5,850 words** (within 6,000-8,000 target)

### Phase E: Ship (Waves 38-40)

| Wave | Task |
|------|------|
| 38 | **3 key figures** — (1) PPU node diagram, (2) 3D→9D topology comparison, (3) cost/power table |
| 39 | **Edit pass** — full read-through, fact-check all numbers, tighten prose, remove hedging |
| 40 | **Assemble + deploy** — single markdown → HTML → mirrorborn.us/papers/ppu-v1.html |

---

## Parallelism Map

```
Phase A (extract):     [2][3][4][5][6][7][8]  ← all independent, split across choir
Phase B (map):         [9][10][11][12] | [13][14][15] | [16][17][18]  ← 3 parallel tracks
Phase C (originate):   [19][20][21] | [22][23][24] | [25][26]  ← 3 parallel tracks  
Phase D (write):       [27] → [28] → [29-36 parallel by section] → [37]
Phase E (ship):        [38][39] → [40]
```

## Quality Gates

| After Wave | Gate | Reviewer |
|-----------|------|---------|
| 8 | Are we reading the paper correctly? | Will |
| 18 | Do the concept mappings hold up? Any false equivalences? | Will |
| 26 | Are the original contributions novel and defensible? | Will + choir |
| 37 | Full draft review before figures/polish | Will |

## Anti-Patterns

- **Don't strawman TPU v4.** It's brilliant hardware by Patterson + Jouppi. Respect it.
- **Don't overclaim.** 9 nodes ≠ 4,096 chips. Be precise about what we're comparing.
- **Don't skip the math.** If we say 3D embeds in 9D, prove it with a mapping function.
- **Don't ignore the workload mismatch.** TPU v4 does matrix multiply. We do agent coordination. Say so.
- **Don't pad.** 6,000 tight words > 10,000 fluffy words.
- **Do credit what TPU v4 does better.** §8 (Honest Tradeoffs) is the integrity section.

---

**Status:** Wave 1 ✅ — paper extracted, structure mapped, plan finalized
**Next:** Waves 2-8 (extraction), parallelizable across choir
**Blockers resolved:** ✅ PDF extracted, ✅ audience = technical (HN/researchers), tone = rigorous blog (not academic paper format)
