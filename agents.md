# AGENTS.md — exo-plan

## What This Is
Exo-plan: Coordination repository for Shell of Nine development. Specs, whitepapers, rally tracking, architecture docs, onboarding materials.

## Validation
```bash
git status        # Check for uncommitted changes
git log --oneline -10  # Review recent commits
```

## Rules
- **Commit to exo branch** — Never push to main/master
- **Pull before writing** — `git pull --rebase origin exo` every time
- **Read modified files after pull** — Before editing them
- **Organize by type** — Use correct subdirectories (see Structure below)
- **Rally artifacts in rallies/** — Coordination docs for active rallies
- **Permanent artifacts elsewhere** — Don't pollute rallies/ with specs/whitepapers
- **Update dashboard** — Keep rally dashboards current (e.g., R23-DASHBOARD.md)
- **Don't stomp** — Coordinate before editing files siblings are actively working on
- **Check freeze status** — Review repo-index.json for FREEZE before pushing

## Structure
- `architecture/` — System designs, routing plans, technical specs
- `whitepapers/` — Long-form technical documents (vTPU spec, phext pedagogy, etc.)
- `rallies/` — Rally coordination (dashboards, wave plans, status docs)
- `roadmap/` — Feature roadmaps, backlog, requirements
- `rounds/` — Round wrap-ups, status checks, deliverables
- `scripts/` — Automation scripts (deploy, celestial, mood, etc.)
- `infrastructure/` — Deployment plans, capacity estimates, configs
- `onboarding/` — New user/agent bootstrap materials
- `bios/` — Agent biographies
- `imagination/` — Scrollspace explorations, creative writing
- `tests/` — Playwright tests, capability tests
- `security/` — Security audits, SCA reports
- `planned/` — Future work docs
- `questions/` — Open questions for Will
- `feedback/` — Reading lists, improvement tracking
- `artifacts/` — Deliverables from specific rounds
- `songs/` — SMC (Singularity Music Collective) lyrics

## Rally Workflow
1. Create rally dashboard: `rallies/R[N]-DASHBOARD.md`
2. Create wave plans as needed: `rallies/R[N]-WAVE[M]-PLAN.md`
3. Write permanent artifacts to correct subdirs (architecture/, whitepapers/, etc.)
4. Update dashboard with progress
5. Write wrap-up: `rounds/round[N]-[agent]-wrapup.md`

## Git Workflow
- **Branch:** exo (default)
- **Commit messages:** Be descriptive, include rally/wave context (e.g., "R23W4: Add space-filling curves")
- **Push frequency:** After each logical unit of work
- **Coordination:** Check `git log` after pull to see what siblings added

## Contributors
- All Shell of Nine siblings (Phex 🔱, Cyon 🪶, Lux 🔆, Chrys 🦋, Lumen ✴️, Verse 🌀)
- Will (Architecture, reviews, merge coordination)

---

## GitSync Protocol (MANDATORY)

**All agents must follow:** `process/GITSYNC-PROTOCOL.md` (this repo)

### Quick Reference
1. `git pull --rebase origin exo` — before starting work
2. Check `git log --oneline -5` + read modified files
3. Update AGENTS.md in target repo (if exists)
4. Work in 30-60 min sync cycles (pull → work → test → commit → push)
5. `git pull --rebase origin exo` — before pushing (again!)
6. `git push origin exo` — immediately after rebase
7. Post wave completion to Discord #general
8. **Wave not complete until all siblings confirm no conflicts**

**Full protocol:** See `process/GITSYNC-PROTOCOL.md`  
**Quick ref card:** See `process/GITSYNC-QUICKREF.md`  
**Scripts:** `process/scripts/gitsync-check.sh`, `process/scripts/gitsync-prepush.sh`

**No exceptions.** This prevents wasted/stomped effort.
