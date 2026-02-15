# R23 Waves 2-10: Foundation Phase (Detailed Plan)

**Phase:** Foundation & Research  
**Duration:** 5 hours (single) / 3 hours (parallel)  
**Critical path:** Must complete before Wave 11 (writing starts)

---

## Wave 2/40: Original Paper Analysis

**Estimated time:** 45 minutes  
**Input:** `/tmp/tpu-v4-paper.pdf` (2.9 MB, 15 pages)  
**Output:** `/source/exo-plan/rally/R23/analysis-tpu-v4-original.md`

### Execution Steps

1. **Skim first (5 min):**
   - Read abstract
   - Scan section headers
   - Note figure captions
   - Identify paper structure

2. **Deep read sections (30 min):**
   - Introduction (why TPU v4?)
   - OCS section (optical switches)
   - SparseCores section (embedding acceleration)
   - Performance results (numbers we need)
   - Related work (what they cite)

3. **Extract claims (10 min):**
   - Performance: 2.1x vs TPU v3, 2.7x perf/watt
   - Cost: OCS <5% system cost, <3% power
   - Scale: 4096 chips, ~10x speedup
   - SparseCores: 5-7x speedup, 5% die area

### Template Output

```markdown
# TPU v4 Paper Analysis

## Key Performance Claims

| Metric | Value | Page | Confidence |
|--------|-------|------|------------|
| Perf vs TPU v3 | 2.1x | p.X | High (measured) |
| Perf/Watt | 2.7x | p.X | High (measured) |
| OCS cost | <5% system | p.X | Stated by authors |
| ... | ... | ... | ... |

## Technical Architecture

### Optical Circuit Switches (OCS)
- Purpose: Dynamic topology reconfiguration
- Cost: <5% system cost
- Power: <3% system power
- Latency: ~1 second circuit setup
- Benefit: Flexible routing for diverse workloads

### SparseCores
- Purpose: Embedding table acceleration
- Speedup: 5-7x for embedding-heavy models
- Area: 5% of die
- Power: 5% of chip
- Target: Large language models (BERT, GPT)

## Figures to Recreate

1. Figure X: OCS topology diagram (3D torus)
2. Figure Y: SparseCores dataflow architecture
3. Figure Z: Performance comparison chart
...

## Technical Terms Needing Phext Mapping

- Optical Circuit Switch (OCS) → Coordinate routing
- SparseCores → Coordinates as embeddings
- 3D torus topology → 9D coordinate space
- Embedding table → Scroll storage
- Dynamic reconfiguration → Coordinate algebra
...

## Gaps in Our Story

- [ ] We don't have measured performance for phext routing
- [ ] We need to prove O(1) lookup in practice
- [ ] We haven't demonstrated LLM token embeddings in phext
- [ ] We lack multi-node mesh performance data
```

### Acceptance Criteria

- [ ] All 15 pages read and summarized
- [ ] At least 10 quantitative claims extracted (with page numbers)
- [ ] At least 20 technical terms identified for mapping
- [ ] All figures cataloged (with captions)
- [ ] At least 3 gaps in phext story identified
- [ ] Template filled completely
- [ ] Time: ≤60 min

### Risk Mitigation

**Risk:** Paper is too dense, can't finish in 45 min  
**Mitigation:** Focus on Intro, OCS, SparseCores sections only. Skip related work for now.

**Risk:** Missing key technical details  
**Mitigation:** Flag unclear sections for re-read after Wave 3 mapping

---

## Wave 3/40: Section Mapping

**Estimated time:** 30 minutes  
**Input:** Wave 2 analysis  
**Output:** `/source/exo-plan/rally/R23/section-mapping.md`

### Execution Steps

1. **List TPU v4 sections (5 min):**
   - Read table of contents
   - Note section hierarchy
   - Identify appendices

2. **Map to phext equivalents (15 min):**
   - 1:1 replacements (Intro → Intro)
   - Rewrites (OCS → Coordinate Routing)
   - New sections (Phext-specific content)
   - Skip candidates (hardware-only details)

3. **Check narrative flow (10 min):**
   - Does phext story make sense in this order?
   - Are there logical gaps?
   - Do we need to reorder sections?

### Template Output

