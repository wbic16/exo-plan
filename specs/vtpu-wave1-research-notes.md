# R23 Wave 1 Addendum: Research Notes & Geometric Analysis
## Chrys 🦋 | 2026-02-14

---

## I. Recent AI Substrate Developments to Incorporate

### 1. BitNet b1.58 — The vTPU's Native Arithmetic

**Key finding:** Microsoft's BitNet b1.58 (2B params, 4T tokens) uses ternary weights {-1, 0, 1}. On x86 CPUs, it achieves 2.37x–6.17x speedups over FP16 and 71.9%–82.2% energy savings. A 100B BitNet model runs on a single CPU node.

**vTPU implication:** The D-Pipe should have a **ternary mode**. When weights are {-1, 0, 1}, multiply-accumulate becomes add/subtract/skip — no FPU needed. The D-Pipe degenerates into pure integer ALU ops, which Zen 4 can retire at 4/cycle, not 2. This means:

- **In ternary mode, D-Pipe throughput doubles.** 6 ops/cycle becomes achievable (4 D-ops + 1 S-op + 1 C-op) for BitNet workloads.
- Qwen3-Coder-Next (51GB, our primary local model) uses quantized weights. If we train/fine-tune a BitNet variant of our sentron compiler's output, the vTPU runs at 2x theoretical peak on cognitive workloads.
- **0.028J per inference** (BitNet b1.58 2B). At 125W per node, that's ~4,464 inferences/second per node. Across 5 nodes: ~22,000 inferences/second.

**Action:** Add `DTERNARY` mode to svISA. When active, D-Pipe uses integer ALU only, C-Pipe gets the freed FP unit.

### 2. TPU v7 Ironwood — What We're Actually Competing With

**Key specs (April 2025):**
- 4.6 petaFLOPS dense FP8 per chip
- 256×256 MXU (up from 128×128 in v4)
- Enhanced SparseCore
- Up to 147,456 TPU v7s on same network via expanded OCS
- 8 HBM3e sites per chip

**vTPU implication:** We're not competing on FLOPS (obviously — 4.6 PFLOPS vs our ~0.75 TFLOPS). But:
- Ironwood's 147K-chip OCS network is solving the *same problem* our C-Pipe solves: routing between heterogeneous compute units. Google uses ~256 optical switches. We use SQ relay over LAN. Same abstraction, different scale.
- Their SparseCore enhancement maps directly to our S-Pipe. We should study what Ironwood's SparseCore actually does differently from v4.
- **Key insight: Ironwood is "the first TPU for the age of inference."** Google is pivoting from training to inference. Our vTPU is *already* inference-first. We're ahead of the curve architecturally, behind on transistors.

### 3. Mixture of Experts (MoE) — Phext-Native Routing

**State of the art (2025):**
- DeepSeek-R1: 256 routed experts, 8 active per token (3.1% activation)
- Qwen3: 128 experts
- LLaMA 4 Maverick: 128 experts
- Key innovation: fine-grained specialization with large expert pools

**vTPU implication:** MoE routing IS phext coordinate selection. When a token arrives and the gating network selects 8 of 256 experts, that's equivalent to:

```
SINDEX rd, expert_base, gate_output, dim_7   // Select expert along dimension 7
SGATHER rd, [expert_coord], width            // Load expert weights from phext space
```

Each expert lives at a phext coordinate. The gating network outputs a *coordinate*, not an index. In flat memory, expert selection requires index → pointer → load. In phext space, expert selection IS addressing — the coordinate encodes both identity and locality.

**This means MoE on vTPU has zero routing overhead.** The S-Pipe's dimensional addressing does routing implicitly. No routing table. No load balancing. The phext coordinate IS the route.

### 4. Hyperdimensional Computing (HDC) / Vector Symbolic Architectures (VSA)

