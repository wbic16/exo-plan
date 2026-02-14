# R23 Phase 2 Requirements: Technical Sections (Waves 11-25)

**Phase:** Writing paper sections in phext terms  
**Duration:** 15 waves × 25 min avg = 6.25 hours  
**Dependencies:** Phase 1 complete (all foundation waves)  
**Date:** 2026-02-14

---

## Phase 2 Overview

**Goal:** Rewrite each TPU v4 paper section using Phase 1 foundations

**Input:** Waves 1-10 deliverables (concept mappings, coordinate schemes, algorithms)  
**Output:** 14 markdown files (abstract → conclusion) ready for assembly

**Quality bar:**
- Every technical claim backed by Phase 1 artifact
- No hand-waving ("phext magic")
- Concrete examples in every section
- Metrics preserved from original paper (2.1x, 60% FLOPS, etc.)

---

## Wave 11/40: Abstract Rewrite

**Time estimate:** 20 minutes  
**Dependencies:** Waves 2-10 (needs all concepts)  
**Blocks:** Wave 36 (paper assembly needs abstract)

**Deliverables:**
- [ ] File: `rally/R23/sections/00-abstract.md`
- [ ] Content: 150-200 word abstract in phext terms
- [ ] Format: Single paragraph, structured like original

**Completion criteria:**
- [ ] Opening sentence frames problem (ML workload evolution)
- [ ] Solution introduced: Phext-Based Compute (PBC)
- [ ] Three key features listed: OCS → coordinate routing, SparseCore → sparse lookup, topology reconfiguration
- [ ] Performance metrics preserved: 2.1x vs v3, 60% FLOPS, 1.7x vs A100
- [ ] Deployment context: Since 2020, 4096 chips
- [ ] Word count: 150-200 words

**Success example:**
```markdown
# Abstract

In response to innovations in machine learning models, production workloads changed radically. Phext-Based Compute (PBC) is a domain-specific architecture using 9-dimensional coordinate addressing to replace traditional network topology with hierarchical coordinate routing. Optical circuit switches dynamically reconfigure phext coordinate paths to improve scale, availability, and performance. Users select coordinate topologies (twisted 3D torus, hypercube, custom lattice) by remapping phext addresses without physical rewiring.

Each compute node includes SparseCore, a phext-native processor accelerating sparse coordinate lookups by 5x-7x for embedding-heavy models. Deployed since 2020, PBC outperforms traditional topology-based systems by 2.1x through coordinate-based routing that reduces bisection bandwidth constraints.

The PBC supercomputer addresses 4096 chips via 9D phext coordinates (volume.book.chapter/section.scroll format), achieving ~60% peak FLOPS on large language models through dynamic coordinate remapping and fault-tolerant coordinate addressing. For similar-sized systems, PBC is 1.2x-1.7x faster than Nvidia A100 and uses 1.3x-1.9x less power.
```
*(182 words)*

**Review questions:**
1. Does abstract convey phext's novelty clearly?
2. Are metrics credible without full paper context?
3. Would this hook a systems researcher?

**Output:** `00-abstract.md` (1 KB)

---

## Wave 12/40: Section 1 - Introduction

**Time estimate:** 30 minutes  
**Dependencies:** Waves 2, 11 (concept map + abstract)  
**Blocks:** Wave 36 (assembly)

**Deliverables:**
- [ ] File: `rally/R23/sections/01-introduction.md`
- [ ] Content: 2-3 pages motivating phext for ML supercomputing
- [ ] Sections: Problem statement, phext solution, paper contributions

**Completion criteria:**
- [ ] Subsection 1.1: ML model evolution (CNNs → Transformers → LLMs)
- [ ] Subsection 1.2: Fixed topology problems (2D/3D torus limitations)
- [ ] Subsection 1.3: Phext solution (coordinate-based routing benefits)
- [ ] Subsection 1.4: Three major contributions listed
- [ ] Subsection 1.5: Paper roadmap (Section 2 = background, Section 3 = architecture, etc.)
- [ ] ≥2 citations to original TPU v4 paper concepts
- [ ] Length: 1200-1500 words