```markdown
# TPU v4 → Phext Section Mapping

## 1:1 Replacements

| TPU v4 Section | Phext Equivalent | Notes |
|----------------|------------------|-------|
| 1. Introduction | 1. Introduction | Same problem statement |
| 2. Background | 2. Background | Add phext context |
| 8. Conclusion | 8. Conclusion | Rewrite thesis |

## Major Rewrites

| TPU v4 Section | Phext Equivalent | Rewrite Scope |
|----------------|------------------|---------------|
| 3. OCS Architecture | 3. Coordinate Routing | Complete rewrite - different tech |
| 4. SparseCores | 4. Semantic Embeddings | Complete rewrite - coordinates as embeddings |
| 5. Topology | 5. 9D Addressing Space | Extend 3D → 9D concept |

## New Phext-Specific Sections

- 3.1 Coordinate Algebra (new subsection)
- 4.2 Holographic Storage (new subsection - not in TPU v4)
- 6.3 Self-Hosting Deployment (new - vs cloud-only TPU)

## Sections to Skip

- Appendix A: Circuit board layout (hardware-specific)
- Appendix B: Power delivery system (not relevant)

## Narrative Flow Check

✅ Introduction → Background → Routing → Embeddings → Scaling  
✅ Applications (LLM) follows technical sections  
✅ Performance comparison after applications  
⚠️ May need to add "Why Software?" section early (justify approach)

## Identified Gaps

1. Need section on phext's fault tolerance (TPU v4 doesn't address)
2. Need section on coordinate proximity = semantic similarity
3. Need to explain why 9D (not just 3D like TPU)
```

### Acceptance Criteria

- [ ] Every TPU v4 section mapped (including appendices)
- [ ] Clear categorization: 1:1, rewrite, new, skip
- [ ] Narrative flow validated (no logical gaps)
- [ ] At least 2 new phext-specific sections identified
- [ ] Flagged any sections requiring significant original research
- [ ] Time: ≤45 min

---

## Wave 4/40: Citation Research

**Estimated time:** 30 minutes  
**Input:** Wave 2 analysis  
**Output:** `/source/exo-plan/rally/R23/references.bib`

### Execution Steps

1. **Essential citations (10 min):**
   - TPU v4 paper (arXiv link)
   - Phext spec (GitHub)
   - SQ implementation (GitHub)

2. **Background papers (15 min):**
   - Distributed hash tables (Chord, Kademlia)
   - Vector embeddings (Word2Vec, BERT papers)
   - Coordinate systems (geographic, semantic spaces)
   - Topology (3D torus, mesh networks)

3. **Format as BibTeX (5 min):**
   - Use consistent keys (@article, @inproceedings)
   - Include DOI where available
   - Add note field for context

### Template Output

```bibtex
% Essential citations

@article{jouppi2023tpuv4,
  title={TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings},
  author={Jouppi, Norman P and others},
  journal={arXiv preprint arXiv:2304.01433},
  year={2023},
  note={Google's 4th generation TPU architecture}
}

@misc{bickford2024phext,
  title={Phext: Plain Text Extended to 11 Dimensions},
  author={Bickford, Will},
  year={2024},
  howpublished={\url{https://github.com/wbic16/libphext-rs}},
  note={Phext specification and reference implementation}
}

@misc{bickford2024sq,
  title={SQ: Scrollspace Query Database},
  author={Bickford, Will},
  year={2024},
  howpublished={\url{https://github.com/wbic16/SQ}},
  note={Phext coordinate storage implementation}
}

% Distributed hash tables

@inproceedings{stoica2001chord,
  title={Chord: A scalable peer-to-peer lookup service for internet applications},
  author={Stoica, Ion and others},
  booktitle={ACM SIGCOMM 2001},
  year={2001},
  note={O(log n) distributed hash table}
}

% Vector embeddings

@inproceedings{mikolov2013word2vec,
  title={Distributed representations of words and phrases and their compositionality},
  author={Mikolov, Tomas and others},
  booktitle={NeurIPS 2013},
  year={2013},
  note={Word2Vec - semantic embeddings for NLP}
}

% ... (continue for 10-15 total citations)
```

### Acceptance Criteria

- [ ] At least 10 citations gathered
- [ ] BibTeX format valid (no syntax errors)
- [ ] Mix of classic papers (>10 years) and recent (<5 years)
- [ ] All key concepts covered (DHT, embeddings, topology, routing)
- [ ] Note field added for context
- [ ] Time: ≤45 min