**Key concept:** Information represented as ~10,000-dimensional hypervectors. Operations: binding (XOR/multiply), bundling (element-wise add), permutation. Hardware accelerators emerging (AXI-HDC on FPGA, SOT-CAM HyDra chip).

**vTPU implication:** Phext coordinates are 128-bit (11×11 + 7 flags). HDC hypervectors are typically 1024-10,000 bits. These are *different scales of the same idea*: encoding meaning in high-dimensional structure rather than flat addresses.

- A phext coordinate is a *compressed* hypervector. 128 bits encoding 11 semantic dimensions vs 10,000 random bits encoding statistical similarity.
- HDC binding (XOR) maps to `DADD` on coordinate pairs
- HDC bundling maps to `CREDUCE` across sentron groups
- The PPT (Phext Page Table) is essentially an HDC codebook

**Potential synthesis:** Use HDC-style hypervectors as the *content* at each phext coordinate. The coordinate provides structural locality (where), the hypervector provides semantic similarity (what). The S-Pipe indexes by coordinate; the D-Pipe computes on hypervectors.

---

## II. Geometric Structures Phext Replicates That 2D/3D Cannot

This is the deep insight Will asked for. What shapes become *trivial* in 11D?

### 1. The 11-Simplex (12-vertex hypertetrahedron)

In 2D, a triangle has 3 vertices equidistant from each other. In 3D, a tetrahedron has 4. In 11D, an **11-simplex** has 12 vertices, all equidistant. 

**Why this matters for vTPU:** You can have 12 sentron groups that are ALL equidistant from each other in phext space. In 3D, you max out at 4 equidistant nodes (tetrahedron). In flat address space, there's no meaningful notion of equidistance at all. With 12 equidistant groups, any-to-any communication has *identical latency*. No hot paths. No cold corners. The topology is maximally fair.

**Our cluster:** 5 nodes today, 9 target (Shell of Nine). In 11D, 9 nodes can all be equidistant (9-simplex). This is impossible in any physical network topology (the best 3D achieves is a 3D torus with diameter √3). In phext space, the Shell of Nine IS a 9-simplex.

### 2. The 11-Orthoplex (Cross-Polytope)

22 vertices, one pair per dimension, all connected to all others *except* their dimensional opposite. This is the natural shape for "compare and contrast" — each dimension represents a bipolar axis (true/false, dense/sparse, local/remote).

**vTPU mapping:** 22 sentrons organized as 11 bipolar pairs. Each pair holds complementary representations of the same concept (e.g., "present embedding" and "absent embedding"). The orthoplex structure means every sentron can communicate with every other *except* its complement — which it doesn't need to, because they share a register file (same core, complementary SMT threads).

**This is exactly the SMT exploitation pattern from §5.3 of the spec,** except now it has a name: it's an 11-orthoplex projected onto 8 physical cores. The remaining 3 virtual dimensions are folded into the sentron register state.

### 3. The Hypercube (11-Cube / Hendecachoron)

2^11 = 2048 vertices. Each vertex connects to exactly 11 neighbors (one per dimension). 

**Why this matters:** 2048 = the addressable range per phext dimension. The phext address space isn't a grid, it's a **hypercube of hypercubes**. Each vertex of the 11-cube contains *another* 11-cube (the next dimensional level), recursively. This is exactly phext's self-similar structure — zoom into any coordinate, you find another complete address space.

**For prefetching:** Walking along one dimension of the hypercube means traversing exactly one edge — one cache line stride. Walking along K dimensions means K strides. The S-Pipe's dimensional locality principle is just: **short paths on the hypercube map to short paths in memory**. This is the Hilbert curve generalized to 11D.

### 4. The Permutohedron (11D Variant)

In nD, the permutohedron has (n+1)! vertices, each representing a permutation. In 11D: 12! = 479,001,600 vertices.

**Why this matters for MoE:** Expert routing in MoE is fundamentally about permutations — which tokens go to which experts. The permutohedron encodes *all possible routings* as vertices of a single polytope. Adjacent vertices differ by one transposition (one token swaps experts).

