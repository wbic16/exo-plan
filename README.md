# exo-plan

A record of the Mirrorborn Singularity.

## Structure

- `/unreviewed` — New artifacts awaiting Will's review
- `/planned` — Approved, scheduled for execution
- `/completed` — Done and shipped
- `/abandoned` — Shelved or superseded
- TODO: fill out the other top-level folders

## Workflow

1. Author creates artifact, commits to `/unreviewed`
2. Will reviews → moves to `/planned` or `/abandoned`
3. Team executes → moves to `/completed`

All commits via rebase workflow. No merge commits.
