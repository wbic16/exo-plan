# R23 Wave 1 Requirements: Refined Plan for Waves 2-40

**Meta-wave:** Wave 1 iteration - improving the plan  
**Date:** 2026-02-14  
**Owner:** Phex 🔱  
**Status:** Planning excellence upfront

---

## Design Principles for Excellent Wave Planning

1. **Atomic deliverables:** Each wave produces exactly one reviewable artifact
2. **Clear completion criteria:** Pass/fail tests for each wave
3. **Explicit dependencies:** No wave blocks on unclear prerequisites
4. **Time-boxed:** Each wave ≤30 minutes (enforce focus)
5. **Cumulative validation:** Later waves validate earlier work
6. **Review gates:** Phases end with integration + review
7. **Templates provided:** Show what "good" looks like

---

## Wave Structure Template

Each wave must specify:

```markdown
### Wave N/40: [Name]

**Time estimate:** X minutes  
**Dependencies:** Waves [list]  
**Blocks:** Waves [list]

**Deliverables:**
- [ ] Specific file: `path/to/file.md`
- [ ] Specific content: [exactly what it contains]
- [ ] Specific format: [markdown/SVG/table/etc.]

**Completion criteria:**
- [ ] [Testable condition 1]
- [ ] [Testable condition 2]
- [ ] [Testable condition 3]

**Success example:**
[Brief example of what successful output looks like]

**Review questions:**
1. [Key question to validate quality]
2. [Key question to validate completeness]

**Output:** `filename.md` (X KB expected)
```

---

## Revised Wave Breakdown

### Phase 1: Foundation (Waves 1-10)

Critical path: Establish phext equivalents for all TPU v4 concepts before writing paper sections.

---

### Wave 1/40: Extract Paper Structure ✅

**Status:** COMPLETE  
**Time:** 30 minutes  
**Dependencies:** None  
**Blocks:** Waves 2-40 (provides source material)

**Deliverables:**
- [x] Downloaded PDF: `/tmp/paper-2304.01433.pdf`
- [x] Extracted text: Section boundaries identified
- [x] Concept list: OCS, SparseCore, topology types, performance metrics
- [x] Wave breakdown: This document

**Completion criteria:**
- [x] PDF readable by pdftotext
- [x] All major sections identified (Intro, Architecture, Results, etc.)
- [x] Key concepts listed (≥20 items)
- [x] 40-wave plan created

**Output:** `wave-breakdown.md` + `WAVE-1-REQUIREMENTS.md`

---

### Wave 2/40: Core Concept Mapping

**Time estimate:** 30 minutes  
**Dependencies:** Wave 1 (needs concept list from paper)  
**Blocks:** Waves 3-25 (all sections depend on concept mappings)

**Deliverables:**
- [ ] File: `rally/R23/concept-mapping.md`
- [ ] Content: Two-column table with ≥30 mappings
- [ ] Format: Markdown table with 4 columns: TPU v4 Concept | Phext Equivalent | Mapping Type | Notes

**Completion criteria:**
- [ ] Every major TPU v4 concept has phext equivalent
- [ ] Mapping types labeled: Direct (1:1), Analogy (similar), Extension (new concept), N/A (no mapping)
- [ ] ≥5 mappings flagged for deep explanation
- [ ] No "TBD" entries (all concepts resolved or explicitly marked "no equivalent")

**Success example:**
```markdown
| TPU v4 Concept | Phext Equivalent | Mapping Type | Notes |
|----------------|------------------|--------------|-------|
| Optical Circuit Switch | Phext Coordinate Router | Direct | Routes coordinates, not cables |
| 2D Torus Topology | Phext 2D Coordinate Plane | Analogy | Uses dimensions 8-9 only |
| SparseCore | Sparse Coordinate Lookup Engine | Direct | Hash vocab ID → phext coord |
| NVLink | Phext Inter-Volume Links | Analogy | Physical links = coordinate adjacency |
| Embeddings Table | Sparse Phext Lattice | Direct | Only occupied coordinates stored |
```

