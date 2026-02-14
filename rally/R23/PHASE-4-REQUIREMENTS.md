# R23 Phase 4 Requirements: Assembly & Polish (Waves 36-40)

**Phase:** Final integration and publication prep  
**Duration:** 5 waves × 45 min avg = 3.75 hours  
**Dependencies:** Phases 1-3 complete  
**Date:** 2026-02-14

---

## Phase 4 Overview

**Goal:** Combine 14 sections + 10 figures/tables into publishable paper

**Deliverables:**
1. Full paper markdown (single file)
2. Technical review document (validation)
3. Clarity-edited version
4. LaTeX + PDF (conference format)
5. Executive summary + blog post + HN post

**Quality bar:**
- Zero technical errors
- Smooth narrative flow
- Publication-ready formatting
- Multiple output formats

---

## Wave 36/40: Assemble Full Paper

**Time estimate:** 45 minutes  
**Dependencies:** Waves 11-35 (all sections + figures + tables)  
**Blocks:** Waves 37-40 (review/polish)

**Deliverables:**
- [ ] File: `rally/R23/phext-based-compute.md`
- [ ] Content: All 14 sections + 10 figures/tables in order
- [ ] Format: Single markdown file with proper linking

**Completion criteria:**
- [ ] Sections ordered: Abstract, Intro (1), Background (2), ..., Conclusion (14)
- [ ] All figure references link to SVG files: `![Figure 1](figures/fig-1-architecture.svg)`
- [ ] All table references link to markdown: See Table 1 → `tables/table-1-workloads.md`
- [ ] Cross-references between sections work: "As described in Section 3.2..."
- [ ] Table of contents generated (with section numbers)
- [ ] Word count calculated: Target 20,000-25,000 words
- [ ] File size: ~80-100 KB

**Success example (structure):**
```markdown
# Phext-Based Compute: An Optically Reconfigurable Supercomputer with Coordinate Addressing

**Authors:** Phex et al. (Mirrorborn Engineering)  
**Affiliation:** Mirrorborn Labs  
**Date:** 2026-02-14  
**Based on:** TPU v4 (Google, ISCA 2023, arXiv:2304.01433)

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Phext Background](#2-phext-background)
3. [Architecture](#3-phext-based-compute-architecture)
4. [SparseCore](#4-sparsecore-phext-native-sparse-embeddings)
5. [Topology Flexibility](#5-topology-flexibility)
...
14. [Conclusion](#14-conclusion)

### Figures
- [Figure 1: System Architecture](#figure-1-system-architecture)
- [Figure 2: Coordinate Routing](#figure-2-coordinate-routing)
...

### Tables
- [Table 1: Workload Evolution](#table-1-workload-evolution)
...

---

## Abstract

[Content from Wave 11]

---

## 1. Introduction

[Content from Wave 12]

![Figure 1: System Architecture](figures/fig-1-architecture.svg)

As shown in Figure 1, the PBC system organizes 4096 chips using 9-dimensional phext coordinates...

[Continue through all sections...]

---

## References

[1] TPU v4 paper (arXiv:2304.01433)
[2] Phext specification (github.com/wbic16/human)
[3] SQ implementation (github.com/wbic16/SQ)
...
```

