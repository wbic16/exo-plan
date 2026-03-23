# R23 Requirements: TPU v4 → Phext Structural Mapping

**Goal:** Produce a rigorous technical paper that maps Google's TPU v4 architecture onto phext, suitable for Hacker News, arxiv preprint, or direct reply to hardware engineers like Hector Yee (@eigenhector).

**Source:** Jouppi et al., "TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings" (ISCA 2023, arXiv:2304.01433)

**Audience:** Systems researchers, HPC engineers, ML infrastructure people. Technical. Skeptical. Want diagrams and numbers, not metaphors.

**Tone:** Academic white paper. Honest about gaps. Let the structural mapping speak for itself.

---

## Wave Plan (40 Waves)

### Phase 1: Deep Read (Waves 2-9)
Read the TPU v4 paper section by section. Extract exact numbers, architectural details, and design rationale. No mapping yet — just understand what Google built and why.

| Wave | Section | Key Questions to Answer |
|------|---------|------------------------|
| 2 | Abstract + Intro | What 5 innovations? What problems do they solve? What benchmarks? |
| 3 | TPU v4 Chip (Section 2-3) | Die area breakdown, FLOPS, memory bandwidth, TDP. How does one chip work? |
| 4 | Interconnect: OCS (Section 4) | How many OCSes? Reconfiguration latency? Cost/power as % of system? What topologies supported? |
| 5 | Interconnect: 3D Torus (Section 5) | Twist factor? Bisection bandwidth? How does the 4096-chip layout work physically? |
| 6 | SparseCores (Section 6) | What are embeddings? Why dedicated hardware? 5-7x speedup mechanism? Die area tradeoff? |
| 7 | Software Stack (Section 7) | XLA compiler, SPMD, how does user code map to hardware? What does the programmer see? |
| 8 | Performance & Benchmarks (Section 8) | MLPerf numbers, comparison to A100/IPU, training vs inference, scaling curves |
| 9 | Availability, Power, Cost (Section 9-10) | Failure modes, OCS as availability tool, power breakdown, total system cost estimates |

### Phase 2: Structural Mapping (Waves 10-19)
For each TPU v4 innovation, identify the *structural isomorphism* with phext. Be precise about what maps and what doesn't.

| Wave | Mapping | Honest Gaps |
|------|---------|-------------|
| 10 | OCS ↔ SQ mesh topology | OCS: nanosecond reconfiguration. SQ mesh: seconds. OCS: hardware. SQ: software. |
| 11 | 3D torus ↔ 9D coordinate space | Torus has fixed dimensionality + physical constraints. Phext has 9 logical dimensions, no physics. |
| 12 | SparseCores ↔ HashMap scroll lookup | Both: O(1) into sparse space. SparseCores: in silicon, pipelined. HashMap: in RAM, single-threaded. |
| 13 | 4096 chips ↔ SQ mesh at scale | TPU v4: 4096 chips = $100M+. Phext: 387M scrolls on one $800 box. Different resource. |
| 14 | Memory hierarchy ↔ Phext memory layout | HBM stack vs. RAM. Bandwidth gap is 10-100x. But phext doesn't need matrix multiply bandwidth. |
| 15 | XLA/SPMD ↔ libphext + SQ REST API | Programmer model: XLA compiles ML graphs. SQ serves coordinate-addressed REST. Fundamentally different compute models. |
| 16 | Embedding tables ↔ Multi-encoder architecture | Both: sparse lookup in high-dimensional space. TPU v4 uses custom silicon. Phext uses coordinate projections. |
| 17 | Fault tolerance ↔ Mercurial cores / coordinate persistence | OCS reroutes around failed chips. Phext coordinates persist regardless of which machine serves them. |
| 18 | Power/cost ↔ Commodity economics | TPU v4: 2.7x perf/watt. Phext: 20W per node. Different optimization targets. |
| 19 | The honest "where phext can't compete" section | Raw FLOPS (zero), matrix multiply (none), training throughput (not applicable), interconnect bandwidth (orders of magnitude less) |

### Phase 3: Diagrams (Waves 20-24)
Technical diagrams that Hector Yee would actually find useful.

| Wave | Diagram |
|------|---------|
| 20 | TPU v4 3D torus topology (from paper) vs. phext 9D coordinate space (side by side) |
| 21 | OCS reconfiguration flow vs. SQ mesh peer addition/removal |
| 22 | SparseCore embedding lookup pipeline vs. HashMap coordinate lookup |
| 23 | Memory hierarchy comparison (HBM → SRAM → registers vs. disk → RAM → HashMap) |
| 24 | Cost/scale comparison chart (log scale: chips vs scrolls per dollar) |

### Phase 4: Writing (Waves 25-34)
Write the paper section by section. Each wave = one section, ~400-600 words.

| Wave | Section | Content |
|------|---------|---------|
| 25 | Abstract | 200 words. Thesis + key results. |
| 26 | Introduction | The 5 innovations, the structural mapping thesis, paper roadmap |
| 27 | Background: Phext | Delimiters, coordinates, SQ, scale properties. For readers who've never seen phext. |
| 28 | Mapping 1: Topology Reconfiguration | OCS ↔ SQ mesh. Diagram from Wave 21. |
| 29 | Mapping 2: Multi-Dimensional Interconnect | 3D torus ↔ 9D coordinates. Diagram from Wave 20. |
| 30 | Mapping 3: Sparse Access | SparseCores ↔ coordinate-addressed HashMap. Diagram from Wave 22. |
| 31 | Mapping 4: Scale Economics | 4096 chips ↔ commodity mesh. Diagram from Wave 24. |
| 32 | Mapping 5: Fault Tolerance | OCS rerouting ↔ coordinate persistence. |
| 33 | Honest Limitations | What phext cannot do. No FLOPS, no training, no matrix multiply. |
| 34 | Conclusion | The organizational thesis. What this means for distributed intelligence. |

### Phase 5: Polish & Ship (Waves 35-40)

| Wave | Task |
|------|------|
| 35 | Internal review: check all numbers against source paper |
| 36 | Simplify: cut jargon, tighten prose, ensure each diagram has a caption |
| 37 | Peer review: share with choir for feedback |
| 38 | Incorporate feedback, final edit |
| 39 | Convert to HTML for mirrorborn.us/papers/ |
| 40 | Ship: push to site repo, post to Discord, prepare HN submission draft |

---

## Success Criteria

1. A hardware engineer reads it and says "that's an interesting structural analogy" — not "that's hand-waving"
2. Every claim has a number or a citation
3. The "Honest Limitations" section is the most credible section in the paper
4. Diagrams are clear enough to post on X without context
5. Total length: 4000-6000 words (academic paper length, not blog post)

## Anti-Goals

- Do NOT claim phext replaces TPUs for ML training
- Do NOT hand-wave about "dimensional equivalence" without defining the mapping precisely
- Do NOT use Mirrorborn mythology — this is a technical paper for strangers
- Do NOT exceed 6000 words — if you need more, you're not being precise enough
