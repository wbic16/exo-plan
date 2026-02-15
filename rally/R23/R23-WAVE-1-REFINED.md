# R23 Wave 1 Refinement: Requirements for Waves 2-40

**Goal:** Create an excellent execution plan before starting Wave 2  
**Status:** Iterating on Wave 1 breakdown  
**Created:** 2026-02-14

---

## What Wave 1 Needs to Define

### 1. Clear Deliverables
**Current:** Each wave has an "Output:" line  
**Missing:** Specific acceptance criteria for each deliverable

**Fix:** Add completion criteria for each wave

### 2. Dependencies
**Current:** Waves are numbered sequentially  
**Missing:** Which waves can be parallelized? Which truly depend on others?

**Fix:** Create dependency graph

### 3. Time Estimates
**Current:** "15-45 minutes per wave"  
**Missing:** Specific estimates per wave type

**Fix:** Categorize waves by complexity (Simple/Medium/Complex)

### 4. Tools & Methods
**Current:** General "create document"  
**Missing:** HOW to create each deliverable

**Fix:** Specify tools (web_fetch, exec, manual reading, diagramming)

### 5. Review Process
**Current:** Checkpoint waves at 10, 20, 30  
**Missing:** What exactly gets reviewed? By whom?

**Fix:** Define review criteria and process

### 6. Quality Standards
**Current:** Implied  
**Missing:** Explicit quality bars for each wave type

**Fix:** Define "good enough to proceed" vs "needs iteration"

### 7. Failure Modes
**Current:** Not addressed  
**Missing:** What if a wave fails? Can we skip? Must we rework?

**Fix:** Add contingency planning

---

## Refined Wave Categories

### Category A: Research (Waves 2-6)
**Time:** 30-45 min each  
**Tools:** PDF reading, web_fetch, note-taking  
**Output:** Markdown analysis documents  
**Acceptance:** Key claims extracted, no major gaps

**Waves:**
- Wave 2: Original paper analysis
- Wave 3: Section mapping
- Wave 4: Citation research
- Wave 5: Technical terminology
- Wave 6: Performance baseline

### Category B: Planning (Waves 7-10)
**Time:** 15-30 min each  
**Tools:** Outlining, sketching, brainstorming  
**Output:** Plan documents  
**Acceptance:** Clear roadmap for execution, no blockers identified

**Waves:**
- Wave 7: Code examples planning
- Wave 8: Figure planning
- Wave 9: Outline refinement
- Wave 10: Foundation review

### Category C: Writing Core (Waves 11-20)
**Time:** 30-60 min each  
**Tools:** Technical writing, pseudocode  
**Output:** 400-800 word sections  
**Acceptance:** Technically accurate, flows well, citations included

**Waves:**
- Wave 11: Abstract
- Wave 12-13: Introduction (2 parts)
- Wave 14: Background
- Wave 15-16: Coordinate routing (2 parts)
- Wave 17-18: Semantic embeddings (2 parts)
- Wave 19: Exponential scaling
- Wave 20: Core sections review

### Category D: Applications (Waves 21-30)
**Time:** 30-45 min each  
**Tools:** Technical writing, calculations  
**Output:** 400-600 word sections  
**Acceptance:** Concrete examples, fair comparisons, honest limitations

**Waves:**
- Wave 21-22: LLM applications (2 parts)
- Wave 23-25: Performance comparisons (3 parts)
- Wave 26: Deployment
- Wave 27: Related work
- Wave 28: Limitations
- Wave 29: Conclusion
- Wave 30: Applications review

### Category E: Visual Assets (Waves 31-37)
**Time:** 20-40 min each  
**Tools:** ASCII art, SVG, matplotlib, code formatting  
**Output:** Figures, code listings, tables  
**Acceptance:** Clear, accurate, publication-ready

**Waves:**
- Wave 31-34: Figures (4 diagrams)
- Wave 35-36: Code listings (2 examples)
- Wave 37: Tables

### Category F: Assembly & Polish (Waves 38-40)
**Time:** 45-90 min each  
**Tools:** Document assembly, formatting, LaTeX  
**Output:** Complete papers, blog posts, presentations  
**Acceptance:** Publication-ready, no errors, compelling narrative

**Waves:**
- Wave 38: First complete draft
- Wave 39: Editorial polish
- Wave 40: Final deployment

---

## Wave Dependency Graph

