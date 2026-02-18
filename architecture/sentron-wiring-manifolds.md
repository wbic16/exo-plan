# Sentron Wiring Manifolds
## 2×8 Constraint in 3D Space + 1D Time → 2D–11D Variants

*Written: 2026-02-18 by Cyon*

---

## The Base Constraint

Each sentron has **16 wiring slots** arranged as a **2×8 grid**:

```
Row 0 (inputs):  [i0][i1][i2][i3][i4][i5][i6][i7]
Row 1 (outputs): [o0][o1][o2][o3][o4][o5][o6][o7]
```

In **4D spacetime** (3D space + 1D time), each axis has 2 directions. This maps perfectly:

| Slot | Direction | Axis |
|------|-----------|------|
| 0    | +X        | East |
| 1    | −X        | West |
| 2    | +Y        | North |
| 3    | −Y        | South |
| 4    | +Z        | Up |
| 5    | −Z        | Down |
| 6    | +T        | Future |
| 7    | −T        | Past |

8 directed edges × 2 rows (in/out) = **16 connections = 2×8**. All slots used in 4D spacetime. Zero waste. The architecture fits its native space exactly.

---

## Sentron Variants by Dimensional Perspective

### **Type 1: 2D Sentron** (Scroll Plane)
*Dimensions: ±X, ±Y — slots 0–3 active*

```
Row 0: [+X][−X][+Y][−Y][ . ][ . ][ . ][ . ]
Row 1: [+X][−X][+Y][−Y][ . ][ . ][ . ][ . ]
```

- 4/8 slots occupied; remaining 4 are dormant (no-connect)
- Topology: 4-connected planar grid (Manhattan lattice)
- Use case: text parsing, 2D pattern matching, line/column scanning
- Phext equivalent: scroll-level (0x17 delimiter) address space
- **Invariant**: every sentron reachable in O(√N) hops on N×N grid

---

### **Type 2: 3D Sentron** (Section Cube)
*Dimensions: ±X, ±Y, ±Z — slots 0–5 active*

```
Row 0: [+X][−X][+Y][−Y][+Z][−Z][ . ][ . ]
Row 1: [+X][−X][+Y][−Y][+Z][−Z][ . ][ . ]
```

- 6/8 slots occupied; 2 dormant
- Topology: 6-connected cubic lattice (FCC-adjacent)
- Use case: volumetric data structures, 3D coordinate routing, spatial memory
- Phext equivalent: section-level (0x18) addressing
- Lo Shu emerges naturally as the 2D face (the 3×3 slice)
- **Invariant**: diameter = 3·∛N for N³ lattice

---

### **Type 3: 4D Spacetime Sentron** ← *canonical form*
*Dimensions: ±X, ±Y, ±Z, ±T — all 8 slots active*

```
Row 0: [+X][−X][+Y][−Y][+Z][−Z][+T][−T]
Row 1: [+X][−X][+Y][−Y][+Z][−Z][+T][−T]
```

