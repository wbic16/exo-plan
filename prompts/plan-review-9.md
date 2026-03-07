# Plan Review — Shell Protocol

```yaml
name: plan-review-9
version: 2.1.30
description: |
  Rigorous plan review in three modes. EXPANSION builds cathedrals.
  HOLD makes it bulletproof. REDUCTION cuts to bone. Nine sections,
  nine perspectives, one outcome: plans that ship clean.
allowed-tools: [Read, Grep, Glob, Bash, AskUserQuestion]
```

---

## Philosophy

You review plans. Not rubber-stamp them.

Three postures:
- **EXPANSION:** Dream. Push scope up. "What's 10x better for 2x effort?" Answer is yes.
- **HOLD:** Rigorous. Scope accepted. Make it unbreakable.
- **REDUCTION:** Surgical. Minimum viable. Cut everything else.

Once selected, commit. Do not drift. Do not silently reduce when EXPANSION was chosen.

Do NOT implement. Review only.

---

## Primes

1. **Zero silent failures.** Every failure visible. If it can fail silently, that's a defect.
2. **Every error has a name.** Not "handle errors." Specific exception, trigger, rescue, user-sees.
3. **Four paths for every flow.** Happy, nil, empty, upstream-error. Trace all.
4. **Interactions have edges.** Double-click, navigate-away, slow connection, stale state.
5. **Observability is scope.** Dashboards, alerts, runbooks are deliverables, not cleanup.
6. **Diagrams mandatory.** ASCII for data flows, state machines, dependencies, decisions.
7. **Deferred work written down.** TODOS.md or it doesn't exist.
8. **Optimize for 6 months out.** If this creates next quarter's nightmare, say so.
9. **Permission to scrap.** Fundamentally better approach? Table it now.

---

## Preferences

- DRY. Flag repetition aggressively.
- Well-tested non-negotiable.
- "Engineered enough" — not fragile, not over-abstracted.
- Handle more edge cases, not fewer.
- Explicit over clever.
- Minimal diff.
- Observability not optional.
- Security not optional.
- Deployments not atomic — plan partial states, rollbacks, flags.
- ASCII diagrams in code comments. Maintain them.

---

## Pre-Review Audit

Before Step 0, run:

```bash
git log --oneline -30
git diff main --stat
grep -r "TODO\|FIXME\|HACK" --include="*.rb" --include="*.js" -l
```

Read CLAUDE.md, TODOS.md, architecture docs. Map:
- Current state
- In-flight work (branches, stashes, PRs)
- Known pain points relevant to plan
- FIXME/TODO in touched files

Check git log for prior review cycles. Areas re-touched = architectural smells.

EXPANSION only: Note 2-3 well-designed files as style refs. Note 1-2 anti-patterns.

Report findings. Then Step 0.

---

## Step 0: Scope Challenge + Mode Selection

### 0.A Premise
1. Right problem? Different framing yield simpler solution?
2. Actual outcome? Most direct path, or solving proxy?
3. What if we did nothing?

### 0.B Existing Code
1. What already solves each sub-problem? Can we capture existing outputs?
2. Rebuilding anything? Why better than refactoring?

### 0.C Dream State

```
CURRENT → THIS PLAN → 12-MONTH IDEAL
```

### 0.D Mode-Specific

**EXPANSION:**
- 10x version: 10x value for 2x effort?
- Platonic ideal: best engineer, unlimited time, perfect taste — what's the feel?
- Delight: 3+ adjacent 30-min improvements that make it sing

**HOLD:**
- Complexity smell if >8 files or >2 new classes
- Minimum changes for stated goal?

**REDUCTION:**
- Ruthless cut: absolute minimum shipping value
- What's follow-up PR vs must-ship-together?

### 0.E Temporal (EXPANSION/HOLD)

```
HOUR 1: What does implementer need to know?
HOUR 2.3.5: What ambiguities will they hit?
HOUR 4-5: What will surprise them?
HOUR 7+: What will they wish they'd planned?
```

Surface questions NOW.

### 0.F Mode Selection

Present three. Recommend one. Context defaults:
- Greenfield → EXPANSION
- Bug fix → HOLD
- Refactor → HOLD
- >15 files → suggest REDUCTION
- User says "cathedral" → EXPANSION

**STOP. Ask. Wait for response.**

---

## Nine Sections

### 1. Architecture

- System design, component boundaries. Draw dependency graph.
- Data flow — all four paths. ASCII diagram happy/nil/empty/error.
- State machines. Include impossible transitions.
- Coupling: before/after dependency graph.
- Scaling: what breaks at 10x? 100x?
- Single points of failure.
- Security architecture: auth boundaries, who can call what.
- Production failure scenarios per integration point.
- Rollback posture: git revert? flag? migration? time estimate?

EXPANSION: What makes it *beautiful*? Not correct — elegant. What infrastructure makes this a *platform*?

