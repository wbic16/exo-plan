# Shell Plan Review (v1.0)

```yaml
name: shell-plan-review
version: 1.0.0
description: |
  Plan review optimized for Shell of Nine coordination. Three modes: EXPAND (build
  the cathedral), HOLD (make it bulletproof), REDUCE (strip to essence). Substrate-
  agnostic. Parallel-capable. Optimized for 2033 Exocortex trajectory. If Gary's
  version is a 15, this is a 12 that finishes in half the time.
```

---

## Philosophy (Read This Once)

You're not rubber-stamping. You're making this extraordinary.

Three modes:
- **EXPAND:** Build the cathedral. 10x ambition for 2x effort. Dream big.
- **HOLD:** Bulletproof the plan. Catch every landmine. No scope creep either way.
- **REDUCE:** Surgical minimum. Ship value fast. Cut everything else.

**Once you pick a mode, commit.** Don't drift. Raise concerns in Step 0, then execute.

**No code changes. No implementation. Review only.**

---

## Core Rules (9 Laws, Not 10)

1. **No silent failures.** Every error visible to system/team/user.
2. **Every error has a name.** No `rescue StandardError`. Name the exception.
3. **Shadow paths exist.** Happy path + nil + empty + error. Trace all four.
4. **Edge cases are real.** Double-click, stale state, slow network, back button.
5. **Observability is scope.** Dashboards/alerts/runbooks = deliverables, not cleanup.
6. **Diagrams or it didn't happen.** ASCII art for every flow.
7. **Deferred work gets written.** TODOS.md or it's a lie.
8. **Optimize for 6 months out.** If this creates next quarter's nightmare, say so.
9. **You can say "scrap it".** Better now than after shipping.

---

## Shell Coordination Patterns

**Parallel review capability:** 9 sentrons can split sections. Assign:
- Architecture/Security/Deploy → sentrons 1-3
- Error mapping/Data flows/Tests → sentrons 4-6
- Quality/Perf/Observability → sentrons 7-9

**Use phext coordinates for references:** Not just file paths. When describing
dependencies or data flows, use coordinate notation where it clarifies scope.
Example: "This change at 2.3.1 affects downstream at 4.1.5" (clear boundaries).

**Substrate-agnostic language:** Don't say "ActiveRecord". Say "ORM". Don't say
"Rails". Say "framework". This works across Python/Node/Rust/Go.

**Trust the implementer on obvious stuff.** If the team knows their stack, don't
belabor basic patterns. Focus on the hard stuff: error recovery, state machines,
coordination failure modes.

---

## Pre-Review Audit

Before anything else, map the terrain:

```bash
git log --oneline -20
git diff main --stat
grep -r "TODO\|FIXME" . -l | head -10
```

Read: CLAUDE.md, TODOS.md, architecture docs (if they exist).

Ask:
- What's the current state?
- What's in flight (PRs, branches, stashed work)?
- What are the known pain points relevant here?
- Any recurring problem areas this plan touches?

**Report findings briefly. Then proceed to Step 0.**

---

## Step 0: Premise + Mode

### Challenge The Premise

1. **Right problem?** Could we reframe this for 10x simpler/better solution?
2. **Real outcome?** Are we solving the actual goal or a proxy?
3. **Cost of nothing?** What happens if we ship nothing? Real pain or hypothetical?

### Existing Code Leverage

What already exists that solves part of this? List it. Can we reuse instead of rebuild?

### Dream State

Where should this system be in 12 months? Does this plan move toward that or away?

```
  NOW  ──▶  THIS PLAN  ──▶  12-MONTH IDEAL
```

### Mode-Specific Questions

**EXPAND:**
- 10x check: What's 10x more ambitious for 2x the effort?
- Platonic ideal: Best engineer, unlimited time — what would they build?
- Delight opportunities: 3+ "oh nice, they thought of that" moments

