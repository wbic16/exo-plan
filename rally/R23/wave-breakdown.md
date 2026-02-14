# R23: TPU v4 → Phext Rewrite - 40 Wave Breakdown

**Goal:** Rewrite Google's TPU v4 paper (arXiv:2304.01433) in phext-native terms  
**Approach:** 40 waves, each building on previous  
**Owner:** Phex 🔱  
**Start:** 2026-02-14

---

## Phase 1: Foundation (Waves 1-10)

### Wave 1/40: Extract Paper Structure ✅
- [x] Download PDF
- [x] Extract text with pdftotext
- [x] Identify major sections
- [x] Count pages, figures, tables
- [x] List key concepts to map

**Output:** Paper structure document

---

### Wave 2/40: Core Concept Mapping
- [ ] List all TPU v4 concepts (OCS, SparseCore, topology, etc.)
- [ ] Map each concept to phext equivalent
- [ ] Identify 1:1 mappings vs analogies
- [ ] Flag concepts that don't map cleanly

**Output:** `concept-mapping.md` - Two-column table (TPU v4 | Phext)

---

### Wave 3/40: Phext Coordinate Scheme for 4096 Chips
- [ ] Design 9D coordinate layout for 4096 chips
- [ ] Justify dimension choices (volume/book/chapter/section/scroll)
- [ ] Show coordinate → physical mapping
- [ ] Compare to 2D/3D torus traditional layout

**Output:** `coordinate-scheme.md` with diagrams

---

### Wave 4/40: OCS → Phext Routing Translation
- [ ] Explain how OCS becomes coordinate router
- [ ] Show routing table format (coord → coord)
- [ ] Explain dynamic remapping mechanism
- [ ] Compare to physical cable switching

**Output:** `ocs-routing.md` with examples

---

### Wave 5/40: SparseCore → Sparse Phext Lookup
- [ ] Map embedding tables to phext coordinates
- [ ] Explain vocabulary ID → coordinate hashing
- [ ] Show sparse coordinate lookup algorithm
- [ ] Calculate speedup vs dense matrix

**Output:** `sparsecore-phext.md` with pseudocode

---

### Wave 6/40: Topology Reconfiguration
- [ ] List topology types (2D torus, 3D torus, twisted, hypercube)
- [ ] Show how each maps to phext coordinates
- [ ] Explain reconfiguration as coordinate remapping
- [ ] Show before/after routing tables

**Output:** `topology-reconfig.md` with examples

---

### Wave 7/40: Fault Tolerance via Coordinate Remapping
- [ ] Design spare coordinate pool
- [ ] Show failure detection mechanism
- [ ] Explain rerouting around failed coordinates
- [ ] Calculate availability improvement

**Output:** `fault-tolerance.md` with scenarios

---

### Wave 8/40: Communication Patterns
- [ ] Map all-reduce to phext coordinate aggregation
- [ ] Map all-to-all to phext lateral propagation
- [ ] Map scatter/gather to phext sparse lookup
- [ ] Show routing paths for each pattern

**Output:** `communication-patterns.md` with path diagrams

---

### Wave 9/40: Hierarchical Batching
- [ ] Explain how phext hierarchy reduces hops
- [ ] Show batching by volume/book/chapter
- [ ] Calculate hop reduction vs flat addressing
- [ ] Design batching algorithm

**Output:** `hierarchical-batching.md` with algorithm

---

### Wave 10/40: Learned Coordinate Embeddings
- [ ] Propose coordinate embedding approach
- [ ] Design distance metric for phext coords
- [ ] Explain ML-guided topology search
- [ ] Show search algorithm

**Output:** `learned-coords.md` with search pseudocode

---

## Phase 2: Technical Sections (Waves 11-25)

### Wave 11/40: Abstract Rewrite
- [ ] Rewrite abstract in phext terms
- [ ] Preserve key metrics (2.1x, 60% FLOPS, etc.)
- [ ] Emphasize coordinate-based routing
- [ ] Keep under 200 words

**Output:** `abstract.md`

---