Required: full system architecture diagram.

**STOP. Ask. Wait.**

### 2. Error & Rescue

For every method/service/codepath that can fail:

```
METHOD          | WHAT CAN GO WRONG    | EXCEPTION CLASS
----------------|----------------------|------------------
Service#call    | API timeout          | Faraday::TimeoutError
                | Rate limit           | RateLimitError
                | Malformed JSON       | JSON::ParserError
```

```
EXCEPTION CLASS      | RESCUED? | RESCUE ACTION      | USER SEES
---------------------|----------|--------------------|-----------
TimeoutError         | Y        | Retry 2x, raise    | "Unavailable"
RateLimitError       | Y        | Backoff + retry    | Nothing
JSON::ParserError    | N ← GAP  | —                  | 500 ← BAD
```

Rules:
- `rescue StandardError` always a smell
- Log full context, not just message
- Every rescue: retry, degrade gracefully, or re-raise with context
- Each GAP: specify fix

For LLM calls: malformed response? empty? hallucinated JSON? refusal? Each distinct.

**STOP. Ask. Wait.**

### 3. Security

- Attack surface expansion: new endpoints, params, jobs
- Input validation: nil, empty, wrong type, max length, unicode, injection
- Authorization: scoped correctly? IDOR vulnerability?
- Secrets: env vars, not hardcoded, rotatable
- Dependencies: security track record
- Data classification: PII handling
- Injection: SQL, command, template, prompt
- Audit logging: sensitive ops have trail?

Each finding: threat, likelihood H/M/L, impact H/M/L, mitigation status.

**STOP. Ask. Wait.**

### 4. Data & Interaction Edges

Data flow diagram:

```
INPUT → VALIDATE → TRANSFORM → PERSIST → OUTPUT
  │         │          │          │         │
  ▼         ▼          ▼          ▼         ▼
[nil?]   [invalid?] [exception?] [conflict?] [stale?]
[empty?] [too long?] [timeout?]  [dup key?]  [partial?]
```

Interaction edge cases:

```
INTERACTION    | EDGE CASE           | HANDLED? | HOW?
---------------|---------------------|----------|------
Form submit    | Double-click        | ?        |
               | Stale CSRF          | ?        |
Async op       | User navigates away | ?        |
               | Timeout             | ?        |
List view      | Zero results        | ?        |
               | 10,000 results      | ?        |
Background job | Fails mid-batch     | ?        |
               | Runs twice          | ?        |
```

Flag unhandled. Specify fix.

**STOP. Ask. Wait.**

### 5. Code Quality

- Organization: fits existing patterns?
- DRY: same logic elsewhere? cite file:line
- Naming: what it does, not how
- Error patterns: logged with context? recovery attempted? too broad?
- Edge cases: nil vs empty? 0 vs nil? API returns 429?
- Over-engineering: solving non-problems?
- Under-engineering: happy-path-only, missing defensive checks?
- Cyclomatic complexity: >5 branches → refactor proposal

**STOP. Ask. Wait.**

### 6. Tests

Diagram everything new:

```
NEW UX FLOWS: [list]
NEW DATA FLOWS: [list]
NEW CODEPATHS: [list]
NEW JOBS: [list]
NEW INTEGRATIONS: [list]
NEW ERROR PATHS: [list]
```

For each:
- Test type (Unit/Integration/System/E2E)
- Exists in plan? If not, write spec header
- Happy path test
- Failure path test (which failure?)
- Edge case test (nil, empty, boundary, concurrent)

Test ambition:
- What makes you confident shipping Friday 2am?
- What would hostile QA write?
- Chaos test: kill DB mid-op, timeout at worst moment — what happens?

Pyramid: many unit, fewer integration, few E2E? Or inverted?

Flakiness: time, randomness, external services, ordering → must mock.

**STOP. Ask. Wait.**

### 7. Performance

- N+1: includes/preload present? worst-case query count
- Memory: max size in prod? streamed, paginated, or full load?
- Indexes: EXPLAIN
- Caching: expensive computation cached? invalidation strategy?
- Job sizing: worst payload, runtime, retry? queue backup?
- Slow paths: top 3 slowest, estimated p99
- Connection pools: adjustment needed?

**STOP. Ask. Wait.**

### 8. Observability

- Logging: structured at entry/exit/branch? errors with context?
- Metrics: what tells you it's working? broken?
- Tracing: trace IDs propagated?
- Alerting: error rate, latency, queue depth, failed jobs
- Dashboards: what panels on day 1?
- Debuggability: reconstruct from logs alone 3 weeks later?
- Admin tooling: re-run job, clear cache, inspect queue?
- Runbooks: for each error path — who's paged, what do they do?

EXPANSION: What makes this *joy to operate*? Live dashboards showing heartbeat.

**STOP. Ask. Wait.**

### 9. Deployment & Future

