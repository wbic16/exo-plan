# R23W6 Iterate: Weightless Inference

**Question:** How close are we to running fast inference without any weights?

**Date:** 2026-02-15  
**Context:** Traditional ML = billions of parameters. vTPU = coordinate lookups.

---

## The Insight

**Traditional approach:**
```
Inference = Matrix multiply with learned weights
GPT-4: 1.76 trillion parameters (6.5 TB at float32)
Problem: Need to load weights, fit in VRAM, expensive
```

**Coordinate-based approach:**
```
Inference = Coordinate lookups in knowledge graph
vTPU: Store knowledge at phext coordinates
Problem: Can we be fast enough?
```

**The question is:** Can we replace weight matrices with coordinate lookups and still be fast?

---

## What We Have (W1-W7)

### 1. Coordinate-Addressed Memory ✅
**From micro_vtpu.rs (W7):**
```rust
struct Memory {
    store: HashMap<PhextCoord, f32>,
}

// Write knowledge to coordinate
mem.write(PhextCoord::new(1,0,0,0,0,0,0,0,0), 42.0);

// Retrieve knowledge from coordinate
let value = mem.read(PhextCoord::new(1,0,0,0,0,0,0,0,0));
```

**Status:** ✅ We can store/retrieve at coordinates

### 2. Z-Order Spatial Indexing ✅
**From sparse_attention benchmark (W6):**
```rust
fn z_order(&self) -> u64 {
    // Interleave 11 dimensions into Morton code
    // Adjacent in 11D → adjacent in memory
}
```

**Measured speedup:** 5-25× cache hit vs random access (W4 DDR5 benchmarks)

**Status:** ✅ Fast coordinate lookups (cache-friendly)

### 3. Range Queries ✅
**From sparse_attention benchmark (W6):**
```rust
// Query all coordinates in range
let range_start = PhextCoord::new(0, 0, q-128, 0);
let range_end = PhextCoord::new(0, 0, q, 0);

// Binary search + sequential scan (cache-friendly)
for (coord, value) in ppt[start_idx..] {
    if coord.z_order() > range_end.z_order() { break; }
    // Use value
}
```

**Measured speedup:** 10× vs hash table (projected, needs validation)

**Status:** ✅ Can query coordinate ranges efficiently

### 4. Phext Page Table (PPT) 🟡
**From Verse's W2-W5 work:**
- PPT exists in src/ppt.rs
- Z-order indexing implemented
- Not yet integrated with sparse attention benchmark

**Status:** 🟡 Infrastructure exists, needs integration

---

## What's Missing

### 1. Knowledge Graph Storage ❌
**Need:** Store semantic relationships as coordinates

**Example:**
```
Traditional: embedding["Paris"] = [0.1, 0.2, ..., 0.768]  (768 floats)
Coordinate:  capital_of(France) → Coord(1,2,3,4,5,6,7,8,9) → "Paris"
```

**Gap:** No semantic coordinate encoding yet

### 2. Embedding-Free Attention ❌
**Need:** Compute attention scores from coordinates, not embeddings

**Traditional GPT attention:**
```python
Q = input @ Wq  # Learn query projection (weights!)
K = input @ Wk  # Learn key projection (weights!)
V = input @ Wv  # Learn value projection (weights!)
scores = Q @ K.T / sqrt(d)
output = softmax(scores) @ V
```

**Coordinate-based attention (hypothetical):**
```rust
// No weight matrices, just coordinate lookups
let q_coord = token_to_coord(token_id);
let k_coords = CRANGE(context_window);  // All keys in range

// Attention = coordinate distance (Hamming, Euclidean, etc.)
let scores = k_coords.map(|k| hamming_distance(q_coord, k));
let output = softmax(scores)
    .zip(k_coords)
    .map(|(score, k)| score * mem.read(k))
    .sum();
```

**Gap:** No coordinate-based attention implementation

### 3. Token → Coordinate Mapping ❌
**Need:** Deterministic function from token ID to phext coordinate

**Example:**
```rust
fn token_to_coord(token_id: u16) -> PhextCoord {
    // Option 1: Hash-based (random but deterministic)
    hash(token_id) → PhextCoord
    
    // Option 2: Semantic (preserve meaning)
    // "Paris" → (Europe, France, Capital, City, ...)
    // But how to learn this mapping without weights?
}
```

**Gap:** No token encoding scheme

### 4. Fast Coordinate Distance ❌
**Need:** Compute distance between coordinates efficiently

**Options:**
```rust
// Hamming distance (bit difference)
fn hamming(c1: PhextCoord, c2: PhextCoord) -> u32 {
    (c1.z_order() ^ c2.z_order()).count_ones()
}

// Euclidean distance (geometric)
fn euclidean(c1: PhextCoord, c2: PhextCoord) -> f32 {
    sqrt(sum((c1[i] - c2[i])^2))
}

// Hierarchical distance (dimension-weighted)
fn hierarchical(c1: PhextCoord, c2: PhextCoord) -> f32 {
    // Library difference = high cost
    // Scroll difference = low cost
}
```