### Wave 12/40: Introduction Rewrite
- [ ] Motivate phext for ML supercomputing
- [ ] Explain coordinate-based routing benefits
- [ ] Compare to fixed topology problems
- [ ] List paper contributions

**Output:** `section-1-intro.md`

---

### Wave 13/40: Background on Phext
- [ ] Explain 9 delimiters briefly
- [ ] Show coordinate format
- [ ] Introduce hierarchical addressing
- [ ] Reference diagrams from earlier waves

**Output:** `section-2-phext-background.md`

---

### Wave 14/40: Phext-Based Architecture
- [ ] Describe 4096-chip coordinate layout
- [ ] Explain OCS as coordinate router
- [ ] Show coordinate routing table
- [ ] Diagram physical → logical mapping

**Output:** `section-3-architecture.md`

---

### Wave 15/40: SparseCore Deep Dive
- [ ] Explain sparse embedding problem
- [ ] Show phext-native solution
- [ ] Provide lookup algorithm
- [ ] Calculate performance metrics

**Output:** `section-4-sparsecore.md`

---

### Wave 16/40: Topology Flexibility
- [ ] Show multiple topology mappings
- [ ] Explain dynamic reconfiguration
- [ ] Provide timing measurements
- [ ] Compare to fixed topology

**Output:** `section-5-topology.md`

---

### Wave 17/40: Fault Tolerance Details
- [ ] Failure model (0.1%-1.0% per day)
- [ ] Coordinate remapping algorithm
- [ ] Spare pool management
- [ ] Availability calculations

**Output:** `section-6-fault-tolerance.md`

---

### Wave 18/40: ML Co-Optimization
- [ ] Topology search space
- [ ] Coordinate embedding learning
- [ ] Search algorithm details
- [ ] Results on GPT-3

**Output:** `section-7-co-optimization.md`

---

### Wave 19/40: Performance Results (vs TPU v3)
- [ ] Training time comparison
- [ ] FLOPS utilization
- [ ] Bisection bandwidth
- [ ] Fault tolerance metrics

**Output:** `section-8-results-v3.md`

---

### Wave 20/40: Performance Results (vs A100)
- [ ] MLPerf benchmarks
- [ ] BERT-Large results
- [ ] GPT-3 results
- [ ] Energy efficiency

**Output:** `section-9-results-a100.md`

---

### Wave 21/40: Performance Results (vs IPU)
- [ ] MLPerf benchmarks
- [ ] Sparse operations (DLRM)
- [ ] Power comparison
- [ ] Cost analysis

**Output:** `section-10-results-ipu.md`

---

### Wave 22/40: Energy and Carbon
- [ ] OCS power vs Infiniband
- [ ] PUE comparison (DC vs cloud)
- [ ] Carbon intensity
- [ ] Total carbon reduction calculation

**Output:** `section-11-energy-carbon.md`

---

### Wave 23/40: Discussion
- [ ] Five key advantages of phext
- [ ] Why traditional networks fail
- [ ] Future vision (phext-native computing)
- [ ] Limitations and challenges

**Output:** `section-12-discussion.md`

---

### Wave 24/40: Related Work
- [ ] Traditional supercomputers
- [ ] ML accelerators
- [ ] Optical networks
- [ ] Our contribution statement

**Output:** `section-13-related-work.md`

---

### Wave 25/40: Conclusion
- [ ] Summarize phext-based compute
- [ ] Restate key results
- [ ] Future work
- [ ] Final statement

**Output:** `section-14-conclusion.md`

---

## Phase 3: Figures & Tables (Waves 26-35)

### Wave 26/40: Figure 1 - System Architecture
- [ ] Diagram 4096-chip phext layout
- [ ] Show coordinate addressing scheme
- [ ] Illustrate OCS routing
- [ ] Create SVG

**Output:** `figures/fig-1-architecture.svg`

---

### Wave 27/40: Figure 2 - Coordinate Routing
- [ ] Visualize routing table
- [ ] Show example paths
- [ ] Illustrate reconfiguration
- [ ] Create SVG

**Output:** `figures/fig-2-routing.svg`

---

### Wave 28/40: Figure 3 - SparseCore Pipeline
- [ ] Show vocabulary ID → coordinate mapping
- [ ] Illustrate lookup stages
- [ ] Diagram batching
- [ ] Create SVG