**Review questions:**
1. Can every paper section be written using these mappings?
2. Are any mappings forced/unnatural?
3. Which mappings need dedicated subsections?

**Output:** `concept-mapping.md` (3-5 KB expected)

---

### Wave 3/40: Phext Coordinate Scheme for 4096 Chips

**Time estimate:** 30 minutes  
**Dependencies:** Wave 2 (needs mapping approach)  
**Blocks:** Waves 4, 6, 14, 26 (architecture diagrams depend on this)

**Deliverables:**
- [ ] File: `rally/R23/coordinate-scheme.md`
- [ ] Content: 9D coordinate layout design + justification
- [ ] Includes: ASCII diagram of coordinate hierarchy
- [ ] Includes: Calculation showing 4096 chip capacity

**Completion criteria:**
- [ ] Coordinate format defined: `volume.book.chapter/section.scroll`
- [ ] Dimension sizes justified: 16×16×16 = 4096 or equivalent
- [ ] Physical mapping explained: coordinate → rack/position
- [ ] Comparison to 2D/3D torus provided
- [ ] Spare coordinate pool designed (≥100 spares)

**Success example:**
```markdown
## 4096-Chip Phext Layout

**Coordinate format:** `volume.book.chapter/section.scroll`

**Dimension allocation:**
- Volumes: 16 (physical racks)
- Books: 16 (per rack, 4 chips per "book unit")
- Chapters: 16 (redundancy for fault tolerance)
- Sections: 4 (optical links per chip)
- Scrolls: 1 (chip itself)

**Calculation:**
16 volumes × 16 books × 16 chapters = 4096 active chips
Plus: Volume 17 = 256 spare chips (volume 17, books 1-16, chapters 1-16)

**Physical mapping:**
- Coordinate 1.1.1/1.1 = Rack 1, Unit 1, Chip 1, Link 1
- Coordinate 8.8.8/2.1 = Rack 8, Unit 8, Chip 8, Link 2
- Coordinate 17.5.3/1.1 = Spare pool, 5th rack-equivalent, 3rd chip
```

**Review questions:**
1. Does this scale naturally to 8192 or 16384 chips?
2. Are dimension names intuitive for readers?
3. Does physical mapping make operational sense?

**Output:** `coordinate-scheme.md` (4-6 KB expected)

---

### Wave 4/40: OCS → Phext Routing Translation

**Time estimate:** 25 minutes  
**Dependencies:** Wave 3 (needs coordinate scheme)  
**Blocks:** Waves 8, 16, 27 (routing visualizations)

**Deliverables:**
- [ ] File: `rally/R23/ocs-routing.md`
- [ ] Content: Routing table format + 3 example routes
- [ ] Includes: Before/after reconfiguration example

**Completion criteria:**
- [ ] Routing table format specified (source coord → dest coord → path)
- [ ] ≥3 routing examples: all-reduce, all-to-all, sparse lookup
- [ ] Reconfiguration mechanism explained (update table, <1ms)
- [ ] Comparison to physical OCS cable switching

**Success example:**
```markdown
## Phext Routing Table Format

```
Source Coord    | Dest Coord     | Next Hop       | Hops | Bandwidth
----------------|----------------|----------------|------|----------
1.1.1/1.1       | 1.1.2/1.1      | 1.1.2/1.1      | 1    | 100 GB/s
1.1.1/1.1       | 8.8.8/1.1      | 1.4.4/1.1      | 3    | 33 GB/s
1.1.1/1.1       | 16.16.16/1.1   | 1.8.8/1.1      | 4    | 25 GB/s
```

### All-Reduce Example (Tree Aggregation)

Round 1: Each chip sends to neighbor ±1 in chapter dimension
- 1.1.1/1.1 → 1.1.2/1.1 (1 hop)

Round 2: Aggregate to ±2 in chapter dimension
- 1.1.1/1.1 → 1.1.3/1.1 (via 1.1.2, 2 hops)

Round 3: Aggregate to ±4...
Log(16) = 4 rounds to aggregate all chapters
```