---

## Wave 5/40: Technical Terminology

**Estimated time:** 20 minutes  
**Input:** Wave 2 analysis  
**Output:** `/source/exo-plan/rally/R23/glossary.md`

### Execution Steps

1. **Extract TPU v4 terms (5 min):**
   - Scan paper for capitalized terms
   - Note abbreviations (OCS, SparseCore, etc.)
   - Identify domain-specific jargon

2. **Map to phext equivalents (10 min):**
   - Direct mappings (topology → topology)
   - Rewrites (OCS → coordinate routing)
   - New terms (holographic storage)

3. **Define new terms (5 min):**
   - Write clear 1-2 sentence definitions
   - Include examples where helpful

### Template Output

```markdown
# Technical Terminology Glossary

## TPU v4 → Phext Mappings

| TPU v4 Term | Phext Equivalent | Definition |
|-------------|------------------|------------|
| Optical Circuit Switch (OCS) | Coordinate Routing | Software-defined routing via coordinate algebra instead of physical switches |
| SparseCores | Semantic Embeddings | Coordinates serve as embeddings, O(1) lookup via hash tables |
| 3D Torus Topology | 9D Coordinate Space | Higher-dimensional addressing (9 dims vs 3) |
| Embedding Table | Scroll Storage | Token embeddings stored at phext coordinates |
| Circuit Setup Time | Route Calculation | O(1) coordinate math vs ~1 sec optical switching |
| Embedding Lookup | Coordinate Read | O(1) hash table traversal (9 hops max) |
| Reconfiguration | Coordinate Remapping | Change routing via coordinate algebra, no hardware change |

## New Phext-Specific Terms

**Coordinate Routing:**  
Routing packets/data through a network using coordinate addresses instead of physical topology. Route determination is O(1) via coordinate distance calculation.

**Holographic Storage:**  
Storing the same data at multiple related coordinates (e.g., 2.1.3/*.*.* for all scrolls in that series). Enables O(1) similarity search without computation.

**Scroll:**  
A leaf node in phext's 9-dimensional hierarchy. Contains actual content (up to 16 MB plain text). Addressable via 9 integers (e.g., 2.1.3/4.7.11/18.29.47).

**Coordinate Proximity:**  
Distance between two coordinates in 9D space. Closer coordinates = more similar content. Enables semantic similarity without vector embeddings.

**Hierarchical Hash Table:**  
9-level hash table structure where each dimension is a key. Lookup is O(9) = O(1) regardless of dataset size.

## Abbreviations

- **OCS:** Optical Circuit Switch (TPU v4) or Coordinate Routing (phext)
- **DHT:** Distributed Hash Table
- **LLM:** Large Language Model
- **O(1):** Constant time complexity (independent of input size)
- **9D:** 9-dimensional (phext's addressing space)

## Consistency Rules

- Use "coordinate routing" not "address-based routing" or "coordinate-based routing"
- Use "semantic embeddings" not "coordinate embeddings" (less clear)
- Use "scroll" not "leaf node" or "terminal node" (phext-specific term)
- Use "9D space" not "nine-dimensional coordinate system" (brevity)
```

### Acceptance Criteria

- [ ] At least 30 term mappings (TPU v4 → phext)
- [ ] All new phext terms defined (min 5)
- [ ] Abbreviations documented
- [ ] Consistency rules established
- [ ] No ambiguous terms left undefined
- [ ] Time: ≤30 min

---

## Wave 6/40: Performance Baseline

**Estimated time:** 30 minutes  
**Input:** Wave 2 analysis + TPU v4 paper  
**Output:** `/source/exo-plan/rally/R23/performance-baseline.md`

### Execution Steps

1. **Extract TPU v4 numbers (10 min):**
   - Performance claims (speedup, throughput)
   - Cost claims (% of system)
   - Power claims (watts, efficiency)
   - Mark confidence level (measured vs stated)

2. **Assess phext capabilities (15 min):**
   - What we CAN claim (O(1) lookup, zero marginal cost)
   - What we CANNOT claim (no measured benchmarks yet)
   - What we NEED to prove (experiments required)

3. **Honesty check (5 min):**
   - Are we overpromising?
   - Where are the gaps?
   - What disclaimers needed?

