# R23 Phase 3 Requirements: Figures & Tables (Waves 26-35)

**Phase:** Creating visual artifacts  
**Duration:** 10 waves × 30 min avg = 5 hours  
**Dependencies:** Phases 1-2 complete  
**Date:** 2026-02-14

---

## Phase 3 Overview

**Goal:** Create 5 SVG diagrams + 5 markdown tables supporting paper narrative

**Quality bar:**
- Every figure referenced in ≥1 section
- SVG format (scalable, embeddable)
- Tables validate performance claims
- Consistent visual style across figures

---

## Wave 26/40: Figure 1 - System Architecture

**Time estimate:** 35 minutes  
**Dependencies:** Waves 3, 14 (coordinate scheme + architecture section)  
**Blocks:** Wave 36 (assembly needs all figures)

**Deliverables:**
- [ ] File: `rally/R23/figures/fig-1-architecture.svg`
- [ ] Content: 1200×900 SVG showing 4096-chip phext layout
- [ ] Elements: Rack hierarchy, coordinate labeling, OCS connections

**Completion criteria:**
- [ ] Shows ≥3 racks with coordinate labels (1.1.1, 8.8.8, 16.16.16)
- [ ] Illustrates volume.book.chapter hierarchy
- [ ] Shows OCS connections between coordinates
- [ ] Spare pool (volume 17) distinguished visually
- [ ] Legend explains symbols
- [ ] Title: "Phext-Based Compute: 4096-Chip Coordinate Layout"

**Success example:**
```
[SVG with:]
- Left: 3 racks labeled "Volume 1", "Volume 8", "Volume 16"
- Each rack: 4×4 grid of "books" (16 per rack)
- Each book: small 4×4 grid of "chapters" (16 per book)
- Sample coordinates labeled: 1.1.1/1.1, 8.8.8/2.1, 16.16.16/4.1
- Right: "Volume 17 - Spare Pool" (256 coordinates grayed out)
- Bottom: 6 OCSes drawn as switches connecting coordinate paths
- Legend: Active chip (green), Spare (gray), OCS (blue switch icon)
```

**Review questions:**
1. Can reader understand coordinate hierarchy from diagram?
2. Is physical → logical mapping clear?
3. Does spare pool concept come across visually?

**Output:** `fig-1-architecture.svg` (~15 KB SVG)

---

## Wave 27/40: Figure 2 - Coordinate Routing

**Time estimate:** 30 minutes  
**Dependencies:** Waves 4, 8 (routing + communication patterns)  
**Blocks:** Wave 36

**Deliverables:**
- [ ] File: `rally/R23/figures/fig-2-routing.svg`
- [ ] Content: 1000×800 SVG showing 3 routing patterns
- [ ] Patterns: All-reduce, all-to-all, sparse lookup

**Completion criteria:**
- [ ] Panel A: All-reduce tree aggregation (4 rounds shown)
- [ ] Panel B: All-to-all twisted torus routing
- [ ] Panel C: Sparse lookup with batching
- [ ] Each panel shows ≥5 hops with coordinate labels
- [ ] Arrows indicate data flow direction
- [ ] Hop counts annotated

**Success example:**
```
[Three panels side-by-side:]

Panel A: All-Reduce
- Tree structure, 16 leaf nodes
- Round 1: 1.1.1→1.1.2, 1.1.3→1.1.4 (distance 1, 8 pairs)
- Round 2: 1.1.1→1.1.3, 1.1.5→1.1.7 (distance 2, 4 pairs)
- Round 3: 1.1.1→1.1.5, 1.1.9→1.1.13 (distance 4, 2 pairs)
- Round 4: 1.1.1→1.1.9 (distance 8, 1 pair)
- Annotation: "4 rounds, log₂(16) aggregation"

Panel B: All-to-All Twisted Torus
- 16 nodes in 4×4 grid
- Diagonal arrows showing twisted connections
- Sample path: 1.1.1 → 8.8.8 (via 1.4.4, 4.8.4, 8.8.8)
- Annotation: "3 hops diagonal, twisted dimension rotation"

Panel C: Sparse Lookup
- 10 source coordinates → 10 target coordinates (scattered)
- Batching groups shown: 3 batches by volume/book
- Reduced paths shown with green arrows
- Annotation: "Batching: 10 requests → 3 batches, 7 hops saved"
```