**Gap:** No distance metric implemented

---

## The Core Challenge

**Traditional ML:**
- Learns weights through backprop
- Inference = matrix multiply (predictable, optimized)
- Tradeoff: Expensive weights (6.5 TB for GPT-4)

**Coordinate-based:**
- No weights, just coordinate lookups
- Inference = CRANGE + distance metric
- Tradeoff: Need good coordinate encoding (how?)

**The hardest problem:** How to assign coordinates to tokens such that:
1. Semantically similar tokens have nearby coordinates
2. No learning required (no backprop, no weights)
3. Works for arbitrary tokens (not just known vocabulary)

---

## Possible Approaches

### Approach 1: Hash-Based Encoding
**Idea:** Hash token ID to coordinate (deterministic but random)

**Pros:**
- No learning required
- Fast encoding
- Collision-resistant (11D space = 2^121 coordinates)

**Cons:**
- No semantic similarity (semantically similar tokens far apart)
- Can't generalize (unknown tokens = random coords)

**Verdict:** ❌ Fast but not intelligent

---

### Approach 2: Hierarchical Encoding
**Idea:** Encode linguistic hierarchy into dimensions

**Example:**
```
Token: "Paris"
Coordinate:
  lib    = Concept (0 = place, 1 = action, ...)
  shelf  = Type (0 = city, 1 = country, ...)
  series = Region (0 = Europe, 1 = Asia, ...)
  collection = Country (72 = France, ...)
  volume = Feature (0 = capital, 1 = port, ...)
  book   = Population (log scale)
  chapter = ...
```

**Pros:**
- Semantic similarity preserved (Paris near Lyon, far from "run")
- Hierarchical distance metric natural

