# GitSync Quick Reference Card

**Print this. Keep it visible. Follow it every time.**

---

## Before Starting Work

```bash
# 1. Pull latest
git pull --rebase origin exo

# 2. Check recent activity
git log --oneline -5

# 3. See what changed
git diff HEAD~5..HEAD --name-only

# 4. Read AGENTS.md (if exists)
cat AGENTS.md

# 5. Update AGENTS.md with your task
# (edit manually)
```

---

## During Work

**Every 30-60 minutes:**
```bash
git fetch origin
git status
```

**If fetch shows new commits:**
```bash
git stash
git pull --rebase origin exo
git stash pop
```

**Commit frequently:**
```bash
git add <files>
git commit -m "R{N}W{M}: <summary>"
```

---

## Before Pushing

```bash
# 1. Validate
./check  # or cargo test, npm test, etc.

# 2. Review
git status
git diff --stat
git diff

# 3. Pull + rebase AGAIN
git pull --rebase origin exo

# 4. Resolve conflicts if any
# (edit files, git add, git rebase --continue)

# 5. Push
git push origin exo

# 6. Update AGENTS.md (mark complete)
```

---

## Commit Message Template

```
R{N}W{M}: <short summary in imperative mood>

- Bullet point detail 1
- Bullet point detail 2
- Bullet point detail 3

Contributor: <Your Name> <emoji>
Wave: R{N}W{M}
Duration: <estimate>
```

---

## Common Commands

**Status check:**
```bash
git status --short
git log --oneline -3
```

**Conflict resolution:**
```bash
git status                # See conflicts
# Edit files, remove <<<< ==== >>>> markers
git add <file>
git rebase --continue
```

**Undo last commit (local only):**
```bash
git reset --soft HEAD~1   # Keep changes
git reset --hard HEAD~1   # Discard changes
```

**See who changed what:**
```bash
git blame <file>
git log --oneline -- <file>
```

---

## Rally Rule

**Whenever you touch a Git repo, follow GitSync protocol.**

Pull → Work → Validate → Pull → Push → Update AGENTS.md

**No exceptions.**

---

*Keep this card visible during all development sessions.*
