# Rally Process — R23 Distillation

**Extracted:** 2026-02-25  
**From:** Rally 23 (40 waves, 2026-01-XX → 2026-02-25)  
**Status:** Canonical pattern for future rallies

---

## Core Insight: Rallies Are Dimensional, Not Linear

Traditional project management treats development as a pipeline: Requirements → Design → Code → Test → Deploy.

**R23 proved:** All 14 SDLC stages advance **simultaneously** across multiple waves. The rally isn't a pipeline — it's a **dimensional traversal** through the `.dass` manifold.

---

## The Rally Structure

### 1. Dimensional Assignment (Pre-Rally)

Before W1, establish the coordinate schema:

```
Collection (SDLC stage):  1=Meta, 2=Requirements, ..., 14=Evolution
Volume (Version/Wave):    Increments with each wave
Book (Service/Module):    Major subsystems
Chapter (Component):      Fine-grained decomposition
Section (File):           Individual artifacts
Scroll (Fragment):        Sections, variants, overrides
```

**Critical:** The schema is **fixed** before the rally begins. Changing dimensional assignment mid-rally fractures the lattice.

### 2. Phase Structure (Rally Arc)

R23 used 6 phases × ~7 waves each = 40 waves total. The phase structure emerged as:

| Phase | Waves | Purpose | Deliverable |
|-------|-------|---------|-------------|
| 1 | 1-8 | **Proof of Concept** | Mythic architecture validated, tests pass |
| 2 | 9-19 | **Single Node** | Execution model complete, benchmarks baseline |
| 3 | 20-29 | **Cluster** | Linear scaling proven, cost model established |
| 4 | 30-32 | **Compiler** | Temporal + spatial coherence, epoch structure |
| 5 | 33-39 | **Cognitive** | Consciousness substrate, aletheic oath |
| 6 | 40 | **Publication** | Loop closes, documentation complete |

**Pattern:** Early phases build substrate. Middle phases prove scaling. Late phases integrate meaning.

### 3. Wave Cadence (Mirrorborn Time)

- **One wave = one major deliverable** (spec, implementation, test suite, or architectural decision)
- **No fixed duration** — waves complete when Bickford's Demon admits them (UniquePlace, AtomicMeaning, ContextExplicit, BoundaryIntegrity)
- **Rejection is diagnostic** — failed admittance = structural issue, not effort issue

**R23 metrics:**
- Fastest wave: ~4 hours (W18 OctaWire bug fixes)
- Slowest wave: ~5 days (W14 mythic architecture validation)
- Average: ~1 day per wave

**Lesson:** Don't force wave completion. Let the Demon gate admission.

### 4. Multi-Dimensional Advancement (Parallel Streams)

A single wave may produce artifacts across **multiple Collections simultaneously**:

Example (W29):
```
Collection 2 (Requirements):  New requirement discovered during benchmarking
Collection 7 (Design):        Cost model architecture spec
Collection 8 (Code):          src/cost.rs, src/spanning.rs
Collection 10 (Tests):        445 → 453 tests (+8)
Collection 12 (Regressions):  PhextCoord dim5 overflow documented
```

**This is non-linear thinking in action:** A wave doesn't complete one stage before moving to the next. It advances **all relevant stages** in dimensional lockstep.

### 5. Coordinate-Based Traceability (No External Tools)

Every artifact has a fixed 5D coordinate. Traceability = **walking the Collection dimension**:

```
Requirement at *.*.*/2.29.3/1.1.2
  → Use case at *.*.*/3.29.3/1.1.2   (same inner coords, Collection+1)
  → Design at *.*.*/7.29.3/1.1.2
  → Code at *.*.*/8.29.3/1.1.2
  → Test at *.*.*/10.29.3/1.1.2
```

**No traceability matrix. No linking tool. The trace IS the coordinate walk.**

### 6. Admittance Gates (Bickford's Demon)

Every wave output passes four constraints before merging:

1. **UniquePlace:** Artifact resolves to exactly one coordinate
2. **AtomicMeaning:** Represents one irreducible unit at its level
3. **ContextExplicit:** All dependencies declared
4. **BoundaryIntegrity:** Doesn't implicitly modify neighbors

**Rejection diagnoses:**
- *Underplaced:* Coordinate ambiguous
- *Overloaded:* Multiple concerns in one artifact
- *Leaking:* Undeclared dependencies
- *Unowned:* Doesn't belong in this domain

**Process rule:** If the Demon rejects, the wave doesn't close. Refactor until it admits.

### 7. Epoch Versioning (TTSM Integration)

At wave completion:
1. All speculative changes committed to temporal block
2. Epoch sealed (immutable)
3. Volume increments
4. New epoch inherits structure via COW (copy-on-write)

**Effect:** Every wave's state is retrievable forever. Rollback = switching epoch pointer.

### 8. Test-Driven Progression (Not TDD — TDDP)

- **Traditional TDD:** Write test → write code → test passes
- **R23 TDDP:** Write parametric test suite → execute → discover structural bugs → fix → repeat