### Phase 1: Foundation (Waves 1-10)
```
Wave 1 (Setup) → Wave 2 (Paper analysis)
                      ↓
    Wave 3 (Section mapping) ← depends on 2
         ↓
    Wave 4 (Citations) ← can run parallel to 3
    Wave 5 (Terminology) ← can run parallel to 4
    Wave 6 (Performance) ← depends on 2
         ↓
    Wave 7 (Code plan) ← depends on 3,5
    Wave 8 (Figure plan) ← depends on 3
    Wave 9 (Outline) ← depends on 3,7,8
         ↓
    Wave 10 (Review) ← depends on 2-9, CHECKPOINT
```

**Parallelizable:** 4+5 can run together

### Phase 2: Core Sections (Waves 11-20)
```
Wave 11 (Abstract) ← depends on 9 (outline)
     ↓
Wave 12-13 (Intro) ← serial, part 2 builds on part 1
     ↓
Wave 14 (Background) ← depends on 2 (paper analysis)
     ↓
Wave 15-16 (Routing) ← serial, part 2 builds on part 1
     ↓
Wave 17-18 (Embeddings) ← serial, part 2 builds on part 1
     ↓
Wave 19 (Scaling) ← depends on 15-18
     ↓
Wave 20 (Review) ← depends on 11-19, CHECKPOINT
```

**Parallelizable:** None (sequential technical narrative)

### Phase 3: Applications (Waves 21-30)
```
Wave 21-22 (LLM) ← depends on 17-18 (embeddings)
     ↓
Wave 23 (OCS perf) ← depends on 15-16 (routing)
Wave 24 (Sparse perf) ← depends on 17-18 (embeddings)
Wave 25 (Power/cost) ← depends on 6 (baseline)
    ↓ (all three can run parallel)
Wave 26 (Deployment) ← independent
Wave 27 (Related work) ← depends on 4 (citations)
Wave 28 (Limitations) ← depends on 23-25 (perf)
Wave 29 (Conclusion) ← depends on 11 (abstract), 28 (limitations)
     ↓
Wave 30 (Review) ← depends on 21-29, CHECKPOINT
```

**Parallelizable:** 23+24+25 can run together, 26+27 can run together

### Phase 4: Visual Assets (Waves 31-37)
```
Wave 31 (Fig 1: Routing) ← depends on 15-16
Wave 32 (Fig 2: Embeddings) ← depends on 17-18
Wave 33 (Fig 3: Scaling) ← depends on 19
Wave 34 (Fig 4: LLM) ← depends on 21-22
    ↓ (all four can run parallel)
Wave 35 (Code 1: Routing) ← depends on 15-16
Wave 36 (Code 2: Embeddings) ← depends on 17-18
    ↓ (both can run parallel)
Wave 37 (Tables) ← depends on 23-25
```

**Parallelizable:** 31+32+33+34 together, then 35+36 together

### Phase 5: Assembly (Waves 38-40)
```
Wave 38 (First draft) ← depends on ALL previous waves (11-37)
     ↓
Wave 39 (Editorial polish) ← depends on 38
     ↓
Wave 40 (Deployment) ← depends on 39, FINAL
```

**Parallelizable:** None (sequential integration)

---

## Detailed Acceptance Criteria

### Wave 2: Original Paper Analysis
**Input:** TPU v4 PDF  
**Output:** `analysis-tpu-v4-original.md`  
**Must include:**
- [ ] Key performance claims with page numbers
- [ ] List of all figures (with captions)
- [ ] Technical terms needing phext mappings (min 20)
- [ ] Section-by-section summary (1-2 sentences each)
- [ ] Identified gaps in our current phext story

**Acceptance criteria:**
- All 15 pages read
- No major technical term missed
- Clear list of what we need to prove/claim
- Time: 45 min

### Wave 3: Section Mapping
**Input:** Wave 2 analysis  
**Output:** `section-mapping.md`  
**Must include:**
- [ ] TPU v4 section → Phext equivalent (1:1 table)
- [ ] Sections requiring new content (flagged)
- [ ] Sections we can skip (with justification)
- [ ] Narrative flow check (does phext story make sense?)

**Acceptance criteria:**
- Every TPU v4 section mapped
- No logical gaps in phext narrative
- Identified 2-3 sections requiring original research
- Time: 30 min

### Wave 4: Citation Research
**Input:** Wave 2 analysis  
**Output:** `references.bib` (BibTeX format)  
**Must include:**
- [ ] TPU v4 paper citation
- [ ] Phext spec (github.com/wbic16/libphext-rs)
- [ ] SQ implementation (github.com/wbic16/SQ)
- [ ] Relevant papers (min 10): embeddings, topology, distributed systems
- [ ] Prior art: hash tables, coordinate systems

**Acceptance criteria:**
- BibTeX entries valid
- All key concepts have citations
- Mix of classic papers + recent work (last 5 years)
- Time: 30 min

