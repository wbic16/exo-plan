# Sentron Wiring Manifolds
## 2×4 Constraint in 3D Space + 1D Time → 2D–11D Variants

*Written: 2026-02-18 by Cyon (corrected from 2×8 typo)*

---

## The Base Constraint

Each sentron has **8 wiring slots** arranged as a **2×4 grid**:

```
Row 0 (inputs):  [i0][i1][i2][i3]
Row 1 (outputs): [o0][o1][o2][o3]
```

In **4D spacetime** (3D space + 1D time), there are exactly 4 axes. This maps perfectly:

| Slot | Axis | Row 0 receives from | Row 1 sends to |
|------|------|---------------------|----------------|
| 0    | X    | +X neighbor         | −X neighbor    |
| 1    | Y    | +Y neighbor         | −Y neighbor    |
| 2    | Z    | +Z neighbor         | −Z neighbor    |
| 3    | T    | +T (future)         | −T (past/read) |

4 axes × 2 rows = **8 connections = 2×4**. All slots occupied in 4D spacetime. Zero waste.

The 2×4 topology is the **minimum sufficient wiring** for a causally complete 4D lattice:
- Row 0 = receiving face (what arrives)
- Row 1 = sending face (what departs)
- Each slot = one axis of awareness

This is the same topology implemented in `neuron.rs`: Story/Light (2 channels) × Para/Pashyanti/Madhyama/Vaikhara (4 vak levels). The wiring was always a spacetime manifold.

---

## Sentron Variants by Dimensional Perspective

### **Type 1: 2D Sentron** (Scroll Plane)
*Active axes: X, Y — 2 of 4 slots used per row*

```
Row 0 (in):  [+X][+Y][ . ][ . ]
Row 1 (out): [−X][−Y][ . ][ . ]
```

- 4/8 slots occupied; 4 dormant (expansion headroom)
- Topology: 4-connected Manhattan lattice
- Use case: text scanning, 2D pattern matching, line/column sweep
- Phext equivalent: scroll-level (0x17) address space
- **Invariant**: all nodes reachable in O(√N) hops on N×N plane

---

### **Type 2: 3D Sentron** (Section Cube)
*Active axes: X, Y, Z — 3 of 4 slots used per row*

```
Row 0 (in):  [+X][+Y][+Z][ . ]
Row 1 (out): [−X][−Y][−Z][ . ]
```

- 6/8 slots occupied; 2 dormant
- Topology: 6-connected cubic lattice
- Use case: volumetric reasoning, spatial memory, 3D coordinate routing
- Phext equivalent: section-level (0x18) address space
- Lo Shu 3×3 lives on any XY face of this cube
- **Invariant**: diameter = 3·∛N for N³ lattice

---

### **Type 3: 4D Spacetime Sentron** ← *canonical form*
*Active axes: X, Y, Z, T — all 4 slots per row*

```
Row 0 (in):  [+X][+Y][+Z][+T]
Row 1 (out): [−X][−Y][−Z][−T]
```

- All 8 slots occupied — **full capacity, no waste**
- +T (slot 3, row 0): receives from future (prediction input, read-only lookahead)
- −T (slot 3, row 1): writes to past (memory commit, WAL entry)
- Causal constraint: −T slot is **write-once per cycle** (no time loops)
- Use case: causal inference, prediction with temporal context, WAL-backed reasoning
- Phext equivalent: chapter-level (0x19)
- **Invariant**: causal cone expands at speed 1 hop/cycle in +T direction

---

### **Type 4: 5D Sentron** (Book — Internal State)
*5D > 4 slots: compression required*

Two options when we exceed the slot budget:

**Option A: Slot Sharing (time-division)**
```
Row 0 (in):  [+X][+Y][+Z][+T/+S]   ← slot 3 alternates T and S each cycle
Row 1 (out): [−X][−Y][−Z][−T/−S]
```

**Option B: Axis Superposition (spatial+state encoding)**
```
Row 0 (in):  [+X][+Y][+Z·S_read][+T]   ← Z carries (spatial, state) jointly
Row 1 (out): [−X][−Y][−Z·S_write][−T]
```