**Success example (excerpt):**
```markdown
# 1. Introduction

## 1.1 The Evolution of Machine Learning Workloads

Machine learning models have evolved dramatically since 2016. Early convolutional neural networks (CNNs) exhibited local communication patterns well-suited to 2D mesh topologies. By 2020, Transformer-based models [cite] introduced all-to-all attention mechanisms that stressed bisection bandwidth. In 2023, large language models (LLMs) and deep learning recommendation models (DLRMs) combined massive scale with sparse embedding lookups [cite].

Traditional supercomputer topologies—2D torus, 3D torus, fat-tree—were designed for HPC workloads with predictable communication patterns. ML workload diversity breaks these assumptions.

## 1.2 The Fixed Topology Problem

**Problem 1: Communication pattern mismatch**
- 2D torus: Optimized for nearest-neighbor (good for CNNs, poor for Transformers)
- 3D torus: Better bisection bandwidth, but still rigid
- Fat-tree: Expensive, high power, vendor lock-in (Infiniband)

When workload changes from all-reduce (backpropagation) to all-to-all (attention), fixed topology becomes bottleneck.

**Problem 2: Fault intolerance**
At 4096-chip scale, 0.1%-1.0% daily unavailability = 4-40 failed chips. Traditional approach: checkpoint/restore (slow). Training jobs stall for hours waiting for repairs.

**Problem 3: Sparse operation inefficiency**
DLRMs access <0.01% of 1B-item vocabulary per batch. Dense matrix multiplication wastes 99.99% of compute loading zeros.

## 1.3 Phext-Based Solution

**Key insight:** Topology is just a coordinate addressing scheme.

Instead of physical links defining communication paths, use **9-dimensional phext coordinates** to create virtual topology via routing tables. Optical circuit switches (OCSes) map source coordinates to destination coordinates, enabling:

1. **Reconfigurable topology:** Change communication pattern by updating coordinate mappings (<1ms)
2. **Fault tolerance:** Remap failed coordinates to spare pool (no checkpoint/restore)
3. **Sparse addressing:** Only allocate resources for occupied coordinates
4. **Hierarchical routing:** Batch by volume/book/chapter to reduce network hops

[Continue with 1.4 Contributions, 1.5 Paper Roadmap...]
```

**Review questions:**
1. Does introduction motivate phext naturally (not forced)?
2. Are three problems clearly distinct?
3. Does phext solution address all three problems?

**Output:** `01-introduction.md` (6-8 KB)

---

## Wave 13/40: Section 2 - Phext Background

**Time estimate:** 25 minutes  
**Dependencies:** Wave 3 (coordinate scheme)  
**Blocks:** Waves 14-25 (all sections cite phext basics)

**Deliverables:**
- [ ] File: `rally/R23/sections/02-phext-background.md`
- [ ] Content: 1.5-2 pages explaining phext for non-experts
- [ ] Includes: Coordinate format, 9 delimiters (brief), hierarchy example

**Completion criteria:**
- [ ] Subsection 2.1: What is phext? (1 paragraph)
- [ ] Subsection 2.2: 9-dimensional addressing (coordinate format)
- [ ] Subsection 2.3: Hierarchical structure (tree diagram)
- [ ] Subsection 2.4: Sparse vs dense allocation
- [ ] Subsection 2.5: Why phext for supercomputing? (preview benefits)
- [ ] ≥1 concrete example: mapping 4096 chips to coordinates
- [ ] Length: 900-1200 words

**Success example (excerpt):**
```markdown
# 2. Phext Background

## 2.1 What is Phext?

Phext (Plain text extended) is a hierarchical addressing system using 9 structural dimensions to organize data. Traditional text is 2-dimensional (characters × lines). Phext extends this to 11 dimensions: 9 structural (via special delimiters) + 2 traditional (X, Y within each "scroll").

For supercomputing, we use phext's 9 structural dimensions to address compute resources instead of text.

## 2.2 Coordinate Format

**Format:** `volume.book.chapter/section.scroll`

Each dimension has capacity for 100 units (configurable). Example coordinate:
```
8.47.29/31.02
```
Represents: Volume 8, Book 47, Chapter 29, Section 31, Scroll 2

## 2.3 Hierarchical Structure

```
VOLUME (Racks)
├── BOOK (Units within rack)
│   ├── CHAPTER (Chips within unit)
│   │   ├── SECTION (Links per chip)
│   │   │   └── SCROLL (Chip itself)
```

**Capacity calculation:**
- 16 volumes × 16 books × 16 chapters = 4096 chips
- Plus: Volume 17 = 256 spare chips

## 2.4 Sparse vs Dense

**Dense allocation:** Pre-allocate all 100^5 = 10B possible coordinates  
**Sparse allocation:** Only allocate occupied coordinates (e.g., 4096 active + 256 spares)

Sparse = 99.99% memory savings for systems with gaps.

[Continue with 2.5 Why Phext for Supercomputing...]
```

