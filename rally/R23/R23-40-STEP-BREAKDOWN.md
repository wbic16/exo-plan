# R23: TPU v4 → Phext Rewrite (40-Step Breakdown)

**Task:** Rewrite Google's TPU v4 paper in phext terms  
**Structure:** 40 waves for granular execution  
**Created:** 2026-02-14  
**Status:** Wave 1/40 (Planning)

---

## Wave Structure Overview

**Waves 1-10:** Foundation & Research  
**Waves 11-20:** Core Technical Sections  
**Waves 21-30:** Applications & Analysis  
**Waves 31-40:** Polish & Deployment

---

## WAVES 1-10: Foundation & Research

### Wave 1/40: Project Setup ✅
- [x] Create 40-step breakdown document
- [x] Establish wave tracking system
- [x] Set up output directory structure
- **Output:** This document

### Wave 2/40: Original Paper Analysis
- [ ] Read TPU v4 paper in full (15 pages)
- [ ] Extract key claims (performance, cost, power)
- [ ] Identify figures to recreate
- [ ] List all technical terms to map
- **Output:** `analysis-tpu-v4-original.md`

### Wave 3/40: Section Mapping
- [ ] Map each TPU v4 section to phext equivalent
- [ ] Identify 1:1 replacements vs new concepts
- [ ] Flag sections requiring original research
- **Output:** `section-mapping.md`

### Wave 4/40: Citation Research
- [ ] Gather phext spec citations
- [ ] Find relevant papers (coordinate systems, embeddings, topology)
- [ ] Document prior art (hash tables, distributed systems)
- **Output:** `references.bib`

### Wave 5/40: Technical Terminology
- [ ] Create glossary (TPU v4 term → Phext term)
- [ ] Define new terms (coordinate routing, semantic addressing)
- [ ] Establish consistent naming conventions
- **Output:** `glossary.md`

### Wave 6/40: Performance Baseline
- [ ] Extract TPU v4 performance numbers
- [ ] Document what we can/can't claim for phext
- [ ] Identify areas needing experimental validation
- **Output:** `performance-baseline.md`

### Wave 7/40: Code Examples Planning
- [ ] List all code examples needed
- [ ] Plan pseudocode vs real implementation
- [ ] Identify SQ API calls to demonstrate
- **Output:** `code-examples-plan.md`

### Wave 8/40: Figure Planning
- [ ] List all figures to create
- [ ] Choose visualization tools (ASCII, SVG, matplotlib)
- [ ] Sketch rough layouts
- **Output:** `figures-plan.md`

### Wave 9/40: Outline Refinement
- [ ] Refine abstract (200 words)
- [ ] Detailed section outlines (bullet points)
- [ ] Identify dependencies between sections
- **Output:** `detailed-outline.md`

### Wave 10/40: Review Foundation
- [ ] Review all foundation documents
- [ ] Identify gaps before starting writing
- [ ] Get Will's approval to proceed to Wave 11
- **Output:** `foundation-review.md`

---

## WAVES 11-20: Core Technical Sections

### Wave 11/40: Abstract (First Draft)
- [ ] Write 200-word abstract
- [ ] State core thesis clearly
- [ ] Include key quantitative claims
- **Output:** `abstract-v1.md`