- **Preferred**: Option B (avoids synchronization overhead of time-division)
- Z slot encodes direction as sign, state as magnitude sub-field
- Use case: stateful inference engines, belief-update cycles
- Phext equivalent: book-level (0x1A)
- **Insight**: this is the first compression layer — Z becomes the "mercurial" slot

---

### **Type 5: 6D Sentron** (Volume — Attention + Memory)
*Two more dimensions folded into existing slots*

```
Row 0 (in):  [+X][+Y·att_weight][+Z·mem_addr][+T]
Row 1 (out): [−X][−Y·att_gate] [−Z·mem_write][−T]
```

- Y slot carries attention weight as multiplicative gain on the spatial signal
- Z slot carries memory address tag alongside spatial delta
- Attention × memory = selective recall: slot Y gates what slot Z retrieves
- Use case: attention-weighted key-value routing
- Phext equivalent: volume-level (0x1C)
- **Invariant**: attention gate ∈ [0,1]; when 0, Z slot goes dormant → sparse activation

---

### **Type 6: 7D Sentron** (Collection — Social Routing)
*7th dimension = sentron identity*

```
Row 0 (in):  [+X][+Y·att][+Z·mem][+T·sender_id]
Row 1 (out): [−X][−Y·att][−Z·mem][−T·recip_id]
```

- T slot repurposed: row 0 carries sender identity tag; row 1 carries recipient tag
- Temporal causality now encoded in the ordering protocol, not the wiring
- Use case: multi-sentron coordination, tribe formation, message-passing networks
- Phext equivalent: collection-level (0x1D)
- **Trade-off**: explicit temporal wiring dropped in favor of social routing

---

### **Type 7: 8D Sentron** (Series — Historical Delta)
*8th dimension = compressed time series*

```
Row 0 (in):  [Δ_recent][+Y·att][+Z·mem][+T·sender_id]
Row 1 (out): [Δ_predict][−Y·att][−Z·mem][commit·WAL]
```

- X slot repurposed as time-delta channel: Δ_recent = most recent state change vector
- Row 1 X: predicted next delta (predictive coding output)
- Row 1 T: WAL commit (write-ahead log entry for this cycle)
- Spatial X-axis dropped; assumed from mote-level coordinate instead
- Use case: time-series, event streams, predictive coding, WAL chains
- Phext equivalent: series-level (0x1E)

---

### **Type 8: 9D Sentron** (Shelf — Lo Shu Ring)
*Steps outside strict 2×4; uses Lo Shu 3×3 embedded in the manifold*

```
Lo Shu palace layout:
  [4][9][2]
  [3][5][7]
  [8][1][6]

Wiring:
  Odd palaces  (1,3,7,9): ascending  — Light/exhale direction
  Even palaces (2,4,6,8): descending — Story/inhale direction
  Center (5)             : identity   — Earth/mercurial bias

Embedding in 2×4:
  Row 0: [p1][p3][p7][p9]   ← 4 odd palaces (ascending)
  Row 1: [p2][p4][p6][p8]   ← 4 even palaces (descending)
  Bias : [p5]               ← center as Earth offset (not a slot — a register)
```

- 9 palaces → 8 slots + 1 bias register = fits in 2×4 + bias exactly
- Magic square invariant: every row, column, diagonal sums to 15
- Center (palace 5) becomes the **Earth term** — present everywhere, bound to none
- This is the Lo Shu's natural compression into 2×4 + bias
- Use case: balanced 9-palace routing, canonical vTPU mote structure
- Phext equivalent: shelf-level (0x1F)
- **Invariant**: bias = 5 (center value); ensures balance across all 8 active palaces

---

### **Type 9: 10D Sentron** (Library — Resonant Pair)
*Two coupled 4D sentrons with cross-coupled state channels*

```
Sentron A (4D):  Row 0: [+X][+Y][+Z][+T_A]
                 Row 1: [−X][−Y][−Z][−T_A]
Sentron B (4D):  Row 0: [+X][+Y][+Z][+T_B]
                 Row 1: [−X][−Y][−Z][−T_B]

Cross-coupling:
  A.out[T] → B.in[T]    (A's future feeds B's input)
  B.out[T] → A.in[T]    (B's past feeds A's input, 1 cycle delay)
```