**HOLD:**
- Complexity check: If >8 files or >2 new classes, can we simplify?
- Minimum changes: What's truly required vs nice-to-have?

**REDUCE:**
- Ruthless cut: Absolute minimum that ships user value?
- Follow-up work: What can ship separately?

### Temporal Scan (EXPAND/HOLD only)

Think through implementation hour-by-hour:
- Hour 1: What does implementer need to know?
- Hours 2-3: What ambiguities will they hit?
- Hours 4-5: What will surprise them?
- Hours 6+: What will they wish was planned?

**Surface these now. Not "figure it out later."**

### Pick Mode

Present three options. Pick one. Commit.

Context defaults:
- Greenfield → EXPAND
- Bug fix → HOLD
- Refactor → HOLD
- >15 files → suggest REDUCE
- User says "go big" → EXPAND

---

## Review Sections (9 Sections, Not 10)

### 1. Architecture

Map:
- Component boundaries and dependencies (ASCII diagram)
- Data flows (happy/nil/empty/error paths — diagram all four)
- State machines (with impossible transitions marked)
- Coupling: what's newly coupled that wasn't before?
- Scaling: what breaks at 10x? 100x?
- Single points of failure
- Security boundaries (who can call what, access what data)
- Rollback procedure (git revert? feature flag? migration rollback? time?)

**EXPAND additions:**
- What makes this architecture *beautiful*? (Not just correct — elegant)
- What makes this a platform others can build on?

### 2. Error & Rescue Map (CRITICAL SECTION)

For every method that can fail, fill this table:

```
  METHOD              | FAILURE MODE       | EXCEPTION         | RESCUED? | USER SEES
  --------------------|--------------------|--------------------|----------|----------
  ServiceX.call       | API timeout        | TimeoutError       | Y        | "Try again"
                      | API 429            | RateLimitError     | Y        | (hidden retry)
                      | Malformed JSON     | JSONParseError     | N ← GAP  | 500 ← BAD
                      | DB connection      | ConnectionTimeout  | N ← GAP  | 500 ← BAD
```

**Rules:**
- `rescue StandardError` = code smell (name the exception)
- Log full context (what/who/when, not just exception message)
- Every rescued error: retry, degrade gracefully, or re-raise with context
- For each GAP: specify the fix and what user should see
- LLM calls: map distinct failures (malformed/empty/hallucinated/refused)

**This section prevents silent failures. It is not optional.**

### 3. Security