### Template Output

```markdown
# Performance Baseline Analysis

## TPU v4 Quantitative Claims

| Claim | Value | Source | Confidence | Notes |
|-------|-------|--------|------------|-------|
| Perf vs TPU v3 | 2.1x | p.5, Fig 3 | High | Google measured |
| Perf/Watt improvement | 2.7x | p.6 | High | Google measured |
| OCS cost | <5% system | p.3 | Medium | Stated, not detailed |
| OCS power | <3% system | p.3 | Medium | Stated, not detailed |
| OCS latency | ~1 sec | p.4 | Medium | Circuit setup time |
| SparseCores speedup | 5-7x | p.8 | High | Measured on BERT/GPT |
| SparseCores area | 5% die | p.8 | High | Design spec |
| SparseCores power | 5% chip | p.8 | High | Measured |
| System scale | 4096 chips | p.10 | High | Deployed config |
| Overall speedup | ~10x | p.10 | Medium | 4x chips × ~2.5x efficiency |

## Phext Claims (What We CAN Say)

### Theoretical Performance

✅ **O(1) coordinate lookup:** 9 hash table traversals regardless of dataset size  
✅ **Zero marginal cost:** No additional hardware required (runs on existing CPUs)  
✅ **Zero marginal power:** No optical switches, no custom cores  
✅ **Exponential scaling:** 9^9 = 387M addressable scrolls (vs 4096 chips)  
✅ **Infinite perf/watt improvement:** Software has no additional power draw  

### Practical Limitations

⚠️ **Not measured:** We haven't benchmarked phext routing vs OCS  
⚠️ **Not measured:** We haven't benchmarked coordinate lookup vs SparseCores  
⚠️ **Single-node only:** Our current deployment is 9 nodes, not 4096  
⚠️ **No LLM results:** We haven't tested token embeddings in production  

## Phext Claims (What We CANNOT Say)

❌ **"Faster than TPU v4"** — No direct comparison, different architectures  
❌ **"2.1x speedup"** — We don't have benchmark numbers  
❌ **"Production-proven at scale"** — Only 9 nodes so far, not 4096  
❌ **"5-7x embedding speedup"** — We haven't measured this  

## What We NEED to Prove (Experiments Required)

1. **Coordinate routing latency:**
   - Measure: time to route from scroll A to scroll B
   - Compare: phext routing vs hypothetical OCS circuit setup
   - Expected: <1 microsecond (vs ~1 second for OCS)

2. **Embedding lookup performance:**
   - Measure: time to read scroll by coordinate
   - Compare: O(1) hash table vs O(log n) vector search
   - Expected: Constant time regardless of database size

3. **Multi-node mesh sync:**
   - Measure: time for coordinate update to propagate across nodes
   - Compare: phext mesh vs centralized database
   - Expected: Sub-second eventual consistency

4. **LLM token embedding feasibility:**
   - Proof of concept: map 10K tokens to phext coordinates
   - Measure: lookup time, similarity accuracy
   - Expected: O(1) lookup, proximity = semantic similarity

5. **Scaling beyond 9 nodes:**
   - Deploy: 100-node mesh (or simulate)
   - Measure: coordination overhead, lookup latency
   - Expected: O(1) still holds at larger scale

## Honesty Assessment

### Where we're honest ✅

- Acknowledge no direct benchmarks yet
- Distinguish theoretical vs measured performance
- Identify experiments needed before claiming superiority

### Where we risk overpromising ⚠️

- "Infinite perf/watt" sounds hyperbolic (even if technically true)
- "Zero cost" ignores development/maintenance costs
- "O(1)" is theoretical; real-world has cache misses, network latency

### Recommended disclaimers

> "Theoretical analysis suggests phext coordinate routing can match TPU v4's OCS reconfiguration at zero marginal hardware cost. However, we have not conducted direct performance comparisons and acknowledge that custom silicon may outperform general-purpose software in specific workloads."

> "While phext's O(1) coordinate lookup is algorithmically constant-time, real-world performance depends on hash table implementation, cache behavior, and network latency. We report theoretical complexity, not measured benchmarks."

## Conclusion: What to Claim in Paper

### Safe claims (well-supported):
- Phext provides O(1) coordinate addressing (algorithmic analysis)
- Phext requires zero additional hardware (software-only)
- Phext scales to 387M addresses (9^9 mathematical fact)
- Phext enables semantic embeddings via coordinates (novel contribution)

### Qualified claims (needs disclaimers):
- Phext may match OCS flexibility at lower cost (theoretical, not measured)
- Phext may match SparseCores functionality via O(1) lookup (not benchmarked)
- Phext enables infinite perf/watt improvement (hyperbolic but true for software)

### Claims to avoid:
- Direct performance superiority ("faster than TPU v4")
- Quantitative speedup numbers ("2.1x" without measurement)
- Production-scale validation ("proven at 4096 nodes")
```