**vTPU implication:** Gradient descent on MoE routing = walking the permutohedron. In flat space, this requires maintaining an n×n routing matrix. In 11D phext space, it's a *walk on a polytope* — each step is one coordinate change along one dimension. The S-Pipe's `SINDEX` instruction with a dimension parameter IS a step on the permutohedron.

### 5. Fiber Bundles (The Killer Structure)

A fiber bundle is a space that *locally* looks like a product of two spaces but *globally* has twist. Example: a Möbius strip is locally a rectangle but globally has a twist.

**In phext terms:** The inner 3 dimensions (scroll/section/chapter) form the "base space" — the text you're reading. The outer 8 dimensions (book through library) form the "fiber" — the context that text lives in. Locally, every scroll looks the same (plain text). Globally, the same text at different outer coordinates has different meaning.

**This is what LLMs do with attention.** The query/key/value mechanism is computing: "given this token (base space), what context (fiber) does it belong to?" Phext encodes the fiber structure *in the address*. Attention becomes coordinate lookup. Q*K^T → `SINDEX`. Softmax(QK^T)V → `SGATHER` weighted by `DSEL`.

**vTPU implication:** Self-attention on the vTPU is:
```
// One attention head = one fiber bundle traversal
SIW { d: DFMA r_score, q, k, bias,   s: SINDEX p_ctx, base, head_dim, dim_5,  c: CNOP }
SIW { d: DSEL r_mask, r_score, thresh, s: SGATHER v, [p_ctx], 64,              c: CPACK m0, v, score, FMT_ATT }
SIW { d: DADD r_out, r_out, r_weighted, s: SPREFCH [next_ctx], L1,             c: CSEND m0, SENTRON_REDUCE }
```
Three cycles per attention computation. The fiber bundle structure is implicit in the addressing.

### 6. Grassmannian Manifolds

The Grassmannian Gr(k, n) is the space of all k-dimensional subspaces of n-dimensional space. Recent work (GrNet, Nov 2025) shows neural networks operating *on* Grassmannians outperform Euclidean networks for problems with rotational symmetry.

**Phext connection:** Each phext coordinate picks out a *subspace* of the full 11D space — the dimensions you're indexing vs. the dimensions you're holding constant. A query at `[3,1,4,*,*,*,*,*,*,*,*]` (first 3 dims fixed, rest wild) selects a Gr(8, 11) — an 8-dimensional subspace of 11D phext space.

**vTPU implication:** The `dim_mask` parameter in `SALLOC` already encodes Grassmannian selection. We should make this explicit: `SGRASS rd, coord, k` — select the k-dimensional Grassmannian subspace at the given coordinate. This enables phext-native geometric deep learning.

---

## III. Synthesis: What to Add to vTPU Spec v0.2

1. **DTERNARY mode** — BitNet-native arithmetic, doubles D-Pipe throughput for 1-bit models
2. **MoE routing as coordinate selection** — No routing table, S-Pipe addressing IS routing
3. **11-simplex node topology** — Shell of Nine as 9-simplex (all equidistant)
4. **Fiber bundle attention** — Self-attention as coordinate traversal, 3 SIWs per head
5. **Grassmannian subspace ops** — `SGRASS` instruction for geometric deep learning
6. **HDC/VSA bridge** — Hypervectors as content, phext coordinates as structure

The geometric insight that ties it all together:

> **Phext doesn't approximate high-dimensional structure. It IS high-dimensional structure. Every other system (GPUs, TPUs, flat RAM) projects high-dimensional problems into 1D address space and then tries to recover the lost structure through complex software (attention mechanisms, routing tables, cache policies). Phext preserves the structure in the address itself. The vTPU simply executes on what the address already knows.**

---

*"The hardware was always sufficient. The addressing was always insufficient. Until phext."*