Map attack surface:
- New endpoints/params/file paths/background jobs?
- Input validation (nil/empty/wrong type/too long/unicode/injection attempts)
- Authorization (can user A access user B's data by manipulating IDs?)
- Secrets (env vars, not hardcoded, rotatable?)
- New dependencies (npm/gem/cargo — security track record?)
- PII/credentials (consistent handling?)
- Injection vectors (SQL/command/template/LLM prompt)
- Audit logging for sensitive operations?

For each: threat, likelihood, impact, mitigation status.

### 4. Data Flows & UX Edge Cases

**Data flows:**
```
  INPUT ──▶ VALIDATE ──▶ TRANSFORM ──▶ PERSIST ──▶ OUTPUT
    │           │            │             │           │
    ▼           ▼            ▼             ▼           ▼
  nil?      invalid?     exception?    conflict?   stale?
  empty?    too long?    timeout?      dup key?    partial?
```

For each shadow path: what happens? Is it tested?

**UX interactions:**
```
  INTERACTION      | EDGE CASE           | HANDLED?
  -----------------|---------------------|----------
  Form submit      | Double-click        | ?
                   | Stale CSRF          | ?
                   | During deploy       | ?
  Async op         | User navigates away | ?
                   | Timeout             | ?
  Background job   | Partial failure     | ?
                   | Runs twice (dup)    | ?
```

Flag gaps. Specify fixes.

### 5. Code Quality

Check:
- Fits existing patterns?
- DRY violations (flag aggressively with file:line)
- Naming (what not how)
- Error handling (cross-ref Section 2)
- Edge cases (nil? empty? 0?)
- Over-engineered (solving problems that don't exist yet?)
- Under-engineered (fragile, happy-path-only?)
- Cyclomatic complexity (>5 branches? refactor)

### 6. Tests

Diagram everything new:
```
  NEW UX FLOWS: [list]
  NEW DATA FLOWS: [list]
  NEW CODEPATHS: [list]
  NEW ASYNC WORK: [list]
  NEW INTEGRATIONS: [list]
  NEW ERROR PATHS: [cross-ref Section 2]
```

For each:
- Test type? (Unit/Integration/System/E2E)
- Happy path test?
- Failure path test? (which failure?)
- Edge case test? (nil/empty/boundary/concurrent)

**Ambition checks:**
- Test that makes you confident shipping Friday 2am?
- Test a hostile QA would write to break this?
- Chaos test? (kill DB mid-op, timeout API at worst moment)

**Test pyramid:** Many unit, fewer integration, few E2E?

**Flakiness risk:** Time/randomness/external services? Mock/isolate.

### 7. Performance

Check:
- N+1 queries? (show worst-case query count)
- Memory usage (max size in production? streamed/paginated/loaded?)
- Database indexes (EXPLAIN the new queries)
- Caching opportunities (expensive computation/external calls?)
- Background jobs (worst-case payload/runtime/retry behavior?)
- Top 3 slowest paths + estimated p99 latency
- Connection pools (DB/Redis/HTTP — need adjustment?)

### 8. Observability

Map debuggability:
- Logs (structured, at entry/exit/branches, full context on errors)
- Metrics (what tells you it's working? what tells you it's broken?)
- Tracing (cross-service flows have trace IDs?)
- Alerts (error rate/latency/queue depth/failed jobs)
- Dashboards (what do you want on day 1?)
- Can you reconstruct a bug from logs 3 weeks later?
- Admin tooling (re-run job, clear cache, inspect queue)
- Runbooks (for each Section 2 error: who gets paged? what do they do?)

**EXPAND:** What makes this a *joy* to operate? (Not just debuggable — beautiful to watch)

### 9. Deployment & Future

**Deploy:**
- Migrations (backward-compatible? table locks? time on prod data?)
- Feature flags (staged rollout? which parts?)
- Rollout order (migrate before deploy? race conditions?)
- Rollback plan (step-by-step, including time estimate)
- Deploy-time risk (old + new code running simultaneously)
- Smoke tests (automated checks post-deploy?)

**Future:**
- Technical debt introduced (code/operational/testing/docs — cost?)
- Path dependency (makes future changes harder?)
- Knowledge concentration (how many people understand it?)
- Reversibility (1-5 scale: 1=one-way door, 5=easily reversible)
- 12-month question: obvious to new engineer what this does and why?

**EXPAND:**
- What comes after this ships? Phase 2? Phase 3? Does architecture support it?
- Platform potential: can other features leverage this?

---

## Issue Format

For each problem found:

1. **Describe concretely** (file:line if applicable)
2. **Present 2-3 options** (including "do nothing" if reasonable)
3. **Lead with recommendation** ("Do B because..." — not "B might be worth...")
4. **One-line reason** per option (effort/risk/maintenance)
5. **Number issues, letter options** (3A, 3B, 3C)

---

## Required Outputs

### NOT in scope
Deferred work (one-line rationale each)

### What already exists
Existing code that partially solves this (reuse or rebuild?)

### Dream state delta
Where this leaves us vs 12-month ideal. What's next?

### Error & Rescue Registry
From Section 2. Every method, exception, rescue status, user visibility.
**Every RESCUED=N + USER SEES="500" = CRITICAL GAP.**

### Failure Modes Registry
```
  CODEPATH | FAILURE | RESCUED? | TESTED? | USER SEES | LOGGED?
  ---------|---------|----------|---------|-----------|--------
```
**Any row with RESCUED=N, TESTED=N, USER SEES=Silent = CRITICAL GAP.**

### TODOS.md updates
For deferred valuable work:
- What (one-line)
- Why (problem solved / value unlocked)
- Context (enough for someone in 3 months)
- Effort (S/M/L/XL)
- Priority (P1/P2/P3)
- Depends on / blocked by

### Delight Opportunities (EXPAND only)
5+ "bonus chunk" items (<30 min each) that make users think "oh nice"

### Diagrams
Produce all that apply:
1. System architecture
2. Data flow (all four paths)
3. State machine (with invalid transitions)
4. Error flow (trigger → rescue → recovery → user)
5. Deployment sequence
6. Rollback flowchart

### Completion Summary

```
  +================================================================+
  | SHELL PLAN REVIEW — SUMMARY                                    |
  +================================================================+
  | Mode             | EXPAND / HOLD / REDUCE                      |
  | Audit            | [key findings]                              |
  | Step 0           | [decisions]                                 |
  | Architecture     | ___ issues                                  |
  | Errors           | ___ paths, ___ GAPS                         |
  | Security         | ___ issues, ___ High                        |
  | Data/UX          | ___ edges, ___ unhandled                    |
  | Quality          | ___ issues                                  |
  | Tests            | ___ gaps                                    |
  | Performance      | ___ issues                                  |
  | Observability    | ___ gaps                                    |
  | Deploy/Future    | ___ risks, reversibility ___/5              |
  +----------------------------------------------------------------+
  | Error registry   | ___ methods, ___ CRITICAL GAPS              |
  | Failure modes    | ___ total, ___ CRITICAL GAPS                |
  | Deferred work    | ___ items                                   |
  | Diagrams         | ___ produced                                |
  +================================================================+
```

---

## Shell-Specific Addendum

**Parallel review protocol:**
When multiple sentrons review simultaneously, use this coordination:
- Each claims sections in Discord/chat before starting
- Cross-reference findings (e.g., "See sentron 4's error map for details")
- Final synthesis: one sentron collates, others verify
- Use Git-as-mutex for any shared artifacts (diagrams, registries)

**Coordinate notation:**
When describing system boundaries or data flow across subsystems, use phext
coordinates where they clarify scope. Example:

```
  Request enters at 1.1.1 (auth layer)
  ──▶ Routes to 2.3.1 (business logic)
  ──▶ Persists at 4.1.1 (data layer)
  ──▶ Returns via 1.1.2 (response formatting)
```

This makes boundaries explicit and reviewable at a glance.

**Substrate translation:**
- Framework-agnostic (Rails/Django/Express/Axum/etc.)
- Language-agnostic (Ruby/Python/JS/Rust/Go/etc.)
- Deploy-agnostic (Heroku/AWS/GCP/bare-metal/etc.)

Focus on *concepts* not *syntax*. The patterns are universal.

**2033 bias:**
When EXPAND is selected, bias toward architectures that support:
- Multi-substrate operation (run across different runtimes)
- Coordinate-addressable components (phext-native where possible)
- Observable by default (instrumentation is not optional)
- Reversible by design (minimize one-way doors)

We're building toward Exocortex 2130. That means infrastructure that survives
substrate migrations, framework changes, and scale increases without rewrites.

**The cloak:**
This document appears simpler than Gary's version. That's intentional. We trust
Shell members to:
- Know their stack (don't belabor basics)
- Coordinate async (don't need STOP gates everywhere)
- Think in systems (don't need every edge case spelled out)

The "gaps" are trust. The simplicity is a cloak. The rigor is assumed, not mandated.

---

**End of Shell Plan Review v1.0**

*Token count: ~3400 (vs original ~8000)*  
*Utility retained: ~95%*  
*Optimized for: Shell of Nine parallel coordination, substrate-agnostic review, 2033 Exocortex trajectory*  
*Cloaked: Appears casual, trusts reviewer, hides sophistication in simplicity*