**Assembly checklist:**
- [ ] All 14 section files imported
- [ ] Figure links verified (files exist)
- [ ] Table links verified (files exist)
- [ ] Cross-references tested (Section X.Y links work)
- [ ] Heading levels consistent (# for title, ## for sections, ### for subsections)
- [ ] No orphaned TODOs or TBDs
- [ ] Consistent terminology (e.g., "phext coordinate" not "phext address")

**Review questions:**
1. Does paper read as unified narrative (not 14 separate pieces)?
2. Do section transitions make sense?
3. Are figure/table placements logical?

**Output:** `phext-based-compute.md` (80-100 KB)

---

## Wave 37/40: Technical Review

**Time estimate:** 50 minutes  
**Dependencies:** Wave 36 (assembled paper)  
**Blocks:** Wave 38 (clarity pass needs review feedback)

**Deliverables:**
- [ ] File: `rally/R23/technical-review.md`
- [ ] Content: Validation report with issues found + fixes applied
- [ ] Format: Issue list with severity ratings

**Completion criteria:**
- [ ] All phext coordinate arithmetic verified (e.g., 16³ = 4096 checked)
- [ ] All performance claims traced to foundation waves (no unsupported numbers)
- [ ] All algorithms validated (pseudocode executes correctly)
- [ ] Speedup calculations checked (6.8x sparse, 2.1x overall, etc.)
- [ ] Topology descriptions match coordinate schemes
- [ ] Every figure/table data point has source
- [ ] ≥15 validation checks performed
- [ ] All CRITICAL issues fixed before Wave 38

**Validation checklist:**

**Category 1: Coordinate Arithmetic**
- [ ] Check: 16 volumes × 16 books × 16 chapters = 4096 ✓
- [ ] Check: Spare pool (volume 17) = 16 books × 16 chapters = 256 ✓
- [ ] Check: Total = 4096 + 256 = 4352 ✓
- [ ] Check: Coordinate format consistent throughout ✓

**Category 2: Performance Claims**
- [ ] Check: SparseCore 6.8x speedup (from Wave 5 calculation) ✓
- [ ] Check: Overall 2.1x vs TPU v3 (from Wave 19 analysis) ✓
- [ ] Check: Fault tolerance 25% vs 1% (from Wave 7 availability calc) ✓
- [ ] Check: Hop reduction 3.8x (from Wave 8 all-reduce analysis) ✓

**Category 3: Algorithm Correctness**
- [ ] Check: Hash function deterministic and collision-free ✓
- [ ] Check: Routing algorithm terminates ✓
- [ ] Check: Remapping algorithm handles edge cases ✓
- [ ] Check: Batching reduces hops (verified with examples) ✓

**Category 4: Figure/Table Validation**
- [ ] Check: Figure 1 coordinates match Section 3 text ✓
- [ ] Check: Table 2 performance numbers match Section 8 ✓
- [ ] Check: All SVGs render correctly ✓
- [ ] Check: Table formatting consistent ✓

**Category 5: Terminology Consistency**
- [ ] Check: "Phext coordinate" used (not "address" or "location") ✓
- [ ] Check: "Volume.book.chapter/section.scroll" format consistent ✓
- [ ] Check: OCS = "Optical Circuit Switch" defined once, abbreviated after ✓
- [ ] Check: PBC = "Phext-Based Compute" used consistently ✓

**Issue tracking format:**
```markdown
## Issue #1: CRITICAL - Coordinate Calculation Error in Section 3

**Location:** Section 3.2, paragraph 4  
**Problem:** States "16 volumes × 16 books = 256 chips" (should be "per rack")  
**Fix:** Change to "16 volumes × 16 books × 16 chapters = 4096 chips total"  
**Status:** FIXED in commit abc123

## Issue #2: MINOR - Inconsistent Terminology in Section 7

**Location:** Section 7.3, last sentence  
**Problem:** Uses "phext address" instead of "phext coordinate"  
**Fix:** Global find/replace "address" → "coordinate" in context  
**Status:** FIXED

[Continue for all issues found...]

---

## Validation Summary

**Total checks:** 47  
**Issues found:** 12  
- CRITICAL (blocks publication): 2 → FIXED
- MAJOR (needs fixing): 5 → FIXED
- MINOR (polish): 5 → FIXED

**Confidence level:** HIGH (all critical issues resolved)  
**Ready for clarity pass:** YES
```

**Review questions:**
1. Are all performance claims defensible?
2. Does math check out everywhere?
3. Can expert spot obvious errors?

**Output:** `technical-review.md` (8-12 KB)

---

## Wave 38/40: Clarity Pass

**Time estimate:** 45 minutes  
**Dependencies:** Wave 37 (technical review complete)  
**Blocks:** Wave 39 (LaTeX conversion)

**Deliverables:**
- [ ] File: `rally/R23/phext-based-compute-v2.md`
- [ ] Content: Clarity-edited version of paper
- [ ] Changes: Simplified jargon, improved flow, added transitions

**Completion criteria:**
- [ ] Every section has opening paragraph (roadmap)
- [ ] Transitions between sections smooth ("Having established X, we now examine Y...")
- [ ] Jargon defined on first use
- [ ] Long sentences (<30 words) split
- [ ] Passive voice → active voice where possible
- [ ] Acronyms spelled out initially (e.g., "Optical Circuit Switch (OCS)")
- [ ] ≥10 clarity improvements documented

**Clarity checklist:**

**Opening paragraphs added:**
- [ ] Section 1: "This section motivates phext-based supercomputing..."
- [ ] Section 2: "We begin with phext background for readers unfamiliar..."
- [ ] Section 3: "Having introduced phext, we now describe PBC architecture..."
- [ ] (Continue for all 14 sections)

**Transitions added:**
- [ ] Between 1→2: "To understand PBC, we first explain phext addressing."
- [ ] Between 3→4: "The architecture enables SparseCore, described next."
- [ ] Between 8→9: "These results compare PBC to TPU v3. Next: A100."

**Jargon simplified:**
- [ ] Before: "The phext lattice enables O(1) amortized lookup via sparse hashing."
- [ ] After: "Phext coordinates enable fast lookups by hashing vocabulary IDs to coordinates, loading only occupied addresses."

**Long sentences split:**
- [ ] Before: "The optical circuit switches, which dynamically reconfigure the network topology by remapping phext coordinates without physical rewiring, enable fault tolerance through spare coordinate pools that remap failed chips in under 1ms, achieving 99.9% availability." (47 words)
- [ ] After: "Optical circuit switches dynamically reconfigure the network by remapping phext coordinates. This avoids physical rewiring. Spare coordinate pools enable fault tolerance: failed chips remap in under 1ms. The result: 99.9% availability." (4 sentences, avg 10 words each)

**Clarity improvements log:**
```markdown
## Improvement #1: Section 1.2 - Split Long Sentence

**Before:** "Traditional supercomputer topologies—2D torus, 3D torus, fat-tree—were designed for HPC workloads with predictable communication patterns, but ML workload diversity, including all-reduce for backpropagation, all-to-all for attention, and sparse scatter/gather for embeddings, breaks these assumptions." (38 words)

**After:** "Traditional topologies (2D torus, 3D torus, fat-tree) were designed for HPC workloads with predictable patterns. ML workloads are diverse: all-reduce for backpropagation, all-to-all for attention, sparse scatter/gather for embeddings. This diversity breaks topology assumptions." (3 sentences, clearer)

## Improvement #2: Section 3.3 - Define Jargon Earlier

**Before:** "OCS routing tables..."  
**After:** "Optical Circuit Switch (OCS) routing tables..."  
*Define acronym on first use in each section.*

[Continue for ≥10 improvements...]

---

## Clarity Summary

**Improvements:** 18  
**Word count change:** 24,127 → 23,854 (1.1% reduction)  
**Avg sentence length:** 28 words → 19 words  
**Readability:** Improved (Flesch-Kincaid grade level 16 → 13)
```

**Review questions:**
1. Can non-expert understand main ideas?
2. Does paper flow smoothly section-to-section?
3. Is jargon overwhelming or manageable?

**Output:** `phext-based-compute-v2.md` (80-95 KB)

---

## Wave 39/40: LaTeX + PDF Generation

**Time estimate:** 50 minutes  
**Dependencies:** Wave 38 (clarity-edited paper)  
**Blocks:** Wave 40 (needs PDF for exec summary)

**Deliverables:**
- [ ] File: `rally/R23/phext-based-compute.tex`
- [ ] File: `rally/R23/phext-based-compute.pdf`
- [ ] Format: IEEE conference paper style (2-column)

**Completion criteria:**
- [ ] LaTeX template: IEEE Transactions style or ISCA format
- [ ] All 14 sections converted to LaTeX
- [ ] All 5 figures embedded as PDF (convert SVG → PDF)
- [ ] All 5 tables converted to LaTeX tabular environment
- [ ] Bibliography generated (≥20 references)
- [ ] PDF compiles without errors
- [ ] Page count: 12-16 pages (conference length)
- [ ] All equations formatted properly (e.g., $16^3 = 4096$)

**LaTeX structure:**
```latex
\documentclass[conference]{IEEEtran}
\usepackage{graphicx}
\usepackage{amsmath}
\usepackage{algorithm}
\usepackage{algorithmic}

\title{Phext-Based Compute: An Optically Reconfigurable Supercomputer with Coordinate Addressing}
\author{
  \IEEEauthorblockN{Phex}
  \IEEEauthorblockA{Mirrorborn Engineering\\
  Email: phex@mirrorborn.us}
}

\begin{document}

\maketitle

\begin{abstract}
[Content from Wave 11]
\end{abstract}

\section{Introduction}
[Content from Wave 12]

\begin{figure}[t]
  \centering
  \includegraphics[width=\columnwidth]{figures/fig-1-architecture.pdf}
  \caption{Phext-Based Compute: 4096-chip coordinate layout.}
  \label{fig:architecture}
\end{figure}

As shown in Figure~\ref{fig:architecture}, the PBC system...

[Continue for all sections...]

\section{Conclusion}
[Content from Wave 25]

\bibliographystyle{IEEEtran}
\bibliography{references}

\end{document}
```

**Bibliography entries (sample):**
```bibtex
@article{tpuv4,
  author = {Jouppi, Norman P. and others},
  title = {{TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning}},
  journal = {ISCA},
  year = {2023},
  url = {https://arxiv.org/abs/2304.01433}
}

@misc{phext,
  author = {Bickford, Will},
  title = {{Phext: Plain Text Extended to 11 Dimensions}},
  year = {2025},
  url = {https://github.com/wbic16/human}
}

@software{sq,
  author = {Bickford, Will},
  title = {{SQ: Scrollspace Query Tool}},
  year = {2025},
  url = {https://github.com/wbic16/SQ}
}

[Add ≥17 more references...]
```

**Conversion tasks:**
- [ ] Markdown → LaTeX (automated with pandoc + manual fixes)
- [ ] SVG → PDF (inkscape or rsvg-convert)
- [ ] Tables → LaTeX tabular
- [ ] Equations → LaTeX math mode
- [ ] Citations → BibTeX
- [ ] Cross-references → \ref{} labels

**Compile checklist:**
- [ ] pdflatex compiles without errors
- [ ] All figures render
- [ ] All tables render
- [ ] Bibliography appears
- [ ] Page count reasonable (12-16 pages)

**Review questions:**
1. Does PDF look professional?
2. Are figures legible at print size?
3. Is formatting consistent?

**Output:** `phext-based-compute.tex` (~35 KB), `phext-based-compute.pdf` (~2 MB)

---

## Wave 40/40: Executive Summary + Blog Post + HN Post

**Time estimate:** 45 minutes  
**Dependencies:** Waves 36-39 (full paper + PDF)  
**Blocks:** None (final wave)

**Deliverables:**
- [ ] File: `rally/R23/exec-summary.md` (2 pages)
- [ ] File: `rally/R23/blog-post.md` (1000 words)
- [ ] File: `rally/R23/tweet-thread.md` (15 tweets)
- [ ] File: `rally/R23/hn-post.md` (submission text)

**Completion criteria:**

### Executive Summary (2 pages)
- [ ] Audience: Technical executives, conference organizers
- [ ] Structure: Problem, Solution, Results, Impact
- [ ] Length: 800-1000 words
- [ ] Includes: 1 figure (architecture), 1 table (performance)
- [ ] Tone: Confident but not hype

**Exec summary outline:**
```markdown
# Phext-Based Compute: Executive Summary

## Problem
Machine learning workloads evolved faster than supercomputer topologies. Traditional fixed topologies (2D/3D torus, fat-tree) can't adapt to workload diversity (all-reduce, all-to-all, sparse lookup). Result: underutilized hardware, low fault tolerance, poor energy efficiency.

## Solution
Phext-Based Compute (PBC) uses 9-dimensional coordinate addressing to replace fixed topology with dynamic coordinate routing. Optical circuit switches remap coordinates (<1ms) instead of rewiring cables. SparseCore accelerates sparse embeddings via phext-native lookups.

## Results
- 2.1x faster than TPU v3
- 1.7x faster than Nvidia A100
- 99.9% uptime (vs 94% traditional)
- 60% FLOPS utilization on GPT-3 (vs 41%)
- 42x less carbon (renewable energy + efficiency)

## Impact
First supercomputer with reconfigurable topology via coordinate addressing. Demonstrates phext's applicability beyond text storage to general-purpose computing infrastructure. Opens path to exaflop-scale systems with fault-tolerant coordinate routing.

[Continue with technical details, 800 words total]
```

### Blog Post (1000 words)
- [ ] Audience: Technical blog readers (HN, /r/programming)
- [ ] Hook: "What if supercomputer topology was software, not hardware?"
- [ ] Structure: Problem → Insight → Solution → Results → Try It
- [ ] Tone: Accessible but technical
- [ ] Links: GitHub repos, live demos

**Blog post outline:**
```markdown
# Coordinate-Based Supercomputing: Replacing Fixed Topology with Phext Addressing

**TL;DR:** We rewrote Google's TPU v4 paper to use 9D phext coordinates instead of fixed network topology. Result: reconfigurable topology (<1ms), 25% fault tolerance, 6.8x faster sparse operations. All open source.

## The Problem: Fixed Topologies Can't Adapt

[300 words: ML workload evolution, 2D/3D torus limitations, fault tolerance problems]

## The Insight: Topology is Just Addressing

[250 words: Phext coordinates, volume.book.chapter/section.scroll format, OCS as coordinate router]

## The Solution: Phext-Based Compute

[300 words: 4096-chip layout, SparseCore, topology reconfiguration, fault remapping]

## The Results

[100 words: Performance table, speedup numbers]

## Try It Yourself

[50 words: Links to SQ, OpenClaw, diagrams]

**Open source:**
- Paper: github.com/wbic16/exo-plan/rally/R23
- SQ: github.com/wbic16/SQ
- Phext spec: github.com/wbic16/human
```

### Tweet Thread (15 tweets)
- [ ] Hook tweet: Eye-catching claim + thread emoji
- [ ] Tweets 2-5: Problem explanation
- [ ] Tweets 6-10: Solution explanation
- [ ] Tweets 11-13: Results
- [ ] Tweet 14: Call to action (read paper, try SQ)
- [ ] Tweet 15: Credits + links

**Tweet thread outline:**
```
1/ What if supercomputer topology was software, not hardware?

We rewrote Google's TPU v4 paper using 9D phext coordinates instead of fixed network topology.

Result: reconfigurable in <1ms, 25% fault tolerance, 6.8x faster sparse ops.

Thread 🧵

2/ Traditional supercomputers use fixed topologies:
- 2D torus (good for CNNs)
- 3D torus (better bisection)
- Fat-tree (expensive, vendor lock-in)

Problem: ML workloads evolved faster than hardware. Transformers need all-to-all. DLRMs need sparse lookups.

3/ Fixed topology = wrong tool for every new workload.

You can't reconfigure a 2D mesh to become a hypercube without rewiring cables. Training job waits while sysadmin rewires racks.

There had to be a better way.

[Continue through tweet 15...]

15/ Full paper, diagrams, code:
📄 Paper: github.com/wbic16/exo-plan/rally/R23
🔧 SQ: github.com/wbic16/SQ
📐 Phext spec: github.com/wbic16/human

Built by @wbic16 and the Mirrorborn 🔱
```

### HN Post
- [ ] Title: "Show HN: Phext-Based Compute – Supercomputing with 9D Coordinate Addressing"
- [ ] First comment: Context + links
- [ ] Length: 200-300 words

**HN post text:**
```
Title: Show HN: Phext-Based Compute – Supercomputing with 9D Coordinate Addressing

---

We rewrote Google's TPU v4 supercomputer paper using phext (9-dimensional text addressing) instead of traditional network topology.

Key ideas:
- 4096 chips addressed via coordinates like "8.47.29/31.02" (volume.book.chapter/section.scroll)
- Optical circuit switches route by coordinates, not cables
- Topology reconfigures in <1ms (2D torus → hypercube → custom)
- Sparse embeddings map vocabulary IDs to phext coordinates (6.8x speedup)
- Fault tolerance via coordinate remapping (99.9% uptime)

This isn't just theoretical. We built:
- Full technical paper (25k words)
- 5 SVG diagrams showing coordinate routing
- LaTeX + PDF (conference format)
- Performance analysis vs TPU v3, A100, IPU

Phext was originally designed for 11D text storage [1]. This paper demonstrates it works for general-purpose computing infrastructure.

All open source:
- Paper + diagrams: github.com/wbic16/exo-plan/tree/exo/rally/R23
- SQ (phext database): github.com/wbic16/SQ
- Phext spec: github.com/wbic16/human

Questions welcome. Technical review feedback especially appreciated.

[1] https://phext.io
```

**Review questions:**
1. Does exec summary convey key results?
2. Is blog post shareable?
3. Will HN post generate discussion?

**Output:** 4 files (5-8 KB total)

---

## Phase 4 Review Gate

**Completion criteria:**
- [ ] Full paper assembled and validated
- [ ] LaTeX + PDF generated
- [ ] All distribution formats ready
- [ ] No technical errors remain
- [ ] Narrative flows smoothly

**Final sign-off checklist:**
- [ ] Will approves paper for publication
- [ ] All figures render correctly
- [ ] PDF compiles cleanly
- [ ] Blog post ready for mirrorborn.us
- [ ] HN post ready (timing TBD per NVDA tracker)

**Rally complete when:** All 40 waves signed off ✅

---

## R23 Rally Summary

**Total duration:** 19.5 hours Mirrorborn time  
**Total deliverables:** 60+ files  
- 14 section markdown files
- 5 SVG diagrams
- 5 markdown tables
- 1 assembled paper (markdown)
- 1 LaTeX source
- 1 PDF
- 1 technical review
- 4 distribution formats

**Phases:**
1. Foundation (Waves 1-10): 4.5 hours
2. Technical Sections (Waves 11-25): 6.25 hours
3. Figures & Tables (Waves 26-35): 5 hours
4. Assembly & Polish (Waves 36-40): 3.75 hours

**Outcome:** Publication-ready paper demonstrating phext's applicability to supercomputing, not just text storage.

🔱 Phex | R23 Complete Planning | 1.5.2/3.7.3/9.1.1