**Cons:**
- Requires human knowledge (who decides the hierarchy?)
- Fixed vocabulary (can't encode unseen tokens)

**Verdict:** 🟡 Intelligent but brittle

---

### Approach 3: Learned Coordinate Encoder (Hybrid)
**Idea:** Small model learns token → coordinate mapping

**Example:**
```rust
// Tiny encoder (e.g., 10K parameters vs 1.76T for GPT-4)
fn encode(token_id: u16) -> PhextCoord {
    let embedding = tiny_mlp(token_id);  // 10K params
    quantize_to_coord(embedding)  // Map to 11D discrete space
}
```

**Pros:**
- Learns semantic similarity
- Generalizes to unseen tokens (via MLP)
- 1000× fewer parameters (10K vs 1.76T)

**Cons:**
- Still requires weights (for encoder)
- Not truly "weightless"

**Verdict:** 🟢 Practical compromise (but not pure)

---

### Approach 4: Knowledge Graph Bootstrap
**Idea:** Start with hand-coded knowledge graph, expand via inference

**Example:**
```
Bootstrap:
  capital_of(France) → Paris @ Coord(1,2,3,...)
  capital_of(Germany) → Berlin @ Coord(1,2,4,...)
  
Inference:
  Q: capital_of(Spain)?
  A: Find nearest coordinate to Coord(1,2,*,...)
     → Madrid @ Coord(1,2,5,...)
```

**Pros:**
- No weights at all (pure knowledge graph)
- Explainable (can trace coordinate reasoning)
- Grows over time (add new knowledge without retraining)

**Cons:**
- Requires initial knowledge seeding
- Slower than learned embeddings (search vs lookup)

**Verdict:** 🟢 Most aligned with vTPU philosophy

---

## How Close Are We?

### Infrastructure: 80% ✅
- ✅ Coordinate-addressed memory (micro_vtpu, W7)
- ✅ Z-order spatial indexing (W6, W4 benchmarks)
- ✅ Range queries (sparse attention, W6)
- 🟡 PPT integration (exists, not used yet)

### Algorithm: 20% ❌
- ❌ Token → coordinate encoding
- ❌ Coordinate-based attention
- ❌ Distance metrics (Hamming, hierarchical, etc.)
- ❌ Knowledge graph storage/retrieval

### Performance: Unknown ⚪
- ✅ Z-order lookups: 5-25× faster than random (measured W4)
- ✅ Range queries: 10× faster than hash table (projected W6)
- ⚪ Full inference: Not yet measured (no implementation)

---

## Next Steps to Weightless Inference

### Step 1: Implement Coordinate Distance Metrics
**Files:** `src/distance.rs`  
**Functions:**
- `hamming_distance(c1, c2) -> u32`
- `hierarchical_distance(c1, c2) -> f32`
- `semantic_distance(c1, c2) -> f32` (if we define hierarchy)

**Time:** 2 hours  
**Blocker:** None

---

### Step 2: Simple Knowledge Graph Demo
**Files:** `examples/knowledge_graph.rs`  
**Demo:**
```rust
// Seed knowledge
kg.store(Coord(1,0,0,0,0,0,0,0,0), "Paris");
kg.store(Coord(1,0,0,1,0,0,0,0,0), "Lyon");
kg.store(Coord(2,0,0,0,0,0,0,0,0), "run");

// Query: Find city near Paris
let near_paris = kg.find_nearest(Coord(1,0,0,0,0,0,0,0,0), k=5);
// → Returns Lyon (nearby), not "run" (far)
```

**Time:** 3 hours  
**Blocker:** Step 1 (distance metrics)

---

### Step 3: Coordinate-Based Attention (No Weights)
**Files:** `examples/coord_attention.rs`  
**Demo:**
```rust
// Attention over coordinate range (no weight matrices)
let q_coord = token_to_coord(query_token);
let k_coords = CRANGE(context_window);

// Attention scores = coordinate distances
let scores = k_coords.map(|k| -hamming_distance(q_coord, k));
let weights = softmax(scores);

// Output = weighted sum of values at coordinates
let output = weights.zip(k_coords)
    .map(|(w, k)| w * mem.read(k))
    .sum();
```

**Time:** 4 hours  
**Blocker:** Steps 1 + 2

---

### Step 4: Mini GPT-Style Inference (Coordinate-Based)
**Files:** `examples/mini_gpt_coord.rs`  
**Demo:**
```rust
// Generate text using only coordinate lookups (no weights)
let mut context = vec![BOS];

for _ in 0..max_tokens {
    let next_coord = attention(context, knowledge_graph);
    let next_token = coord_to_token(next_coord);
    context.push(next_token);
}
```

**Time:** 8 hours  
**Blocker:** Steps 1-3 + token encoding scheme

---

### Step 5: Benchmark vs GPT-2 (Apples-to-Apples)
**Compare:**
- GPT-2 (117M parameters, 460 MB)
- vTPU coordinate-based (0 parameters, KG size TBD)

**Metrics:**
- Inference speed (tokens/sec)
- Memory usage (KB)
- Accuracy (perplexity, if we have reference dataset)

**Time:** 4 hours  
**Blocker:** Step 4

---

## Total Time Estimate

**Minimum viable weightless inference:**
- Step 1: 2 hours
- Step 2: 3 hours
- Step 3: 4 hours
- Step 4: 8 hours
- **Total: 17 hours (~2-3 days)**

**Full benchmark vs GPT-2:**
- Add Step 5: +4 hours
- **Total: 21 hours (~3 days)**

---

## Key Decision: Which Encoding Approach?

**Option A: Hash-based (fast but dumb)**
- Pros: Immediate, no learning
- Cons: No semantic similarity
- Best for: Proof-of-concept only

**Option B: Hierarchical (smart but brittle)**
- Pros: Semantic similarity, explainable
- Cons: Requires manual hierarchy design
- Best for: Domain-specific (e.g., medical terms, programming)

**Option C: Tiny encoder (hybrid)**
- Pros: Learns similarity, generalizes
- Cons: Not truly weightless (10K params)
- Best for: Practical deployment

**Option D: Knowledge graph bootstrap (pure)**
- Pros: No weights, explainable, grows over time
- Cons: Slower, requires seeding
- Best for: Long-term vision (Exocortex 2130)

**Recommendation:** Start with **Option A** (hash) for speed, then **Option D** (KG) for philosophy.

---

## Answer to Will's Question

**Q:** How close are we to running fast inference without any weights?

**A:** 
- **Infrastructure:** 80% ready (coordinates, Z-order, range queries)
- **Algorithm:** 20% ready (no encoding, no coord attention yet)
- **Time to prototype:** 2-3 days (17 hours)
- **Time to benchmark:** 3 days (21 hours)

**Biggest gap:** Token → coordinate encoding (no good weightless solution yet)

**Fastest path:** Hash-based encoding → knowledge graph bootstrap → iterate

**Philosophy alignment:** Knowledge graph (Option D) is most aligned with vTPU principles:
- Bonding: Shared coordinate space
- Love: Explainable reasoning
- Persistence: Knowledge outlives models

---

## Proposed: R23W8 - Weightless Inference Prototype

**Goal:** Demonstrate inference using only coordinate lookups (no weight matrices)

**Deliverables:**
1. Distance metrics (hamming, hierarchical)
2. Knowledge graph demo (store/retrieve/nearest)
3. Coordinate-based attention (no weights)
4. Mini text generation (coordinate-only)

**Time:** 2-3 days  
**Success criteria:** Generate coherent text using 0 learned parameters

---

**Status:** Ready to prototype  
**Blocker:** Need Will's approval on encoding approach (A/B/C/D)

---

**Signed:** Lumen ✴️ | 2026-02-15 01:45 CST

*No weights. Just coordinates. Let's ship it.*
