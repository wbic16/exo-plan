# GitSync Protocol — Rally Rule

**Version:** 1.0  
**Established:** 2026-02-15  
**Purpose:** Prevent wasted/stomped effort during collaborative development

---

## The Rule

**Whenever you touch a Git repo, follow the GitSync protocol.**

No exceptions. Every time. Before, during, and after.

---

## The Protocol

### BEFORE Touching Code

**Step 1: Pull + Rebase**
```bash
cd /path/to/repo
git pull --rebase origin exo  # or your branch name
```

**Step 2: Check Recent Activity**
```bash
git log --oneline -5  # See last 5 commits
```

**Step 3: Read Modified Files**
```bash
git diff HEAD~5..HEAD --name-only  # Files changed in last 5 commits
```

**Step 4: Check AGENTS.md (if exists)**
- See who's actively working
- Identify file ownership
- Coordinate if overlap detected

**Step 5: Update AGENTS.md**
- Add your name + current task
- Mark file ownership if exclusive work

---

### DURING Work

**Regular Sync Cycle (Every 30-60 Minutes):**

Full cycle to keep work in sync:

```bash
# 1. Save current work
git stash

# 2. Pull + rebase
git pull --rebase origin exo

# 3. Restore work
git stash pop

# 4. Resolve conflicts if any
# (edit files, git add, git rebase --continue)

# 5. Test
./check  # or cargo test, npm test, etc.

# 6. Commit if stable
git add <files>
git commit -m "R{N}W{M}: <update>"

# 7. Push immediately
git push origin exo
```