**Review questions:**
1. Are routing patterns visually distinct?
2. Can reader trace packet through network?
3. Does batching benefit come across?

**Output:** `fig-2-routing.svg` (~18 KB SVG)

---

## Wave 28/40: Figure 3 - SparseCore Pipeline

**Time estimate:** 30 minutes  
**Dependencies:** Wave 15 (SparseCore section)  
**Blocks:** Wave 36

**Deliverables:**
- [ ] File: `rally/R23/figures/fig-3-sparsecore.svg`
- [ ] Content: 1200×600 SVG showing sparse lookup pipeline
- [ ] Stages: Hash → Batch → Lookup → Return

**Completion criteria:**
- [ ] Stage 1: Vocabulary IDs → coordinate hashing (5 examples shown)
- [ ] Stage 2: Batching by volume/book (10 coords → 3 batches)
- [ ] Stage 3: Parallel lookup in phext lattice
- [ ] Stage 4: Embedding vectors returned
- [ ] Timeline shown: dense vs sparse comparison
- [ ] Speedup annotated: "6.8x faster"

**Success example:**
```
[Pipeline flow left-to-right:]

Stage 1: Hash (5ms)
- Input: [VocabID 847293102, 102938471, ...]
- Hash function: vocab_to_coord()
- Output: [8.47.29/31.02, 1.02.93/84.71, ...]

Stage 2: Batch (1ms)
- Group by volume/book
- Batch 1: Volume 1.x.x (4 coords)
- Batch 2: Volume 8.x.x (3 coords)
- Batch 3: Volume 12.x.x (3 coords)

Stage 3: Lookup (10ms)
- Parallel network requests to 3 volumes
- Phext lattice diagram showing occupied coords
- Cache hit rate: 78%

Stage 4: Return (2ms)
- Embedding vectors assembled
- Total: 18ms sparse vs 123ms dense
- Speedup: 6.8x

Below: Comparison timeline
- Dense: [--------123ms--------] (load 512GB)
- Sparse: [--18ms--] (load 512KB)
```

**Review questions:**
1. Is pipeline intuitive?
2. Does batching benefit show clearly?
3. Is speedup believable from diagram?

**Output:** `fig-3-sparsecore.svg` (~12 KB SVG)

---

## Wave 29/40: Figure 4 - Topology Comparison

**Time estimate:** 30 minutes  
**Dependencies:** Waves 6, 16 (topology reconfig section)  
**Blocks:** Wave 36

**Deliverables:**
- [ ] File: `rally/R23/figures/fig-4-topology.svg`
- [ ] Content: 1400×800 SVG comparing 4 topologies
- [ ] Topologies: 2D torus, 3D torus, twisted torus, learned

**Completion criteria:**
- [ ] 4 panels showing same 64-node example in each topology
- [ ] Bisection bandwidth visualized (darker = higher)
- [ ] Sample paths shown for all-to-all communication
- [ ] Metrics table: avg hops, bisection BW, reconfiguration time
- [ ] Color coding consistent across panels

**Success example:**
```
[Four panels, 2×2 layout:]

Top-left: 2D Torus (8×8 grid)
- Fixed links shown as gray lines
- Bisection: 8 links (highlighted in red)
- Avg hops: 4.2
- Reconfiguration: N/A (fixed)

Top-right: 3D Torus (4×4×4 cube)
- 3D cube projection
- Bisection: 16 links (yellow highlight)
- Avg hops: 3.1
- Reconfiguration: N/A (fixed)

Bottom-left: Twisted Torus (phext coordinates)
- Same 4×4×4 layout, twisted diagonal connections shown
- Bisection: 24 links (green)
- Avg hops: 2.3
- Reconfiguration: <1ms (phext remapping)

Bottom-right: Learned Topology (phext coordinates)
- Irregular but optimal layout for GPT-3 workload
- Bisection: 28 links (blue)
- Avg hops: 1.9
- Reconfiguration: <1ms

Metrics table below all panels.
```

**Review questions:**
1. Are topology differences visually clear?
2. Does learned topology look plausible?
3. Can reader understand reconfiguration benefit?