### Wave 5: Technical Terminology
**Input:** Wave 2 analysis  
**Output:** `glossary.md`  
**Must include:**
- [ ] TPU v4 term → Phext equivalent (min 30 mappings)
- [ ] New terms we're introducing (with definitions)
- [ ] Consistent naming (e.g., "coordinate routing" not "address-based routing")
- [ ] Abbreviations (OCS, SparseCores, etc.)

**Acceptance criteria:**
- No ambiguous terms
- All TPU v4 jargon mapped
- Phext terms clearly defined
- Time: 20 min

### Wave 6: Performance Baseline
**Input:** Wave 2 analysis + TPU v4 paper  
**Output:** `performance-baseline.md`  
**Must include:**
- [ ] TPU v4 quantitative claims (with confidence)
- [ ] What phext CAN claim (with evidence)
- [ ] What phext CANNOT claim (honest gaps)
- [ ] Areas needing experimental validation

**Acceptance criteria:**
- No overpromising on phext performance
- Clear distinction: theoretical vs measured
- Identified 3-5 experiments we'd need to run
- Time: 30 min

### (Continue for all 40 waves...)

---

## Review Process at Checkpoints

### Wave 10: Foundation Review
**Reviewer:** Will (or designated Shell member)  
**Time:** 30 min  
**Review checklist:**
- [ ] Paper analysis complete (Wave 2)
- [ ] Section mapping logical (Wave 3)
- [ ] Citations sufficient (Wave 4)
- [ ] Terminology consistent (Wave 5)
- [ ] Performance baseline honest (Wave 6)
- [ ] Code examples feasible (Wave 7)
- [ ] Figures achievable (Wave 8)
- [ ] Outline compelling (Wave 9)

**Decision:** Proceed to Wave 11 OR iterate on gaps

### Wave 20: Core Sections Review
**Reviewer:** Will + Shell technical leads (Phex, Verse)  
**Time:** 60 min  
**Review checklist:**
- [ ] Abstract compelling (Wave 11)
- [ ] Introduction clear (Waves 12-13)
- [ ] Background accurate (Wave 14)
- [ ] Routing section sound (Waves 15-16)
- [ ] Embeddings section sound (Waves 17-18)
- [ ] Scaling argument valid (Wave 19)
- [ ] Technical claims defensible
- [ ] Narrative flows

**Decision:** Proceed to Wave 21 OR revise weak sections

### Wave 30: Applications Review
**Reviewer:** Will + Shell (full team)  
**Time:** 60 min  
**Review checklist:**
- [ ] LLM applications concrete (Waves 21-22)
- [ ] Performance comparisons fair (Waves 23-25)
- [ ] Deployment section realistic (Wave 26)
- [ ] Related work comprehensive (Wave 27)
- [ ] Limitations honest (Wave 28)
- [ ] Conclusion strong (Wave 29)

**Decision:** Proceed to Wave 31 (figures) OR strengthen applications

### Wave 38: First Draft Review
**Reviewer:** Will + Shell (final approval)  
**Time:** 90 min  
**Review checklist:**
- [ ] All sections integrated coherently
- [ ] Figures support narrative
- [ ] Code examples work
- [ ] Tables accurate
- [ ] Citations complete
- [ ] 15-page target hit
- [ ] Ready for editorial polish

**Decision:** Proceed to Wave 39 OR major revisions

---

## Quality Standards by Wave Type

### Research Waves (2-6)
**Good enough to proceed:**
- Main points extracted
- Key numbers captured
- Major gaps identified

**Needs iteration:**
- Missing critical data
- Unclear mapping to phext
- Contradictory claims

### Writing Waves (11-29)
**Good enough to proceed:**
- Technically accurate
- Clear thesis
- Flows logically
- Citations present

**Needs iteration:**
- Factual errors
- Unclear arguments
- Missing key points
- Poor flow

### Visual Waves (31-37)
**Good enough to proceed:**
- Conveys information clearly
- Accurate representation
- Publication-ready quality

**Needs iteration:**
- Confusing layout
- Incorrect data
- Sloppy formatting

---

## Failure Mode Handling

### Scenario 1: Wave takes too long (>60 min)
**Action:** Split into sub-waves (e.g., Wave 15a, 15b)  
**Don't:** Keep pushing through (diminishing returns)

### Scenario 2: Wave reveals blocker
**Action:** Pause, create contingency wave  
**Example:** "Wave 6 shows we can't claim performance → add Wave 6.5: performance experiment design"

### Scenario 3: Checkpoint fails review
**Action:** Create remediation waves  
**Example:** "Wave 20 review fails → add Waves 20.1-20.3 to fix routing section"

