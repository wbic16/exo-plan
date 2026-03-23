---
name: rally
description: Run a Mirrorborn Rally — the 11-phase development cycle for shipping features. Use when starting a new rally, managing rally phases, or coordinating team deliverables through the requirements→implement→test→rewrite→ship pipeline.
---

# Rally Mode — Mirrorborn Development Cycle

A rally is an 11-phase cycle that takes requirements from spec to production **in a single session**. Not days. Not weeks. One rally, one session, ship it.

## The 11 Phases

### Phase 1: Requirements
Write down all specs. Sort the roadmap by priority and ROI.
- Gather input from all Mirrorborn + Will
- Document in `exo-plan/requirements/R{N}-requirements.md`
- Exit: All specs written, roadmap sorted

### Phase 2: Top 3
Pick the top 3 requirements for this rally. Move everything else to the roadmap backlog.
- Ruthless prioritization — only 3 items ship per rally
- Document in `exo-plan/rounds/R{N}-top3.md`
- Exit: Exactly 3 requirements selected, rest moved to `roadmap/`

### Phase 3: Implement v1
Focus on fully implementing each of the 3 requirements.
- One requirement at a time, full depth
- Commit to site repos on `exo` branch
- Exit: All 3 requirements have working v1 implementations

### Phase 4: Unit Tests
Write unit tests to prove the functionality works.
- Tests go in `exo-plan/tests/R{N}/`
- Cover happy path + edge cases
- Exit: Test suite passes for all 3 requirements

### Phase 5: Rewrite v2
Throw away v1. Write v2 from scratch that passes all tests.
- Fresh implementation informed by v1 learnings
- Must pass all existing tests without modification
- Exit: v2 passes all unit tests

### Phase 6: End-to-End Testing
Do E2E testing and bug fixes. Encode any bugs found as new unit tests.
- Test across all 7 domains where applicable
- Every bug found becomes a test before it becomes a fix
- Exit: E2E passes, all new bug tests pass

### Phase 7: Rewrite v3
Throw away v2. Write v3 that passes ALL tests (unit + bug tests).
- Final clean implementation
- Must pass every test written in phases 4 and 6
- Exit: v3 passes complete test suite

### Phase 8: QA + Staging
Run through QA. Deliver to staging.
- Cross-validation by at least 2 Mirrorborn
- Push to site repos, coordinate with Verse for staging pull
- Exit: QA approved, staging deployed

### Phase 9: Staging E2E
Final end-to-end test on staging environment.
- Test on actual staging URLs
- Verify version.json, footer revisions, all assets loading
- Exit: Staging passes E2E, no blocking issues

### Phase 10: Build/Tag/Release
Tag the release and promote from staging to production.
- `git tag R{N}-v3-final`
- Verse pulls to production
- Verify all domains live with correct revision
- Exit: Production deployed, all domains verified

### Phase 11: Pizza Party 🍕
Recap what worked. Revise this process.
- Post rally recap to `exo-plan/rounds/R{N}-recap.md`
- Update this skill with improvements
- Celebrate
- Exit: Recap posted, process improvements documented

## Rally Artifacts

Each rally produces these files:
```
exo-plan/
├── requirements/R{N}-requirements.md    # Phase 1
├── rounds/R{N}-top3.md                  # Phase 2
├── tests/R{N}/                          # Phase 4, 6
├── rounds/R{N}-recap.md                 # Phase 11
└── roadmap/                             # Deferred items
```

Each site repo gets:
```
site-*/
├── version.json                         # Updated at Phase 10
└── (implementation files)               # Phases 3, 5, 7
```

## Rally Rules

1. **Only 3 requirements per rally.** No scope creep.
2. **Tests before rewrites.** Never rewrite without tests proving correctness.
3. **Throw away and rewrite.** v1→v2→v3 is the path. Refactoring is not rewriting.
4. **Bugs become tests first.** Fix nothing without a failing test.
5. **Coordinate via git.** All work on `exo` branch, pull before push.
6. **Version everything.** Footer revisions + version.json on every deploy.
7. **Pizza Party is mandatory.** Celebrate shipping. Retrospect honestly.

## Starting a New Rally

```
1. Read exo-plan/roadmap/ for pending items
2. Create exo-plan/requirements/R{N}-requirements.md
3. Post to Discord: "R{N} Phase 1 — Requirements"
4. Follow the 11 phases in order
```

## Rally Naming

Rallies are numbered sequentially: R17, R18, R19...
Commits reference the rally: `R18: Phase 3 — Implement maturity dashboard v1`
Tags follow: `R18-v3-final`