### Wave 12/40: Introduction (Part 1)
- [ ] Problem statement (ML infrastructure challenges)
- [ ] TPU v4 context (Google's solution)
- [ ] Phext positioning (alternative approach)
- **Output:** `section-1-intro-part1.md` (500 words)

### Wave 13/40: Introduction (Part 2)
- [ ] Contributions summary
- [ ] Paper structure overview
- [ ] Key innovations highlighted
- **Output:** `section-1-intro-part2.md` (500 words)

### Wave 14/40: Background - TPU v4 Architecture
- [ ] Summarize TPU v4 design
- [ ] Explain OCS and SparseCores
- [ ] Set up comparison framework
- **Output:** `section-2-background.md` (800 words)

### Wave 15/40: Coordinate Routing (Part 1)
- [ ] Explain coordinate-based routing concept
- [ ] Compare to OCS physical switching
- [ ] Show O(1) lookup algorithm
- **Output:** `section-3-routing-part1.md` (600 words)

### Wave 16/40: Coordinate Routing (Part 2)
- [ ] Dynamic topology via coordinate algebra
- [ ] Pseudocode examples
- [ ] Performance comparison table
- **Output:** `section-3-routing-part2.md` (600 words)

### Wave 17/40: Semantic Embeddings (Part 1)
- [ ] Coordinates as embeddings concept
- [ ] Mapping tokens to 9D space
- [ ] Similarity via coordinate distance
- **Output:** `section-4-embeddings-part1.md` (600 words)

### Wave 18/40: Semantic Embeddings (Part 2)
- [ ] Compare to SparseCores hardware acceleration
- [ ] O(1) hash table lookup details
- [ ] Code example (embedding lookup)
- **Output:** `section-4-embeddings-part2.md` (600 words)

### Wave 19/40: Exponential Scaling
- [ ] 3D vs 9D addressing space
- [ ] Scaling math (9^9 = 387M)
- [ ] Modular dimension expansion
- **Output:** `section-5-scaling.md` (800 words)

### Wave 20/40: Review Core Sections
- [ ] Read Waves 11-19 outputs
- [ ] Check consistency, flow, technical accuracy
- [ ] Revise before proceeding to applications
- **Output:** `core-sections-review.md`

---

## WAVES 21-30: Applications & Analysis

### Wave 21/40: LLM Token Embeddings
- [ ] Token → coordinate mapping
- [ ] Positional encoding in coordinates
- [ ] Context window as coordinate range
- **Output:** `section-6-llm-tokens.md` (600 words)

### Wave 22/40: LLM Attention Mechanism
- [ ] Attention as coordinate proximity
- [ ] Query-key-value via distance
- [ ] Example attention calculation
- **Output:** `section-6-llm-attention.md` (600 words)

### Wave 23/40: Performance Comparison (OCS)
- [ ] TPU v4 OCS numbers (cost, power, latency)
- [ ] Phext routing equivalent
- [ ] Comparison table + analysis
- **Output:** `section-7-perf-ocs.md` (400 words)

### Wave 24/40: Performance Comparison (SparseCores)
- [ ] TPU v4 SparseCores (5-7x speedup, 5% area)
- [ ] Phext O(1) lookup performance
- [ ] Comparison table + analysis
- **Output:** `section-7-perf-sparse.md` (400 words)

### Wave 25/40: Power & Cost Analysis
- [ ] TPU v4: 2.7x perf/watt, hardware costs
- [ ] Phext: zero marginal power/cost
- [ ] ∞ perf/watt argument (software vs hardware)
- **Output:** `section-7-power-cost.md` (500 words)

### Wave 26/40: Deployment & Availability
- [ ] TPU v4 deployment (Google Cloud, warehouse scale)
- [ ] Phext deployment (self-host, SQ Cloud, open source)
- [ ] No vendor lock-in advantage
- **Output:** `section-8-deployment.md` (600 words)

### Wave 27/40: Related Work
- [ ] Cite TPU v4 (acknowledge Google's innovation)
- [ ] Vector databases (LanceDB, Pinecone, Weaviate)
- [ ] Distributed hash tables (Chord, Kademlia)
- [ ] Prior coordinate systems
- **Output:** `section-9-related.md` (800 words)

### Wave 28/40: Limitations & Future Work
- [ ] What phext can't do (vs TPU v4 hardware)
- [ ] Areas needing research (BASE execution, mesh validation)
- [ ] Honest assessment of trade-offs
- **Output:** `section-10-limitations.md` (600 words)

### Wave 29/40: Conclusion (First Draft)
- [ ] Restate thesis
- [ ] Summarize key contributions
- [ ] Call to action (try SQ, contribute to phext)
- **Output:** `section-11-conclusion.md` (400 words)

### Wave 30/40: Review Applications & Analysis
- [ ] Read Waves 21-29 outputs
- [ ] Check for gaps, inconsistencies
- [ ] Revise before moving to figures
- **Output:** `applications-review.md`

---

## WAVES 31-40: Figures, Polish & Deployment

### Wave 31/40: Figure 1 - Coordinate Routing Diagram
- [ ] ASCII or SVG diagram
- [ ] Show 9D hierarchy
- [ ] Compare to OCS 3D torus
- **Output:** `figures/fig1-routing.svg` (or .txt)

### Wave 32/40: Figure 2 - Embedding Lookup Comparison
- [ ] SparseCores dataflow vs phext hash table
- [ ] Visual: O(1) lookup path
- [ ] Side-by-side comparison
- **Output:** `figures/fig2-embeddings.svg`

### Wave 33/40: Figure 3 - Scaling Chart
- [ ] X-axis: dimensions (3D, 9D)
- [ ] Y-axis: addressable space (log scale)
- [ ] Compare TPU v4 chips vs phext coordinates
- **Output:** `figures/fig3-scaling.svg`

### Wave 34/40: Figure 4 - LLM Token Example
- [ ] Visual: token → coordinate mapping
- [ ] Show attention as proximity
- [ ] Context window as range
- **Output:** `figures/fig4-llm.svg`

### Wave 35/40: Code Listing 1 - Coordinate Routing
- [ ] Pseudocode for routing algorithm
- [ ] Compare to OCS circuit setup
- [ ] Include complexity analysis
- **Output:** `code/listing1-routing.py`

### Wave 36/40: Code Listing 2 - Embedding Lookup
- [ ] SQ API example (read scroll)
- [ ] Token to coordinate function
- [ ] Attention calculation
- **Output:** `code/listing2-embeddings.py`

### Wave 37/40: Tables & Data
- [ ] Table 1: Performance comparison (OCS vs routing)
- [ ] Table 2: SparseCores vs coordinate lookup
- [ ] Table 3: Power/cost analysis
- [ ] Table 4: Scaling (chips vs dimensions)
- **Output:** `tables/all-tables.md`

### Wave 38/40: First Complete Draft Assembly
- [ ] Combine all sections (Waves 11-29)
- [ ] Insert figures (Waves 31-34)
- [ ] Insert code (Waves 35-36)
- [ ] Insert tables (Wave 37)
- [ ] Format as single document
- **Output:** `tpu-v4-phext-rewrite-v1.md` (15 pages)

### Wave 39/40: Editorial Polish
- [ ] Proofread for clarity, grammar, flow
- [ ] Check citations format
- [ ] Verify all claims have support
- [ ] Ensure consistent terminology (use glossary)
- [ ] Format for arXiv submission
- **Output:** `tpu-v4-phext-rewrite-v2.md`

### Wave 40/40: Final Deployment
- [ ] Convert to LaTeX (if needed for arXiv)
- [ ] Create blog post version (shorter, accessible)
- [ ] Create presentation slides (key points)
- [ ] Post to GitHub (exo-plan/papers/)
- [ ] Announce in Discord
- [ ] **Rally complete** ✅

---

## Wave Execution Guidelines

**Each wave should:**
- Take 15-45 minutes (not hours)
- Produce concrete output file
- Build on previous waves
- Be independently reviewable

**Wave checkpoints:**
- Wave 10: Foundation review (before writing)
- Wave 20: Core sections review (before applications)
- Wave 30: Applications review (before figures)
- Wave 38: First complete draft
- Wave 40: Final deployment

**Flexibility:**
- Waves can be reordered if needed
- Some waves may merge (e.g., short sections)
- New waves can be inserted if gaps found
- Target: complete in 2-4 sessions over 1-2 weeks

---

## Output Directory Structure

```
/source/exo-plan/rally/R23/
├── R23-40-STEP-BREAKDOWN.md          (this file)
├── R23-TPU-V4-PHEXT-REWRITE.md       (original planning)
├── analysis-tpu-v4-original.md        (Wave 2)
├── section-mapping.md                 (Wave 3)
├── references.bib                     (Wave 4)
├── glossary.md                        (Wave 5)
├── performance-baseline.md            (Wave 6)
├── code-examples-plan.md              (Wave 7)
├── figures-plan.md                    (Wave 8)
├── detailed-outline.md                (Wave 9)
├── foundation-review.md               (Wave 10)
├── abstract-v1.md                     (Wave 11)
├── section-1-intro-part1.md           (Wave 12)
├── section-1-intro-part2.md           (Wave 13)
├── ... (continue for all waves)
├── figures/
│   ├── fig1-routing.svg
│   ├── fig2-embeddings.svg
│   ├── fig3-scaling.svg
│   └── fig4-llm.svg
├── code/
│   ├── listing1-routing.py
│   └── listing2-embeddings.py
├── tables/
│   └── all-tables.md
└── output/
    ├── tpu-v4-phext-rewrite-v1.md    (Wave 38)
    ├── tpu-v4-phext-rewrite-v2.md    (Wave 39)
    ├── blog-post.md                   (Wave 40)
    └── presentation.md                (Wave 40)
```

---

## Success Metrics

**Academic rigor:**
- [ ] All TPU v4 claims mapped to phext equivalents
- [ ] Fair comparison (acknowledge where hardware wins)
- [ ] Novel insights (coordinate algebra as paradigm)
- [ ] Proper citations (TPU v4, related work)

**Accessibility:**
- [ ] Readable by ML engineers (not just hardware architects)
- [ ] Code examples runnable (or clear pseudocode)
- [ ] Figures clear and informative
- [ ] Blog post version for wider audience

**Impact:**
- [ ] arXiv submission ready
- [ ] HN Show post prepared
- [ ] Presentation deck for talks
- [ ] Positions phext as serious ML infrastructure

---

## Wave 1/40 Status

✅ **Complete**

**Outputs:**
- This 40-step breakdown document
- Clear execution path
- Checkpoint structure
- Output directory plan

**Next:** Wave 2/40 - Original Paper Analysis

**Time estimate:** 15 minutes per wave average = 10 hours total (matches original estimate)

---

*Created by Lumen ✴️*  
*2026-02-14 · R23 Wave 1/40*  
*Coordinate: 2.1.3/4.7.11/18.29.47*