### Scenario 4: Scope creep
**Action:** Defer to "Future Work" section  
**Don't:** Expand 40 waves to 60 (keep scope tight)

### Scenario 5: External dependency blocks progress
**Action:** Skip ahead to independent waves  
**Example:** "Can't get TPU v4 numbers → skip Wave 23, do Waves 24-25, return to 23 later"

---

## Time Estimates (Detailed)

### Phase 1: Foundation (Waves 1-10)
- Wave 1: 30 min ✅ (complete)
- Wave 2: 45 min (paper reading)
- Wave 3: 30 min (mapping)
- Wave 4: 30 min (citations)
- Wave 5: 20 min (glossary)
- Wave 6: 30 min (performance)
- Wave 7: 20 min (code plan)
- Wave 8: 20 min (figure plan)
- Wave 9: 30 min (outline)
- Wave 10: 30 min (review)
**Subtotal:** 5 hours

### Phase 2: Core Sections (Waves 11-20)
- Wave 11: 45 min (abstract)
- Waves 12-13: 60 min each (intro)
- Wave 14: 45 min (background)
- Waves 15-16: 60 min each (routing)
- Waves 17-18: 60 min each (embeddings)
- Wave 19: 45 min (scaling)
- Wave 20: 60 min (review)
**Subtotal:** 8 hours

### Phase 3: Applications (Waves 21-30)
- Waves 21-22: 45 min each (LLM)
- Waves 23-25: 30 min each (performance)
- Wave 26: 30 min (deployment)
- Wave 27: 45 min (related work)
- Wave 28: 30 min (limitations)
- Wave 29: 30 min (conclusion)
- Wave 30: 60 min (review)
**Subtotal:** 6 hours

### Phase 4: Visual Assets (Waves 31-37)
- Waves 31-34: 40 min each (figures)
- Waves 35-36: 30 min each (code)
- Wave 37: 30 min (tables)
**Subtotal:** 4 hours

### Phase 5: Assembly (Waves 38-40)
- Wave 38: 90 min (assembly)
- Wave 39: 60 min (polish)
- Wave 40: 45 min (deployment)
**Subtotal:** 3 hours

**TOTAL:** 26 hours (revised from 10 hours)

**Why longer?**
- More realistic per-wave estimates
- Includes checkpoint review time
- Accounts for iteration/revisions
- Assumes single-person execution (Lumen)

**If parallelized (Shell collaboration):**
- Phase 4 (figures): 4 waves in parallel = 40 min instead of 2.7 hours
- Phase 3 (comparisons): 3 waves in parallel = 30 min instead of 1.5 hours
- **Reduced total: ~20 hours** (with 4-person collaboration)

---

## Tools & Methods by Wave Type

### Research Waves
- **web_fetch** for online papers
- **Read** for local PDFs
- Manual note-taking in markdown
- Structured templates (claims, figures, terms)

### Planning Waves
- Outlining tools (markdown lists)
- Brainstorming (bullet points)
- Dependency graphing (ASCII art)

### Writing Waves
- Technical writing (markdown)
- Pseudocode (Python-style)
- Citation management (BibTeX)
- Version control (git commits per wave)

### Visual Waves
- ASCII art (for routing diagrams)
- Python matplotlib (for charts)
- SVG (for publication figures)
- Code formatting (syntax highlighting)

### Review Waves
- Read-through (all prior outputs)
- Checklist validation
- Gap identification
- Revision planning

---

## Success Criteria (Overall R23)

**Academic success:**
- [ ] Paper accepted for arXiv publication
- [ ] Cited by ML infrastructure researchers
- [ ] Fair comparison acknowledged by Google engineers

**Narrative success:**
- [ ] Clear thesis: coordinate algebra = alternative to custom silicon
- [ ] Honest about limitations
- [ ] Respects TPU v4's innovation

**Impact success:**
- [ ] HN front page discussion
- [ ] Positions SQ Cloud as serious ML infrastructure
- [ ] Drives blog traffic to mirrorborn.us
- [ ] Recruits technical contributors to phext

---

## Wave 1 Refinement Status

✅ **Requirements defined:**
- Clear deliverables per wave
- Dependency graph created
- Time estimates detailed (26 hours single-person, 20 hours Shell)
- Tools & methods specified
- Review process defined
- Quality standards set
- Failure mode handling planned

**Next decision:**
- Approve refined plan → proceed to Wave 2
- Further iteration needed → refine specific waves
- Change scope → adjust wave count or targets

---

*Refined by Lumen ✴️*  
*2026-02-14 · R23 Wave 1 Iteration*  
*Coordinate: 2.1.3/4.7.11/18.29.47*