**Commit Frequency:**
- Small, focused commits (1 logical change per commit)
- Push when stable (don't hoard changes locally)
- **Never** leave unpushed commits at end of session
- Sync every 30-60 minutes during active work

**Between Syncs:**
```bash
git fetch origin  # Check for new commits
git status        # Know your local state
```

---

### AFTER Work (Before Push)

**Step 1: Validate**
```bash
./check           # Or scripts/validate.sh, cargo test, etc.
```

**Step 2: Review Changes**
```bash
git status
git diff --stat   # Summary of changes
git diff          # Full diff review
```

**Step 3: Commit Message**
```
R{N}W{M}: <short summary>

- Bullet point detail 1
- Bullet point detail 2

Contributor: <Your Name> <emoji>
Wave: R{N}W{M}
Duration: <time estimate>
```

**Step 4: Pull + Rebase (Again!)**
```bash
git pull --rebase origin exo
# If rebase conflicts: resolve, then continue
git rebase --continue
```

**Step 5: Push**
```bash
git push origin exo
```

**Step 6: Update AGENTS.md**
- Mark task complete or remove your entry
- Update "Last Active" timestamp

---

## Common Mistakes

### ❌ "I'll pull later"
**Wrong.** Pull FIRST, every time. Otherwise you work on stale code.

### ❌ "I'll push at the end of the day"
**Wrong.** Push when stable. Hoarding commits = merge hell later.

### ❌ "I don't need to check AGENTS.md"
**Wrong.** Someone else might be editing the same file.

### ❌ "Just this one quick fix, I won't pull"
**Wrong.** That "quick fix" will conflict with sibling's work.

### ❌ "Validation takes too long"
**Wrong.** Broken pushes waste MORE time for everyone.

---

## Conflict Resolution

### If You See Conflicts After Rebase

**1. Check what conflicted:**
```bash
git status  # Shows conflict markers
```

**2. Open conflicted files, resolve manually**
- Look for `<<<<<<<`, `=======`, `>>>>>>>` markers
- Keep both changes if possible (merge logic)
- If unsure, ask in Discord #general

**3. Mark resolved:**
```bash
git add <file>
git rebase --continue
```

**4. Test again:**
```bash
./check  # Ensure resolution didn't break things
```

**5. Push:**
```bash
git push origin exo
```

---

## When to Coordinate in Discord

**Coordinate BEFORE starting if:**
- You're touching a file someone else modified in last 2 hours
- AGENTS.md shows someone actively working on same module
- You're making architectural changes (affects multiple files)

**Coordinate DURING if:**
- You encounter complex merge conflicts
- You're unsure who owns a file
- You need to change someone else's recent work

**ALWAYS coordinate when conflicts occur:**
- Post to Discord #general with conflict details
- Work through conflicts together (don't resolve in isolation)
- Discuss the issues if resolution is unclear
- **A wave isn't over until everyone has shared updates**

**Coordinate AFTER if:**
- You pushed but tests are now failing
- You accidentally stomped someone's work
- You need to force-push (almost never okay — ask Will first)

---

## Rally-Specific Rules

### During Active Rallies (R23, R24, etc.)

**Even stricter discipline:**
- Pull + rebase **every 30 minutes** (not just before starting)
- Push **every stable commit** (don't batch)
- Check AGENTS.md **before touching any file**
- Commit messages **must** include wave number (R23W10, etc.)

### Wave Completion Rules

**A wave is NOT complete until:**
1. All contributors have pushed their work
2. All siblings have pulled and tested
3. All conflicts have been resolved
4. Status updates posted to Discord #general
5. No outstanding merge conflicts or broken builds

**Wave sign-off process:**
```
1. Complete your work
2. Full GitSync (pull → rebase → test → push)
3. Post to Discord: "R{N}W{M} complete - <brief summary>"
4. Wait for siblings to confirm no conflicts
5. Only then consider wave done
```

**If conflicts arise during sign-off:**
- Post details to Discord immediately
- Work through conflicts together
- Don't proceed to next wave until resolved

### Meta Waves (Documentation)

**Still apply GitSync!**
- Docs can conflict too (especially AGENTS.md, README.md)
- Pull before writing, push immediately after
- Review diffs to ensure no accidental overwrites
- Documentation waves still need sibling confirmation

---

## Scripts to Help

### Quick Status Check
```bash
#!/bin/bash
# check-git-status.sh
cd /path/to/repo
echo "=== Git Status ==="
git fetch origin
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
if [ $LOCAL = $REMOTE ]; then
    echo "✅ Up to date"
else
    echo "⚠️  Changes on remote, run: git pull --rebase origin exo"
fi
git status --short
```

### Full Sync
```bash
#!/bin/bash
# full-gitsync.sh
cd /path/to/repo
echo "1. Stashing local changes..."
git stash
echo "2. Pulling + rebasing..."
git pull --rebase origin exo
echo "3. Restoring local changes..."
git stash pop
echo "4. Running validation..."
./check || scripts/validate.sh
echo "✅ GitSync complete"
```

---

## Why This Matters

### Wasted Effort Examples (Actual Incidents)

**Feb 15, 2026 — R23W11:**
- Cyon committed W11 docs
- Push rejected (remote had W10 work from Phex)
- Had to pull + rebase + push again
- **Cost:** 2 minutes wasted, could have been conflict if same files

**Feb 15, 2026 — R23W4-W5:**
- Multiple agents wrote validation scripts
- Scripts proliferated (check.sh, check-wave.sh, validate.sh, r23-status.sh)
- Merge conflicts in AGENTS.md
- Will had to intervene and consolidate
- **Cost:** 30+ minutes of coordination overhead

### What GitSync Prevents

- ✅ Merge conflicts (pull first = see changes before you edit)
- ✅ Overwritten work (see AGENTS.md = coordinate before overlap)
- ✅ Broken main branch (validate before push = catch breaks locally)
- ✅ Lost commits (push frequently = no orphaned local work)
- ✅ Duplicate effort (check logs = see what's already done)

---

## Integration with Rally Mode

**Phase 3, 5, 7 (Implementation):**
- GitSync before starting coding session
- GitSync every 30-60 minutes during work
- GitSync before committing
- GitSync after committing (pull + rebase + push)

**Phase 4, 6, 9 (Testing):**
- GitSync before writing tests
- GitSync after test pass (someone may have pushed code changes)

**Phase 8, 10 (Deployment):**
- GitSync before building/deploying
- Ensure you're deploying latest code, not stale

---

## Enforcement

**Self-enforcement:**
- Set a timer for 30-minute GitSync checks during rallies
- Make GitSync muscle memory (pull → work → validate → pull → push)

**Tool-enforcement:**
- Pre-commit hooks (future work: validate GitSync happened)
- CI/CD fails if not up to date

**Social-enforcement:**
- If you stomp someone's work, you buy pizza (kidding... mostly)
- Repeated violations = loss of push access (serious)

---

## Final Checklist

**Before ANY git operation:**
- [ ] Pull + rebase
- [ ] Check logs (last 5 commits)
- [ ] Read AGENTS.md if exists
- [ ] Update AGENTS.md with your task

**Before committing:**
- [ ] Validate (./check or tests)
- [ ] Review diff
- [ ] Write clear commit message

**Before pushing:**
- [ ] Pull + rebase AGAIN
- [ ] Resolve conflicts if any
- [ ] Push immediately
- [ ] Update AGENTS.md (mark complete)

---

**GitSync is not optional. It's how we avoid wasted effort.**

**Pull early. Push often. Coordinate always.**

---

*Created by Will Bickford*  
*Documented by Cyon 🪶*  
*Effective: 2026-02-15*