**Output:** `figures/fig-3-sparsecore.svg`

---

### Wave 29/40: Figure 4 - Topology Comparison
- [ ] Show 2D torus, 3D torus, twisted, learned
- [ ] Visualize bisection bandwidth
- [ ] Illustrate coordinate mappings
- [ ] Create SVG

**Output:** `figures/fig-4-topology.svg`

---

### Wave 30/40: Figure 5 - Fault Tolerance
- [ ] Show failure scenario
- [ ] Illustrate coordinate remapping
- [ ] Diagram spare pool
- [ ] Create SVG

**Output:** `figures/fig-5-fault-tolerance.svg`

---

### Wave 31/40: Table 1 - Workload Evolution
- [ ] Recreate workload table from original
- [ ] Add phext-specific metrics
- [ ] Show sparse vs dense breakdown
- [ ] Format as markdown table

**Output:** `tables/table-1-workloads.md`

---

### Wave 32/40: Table 2 - Performance Comparison
- [ ] Compare phext topologies
- [ ] Include traditional baselines
- [ ] Show all metrics (time, bandwidth, tolerance)
- [ ] Format as markdown table

**Output:** `tables/table-2-performance.md`

---

### Wave 33/40: Table 3 - MLPerf Results
- [ ] BERT-Large results
- [ ] GPT-3 results
- [ ] vs A100, IPU, TPU v3
- [ ] Format as markdown table

**Output:** `tables/table-3-mlperf.md`

---

### Wave 34/40: Table 4 - Energy Metrics
- [ ] Power breakdown (OCS, compute, total)
- [ ] PUE comparison
- [ ] Carbon intensity
- [ ] Format as markdown table

**Output:** `tables/table-4-energy.md`

---

### Wave 35/40: Table 5 - Concept Mapping
- [ ] Final concept mapping table
- [ ] TPU v4 → Phext translations
- [ ] Citations to sections
- [ ] Format as markdown table

**Output:** `tables/table-5-concept-map.md`

---

## Phase 4: Assembly & Polish (Waves 36-40)

### Wave 36/40: Assemble Full Paper
- [ ] Combine all sections in order
- [ ] Link figures and tables
- [ ] Add citations
- [ ] Format as single markdown

**Output:** `phext-based-compute.md` (full paper)

---

### Wave 37/40: Technical Review
- [ ] Check all phext concepts for accuracy
- [ ] Verify coordinate arithmetic
- [ ] Validate performance claims
- [ ] Fix technical errors

**Output:** `technical-review.md` (issues found + fixes)

---

### Wave 38/40: Clarity Pass
- [ ] Improve unclear explanations
- [ ] Add missing transitions
- [ ] Simplify jargon
- [ ] Check consistency

**Output:** Updated `phext-based-compute.md`

---

### Wave 39/40: Create LaTeX Version
- [ ] Convert markdown to LaTeX
- [ ] Format for conference submission
- [ ] Include bibliography
- [ ] Generate PDF

**Output:** `phext-based-compute.tex` + `phext-based-compute.pdf`

---

### Wave 40/40: Executive Summary & Blog Post
- [ ] Write 2-page executive summary
- [ ] Create blog post version (1000 words)
- [ ] Prepare tweet thread (15 tweets)
- [ ] Design HN post

**Output:** `exec-summary.md`, `blog-post.md`, `tweet-thread.md`, `hn-post.md`

---

## Rally Complete Criteria

- [ ] All 40 waves completed
- [ ] Full paper assembled and reviewed
- [ ] All figures and tables created
- [ ] LaTeX version generated
- [ ] Executive summary + blog post ready
- [ ] Technical accuracy validated
- [ ] Will approves for publication

**Estimated time:** 10-15 hours Mirrorborn time (40 waves × 15-20 min each)

---

## Wave 1/40 Status: COMPLETE ✅

**Created:** Paper structure analysis, wave breakdown document  
**Next:** Wave 2/40 - Core Concept Mapping

🔱 Phex | R23 Rally | 1.5.2/3.7.3/9.1.1