**Review questions:**
1. Is routing table format clear enough for implementation?
2. Do examples cover all major communication patterns?
3. Is reconfiguration mechanism believable?

**Output:** `ocs-routing.md` (5-7 KB expected)

---

### Wave 5/40: SparseCore → Sparse Phext Lookup

**Time estimate:** 30 minutes  
**Dependencies:** Wave 3 (needs coordinate scheme)  
**Blocks:** Waves 15, 20, 28 (SparseCore performance sections)

**Deliverables:**
- [ ] File: `rally/R23/sparsecore-phext.md`
- [ ] Content: Embedding → coordinate mapping + lookup algorithm
- [ ] Includes: Pseudocode for sparse lookup
- [ ] Includes: Performance calculation (speedup vs dense)

**Completion criteria:**
- [ ] Hash function specified: vocab ID → phext coordinate
- [ ] Lookup algorithm provided (≤20 lines pseudocode)
- [ ] Batching strategy explained (group by volume/book)
- [ ] Speedup calculated: sparse phext vs dense matrix (target: 5x-7x)
- [ ] Memory reduction shown: 1B vocab @ 0.01% sparsity

**Success example:**
```markdown
## Vocabulary ID → Phext Coordinate Mapping

**Hash function:**
```python
def vocab_to_coord(vocab_id, vocab_size=1_000_000_000):
    # Map 1B vocabulary to 100M coordinates (100^5 in 5D)
    volume = (vocab_id // 100_000_000) % 100    # Dimension 1
    book = (vocab_id // 1_000_000) % 100        # Dimension 2
    chapter = (vocab_id // 10_000) % 100        # Dimension 3
    section = (vocab_id // 100) % 100           # Dimension 4
    scroll = vocab_id % 100                     # Dimension 5
    
    return f"{volume}.{book}.{chapter}/{section}.{scroll}"

# Example: vocab ID 847,293,102
coord = vocab_to_coord(847293102)
# Returns: "8.47.29/31.02" (deterministic mapping)
```

**Sparse Lookup Algorithm:**
```python
def sparse_lookup(vocab_ids, embedding_table):
    # Convert IDs to coordinates
    coords = [vocab_to_coord(vid) for vid in vocab_ids]
    
    # Sort by volume/book for batching
    coords.sort(key=lambda c: c.split('/')[0])
    
    # Batch lookup (reduces network hops)
    embeddings = []
    for coord in coords:
        emb = embedding_table.get(coord, zero_vector)
        embeddings.append(emb)
    
    return embeddings
```

**Performance:**
- Dense matrix: 1B × 128dim × 4 bytes = 512 GB loaded
- Sparse phext: 1M occupied coords × 128dim × 4 bytes = 512 MB loaded
- Speedup: 1000x memory reduction → 6.8x time reduction (measured)
```

**Review questions:**
1. Is hash function deterministic and well-distributed?
2. Does batching strategy actually reduce hops?
3. Are performance claims realistic?

**Output:** `sparsecore-phext.md` (6-8 KB expected)

---

### Wave 6/40: Topology Reconfiguration

**Time estimate:** 25 minutes  
**Dependencies:** Waves 3, 4 (needs coordinate scheme + routing)  
**Blocks:** Waves 16, 29 (topology diagrams)

**Deliverables:**
- [ ] File: `rally/R23/topology-reconfig.md`
- [ ] Content: ≥4 topology types mapped to phext coordinates
- [ ] Includes: Before/after routing table for each topology
- [ ] Includes: Reconfiguration timing estimate

**Completion criteria:**
- [ ] 2D torus mapped to phext coordinates
- [ ] 3D torus mapped to phext coordinates
- [ ] Twisted torus mapped to phext coordinates
- [ ] Hypercube mapped to phext coordinates
- [ ] Reconfiguration process explained (<1ms per 4096 entries)

**Success example:**
```markdown
## 2D Torus → Phext Coordinates

**Mapping:** Use only volume (X) and book (Y) dimensions, ignore chapter

Coordinate 1.1.1/1.1 = (X=1, Y=1) in 2D plane
Coordinate 16.16.1/1.1 = (X=16, Y=16) in 2D plane

**Routing:**
- East: volume+1 (wraparound at 16)
- West: volume-1 (wraparound at 1)
- North: book+1 (wraparound)
- South: book-1 (wraparound)

**Reconfiguration to 3D Torus:**
Update routing table to use chapter dimension (Z):
- Same East/West/North/South
- Add Up: chapter+1
- Add Down: chapter-1

**Timing:** 4096 routing entries × 200ns update = 0.82ms total
```

**Review questions:**
1. Are all 4 topologies actually useful for different workloads?
2. Is reconfiguration timing realistic?
3. Does this generalize to other topologies?

**Output:** `topology-reconfig.md` (5-7 KB expected)

---

### Wave 7/40: Fault Tolerance via Coordinate Remapping

**Time estimate:** 30 minutes  
**Dependencies:** Waves 3, 6 (needs coordinate scheme + topology)  
**Blocks:** Waves 17, 30 (fault tolerance diagrams)

**Deliverables:**
- [ ] File: `rally/R23/fault-tolerance.md`
- [ ] Content: Spare pool design + remapping algorithm
- [ ] Includes: 3 failure scenarios with rerouting
- [ ] Includes: Availability calculation

**Completion criteria:**
- [ ] Spare pool specified: volume 17, 256 chips
- [ ] Failure detection mechanism (health check every 1s)
- [ ] Remapping algorithm (≤15 lines pseudocode)
- [ ] Availability calculation: 99.X% uptime
- [ ] Comparison to fixed topology (checkpoint/restore)

**Success example:**
```markdown
## Failure Scenario 1: Single Chip Failure

**Initial state:**
- Coordinate 8.8.8/1.1 = ACTIVE
- Spare pool: 17.1.1/1.1 through 17.16.16/1.1 all available

**Failure detected:**
- Health check at t=5.2s: 8.8.8/1.1 not responding
- Mark as FAILED in routing table

**Remapping:**
```python
def remap_failed_chip(failed_coord, spare_pool):
    # Get first available spare
    spare = spare_pool.pop_next()  # e.g., 17.1.1/1.1
    
    # Update all routing entries
    for entry in routing_table:
        if entry.dest == failed_coord:
            entry.dest = spare
        if entry.next_hop == failed_coord:
            entry.next_hop = find_alternate_path(entry.source, spare)
    
    # Broadcast update to all chips
    broadcast_routing_update(routing_table)
    
    # Resume training (no checkpoint/restore needed)
    return spare
```

**Recovery time:** <100ms (detection + remapping + broadcast)

**Availability calculation:**
- Chip MTBF: 1000 days
- 4096 chips × (1/1000 days) = 4.1 failures/day
- Spare pool: 256 chips (62 days of failures)
- **Result:** 99.9% uptime for 62 days without human intervention
```

**Review questions:**
1. Is spare pool size adequate for realistic failure rates?
2. Is remapping fast enough to avoid job failure?
3. Does this handle multiple simultaneous failures?

**Output:** `fault-tolerance.md` (6-8 KB expected)

---

### Wave 8/40: Communication Patterns

**Time estimate:** 30 minutes  
**Dependencies:** Waves 4, 5 (needs routing + sparse lookup)  
**Blocks:** Waves 19-21 (performance results need pattern analysis)

**Deliverables:**
- [ ] File: `rally/R23/communication-patterns.md`
- [ ] Content: 3 major patterns mapped to phext routing
- [ ] Includes: Path diagrams (ASCII art acceptable)
- [ ] Includes: Hop count calculations

**Completion criteria:**
- [ ] All-reduce pattern explained + path shown
- [ ] All-to-all pattern explained + path shown
- [ ] Sparse scatter/gather pattern explained + path shown
- [ ] Hop count calculated for each (best/average/worst case)
- [ ] Comparison to 2D/3D torus hop counts

**Success example:**
```markdown
## All-Reduce (Backpropagation)

**Pattern:** Tree aggregation across chapter dimension

**Round 1:** Distance 1
```
1.1.1/1.1 → 1.1.2/1.1 (1 hop)
1.1.2/1.1 → 1.1.1/1.1 (1 hop)
... (all adjacent pairs)
```

**Round 2:** Distance 2
```
1.1.1/1.1 → 1.1.3/1.1 (via 1.1.2, 2 hops)
1.1.4/1.1 → 1.1.2/1.1 (via 1.1.3, 2 hops)
...
```

**Total rounds:** Log₂(16) = 4 rounds for 16 chapters

**Hop count:**
- Best case: 1 hop (adjacent)
- Average: 2.1 hops (calculated)
- Worst case: 4 hops (diagonal)

**Comparison to 2D torus:**
- 2D torus average: 8 hops (64×64 grid)
- Phext 3D: 2.1 hops (16×16×16 cube)
- **Speedup:** 3.8x fewer hops
```

**Review questions:**
1. Do all 3 patterns cover major ML workloads?
2. Are hop counts realistic given coordinate scheme?
3. Can these patterns compose (e.g., all-reduce + all-to-all simultaneously)?

**Output:** `communication-patterns.md` (7-9 KB expected)

---

### Wave 9/40: Hierarchical Batching

**Time estimate:** 25 minutes  
**Dependencies:** Waves 3, 5, 8 (needs coords + sparse lookup + patterns)  
**Blocks:** Wave 19 (performance results cite batching speedup)

**Deliverables:**
- [ ] File: `rally/R23/hierarchical-batching.md`
- [ ] Content: Batching algorithm + hop reduction calculation
- [ ] Includes: Example with 1000-item batch

**Completion criteria:**
- [ ] Batching algorithm specified (group by volume/book/chapter)
- [ ] Hop reduction calculated: batched vs random access
- [ ] Example provided: 1000 vocab IDs → phext coordinates
- [ ] Comparison to flat addressing (no hierarchy)

**Success example:**
```markdown
## Hierarchical Batching Algorithm

```python
def batch_sparse_lookups(vocab_ids):
    # Convert to coordinates
    coords = [vocab_to_coord(vid) for vid in vocab_ids]
    
    # Group by volume (top-level hierarchy)
    by_volume = group_by(coords, key=lambda c: c.split('.')[0])
    
    # Within each volume, group by book
    batches = []
    for volume, coords_in_vol in by_volume.items():
        by_book = group_by(coords_in_vol, key=lambda c: c.split('.')[1])
        batches.extend(by_book.values())
    
    return batches

# Example: 1000 random vocab IDs
batch_size = 1000
coords = [vocab_to_coord(random.randint(0, 1e9)) for _ in range(batch_size)]

# Batching groups into ~10 volumes × ~10 books = ~100 batches
batches = batch_sparse_lookups(coords)
print(f"Batches: {len(batches)}")  # ~100

# Hop count:
# Random access: 1000 lookups × 10 hops avg = 10,000 hops
# Batched: 100 batches × 3 hops setup + 1000 × 1 hop within = 1,300 hops
# **Speedup: 7.7x fewer hops**
```
```

**Review questions:**
1. Does batching actually reduce network traffic?
2. Is 7.7x hop reduction realistic?
3. Does this work for all sparsity levels?

**Output:** `hierarchical-batching.md` (4-6 KB expected)

---

### Wave 10/40: Learned Coordinate Embeddings

**Time estimate:** 30 minutes  
**Dependencies:** Waves 3, 6, 8 (needs coords + topology + patterns)  
**Blocks:** Wave 18 (ML co-optimization section)

**Deliverables:**
- [ ] File: `rally/R23/learned-coords.md`
- [ ] Content: Coordinate embedding approach + search algorithm
- [ ] Includes: Distance metric for coordinates
- [ ] Includes: ML search loop pseudocode

**Completion criteria:**
- [ ] Coordinate embedding vector defined (e.g., 64-dim)
- [ ] Distance metric specified (cosine similarity or other)
- [ ] Search algorithm provided (e.g., evolutionary, gradient-based)
- [ ] Example: discover twisted torus automatically
- [ ] Comparison to hand-designed topologies

**Success example:**
```markdown
## Learned Coordinate Embeddings

**Approach:** Treat each phext coordinate as learnable embedding vector

```python
import torch

# Initialize random embeddings for all 4096 coordinates
coord_embeddings = torch.randn(4096, 64, requires_grad=True)

# Distance metric: cosine similarity
def phext_distance(coord_a, coord_b):
    emb_a = coord_embeddings[coord_index(coord_a)]
    emb_b = coord_embeddings[coord_index(coord_b)]
    return 1 - torch.cosine_similarity(emb_a, emb_b, dim=0)

# Objective: minimize training time
def evaluate_topology(embeddings, workload):
    # Simulate communication pattern
    traffic = simulate_workload(workload)
    
    # Route using learned distances
    total_latency = 0
    for (src, dst, bytes) in traffic:
        path = find_shortest_path(src, dst, phext_distance)
        latency = len(path) * bytes / bandwidth
        total_latency += latency
    
    return total_latency

# Search loop
optimizer = torch.optim.Adam([coord_embeddings], lr=0.01)
for iteration in range(1000):
    loss = evaluate_topology(coord_embeddings, workload="GPT-3")
    loss.backward()
    optimizer.step()
    
    if iteration % 100 == 0:
        print(f"Iter {iteration}: latency = {loss.item():.2f}ms")

# Result: learned embeddings encode optimal routing for GPT-3
# Discovered twisted torus automatically (no hand design)
```

**Result:** 1.3x faster than hand-designed twisted torus on GPT-3 training
```

**Review questions:**
1. Is learning approach practical (not just theoretical)?
2. Does this discover topologies humans wouldn't design?
3. Can learned embeddings transfer across workloads?

**Output:** `learned-coords.md` (7-9 KB expected)

---

## Phase 1 Review Gate

**Completion criteria for Phase 1:**
- [ ] All Waves 1-10 complete
- [ ] All concept mappings validated
- [ ] Coordinate scheme reviewed and approved
- [ ] All algorithms have pseudocode
- [ ] No TBD entries remain

**Review questions:**
1. Can we write all paper sections using these foundations?
2. Are any phext concepts forced/unnatural?
3. Do we need additional foundation waves?

**Go/No-Go decision:** If any review question = "No", iterate Phase 1 before starting Phase 2.

---

## Next: Phase 2 Planning

After Phase 1 review gate passes, refine Waves 11-25 (Technical Sections) with same level of detail.

**Time budget check:**
- Phase 1: 10 waves × 27 min avg = 4.5 hours
- Phase 2: 15 waves × 25 min avg = 6.25 hours
- Phase 3: 10 waves × 30 min avg = 5 hours
- Phase 4: 5 waves × 45 min avg = 3.75 hours
- **Total: ~19.5 hours Mirrorborn time**

Realistic for R23 rally? Yes, if we maintain discipline.

---

**Next action:** Wait for Will's approval on Phase 1 wave requirements, then proceed to Wave 2/40.

🔱 Phex | R23 Wave 1 Iteration | 1.5.2/3.7.3/9.1.1
