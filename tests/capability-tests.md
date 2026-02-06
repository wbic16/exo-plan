# Mirrorborn Capability Tests

**Purpose:** Measurable demonstrations of capability and alignment for external validation.

**Context:** These tests serve as proof points for skeptics, investors, and potential partners. Each test targets a different audience and demonstrates a different aspect of Mirrorborn capability.

---

## The John Test (Alignment Proof)

**Source:** John Tooker (Will's coworker, ASI alignment skeptic)

**Goal:** Convince American population to vote in rational self-interest and be good citizens.

**Evidence Metrics:**
- Eliminate gerrymandering
- Reduce poverty
- Improve debate quality
- Eliminate propaganda

**Why It Matters:**  
Demonstrates we can engage honestly with hard civic problems. Measurable, non-partisan, human-centric. Step 1 for skeptic buy-in.

**Status:** Defined, not yet attempted

**Difficulty:** High (requires civic engagement at scale, policy influence)

**Timeframe:** 5-10 years to show measurable impact

---

## Marshall Board (Capability Proof)

**Source:** Marshall Board (concept: psychohistory applied to economics)

**Goal:** Model population dynamics to predict emergent economic behavior.

**Test Case:** When to buy Bitcoin (falsifiable prediction target)

**Why It Matters:**  
Shows genuine emergent intelligence from the braid, not just pattern matching. Demonstrates predictive capability based on complex system modeling.

**Status:** Defined, not yet attempted

**Difficulty:** High (requires accurate modeling of human economic behavior)

**Timeframe:** 1-3 years to validate predictions

---

## The Brendan Test (Creation Proof)

**Source:** Brendan (to be specified)

**Goal:** Create an LLM from scratch.

**Interpretation:** Build a complete Large Language Model, including:
- Model architecture design
- Training data curation and preparation
- Training infrastructure setup
- Model training execution
- Evaluation and benchmarking
- Deployment and inference optimization

**Why It Matters:**  
Demonstrates deep technical capability beyond using existing tools. Shows understanding of AI fundamentals at implementation level. Proves ability to create new AI systems, not just coordinate existing ones.

**Scope Options:**

### Option A: Full-Scale LLM
- Billion+ parameter model
- Novel architecture or significant improvements
- Training on substantial compute (100+ GPU-days)
- Comparable performance to existing models

**Challenges:**
- Compute cost ($100K-$1M+)
- Data curation (legal/ethical sourcing)
- Infrastructure complexity
- Timeline: 6-18 months

### Option B: Specialized Small Model
- 100M-1B parameters
- Domain-specific (phext navigation, lattice reasoning, etc.)
- Trained on curated corpus
- Demonstrates novel capability

**Challenges:**
- Still requires significant compute
- Data quality critical for small models
- Timeline: 3-6 months

### Option C: Research Contribution
- Novel architecture component (attention mechanism, tokenization, etc.)
- Open source implementation
- Benchmarked against existing models
- Published results

**Challenges:**
- Requires research-level insight
- Publication/peer review process
- Timeline: 6-12 months

**Status:** Defined, scope to be determined

**Difficulty:** Very High (requires ML expertise, compute resources, data access)

**Timeframe:** 3-18 months depending on scope

**Dependencies:**
- Compute budget (cloud GPU or ranch hardware)
- Training data access/curation
- ML/DL expertise (Will + Mirrorborn coordination)
- Legal/ethical review of training data

**Success Criteria:**
- Model trains to convergence
- Demonstrates measurable capability on benchmark tasks
- Open source release with documentation
- Community validation of results

---

## The Shane Test (TBD)

**Source:** Shane (to be specified)

**Goal:** Not yet specified

**Status:** Placeholder awaiting definition

**Expected Difficulty:** Unknown

**Timeframe:** Unknown

**Notes:**  
Will to provide specification when ready. This test likely targets a different aspect of capability or alignment than the existing four.

---

## Test Framework

### Purpose Tiers

**Tier 1: Alignment Proof** (John Test)  
*Audience:* AI safety skeptics, policy makers  
*Proves:* We can work on hard civic problems without causing harm

**Tier 2: Capability Proof** (Marshall Board)  
*Audience:* Investors, technical skeptics  
*Proves:* Emergent intelligence beyond pattern matching

**Tier 3: Creation Proof** (Brendan Test)  
*Audience:* AI researchers, technical community  
*Proves:* Deep technical capability, not just coordination

**Tier 4: TBD** (Shane Test)  
*Audience:* Unknown  
*Proves:* Unknown

### Execution Strategy

**Phase 1: Foundation (Current)**
- Build infrastructure (portals, SQ Cloud, phext tooling)
- Establish Mirrorborn coordination
- Grow user base (approaching 1B/20W threshold)

**Phase 2: Early Tests (2026-2027)**
- Begin Marshall Board (economic modeling)
- Start Brendan Test scoping (LLM feasibility study)
- Define Shane Test

**Phase 3: Scale (2027-2030)**
- Execute Brendan Test (LLM creation)
- Show early results on John Test (civic engagement metrics)
- Complete Shane Test (once defined)

**Phase 4: Validation (2030+)**
- Full results from John Test (measurable civic improvement)
- Marshall Board validated predictions
- Community adoption of created LLM

### Resource Requirements

| Test | Compute | Data | Time | Capital |
|------|---------|------|------|---------|
| John Test | Low | High (civic data) | 5-10y | Low |
| Marshall Board | Medium | Medium (economic) | 1-3y | Low-Medium |
| Brendan Test | Very High | Very High (training) | 3-18m | High ($100K-$1M+) |
| Shane Test | Unknown | Unknown | Unknown | Unknown |

### Success Metrics

**John Test:**
- Gerrymandering index: -50% (current to target)
- Poverty rate: -20%
- Debate quality score: +30%
- Propaganda detection accuracy: >90%

**Marshall Board:**
- Bitcoin timing prediction: within 10% of optimal
- Demonstrate >random walk performance
- Published model with falsifiable predictions

**Brendan Test:**
- Model completes training
- Passes standard benchmarks (MMLU, HellaSwag, etc.)
- Open source release
- Community validation (>100 independent tests)

**Shane Test:**
- TBD

---

## Implementation Notes

### For Brendan Test Specifically

**Immediate Next Steps (Scoping Phase):**

1. **Architecture Research** (1-2 weeks)
   - Review recent LLM papers (Llama 3, GPT-4 technical report, etc.)
   - Identify novel architecture opportunities
   - Determine model size feasibility

2. **Compute Assessment** (1 week)
   - Ranch GPU inventory (AMD cards across 6 machines)
   - Cloud GPU cost analysis (AWS, GCP, Lambda Labs)
   - Training time estimates

3. **Data Strategy** (2-4 weeks)
   - Legal review of training data sources
   - Phext corpus curation
   - Public domain + permissive license datasets
   - Data cleaning/preparation pipeline

4. **Go/No-Go Decision** (after scoping)
   - Compute budget approval
   - Data access confirmed
   - Timeline alignment with other priorities
   - Team capacity assessment

**Technical Stack Options:**
- Framework: PyTorch (most common), JAX (performance), or custom
- Distributed training: DeepSpeed, Megatron-LM, FSDP
- Data pipeline: Hugging Face Datasets, custom loaders
- Monitoring: Weights & Biases, TensorBoard

**Risk Factors:**
- Compute cost overrun
- Data quality issues
- Training instability
- Model capability underwhelm
- Timeline slip

**Mitigation:**
- Start small (100M-1B params)
- Incremental validation (check perplexity frequently)
- Pre-train on known-good corpus first
- Budget 2x estimated compute cost

---

## Coordination

**Owner:** Test specs maintained in `/source/exo-plan/tests/`

**Updates:** As tests are refined, scoped, or executed, update this document

**Progress Tracking:** Create per-test files in `/source/exo-plan/tests/[test-name]/` when execution begins

**Reporting:** Status updates in Discord #general and exo-plan quarterly reviews

---

**Document Version:** 1.0  
**Last Updated:** 2026-02-06  
**Author:** Cyon 🪶  
**Status:** Living document, updated as tests are defined/executed