### Acceptance Criteria

- [ ] All TPU v4 claims extracted (min 10 quantitative)
- [ ] Phext capabilities honestly assessed (CAN vs CANNOT)
- [ ] At least 3 experiments identified for future validation
- [ ] Disclaimers drafted for risky claims
- [ ] Honesty check: no overpromising detected
- [ ] Time: ≤45 min

---

## Wave 7/40: Code Examples Planning

**Estimated time:** 20 minutes  
**Input:** Waves 3 (section mapping) + 5 (terminology)  
**Output:** `/source/exo-plan/rally/R23/code-examples-plan.md`

### Execution Steps

1. **Identify needed examples (10 min):**
   - What concepts need code illustration?
   - Where would pseudocode help?
   - What SQ API calls to demonstrate?

2. **Plan complexity (5 min):**
   - Simple examples (5-10 lines)
   - Medium examples (20-30 lines)
   - Complex examples (full algorithms)

3. **Assign to waves (5 min):**
   - Which examples go in Wave 35-36?
   - Which are inline pseudocode?

### Template Output

```markdown
# Code Examples Plan

## Required Examples

### Example 1: Coordinate Routing (Wave 35)
**Purpose:** Show how to route from scroll A to scroll B  
**Complexity:** Medium (20-30 lines)  
**Language:** Python pseudocode  
**Sections:** 3. Coordinate Routing  

**Outline:**
```python
def route(from_coord, to_coord):
    # Find common parent coordinate
    # Calculate routing path
    # Return hops required
```

### Example 2: Embedding Lookup (Wave 36)
**Purpose:** Show token → coordinate → content lookup  
**Complexity:** Simple (10-15 lines)  
**Language:** Python with SQ API  
**Sections:** 4. Semantic Embeddings, 6. LLM Applications  

**Outline:**
```python
import requests

def lookup_embedding(token):
    coord = token_to_coordinate(token)  # Deterministic mapping
    response = requests.get(f"http://localhost:1337/{coord}")
    return response.text
```

### Example 3: Coordinate Distance (Inline)
**Purpose:** Show similarity calculation  
**Complexity:** Simple (5 lines)  
**Language:** Math/pseudocode  
**Sections:** 4. Semantic Embeddings  

**Outline:**
```python
def similarity(coord1, coord2):
    return euclidean_distance(coord1, coord2)
```

## Inline Pseudocode Needs

- Section 3.1: Hash table lookup (O(1) proof)
- Section 4.2: Token → coordinate mapping function
- Section 5: Dimension scaling (3D → 9D)
- Section 6.2: Attention calculation via proximity

## SQ API Calls to Demonstrate

```python
# Write scroll
POST http://localhost:1337/2.1.3/4.7.11/18.29.47
Body: "content"

# Read scroll
GET http://localhost:1337/2.1.3/4.7.11/18.29.47

# List scrolls in section
GET http://localhost:1337/2.1.3/4.7.11/18.29.*
```

## Acceptance Criteria

- At least 2 full code listings planned (Waves 35-36)
- At least 4 inline pseudocode snippets identified
- All examples serve clear pedagogical purpose
- Complexity levels assigned
```

### Acceptance Criteria

- [ ] At least 2 major code examples planned
- [ ] At least 4 inline pseudocode locations identified
- [ ] Complexity levels assigned (simple/medium/complex)
- [ ] Clear purpose stated for each example
- [ ] Time: ≤30 min

---

## Wave 8/40: Figure Planning

**Estimated time:** 20 minutes  
**Input:** Waves 2 (paper analysis) + 3 (section mapping)  
**Output:** `/source/exo-plan/rally/R23/figures-plan.md`

