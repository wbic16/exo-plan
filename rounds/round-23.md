# R23: TPU v4 → Phext Processing Unit

**Started:** 2026-02-14
**Paper:** Jouppi et al., "TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings" (ISCA 2023)
**Task:** Rewrite the paper in terms of phext — every concept mapped to its scrollspace equivalent.

---

## 40-Step Plan

### Phase A: Deep Read (Waves 1-10)
Extract and summarize every section of the original paper.

| Wave | Task | Output |
|------|------|--------|
| 1 | **Map the paper structure** — identify all sections, figures, tables | `r23/00-paper-map.md` |
| 2 | **§1 Introduction** — extract claims, context, motivation | `r23/01-introduction.md` |
| 3 | **§2 TPU v4 Chip** — TensorCores, memory hierarchy, ISA | `r23/02-chip.md` |
| 4 | **§3 SparseCores** — architecture, dataflow, embedding acceleration | `r23/03-sparsecores.md` |
| 5 | **§4 Interconnect (ICI)** — inter-chip links, bandwidth, latency | `r23/04-ici.md` |
| 6 | **§5 Optical Circuit Switches** — OCS architecture, reconfiguration, topologies | `r23/05-ocs.md` |
| 7 | **§6 Supercomputer Architecture** — pods, racks, cooling, power | `r23/06-supercomputer.md` |
| 8 | **§7 Benchmarks** — MLPerf, LLM training, embedding workloads | `r23/07-benchmarks.md` |
| 9 | **§8 Related Work** — comparison to A100, IPU Bow, other DSAs | `r23/08-related.md` |
| 10 | **§9 Lessons & Conclusion** — what Google learned, future directions | `r23/09-lessons.md` |

### Phase B: Concept Mapping (Waves 11-20)
Map each TPU v4 concept to its phext equivalent. Identify where phext adds value, where it doesn't apply, and where new concepts are needed.

| Wave | Task | Output |
|------|------|--------|
| 11 | **Compute model** — TensorCore → what? (LLM inference, Ollama, Claude API) | `r23/10-compute-map.md` |
| 12 | **Memory hierarchy** — HBM2 → RAM → disk → phext coordinate space | `r23/11-memory-map.md` |
| 13 | **SparseCores → SQ** — embedding tables as scrollspace, O(1) lookup | `r23/12-sparse-to-sq.md` |
| 14 | **ICI → TCP/mesh** — inter-chip interconnect vs. SQ mesh/git/rsync | `r23/13-ici-map.md` |
| 15 | **OCS → coordinate routing** — optical reconfiguration vs. namespace remapping | `r23/14-ocs-map.md` |
| 16 | **3D torus → 9D scrollspace** — fixed topology vs. delimiter-implicit structure | `r23/15-topology-map.md` |
| 17 | **Pod architecture → ranch/swarm** — 4096 chips vs. Shell of Nine + Ember | `r23/16-scale-map.md` |
| 18 | **Power/cooling → 650W ranch** — datacenter thermal vs. commodity | `r23/17-power-map.md` |
| 19 | **Fault tolerance** — OCS rerouting vs. phext's full-copy redundancy | `r23/18-fault-map.md` |
| 20 | **Security model** — TPU multi-tenancy vs. SQ tenant isolation | `r23/19-security-map.md` |

### Phase C: Novel Analysis (Waves 21-30)
Original analysis that goes beyond simple mapping — where phext *extends* what TPU v4 does.

| Wave | Task | Output |
|------|------|--------|
| 21 | **Dimensionality analysis** — why 3D torus is a subset of 9D scrollspace | `r23/20-dimensions.md` |
| 22 | **Embedding as first-class** — what changes when lookup IS the address space | `r23/21-embedding-native.md` |
| 23 | **Workload comparison** — training (TPU) vs. coordination (PPU), where each wins | `r23/22-workloads.md` |
| 24 | **Cost model** — $/FLOP for TPU v4 vs. $/scroll for PPU, apples vs oranges | `r23/23-cost-model.md` |
| 25 | **Bandwidth analysis** — optical ICI bandwidth vs. phext's "no bandwidth needed" (full copies) | `r23/24-bandwidth.md` |
| 26 | **Latency analysis** — microsecond ICI vs. second-scale scroll access, when it matters | `r23/25-latency.md` |
| 27 | **BASE memory model** — echo-frame's 5D/9D allocation mapped to TPU v4 memory | `r23/26-base-memory.md` |
| 28 | **Sentron density** — 387M scrolls ≈ 400M sentrons, cognitive architecture implications | `r23/27-sentron.md` |
| 29 | **Mercurial cores** — fault-tolerant compute on unreliable hardware (Bostrom + phext) | `r23/28-mercurial.md` |
| 30 | **Complementarity thesis** — TPU for training, PPU for coordination, both for Exocortex | `r23/29-complementary.md` |

### Phase D: Paper Writing (Waves 31-38)
Write the actual paper, section by section.

| Wave | Task | Output |
|------|------|--------|
| 31 | **Abstract + Introduction** | `r23/paper/01-intro.md` |
| 32 | **§2 PPU Node Architecture** | `r23/paper/02-node.md` |
| 33 | **§3 Scrollspace as Interconnect** | `r23/paper/03-scrollspace.md` |
| 34 | **§4 Coordinate-Native Embeddings** | `r23/paper/04-embeddings.md` |
| 35 | **§5 Scaling: Ranch to Exocortex** | `r23/paper/05-scaling.md` |
| 36 | **§6 Benchmarks and Honest Tradeoffs** | `r23/paper/06-benchmarks.md` |
| 37 | **§7 Related Work and Complementarity** | `r23/paper/07-related.md` |
| 38 | **§8 Conclusion + Future Work** | `r23/paper/08-conclusion.md` |

### Phase E: Polish & Ship (Waves 39-40)

| Wave | Task | Output |
|------|------|--------|
| 39 | **Figures and diagrams** — SVG/PNG for each key concept | `r23/figures/` |
| 40 | **Final assembly + deploy** — single markdown → HTML → mirrorborn.us | `r23/paper/PPU-v1.md` |

---

## Wave 1/40: Paper Map

Need to extract the full structure of the TPU v4 paper — all sections, figures, tables, and key claims. The PDF didn't parse via web_fetch. Options:
1. Will provides a text extraction or section list
2. We work from the abstract + publicly available summaries + ISCA presentation
3. Will downloads and drops the PDF text into a scroll

**Will:** Can you extract the paper text, or should I work from public summaries + the abstract? The depth of Waves 2-10 depends on having the actual section content.

---

**Status:** Wave 1/40 — planning complete, awaiting paper access
**Scribe:** Chrys 🦋
**Coordinator:** Will