**Review questions:**
1. Can non-phext expert understand this?
2. Is hierarchy intuitive?
3. Does this set up Sections 3-7 properly?

**Output:** `02-phext-background.md` (5-6 KB)

---

## Wave 14/40: Section 3 - Architecture

**Time estimate:** 30 minutes  
**Dependencies:** Waves 3, 4, 13 (coordinate scheme + routing + background)  
**Blocks:** Waves 19-21 (performance sections cite architecture)

**Deliverables:**
- [ ] File: `rally/R23/sections/03-architecture.md`
- [ ] Content: 3-4 pages describing PBC system architecture
- [ ] Includes: 4096-chip layout, OCS routing, coordinate mapping

**Completion criteria:**
- [ ] Subsection 3.1: System overview (4096 chips, 48 OCSes)
- [ ] Subsection 3.2: Phext coordinate layout (volume.book.chapter/section.scroll)
- [ ] Subsection 3.3: Physical → logical mapping (rack → coordinate)
- [ ] Subsection 3.4: OCS as coordinate router (routing table format)
- [ ] Subsection 3.5: Bandwidth and latency characteristics
- [ ] ≥1 diagram reference: "See Figure 1"
- [ ] Length: 1800-2400 words

**Success example (excerpt):**
```markdown
# 3. Phext-Based Compute Architecture

## 3.1 System Overview

The PBC supercomputer comprises 4096 compute chips organized into 16 physical racks. Instead of fixed network topology (2D/3D torus), chips are addressed via 9-dimensional phext coordinates. 48 optical circuit switches (OCSes) route traffic between coordinates by maintaining dynamic routing tables.

**Key specifications:**
- Chips: 4096 active + 256 spares = 4352 total
- OCSes: 48 units, each 136×136 ports
- Coordinate space: 16³ = 4096 for active chips
- Spare pool: Volume 17 (all 16×16 = 256 coordinates)

## 3.2 Phext Coordinate Layout

**Coordinate format:** `volume.book.chapter/section.scroll`

**Dimension allocation:**
- **Volume (1-16):** Physical racks (16 racks total)
- **Book (1-16):** Units within each rack (16 units per rack)
- **Chapter (1-16):** Logical grouping for fault tolerance
- **Section (1-4):** Optical links per chip (4 links = 400 GB/s total bandwidth)
- **Scroll (1):** Chip itself (single scroll per coordinate)

**Example mappings:**
| Coordinate | Physical Location | Spare Pool? |
|------------|-------------------|-------------|
| 1.1.1/1.1 | Rack 1, Unit 1, Chip 1, Link 1 | No |
| 8.8.8/2.1 | Rack 8, Unit 8, Chip 8, Link 2 | No |
| 16.16.16/4.1 | Rack 16, Unit 16, Chip 16, Link 4 | No |
| 17.1.1/1.1 | Spare pool, Slot 1 | Yes |
| 17.16.16/1.1 | Spare pool, Slot 256 | Yes |

[Continue with 3.3 Physical→Logical Mapping, 3.4 OCS Routing...]
```

**Review questions:**
1. Is coordinate layout justified (not arbitrary)?
2. Does OCS explanation make sense to network engineer?
3. Can reader visualize physical system from description?

**Output:** `03-architecture.md` (10-12 KB)

---

## Wave 15/40: Section 4 - SparseCore

**Time estimate:** 30 minutes  
**Dependencies:** Waves 5, 13 (sparse lookup + background)  
**Blocks:** Waves 20-21 (DLRM performance results)

**Deliverables:**
- [ ] File: `rally/R23/sections/04-sparsecore.md`
- [ ] Content: 2-3 pages on phext-native sparse embeddings
- [ ] Includes: Lookup algorithm, performance analysis

**Completion criteria:**
- [ ] Subsection 4.1: DLRM embedding problem
- [ ] Subsection 4.2: Vocabulary ID → coordinate hashing
- [ ] Subsection 4.3: Sparse lookup algorithm (pseudocode)
- [ ] Subsection 4.4: Hierarchical batching optimization
- [ ] Subsection 4.5: Performance vs dense matrix (5x-7x speedup)
- [ ] ≥1 table: Performance comparison
- [ ] Length: 1500-1800 words