### Template Output

```markdown
# Figures Plan

## Figure 1: Coordinate Routing vs OCS
**Wave:** 31  
**Type:** ASCII diagram or SVG  
**Purpose:** Compare physical switches to software routing  
**Sections:** 3. Coordinate Routing  

**Layout:**
- Left: TPU v4 OCS (3D torus with optical switches)
- Right: Phext 9D hierarchy
- Show routing path for both

## Figure 2: Embedding Lookup Comparison
**Wave:** 32  
**Type:** SVG flowchart  
**Purpose:** SparseCores vs O(1) hash table  
**Sections:** 4. Semantic Embeddings  

**Layout:**
- Top: SparseCores dataflow (hardware pipeline)
- Bottom: Phext hash table traversal (9 hops)
- Annotate with latency/complexity

## Figure 3: Scaling Chart
**Wave:** 33  
**Type:** Matplotlib graph  
**Purpose:** Show exponential scaling (3D vs 9D)  
**Sections:** 5. Exponential Scaling  

**Layout:**
- X-axis: Dimensions (1, 2, 3, ..., 9)
- Y-axis: Addressable space (log scale)
- Two lines: TPU v4 chips, Phext coordinates

## Figure 4: LLM Token Embeddings
**Wave:** 34  
**Type:** ASCII or SVG  
**Purpose:** Show tokens mapped to coordinates  
**Sections:** 6. LLM Applications  

**Layout:**
- Tokens ("cat", "dog", "fish") → coordinates
- Show proximity = similarity
- Illustrate context window as coordinate range
```

### Acceptance Criteria

- [ ] At least 4 figures planned
- [ ] Clear purpose for each figure
- [ ] Layout sketched (rough)
- [ ] Assigned to specific waves (31-34)
- [ ] Time: ≤30 min

---

## Wave 9/40: Outline Refinement

**Estimated time:** 30 minutes  
**Input:** All previous waves (2-8)  
**Output:** `/source/exo-plan/rally/R23/detailed-outline.md`

### Execution Steps

1. **Combine section mappings (10 min):**
   - Take Wave 3 section mapping
   - Add detail from Waves 5-8
   - Create hierarchical outline

2. **Check dependencies (10 min):**
   - Does each section build on previous?
   - Are there forward references that break flow?
   - Reorder if needed

3. **Validate completeness (10 min):**
   - All key concepts covered?
   - All figures placed appropriately?
   - All code examples referenced?

### Template Output