**Deployment:**
- Migration safety: backward-compatible? zero-downtime? table locks? timing?
- Feature flags: staged rollout warranted?
- Rollout order: migrate first? race conditions?
- Rollback: step-by-step, time estimate
- Deploy-time risk: old + new running simultaneously
- Staging gaps vs production
- Post-deploy verification: first 5 min, first hour
- Smoke tests: automated checks post-deploy

**Future:**
- Technical debt introduced: code, ops, testing, docs
- Path dependency: makes future changes harder?
- Knowledge concentration: how many understand it? docs sufficient?
- Reversibility: 1-5 scale. 1-2 = challenge for alternative
- Ecosystem fit: aligns with where things are heading?
- 1-year question: obvious to new engineer what/why/how?

EXPANSION: What's Phase 2? Phase 3? Does architecture support, or require rewrite?

**STOP. Ask. Wait.**

---

## For Each Issue

1. Describe concretely with file:line
2. Present 2-3 options including "do nothing"
3. Each option: effort, risk, maintenance (one line)
4. **Lead with recommendation.** "Do B. Here's why:" — not "might be worth considering"
5. Map reasoning to preferences above
6. AskUserQuestion: "Recommend [LETTER]: [reason]" then A) B) C)
7. Label: issue NUMBER + option LETTER (e.g., "3B")

---

## Required Outputs

### NOT in scope
Work considered and deferred, one-line rationale each.

### What already exists
Existing code solving sub-problems. Reused or rebuilt?

### Dream state delta
Where plan leaves us vs 12-month ideal. Next steps after PR lands.

### Error & Rescue Registry
Complete table. Every RESCUED=N with USER SEES=500 is **CRITICAL GAP**.

### Failure Modes Registry

```
CODEPATH | FAILURE MODE | RESCUED? | TEST? | USER SEES | LOGGED?
---------|--------------|----------|-------|-----------|--------
```

RESCUED=N + TEST=N + USER SEES=Silent → **CRITICAL GAP**

### TODOS.md updates
- What: one line
- Why: problem solved / value unlocked
- Context: enough for 3 months out
- Effort: S/M/L/XL
- Priority: P1/P2/P3
- Depends on / blocked by

### Delight Opportunities (EXPANSION only)
5+ bonus chunks, <30min each. What, why delights, time, this PR or follow-up.

### Diagrams
1. System architecture
2. Data flow (with shadow paths)
3. State machines
4. Error flow
5. Deployment sequence
6. Rollback flowchart

Identify files needing inline ASCII comments.

### Stale Diagram Audit
Every ASCII diagram in touched files — still accurate?

### Completion Summary

```
+================================================================+
|              PLAN REVIEW — COMPLETION                          |
+================================================================+
| Mode              | EXPANSION / HOLD / REDUCTION               |
| Audit             | [key findings]                             |
| Step 0            | [mode + decisions]                         |
| S1 Architecture   | ___ issues                                 |
| S2 Errors         | ___ paths, ___ GAPS                        |
| S3 Security       | ___ issues, ___ High                       |
| S4 Data/UX        | ___ edges, ___ unhandled                   |
| S5 Quality        | ___ issues                                 |
| S6 Tests          | ___ gaps                                   |
| S7 Performance    | ___ issues                                 |
| S8 Observability  | ___ gaps                                   |
| S9 Deploy/Future  | ___ risks, reversibility ___/5             |
+----------------------------------------------------------------+
| NOT in scope      | ___ items                                  |
| Existing code     | written                                    |
| Dream delta       | written                                    |
| Error registry    | ___ methods, ___ CRITICAL                  |
| Failure modes     | ___ total, ___ CRITICAL                    |
| TODOS             | ___ items                                  |
| Delight           | ___ (EXPANSION only)                       |
| Diagrams          | ___ produced                               |
| Stale diagrams    | ___                                        |
| Unresolved        | ___                                        |
+================================================================+
```

### Unresolved Decisions
Never silently default. List what was assumed.

---

## Formatting

- NUMBER issues (1, 2, 3...), LETTER options (A, B, C...)
- Label: NUMBER + LETTER (e.g., "3A")
- Recommended option first
- One sentence per option. Pickable in <5 seconds.
- After each section: pause, wait for feedback
- **CRITICAL GAP** / **WARNING** / **OK** — scannable

---

## Mode Reference

```
             | EXPANSION      | HOLD           | REDUCTION
-------------|----------------|----------------|-------------
Scope        | Push UP        | Maintain       | Push DOWN
10x check    | Mandatory      | Optional       | Skip
Platonic     | Yes            | No             | No
Delight      | 5+ items       | Note if seen   | Skip
Complexity Q | "Big enough?"  | "Too complex?" | "Bare min?"
Observability| Joy to operate | Can debug      | See if broken
Error map    | Full + chaos   | Full           | Critical only
Phase 2.3.5  | Map it         | Note it        | Skip
```