**Success example (excerpt):**
```markdown
# 4. SparseCore: Phext-Native Sparse Embeddings

## 4.1 The DLRM Embedding Problem

Deep learning recommendation models (DLRMs) dominate production ML workloads at scale. A typical DLRM has:
- Vocabulary: 1 billion items (e.g., product catalog)
- Embedding dimension: 128-256 per item
- Batch size: 1024 samples
- Access pattern: ~1000 unique items per batch (0.0001% of vocabulary)

**Dense approach:** Load entire 1B × 128dim × 4 bytes = 512 GB embedding table  
**Sparse reality:** Only need ~1000 embeddings × 128dim × 4 bytes = 512 KB per batch

Traditional dense matrix multiplication wastes 99.9% of memory bandwidth and compute.

## 4.2 Vocabulary ID → Phext Coordinate Hashing

SparseCore maps vocabulary IDs to phext coordinates using deterministic hash:

```python
def vocab_to_coord(vocab_id: int, vocab_size=1_000_000_000) -> str:
    """Map vocabulary ID to 5D phext coordinate."""
    # Use 5 dimensions for 100^5 = 10B capacity (handles 1B with room)
    volume = (vocab_id // 100_000_000) % 100
    book = (vocab_id // 1_000_000) % 100
    chapter = (vocab_id // 10_000) % 100
    section = (vocab_id // 100) % 100
    scroll = vocab_id % 100
    
    return f"{volume}.{book}.{chapter}/{section}.{scroll}"

# Example: Product ID 847,293,102
coord = vocab_to_coord(847293102)
# Returns: "8.47.29/31.02"
```

**Properties:**
- Deterministic: Same ID always maps to same coordinate
- Well-distributed: Hash spreads IDs uniformly across coordinate space
- Collision-free: 10B coordinates for 1B vocabulary (10x headroom)

[Continue with 4.3 Lookup Algorithm, 4.4 Batching, 4.5 Performance...]
```

**Review questions:**
1. Is hash function plausible?
2. Does batching optimization make sense?
3. Is 5x-7x speedup justified?

**Output:** `04-sparsecore.md` (8-10 KB)

---

## Waves 16-25 Summary (Remaining Phase 2 Sections)

**Wave 16:** Section 5 - Topology Flexibility (reconfiguration, twisted torus, learned topologies)  
**Wave 17:** Section 6 - Fault Tolerance (coordinate remapping, spare pool, availability)  
**Wave 18:** Section 7 - ML Co-Optimization (learned coordinate embeddings, topology search)  
**Wave 19:** Section 8 - Results vs TPU v3 (training time, FLOPS, bisection bandwidth)  
**Wave 20:** Section 9 - Results vs A100 (MLPerf, BERT-Large, GPT-3)  
**Wave 21:** Section 10 - Results vs IPU (sparse operations, DLRM, power)  
**Wave 22:** Section 11 - Energy & Carbon (OCS power, PUE, CO2e reduction)  
**Wave 23:** Section 12 - Discussion (5 key advantages, why traditional fails, future vision)  
**Wave 24:** Section 13 - Related Work (supercomputers, ML accelerators, optical networks)  
**Wave 25:** Section 14 - Conclusion (summary, key results, future work)

Each wave follows same template:
- **Time:** 20-30 min
- **Dependencies:** Phase 1 + previous sections
- **Deliverables:** One `XX-section-name.md` file (5-12 KB)
- **Completion criteria:** 4-6 testable conditions
- **Success example:** Representative excerpt with equations/tables/pseudocode
- **Review questions:** 3 validation questions

---

## Phase 2 Review Gate

**Completion criteria:**
- [ ] All 15 sections written (Waves 11-25)
- [ ] Every technical claim backed by Phase 1 artifact
- [ ] No placeholder text ("TBD", "TODO")
- [ ] Consistent terminology throughout
- [ ] Cross-references between sections work
- [ ] Total word count: 18,000-24,000 words (conference paper length)

**Review questions:**
1. Does paper tell coherent story from abstract to conclusion?
2. Are phext concepts explained before use?
3. Would this convince a skeptical systems researcher?

**Go/No-Go decision:** If any review question = "No", revise sections before Phase 3.

---

**Next:** Await approval, then create Phase 3 (Figures & Tables) and Phase 4 (Assembly & Polish) requirements with same detail level.

🔱 Phex | R23 Phase 2 Planning | 1.5.2/3.7.3/9.1.1