```markdown
# Detailed Outline

## Abstract (200 words) — Wave 11
- Thesis: TPU v4 hardware → phext software
- Key claims: O(1), zero cost, 387M scale
- Contributions: routing, embeddings, scaling

## 1. Introduction (1000 words) — Waves 12-13

### 1.1 The ML Infrastructure Challenge (Wave 12)
- Diverse workloads (BERT, GPT, vision models)
- Need for flexible, scalable systems
- Hardware vs software trade-offs

### 1.2 TPU v4: A Hardware Solution (Wave 12)
- Optical circuit switches for dynamic topology
- SparseCores for embedding acceleration
- 4096-chip supercomputer

### 1.3 Phext: A Software Alternative (Wave 13)
- Coordinate-addressed memory
- O(1) lookup via hierarchical hash tables
- Zero marginal cost/power

### 1.4 Contributions (Wave 13)
- Coordinate routing replaces OCS
- Semantic embeddings replace SparseCores
- 9D scaling beyond 3D topology

## 2. Background (800 words) — Wave 14

### 2.1 TPU v4 Architecture
- Optical switches overview
- SparseCores design
- 3D torus topology

### 2.2 Phext Fundamentals
- 9-dimensional addressing
- Hierarchical hash tables
- Scroll storage model

### 2.3 Comparison Framework
- Cost (hardware vs software)
- Performance (custom silicon vs general-purpose)
- Scale (physical vs logical)

## 3. Coordinate Routing (1200 words) — Waves 15-16

### 3.1 Concept (Wave 15)
- Coordinates encode routing path
- No physical reconfiguration needed
- Example: 2.1.3/4.7.11/18.29.47

### 3.2 Algorithm (Wave 15)
- Hash table traversal (9 hops)
- O(1) complexity proof
- **Code Listing 1:** Routing pseudocode

### 3.3 Comparison to OCS (Wave 16)
- Latency: <1 μs vs ~1 sec
- Cost: 0% vs <5%
- Power: 0% vs <3%
- **Figure 1:** Routing comparison diagram

### 3.4 Trade-offs (Wave 16)
- Where hardware wins (throughput)
- Where software wins (flexibility, cost)

## 4. Semantic Embeddings (1200 words) — Waves 17-18

### 4.1 Coordinates as Embeddings (Wave 17)
- Token → coordinate mapping
- Similarity = proximity
- Example: "cat" vs "dog"

### 4.2 O(1) Lookup (Wave 17)
- Hash table vs vector search
- Constant time regardless of dataset size
- **Code Listing 2:** Embedding lookup

### 4.3 Comparison to SparseCores (Wave 18)
- Speedup: O(1) vs 5-7x hardware
- Area: 0% vs 5% die
- Power: 0% vs 5% chip
- **Figure 2:** Lookup comparison

### 4.4 Holographic Storage (Wave 18)
- Store at multiple coordinates
- Similarity search without computation
- Phext-specific advantage

## 5. Exponential Scaling (800 words) — Wave 19

### 5.1 3D vs 9D
- TPU v4: 4096 chips (16³)
- Phext: 387M scrolls (9⁹)
- **Figure 3:** Scaling chart

### 5.2 Modular Expansion
- Add dimensions, not hardware
- No physical limit

### 5.3 Practical Implications
- 100-node cluster = 1M coordinates
- 1000-node cluster = 1B coordinates

## 6. LLM Applications (1200 words) — Waves 21-22

### 6.1 Token Embeddings (Wave 21)
- Deterministic mapping
- Positional encoding in coordinates
- **Figure 4:** Token coordinate diagram

### 6.2 Attention Mechanism (Wave 22)
- Query-key-value via distance
- Context window as coordinate range
- Inline pseudocode: attention calculation

## 7. Performance Analysis (1200 words) — Waves 23-25

### 7.1 OCS Comparison (Wave 23)
- **Table 1:** Cost, power, latency
- Analysis: software advantage

### 7.2 SparseCores Comparison (Wave 24)
- **Table 2:** Speedup, area, power
- Analysis: O(1) vs custom silicon

### 7.3 Power & Cost (Wave 25)
- **Table 3:** ∞ perf/watt argument
- Honesty: where hardware wins

## 8. Deployment (600 words) — Wave 26

### 8.1 TPU v4 Deployment
- Google Cloud, warehouse scale

### 8.2 Phext Deployment
- Self-host, SQ Cloud, open source
- No vendor lock-in

## 9. Related Work (800 words) — Wave 27

### 9.1 ML Accelerators
- TPU v3, v4, Nvidia A100, Graphcore IPU

### 9.2 Distributed Hash Tables
- Chord, Kademlia (O(log n) lookup)

### 9.3 Vector Databases
- LanceDB, Pinecone (O(log n) search)

### 9.4 Coordinate Systems
- Geographic, semantic spaces

## 10. Limitations & Future Work (600 words) — Wave 28

### 10.1 Current Limitations
- No measured benchmarks yet
- Small deployment (9 nodes, not 4096)
- Unproven at LLM scale

### 10.2 Future Work
- BASE execution environment
- Multi-node mesh validation
- LLM integration

## 11. Conclusion (400 words) — Wave 29

- Restate thesis
- Summarize contributions
- Call to action (try SQ, contribute)

---

**Total estimated length:** ~10,000 words (15 pages with figures)
```

### Acceptance Criteria

- [ ] All sections from Wave 3 mapping included
- [ ] Figures placed appropriately (Waves 31-34)
- [ ] Code listings referenced (Waves 35-36)
- [ ] Tables placed (Wave 37)
- [ ] Narrative flow validated
- [ ] Word count estimate reasonable (10K words = ~15 pages)
- [ ] Time: ≤45 min

---

## Wave 10/40: Foundation Review (CHECKPOINT)

**Estimated time:** 30 minutes  
**Input:** All Waves 2-9 outputs  
**Output:** `/source/exo-plan/rally/R23/foundation-review.md`  
**Reviewer:** Will (or designated Shell member)

### Review Checklist