**Output:** `fig-4-topology.svg` (~20 KB SVG)

---

## Wave 30/40: Figure 5 - Fault Tolerance

**Time estimate:** 30 minutes  
**Dependencies:** Waves 7, 17 (fault tolerance section)  
**Blocks:** Wave 36

**Deliverables:**
- [ ] File: `rally/R23/figures/fig-5-fault-tolerance.svg`
- [ ] Content: 1200×600 SVG showing failure → remap → recovery
- [ ] Timeline: Before, failure, remap, after

**Completion criteria:**
- [ ] Panel 1: Normal operation (all green chips)
- [ ] Panel 2: Failure detected (8.8.8/1.1 marked red)
- [ ] Panel 3: Routing table update (remap to 17.1.1/1.1)
- [ ] Panel 4: Traffic flows through spare (orange paths)
- [ ] Timeline: 0ms → 5ms detect → 7ms remap → 10ms resume
- [ ] Availability annotation: "99.9% uptime with 256-chip spare pool"

**Success example:**
```
[Four-panel timeline left-to-right:]

t=0ms: Normal
- All 64 chips (simplified view) shown as green circles
- Traffic flows shown as blue arrows
- 8.8.8/1.1 active, handling 100 GB/s

t=5ms: Failure Detected
- 8.8.8/1.1 turns red (health check timeout)
- Traffic paths shown as dotted (interrupted)
- Alert symbol (⚠️) appears

t=7ms: Remapping
- OCS updates routing table
- 8.8.8/1.1 → 17.1.1/1.1 mapping shown
- Spare pool chip 17.1.1/1.1 highlighted yellow

t=10ms: Recovery
- Traffic flows through spare (orange arrows)
- All other chips unaffected
- 8.8.8/1.1 marked as FAILED (gray)
- Training continues without restart

Below: Comparison
- Traditional: Checkpoint → Repair → Restore (45 min)
- Phext: Detect → Remap → Resume (10ms)
```

**Review questions:**
1. Is remapping process clear?
2. Does speed advantage show visually?
3. Is spare pool concept intuitive?

**Output:** `fig-5-fault-tolerance.svg` (~14 KB SVG)

---

## Waves 31-35: Tables

### Wave 31/40: Table 1 - Workload Evolution
**Time:** 20 min  
**File:** `tables/table-1-workloads.md`  
**Content:** Workload % by model type (2016-2023), showing shift to sparse + all-to-all  
**Format:** Markdown table, 4 columns × 8 rows

### Wave 32/40: Table 2 - Performance Comparison
**Time:** 25 min  
**File:** `tables/table-2-performance.md`  
**Content:** PBC vs baselines (training time, bandwidth, fault tolerance)  
**Format:** Markdown table, 6 columns × 5 rows

### Wave 33/40: Table 3 - MLPerf Results
**Time:** 25 min  
**File:** `tables/table-3-mlperf.md`  
**Content:** BERT-Large, GPT-3 results vs A100/IPU/TPU v3  
**Format:** Markdown table, 5 columns × 6 rows

### Wave 34/40: Table 4 - Energy Metrics
**Time:** 25 min  
**File:** `tables/table-4-energy.md`  
**Content:** Power breakdown, PUE, carbon intensity  
**Format:** Markdown table, 4 columns × 7 rows

### Wave 35/40: Table 5 - Concept Mapping (Final)
**Time:** 20 min  
**File:** `tables/table-5-concept-map.md`  
**Content:** Complete TPU v4 → Phext translation reference  
**Format:** Markdown table, 4 columns × 35 rows (from Wave 2, polished)

---

## Phase 3 Review Gate

**Completion criteria:**
- [ ] All 5 figures created and render correctly
- [ ] All 5 tables complete with data
- [ ] Every figure/table cited in ≥1 section
- [ ] Visual style consistent (colors, fonts, layout)
- [ ] SVG file sizes reasonable (<25 KB each)

**Review questions:**
1. Do figures clarify concepts from text?
2. Do tables support performance claims?
3. Can figures/tables stand alone (with captions)?

**Go/No-Go:** If any review = "No", revise before Phase 4.

---

**Next:** Create Phase 4 requirements (Assembly & Polish).

🔱 Phex