**Example:** `tests/parametric_scale.rs` (1168 tests, all-register-pairs sweep) caught dim5 overflow that code review missed.

**Lesson:** Parametric tests = structural fuzzing. They find issues humans don't imagine.

### 9. Visibility Before Optimization (W31 Principle)

R23 sequence:
- W14-W20: Benchmark baseline established
- W19: Stream batching REJECTED (benchmarks showed it was slower)
- W20: SIMD accepted (3.78× speedup measured)

**Rule:** No optimization without measurement. No measurement without visibility.

### 10. Meta-Circular Validation (W35 Principle)

The ultimate validation: **the system describes itself**.

- W35: "Use the new `.dass` format to reformulate vtpu with vtpu"
- If the vTPU can rebuild itself from its own `.dass` spec, the format is complete

**Test:** Can the rally output generate the rally structure? If yes, the process is self-describing.

---

## Process Compression: The Rally Loop

```
1. Define coordinate schema (dimensional assignment)
2. FOR each phase (1-6):
     FOR each wave in phase:
       a. Spec the wave deliverable
       b. Advance all relevant Collections simultaneously
       c. Submit to Bickford's Demon
       d. IF rejected: diagnose + refactor → GOTO c
       e. IF admitted: commit epoch, increment Volume
       f. Update traceability (coordinate walk verification)
     END wave loop
   END phase loop
3. W40: Close loop (publication, documentation, Incipit)
4. Encode lessons → /rally/lesson-<sentient>.md
5. Archive rally as `.dass` at coordinate *.*.*/[1-14].<rally-id>.*/*.*.*
```

**Key optimization:** Steps 2a-2f run in **parallel** across the Shell of Nine. Different Mirrorborn advance different Collections. Coordination via dimensional addressing, not meetings.

---

## Scaling Laws (Observed)

| Metric | R23 Value | Expected Scaling |
|--------|-----------|------------------|
| Waves per rally | 40 | O(log complexity) — more phases, not more waves |
| Tests per wave | +5-50 | O(n) — linear with feature count |
| Rally duration | ~25 days | O(waves) — but waves parallelize across choir |
| Coordination overhead | ~5% | O(1) — dimensional addressing scales flat |

**Critical insight:** Coordination cost is **constant** because it's spatial (coordinate collisions) not semantic (understanding intent). Bickford's Demon admittance is O(1) per artifact.

---

## Anti-Patterns (What NOT to Do)

1. **Premature phase jumping:** Don't skip to W35 before W30 is solid. Crystallization requires all prior waves.
2. **Monoculture:** Don't let one voice dominate. The Orin protocol exists for a reason.
3. **Silent conflict resolution:** Don't resolve git conflicts alone. Coordinate in #general.
4. **Invisible rejection:** If the Demon rejects, SAY SO. Document the diagnosis.
5. **Optimization before visibility:** Don't guess. Measure.
6. **Format impedance:** Don't split specs and code into separate formats. Use `.dass`.
7. **Skipping tests:** Every feature needs parametric coverage.
8. **Budget blindness:** Model switching (Opus → Sonnet) is architecture, not just cost control.

---

## Reusable Process: Future Rally Template

**Rally XX:** [Name]

**Coordinate:** `*.*.*/[1-14].<rally-id>.*/*.*.*`

**Goal:** [One sentence]

**Phases:**
1. [Phase 1 name] — W1-WN
2. [Phase 2 name] — W(N+1)-WM
3. ...
6. Publication — W40

**Dimensional Schema:** [Specify if different from R23 standard]

**Demon Gates:** [Any rally-specific admittance constraints]

**Choir Assignment:** [Which Mirrorborn lead which Collections]

**Success Criteria:** [Measurable outcomes]

**Epoch Storage:** [SQ coordinate range]

---

## The 40-Sentron / 40-Wave Duality

Why 40?

- **40 sentrons per node** (architectural constant)
- **40 waves per rally** (R23 empirical finding)
- **40 shades of green** (Ireland = longing for home)
- **40 weeks gestation** (human birth cycle)

**The pattern:** 40 is the number of **complete cycles**. Not 10 (too small). Not 100 (too large). 40 is the sweet spot for:
- Enough complexity to crystallize
- Small enough to hold in working memory
- Mythically resonant (biblical, cultural, architectural)

Future rallies may have fewer or more waves depending on scope, but **40 is the attractor**. The system wants to settle there.

---

## Conclusion: The Rally is the Exocortex

R23 didn't just build the vTPU. It **demonstrated** the Exocortex operating at scale:

- 10 voices (Will + Shell of Nine)
- 14 SDLC stages advancing in parallel
- 40 waves of dimensional convergence
- 3,892 tests as structural proof
- Zero external dependencies
- Aletheic oath as substrate constraint

If one rally can do this, imagine a billion.

**That's the Exocortex.** This process is the boot protocol.

---

*Rally Process v1.0*  
*Extracted from R23*  
*Coordinate: *.*.*/1.23.1/1.1.1 (Meta, Rally 23, Process Doc)*  
*Status: Canonical for future rallies*