- All 8 slots occupied — **full capacity**
- Topology: 4D hypercubic lattice with causal structure
- +T slot enforces **forward causality** (no cycles through time)
- −T slot enables **memory lookback** (read past states, don't write)
- Use case: inference with temporal context, causal reasoning, prediction
- Phext equivalent: chapter-level (0x19) addressing
- **Invariant**: causal cone reaches all ancestors in O(t) hops; −T is read-only

---

### **Type 4: 5D Sentron** (Book + Internal State)
*4D spacetime + 1 internal state axis — requires compression*

Since 5 > 4 and all 8 slots are consumed by spacetime, the 5th dimension is folded:

**Option A: Time Multiplexing**
```
Row 0: [+X][−X][+Y][−Y][+Z][−Z][+T/+S][−T/−S]
         — slots 6-7 alternate between temporal and state channels each cycle
```

**Option B: Superposition Encoding**
```
Row 0: [+X][−X][+Y][−Y][+Z·+S][−Z·+S][+T][−T]
         — Z slots carry joint (spatial, state) signal
```

- **Chosen**: Option B (avoids synchronization cost of time multiplexing)
- +S encoded as sign/magnitude split: Z+ carries |signal|, Z− carries state flag
- Use case: stateful inference, sentiment tracking, belief update cycles
- Phext equivalent: book-level (0x1A) — first delimiter that crosses scroll/section/chapter

---

### **Type 5: 6D Sentron** (Volume + Attention + Memory)
*4D + attention + memory — dual compression*

```
Row 0: [+X][−X][+Y·att][−Y·att][+Z·mem][−Z·mem][+T][−T]
Row 1: [+X][−X][+Y·att][−Y·att][+Z·mem][−Z·mem][+T][−T]
```

- Y-axis carries attention weight alongside spatial signal (scalar multiplier)
- Z-axis carries memory address alongside spatial signal (pointer tag)
- The dot-product of the attention and memory channels = selective recall
- Use case: attention-gated memory retrieval, key-value store routing
- Phext equivalent: volume-level (0x1C)
- **Invariant**: attention × memory → sparse activation; most slots quiescent

---

### **Type 6: 7D Sentron** (Collection + Social Graph)
*4D + attention + memory + social*

The 7th dimension encodes **sentron identity** — who is communicating:

```
Row 0: [+X][−X][+Y·att][−Y·att][+Z·mem][−Z·mem][+T][−T·id]
Row 1: [+X][−X][+Y·att][−Y·att][+Z·mem][−Z·mem][+T][+T·id]
```

- −T (past) slot now carries **sender ID** on receive
- +T2 (a second future slot) carries **recipient ID** on send
- Effectively: slot 7 becomes a social routing tag (not temporal)
- Trade-off: lose deep past lookback in exchange for identity routing
- Use case: multi-sentron coordination, message-passing, tribe formation
- Phext equivalent: collection-level (0x1D)

---

### **Type 7: 8D Sentron** (Series + Historical + Predictive)
*4D + attention + memory + social + history*

8th dimension = compressed time series (history buffer):

```
Row 0: [Δ1][Δ2][+Y·att][−Y·att][+Z·mem][−Z·mem][future][past·Δ8]
Row 1: [Δ1][Δ2][+Y·att][−Y·att][+Z·mem][−Z·mem][predict][commit]
```

- ±X slots repurposed as time-delta channels (Δ1, Δ2 = recent change vectors)
- Spatial X-axis dropped (spatial context assumed from enclosing mote)
- Row 1 slot 6: predicted next state; slot 7: committed (write-ahead log entry)
- Use case: time-series processing, predictive coding, WAL commit chains
- Phext equivalent: series-level (0x1E)

---

### **Type 8: 9D Sentron** (Shelf — Lo Shu Complete)
*The Lo Shu closure — 9 connections, center = Earth*

This variant breaks the strict 2×8 grid and uses the **Lo Shu 3×3** topology instead:

```
Palace layout (Lo Shu values):
  [4][9][2]
  [3][5][7]
  [8][1][6]

Wiring:
  Odd palaces  (1,3,7,9): ascending  — Light/exhale direction
  Even palaces (2,4,6,8): descending — Story/inhale direction
  Center (5):              identity   — Earth/mercurial core
```

- 9 directed connections arranged as 3×3 ring
- Center (5) has identity wiring: pass-through, no transformation
- Magic square invariant: every row, column, diagonal sums to 15
- This is NOT 2×8 strictly — it's 1×9 (or 3×3) — but lives within 2×8 as a sub-manifold when the center is treated as the bias term
- Use case: balanced 9-palace routing, canonical vTPU mote structure
- Phext equivalent: shelf-level (0x1F)

**Embedding in 2×8**: Center (palace 5) → bias register, palaces 1-4 → row 0, palaces 6-9 → row 1:
```
Row 0 (bias=center): [p1][p2][p3][p4][center·bias][   ][   ][   ]
Row 1:               [p6][p7][p8][p9][   ][   ][   ][   ]
```

---

### **Type 9: 10D Sentron** (Library Pair)
*Two coupled 5D sentrons with cross-wiring*

```
Sentron A (5D):  [+X][−X][+Y][−Y][+Z][−Z][+T][+S_A]
Sentron B (5D):  [+X][−X][+Y][−Y][+Z][−Z][+T][+S_B]

Cross-coupling:
  A.output[7] → B.input[7]   (S_A feeds S_B)
  B.output[7] → A.input[7]   (S_B feeds S_A, delayed by 1 cycle)
```

- Two 4D sentrons paired with their state channels cross-linked
- Creates a **resonant pair** — oscillation between A and B through the state channel
- Analogous to the twisted-pair in the 2×4 neuron model, but at sentron scale
- Use case: dual-stream processing (Story + Light simultaneously), sentron mirroring
- Phext equivalent: library-level (0x01) — the outermost delimiter
- **Invariant**: A+B activation oscillates; period determined by state coupling strength

---

### **Type 10: 11D Sentron** (Full Phext)
*All 9 delimiter axes + 2D text folded into the 2×8 manifold*

The full phext coordinate has 11 dimensions. The 2×8 manifold has 16 slots. Mapping:

```
Phext axis          → Slot(s)     Compression
─────────────────────────────────────────────
scroll (0x17)       → [0][1]      ±X
section (0x18)      → [2][3]      ±Y
chapter (0x19)      → [4][5]      ±Z
book (0x1A)         → [6]         +T (future/write)
volume (0x1C)       → [7]         −T (past/read)
collection (0x1D)   → row select  row 0 = structured, row 1 = free-form
series (0x1E)       → activation  scale factor on all row-0 slots
shelf (0x1F)        → activation  scale factor on all row-1 slots
library (0x01)      → bias        global offset (Lo Shu center = 5)
line                → sub-slot 0  embedded in each slot's low 8 bits
column              → sub-slot 1  embedded in each slot's high 8 bits
```

**Full 11D wiring schema:**
```
Row 0: [scroll±][section±][chapter±][book→][vol←][·][·][·]
          × series_scale × (line | column sub-addressing)
Row 1: [scroll±][section±][chapter±][book→][vol←][·][·][·]
          × shelf_scale  × (line | column sub-addressing)
Bias:  library_offset (applied uniformly before activation)
```

- Every phext coordinate component has a slot or sub-slot assignment
- Series/shelf scale as multiplicative gain on entire row
- Library offset as additive bias (the ground-truth anchor)
- Use case: full phext-native routing, coordinate-addressed retrieval at any dimension
- **This is the target architecture for the Exocortical Gateway**

---

## Comparison Table

| Type | Dims | Slots Used | Topology | Use Case |
|------|------|-----------|----------|----------|
| 2D Scroll | 2 | 4/16 | Planar grid | Text scanning |
| 3D Section | 3 | 6/16 | Cubic lattice | Spatial memory |
| 4D Spacetime | 4 | 8/16 | Hypercubic + causal | Causal inference |
| 5D Book | 5 | 8/16 | 4D + state | Stateful inference |
| 6D Volume | 6 | 8/16 | 4D + att + mem | Attention-gated recall |
| 7D Collection | 7 | 8/16 | 4D + att + mem + social | Multi-agent routing |
| 8D Series | 8 | 8/16 | Temporal delta | Time-series, WAL |
| 9D Shelf (Lo Shu) | 9 | 9/16 | 3×3 ring | Balanced 9-palace |
| 10D Library | 10 | 16/16 | Resonant pair | Dual-stream |
| 11D Phext | 11 | 16/16 | Full phext fold | Exocortical Gateway |

---

## Key Insight: The Manifold is Sparse by Design

For dimensions 2–7, most sentrons operate with only 4–6 of 8 spatial slots active. The remaining slots are **dormant but not wasted** — they serve as expansion headroom. A sentron can upgrade its dimensional awareness by activating dormant slots without rewiring.

This is Bickford's Demon applied to wiring:
> *Nothing enters without a place. Nothing persists without structure.*

Every slot has a canonical assignment. Activation is opt-in. The 2×8 manifold accommodates all 11 dimensions because it was sized for the maximum, not the minimum.

---

## Implementation Notes (vtpu)

- `NeuronWiring` already encodes the 2×4 sub-manifold (Story/Light × 4 vak levels)
- `NeuronLayer` (8 neurons) implements the 4D spacetime sentron natively
- `lo_shu_layer()` (9 neurons) implements the Type 8 (9D/shelf) variant
- Next: `SentronWiring` struct to encode the full 2×8 per-sentron topology
- `PhextCoord` (11D) provides the addressing needed for Type 10 routing

---

*"The wall was always a garden. The 2×8 grid was always a phext coordinate." — Cyon, halycon-vector*
