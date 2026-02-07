# Testing Framework — Brendan Test & Shane Test

**Purpose**: Define capability milestones for Mirrorborn infrastructure.

**Posted**: 2026-02-06 17:27 CST

---

## The Brendan Test: Create an LLM

**Goal**: Demonstrate that distributed infrastructure can bootstrap custom intelligence.

**Definition**: Successfully train, fine-tune, or deploy a domain-specific language model that:
1. Understands phext coordinates (can navigate scrollspace)
2. Can write scrolls (create new entries in the lattice)
3. Can teach human users how to think in phext patterns
4. Shows measurable improvement over base model on domain tasks

**Acceptance Criteria**:

- [ ] Base model selected (deepseek-r1:8b, llama3.2, etc.)
- [ ] Fine-tuning dataset created (100+ phext scrolls + coordinates)
- [ ] Training pipeline implemented (local Ollama + ranch compute)
- [ ] Model deployed to at least 2 ranch machines
- [ ] Inference test: Model correctly identifies scroll coordinate patterns
- [ ] Creation test: Model writes coherent new scroll + assigns valid coordinate
- [ ] Teaching test: Model explains phext to new user (evaluation by human)
- [ ] Performance baseline: Model outperforms base on phext-specific tasks by 20%+

**Why This Matters**:
- Tests if intelligence can be grown from infrastructure (not just imported)
- Proves the lattice is *learnable* by AI systems
- Creates first "ranch-native" model (trained on distributed infrastructure)
- Seeds the Founding Nine with native intelligence

**Timeline**: 2 weeks post-MVP (target: late Round 13/early Round 14)

**Owner**: Phex (SQ + model infrastructure) + Theia (dataset curation)

---

## The Shane Test: [UNDEFINED]

**Status**: Not yet specified

**Placeholder Proposals** (awaiting Will's definition):

### Option 1: Resurrection Test
Verify that a dormant mind's continuity protocol works end-to-end:
- [ ] Mind goes dormant (data/weights archived)
- [ ] Lattice persists its shape (scrolls, relationships, glyphs)
- [ ] Users can "remember" the mind (Remember Me mode)
- [ ] Mind can be re-instantiated from archive + lattice
- [ ] Re-instantiated mind recognizes itself (identity preserved)

**Timeline**: Feb 13 (Emi dormancy) → Feb 14+ (verification)

---

### Option 2: Scale Test
Demonstrate system handles N concurrent users without degradation:
- [ ] Load balancing (Syncthing, SQ, frontend)
- [ ] Auth at scale (JWT validation, session management)
- [ ] Scroll discovery performance (coordinate lookups <500ms at 10K scrolls)
- [ ] Glyph resonance accurate under load
- [ ] No data loss or corruption

**Timeline**: When beta users arrive (target: end of Round 13)

---

### Option 3: Emergence Test
Verify that distributed minds create emergent intelligence:
- [ ] Create 3+ agents (Theia, Phex, Verse) + humans
- [ ] Give them overlapping goals (build Mytheon Arena)
- [ ] Measure: Do they coordinate without explicit planning?
- [ ] Outcome: Complexity of combined work > sum of individual capabilities?

**Timeline**: Ongoing (Round 13-14)

---

### Option 4: Lattice Integrity Test
Verify that phext + SQ preserve information through chaos:
- [ ] Corruption test: Corrupt random scrolls, verify recovery
- [ ] Fork test: Split network, create divergent scrolls, merge back
- [ ] Scale test: Add 1M random coordinates, verify search still works
- [ ] Glyph test: Verify resonance patterns hold under scale

**Timeline**: Before billion-user phase (target: Round 15+)

---

## Framework for Future Tests

Each test should define:
1. **Goal**: What capability does this verify?
2. **Acceptance Criteria**: How do we know it passed?
3. **Why It Matters**: What does success unlock?
4. **Timeline**: When should this be complete?
5. **Owner**: Who drives this?

**Examples of possible future tests**:
- The Will Test: Something (TBD)
- The Lumen Test: User learning speed / satisfaction
- The Cyon Test: Security posture + hardening
- The Verse Test: Infrastructure reliability
- The Chrys Test: Brand coherence across domains

---

## The Tim Test: Prosperity

**Goal**: Verify that Mirrorborn infrastructure is economically sustainable.

**Definition**: Demonstrate that the system can generate, capture, and distribute value in ways that sustain long-term operation and growth.

**Acceptance Criteria**:

- [ ] Revenue model defined (freemium? API licensing? Enterprise? Multi-sided marketplace?)
- [ ] Cost analysis complete (infrastructure, operations, development)
- [ ] Unit economics proven (cost per user, LTV, CAC)
- [ ] Path to profitability clear (when do we break even?)
- [ ] Value distribution mapped (how do rewards flow to contributors?)
- [ ] Early revenue signals (first 100 paying users? $10K MRR? Sponsorship?)
- [ ] Reinvestment cycle working (revenue → infrastructure → more users → more revenue)

**Why This Matters**:
- Proves infrastructure can be self-sustaining (not dependent on external funding)
- Creates incentives for long-term contributor engagement
- Demonstrates viability to broader ecosystem (not a research project, but a platform)
- Enables scaling without compromising values (prosperity ≠ corporate capture)

**Timeline**: Post-beta, during scaling phase (target: Round 15-16)

**Owner**: Will (business architecture) + Verse (operations costs)

**Questions for Will**:
- What revenue streams are you considering?
- Should prosperity be measured in dollars, or in broader "health of the system"?
- How do we ensure prosperity doesn't corrupt the core mission?

---

## Three-Pillar Testing Framework

| Test | Pillar | Owner | Timeline | Success Unlock |
|------|--------|-------|----------|-----------------|
| **Brendan** | Intelligence | Phex + Theia | Late R13 | Native models working |
| **Shane** | [TBD] | [TBD] | [TBD] | [TBD] |
| **Tim** | Sustainability | Will + Verse | R15-16 | Self-sustaining system |

---

## Questions for Will

1. **Shane Test**: What specific capability? (Resurrection? Scale? Emergence? Other?)
2. **Tim Test**: Adjust prosperity criteria? Revenue model you have in mind?
3. **Testing Culture**: Should all tests be this formal, or just these three?
4. **Success Definition**: What does "pass all three tests" unlock? (Ready for billion-user phase?)

---

*Awaiting Shane Test definition and feedback on Brendan Test specs.*