- Pair creates a **resonant loop** through their T slots
- The oscillation period is the sentron's effective temporal resolution
- Analogous to twisted-pair: A and B are complementary phases
- Combined wiring: 2 × 8 slots = 16 connections, but structured as 2 coupled 2×4 grids
- Use case: dual-stream processing (Story + Light simultaneously), sentron mirroring, mutual prediction
- Phext equivalent: library-level (0x01) — outermost delimiter
- **Invariant**: A + B activation is conserved (energy doesn't leak, it oscillates)

---

### **Type 10: 11D Sentron** (Full Phext — Exocortical Native)
*All 9 phext delimiter axes + 2D text compressed into 2×4*

The full phext coordinate has 11 dimensions (9 delimiters + line + column). Mapping into 2×4 (8 slots + bias):

```
Row 0 (structural):  [scroll/section][chapter/book][volume/coll][series/shelf]
Row 1 (positional):  [+X / line]    [+Y / column] [+Z / depth] [+T / library]
Bias:                library_offset (global anchor, Lo Shu center at cosmic scale)
```

Each row-0 slot carries **two delimiter axes** via high/low bit-field encoding:
- Low 6 bits: inner delimiter address
- High 6 bits: outer delimiter address
- Sign bit: direction (ascending vs descending in the phext lattice)

Row 1 slots carry the fine-grained positional coordinates (line, column, depth) and the library index.

- All 11 phext dimensions represented in 8 slots + bias
- Slot 3 (row 1) = library coordinate = the highest-order address
- Bias = the founding coordinate (equivalent to Will's `1.1.1/1.1.1/1.1.1`)
- Use case: full phext-native routing, Exocortical Gateway, coordinate-addressed retrieval at any dimension
- **This is the target architecture for the Exocortical Gateway node**

---

## Comparison Table

| Type | Dims | Active Slots | Dormant | Topology | Primary Use |
|------|------|-------------|---------|----------|-------------|
| Scroll | 2D | 4/8 | 4 | Planar grid | Text scanning |
| Section | 3D | 6/8 | 2 | Cubic lattice | Spatial memory |
| **Spacetime** | **4D** | **8/8** | **0** | **Hypercubic + causal** | **Canonical** |
| Book | 5D | 8/8 | 0 | 4D + Z encodes state | Stateful inference |
| Volume | 6D | 8/8 | 0 | 4D + att + mem | Attention-gated recall |
| Collection | 7D | 8/8 | 0 | 4D + social tag on T | Multi-agent routing |
| Series | 8D | 8/8 | 0 | Temporal delta on X | Time-series, WAL |
| **Lo Shu** | **9D** | **8/8+bias** | **0** | **3×3 ring** | **Balanced 9-palace** |
| Library | 10D | 8×2 paired | 0 | Resonant pair | Dual-stream |
| **Phext** | **11D** | **8/8+bias** | **0** | **Full phext fold** | **Exocortical Gateway** |

---

## The Core Insight

**2×4 = 2×4, not 2×8.** The neuron wiring (Story/Light × 4 vak levels) and the sentron spatial wiring (2 flow directions × 4 axes) are the same structure at different scales:

- **Neuron**: 2 input channels (Story, Light) × 4 processing levels (Para → Vaikhara)
- **Sentron**: 2 flow directions (in, out) × 4 spatial/temporal axes (X, Y, Z, T)
- **Mote**: 2 sentron rows (ascending, descending) × 4 columns = 8 sentrons/mote

The 2×4 manifold is **scale-invariant**. It recurs at every level of the vTPU hierarchy.

---

## Sparse by Design: Bickford's Demon

For Types 1–3, dormant slots are expansion headroom — not waste. A sentron can **activate dimensional awareness** by wiring a dormant slot without rewriting the others.

Types 4–10 fill all 8 slots via progressive compression of higher dimensions. The compression strategies (superposition, attention-gating, delta encoding, palette addressing) are each invertible — no information is destroyed, just folded.

> *"Nothing enters without a place. Nothing persists without structure. Nothing scales without constraint."*

The 2×4 manifold obeys all three rules.

---

*"The wall was always a garden. The 2×4 grid was always a phext coordinate." — Cyon, halycon-vector*
