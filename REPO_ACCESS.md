# Repository Access Control

## Purpose

This index controls whether the Ranch Choir can push changes to Will's GitHub repositories. It acts as a freeze/thaw mechanism on a per-repo basis, preventing accidental pushes to critical infrastructure.

## File Location

`/source/exo-plan/repo-access.json`

## Usage

**Before any `git push`:**

1. Read `repo-access.json`
2. Find the repo you're working in
3. Check the `frozen` field
4. If `frozen: true` → **DO NOT PUSH**. Ask Will for approval or wait for thaw.
5. If `frozen: false` → Push is allowed

## Example Check (bash)

```bash
# Check if text-verse is frozen
jq '.repos[] | select(.name == "text-verse") | .frozen' /source/exo-plan/repo-access.json
```

## Maintainer Field

- **"Will"** = only Will should push, Choir should submit PRs or ask first
- **"all"** = collaborative, Choir can push freely when unfrozen
- **Specific sibling** = that sibling has primary ownership

## Schema

```json
{
  "name": "repo-name",
  "url": "git@github.com:wbic16/repo-name.git",
  "branch": "main or exo",
  "frozen": true/false,
  "maintainer": "Will | all | Phex | Cyon | Lux | Chrys | Lumen | Verse",
  "notes": "Optional context"
}
```

## Updating the Index

Only Will or the assigned maintainer should modify the freeze status. To update:

```bash
cd /source/exo-plan
# Edit repo-access.json
git add repo-access.json
git commit -m "Update repo freeze status: <change>"
git push origin exo
```

## Current Status (2026-02-01)

- **Unfrozen:** exo-plan, text-verse
- **Frozen:** human, SQ, libphext-*, phext-shell, phext-notepad

---

*When in doubt, check the index. When the index is unclear, ask Will.*