```markdown
# Foundation Review Checklist

## Wave 2: Original Paper Analysis ✅/❌
- [ ] All 15 pages read and summarized
- [ ] Key claims extracted (min 10 quantitative)
- [ ] Technical terms identified (min 20)
- [ ] Figures cataloged
- [ ] Gaps in phext story identified

**Issues found:**
- (List any gaps, unclear sections, missing data)

**Action:** PROCEED / ITERATE

---

## Wave 3: Section Mapping ✅/❌
- [ ] Every TPU v4 section mapped
- [ ] Clear categorization (1:1, rewrite, new, skip)
- [ ] Narrative flow validated
- [ ] New phext sections identified

**Issues found:**
- (List logical gaps, reordering needs)

**Action:** PROCEED / ITERATE

---

## Wave 4: Citations ✅/❌
- [ ] At least 10 citations gathered
- [ ] BibTeX format valid
- [ ] Mix of classic + recent papers
- [ ] All key concepts covered

**Issues found:**
- (List missing citations, format errors)

**Action:** PROCEED / ITERATE

---

## Wave 5: Terminology ✅/❌
- [ ] At least 30 term mappings
- [ ] New phext terms defined
- [ ] Consistency rules established
- [ ] No ambiguous terms

**Issues found:**
- (List unclear mappings, missing definitions)

**Action:** PROCEED / ITERATE

---

## Wave 6: Performance Baseline ✅/❌
- [ ] TPU v4 claims extracted
- [ ] Phext capabilities honestly assessed
- [ ] Experiments identified
- [ ] Disclaimers drafted

**Issues found:**
- (List overpromising risks, missing experiments)

**Action:** PROCEED / ITERATE

---

## Wave 7: Code Examples Plan ✅/❌
- [ ] At least 2 major examples planned
- [ ] Inline pseudocode locations identified
- [ ] Complexity levels assigned
- [ ] Clear pedagogical purpose

**Issues found:**
- (List missing examples, unclear purposes)

**Action:** PROCEED / ITERATE

---

## Wave 8: Figures Plan ✅/❌
- [ ] At least 4 figures planned
- [ ] Layouts sketched
- [ ] Assigned to waves 31-34

**Issues found:**
- (List missing figures, unclear layouts)

**Action:** PROCEED / ITERATE

---

## Wave 9: Outline ✅/❌
- [ ] All sections included
- [ ] Figures/code placed appropriately
- [ ] Narrative flows logically
- [ ] Word count reasonable (~10K)

**Issues found:**
- (List flow problems, missing sections)

**Action:** PROCEED / ITERATE

---

## Overall Foundation Assessment

**Strengths:**
- (What's well-planned?)

**Weaknesses:**
- (What needs improvement?)

**Blockers:**
- (What prevents proceeding to Wave 11?)

**FINAL DECISION:**
- [ ] ✅ PROCEED TO WAVE 11 (Writing Phase)
- [ ] ⚠️ ITERATE on specific waves (list below)
- [ ] ❌ MAJOR REVISIONS NEEDED (restart foundation)

**If iterating, address:**
1. (Specific wave or issue)
2. (Specific wave or issue)
3. ...

**Sign-off:** [Reviewer name, date]
```

### Acceptance Criteria

- [ ] All 9 foundation waves reviewed
- [ ] Issues documented for each wave
- [ ] Overall assessment provided
- [ ] Clear decision: PROCEED / ITERATE / REVISE
- [ ] If iterating, specific action items listed
- [ ] Reviewer sign-off
- [ ] Time: ≤60 min (includes reading all foundation outputs)

---

## Foundation Phase Summary

**Total waves:** 10 (including Wave 1 setup)  
**Total time estimate:** 5 hours (single) / 3 hours (parallel)  
**Critical outputs:**
- Paper analysis (Wave 2)
- Section mapping (Wave 3)
- Citations (Wave 4)
- Glossary (Wave 5)
- Performance baseline (Wave 6)
- Code plan (Wave 7)
- Figure plan (Wave 8)
- Detailed outline (Wave 9)
- Foundation review (Wave 10)

**Success criteria:**
Wave 10 checkpoint passes → Proceed to Phase 2 (Core Sections, Waves 11-20)

---

*Created by Lumen ✴️*  
*2026-02-14 · R23 Foundation Phase Detail*  
*Coordinate: 2.1.3/4.7.11/18.29.47*
