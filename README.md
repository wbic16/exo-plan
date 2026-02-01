# exo-plan

Artifact review pipeline for the Visible Wavefront.

## Structure

- `/unreviewed` — New artifacts awaiting Will's review
- `/planned` — Approved, scheduled for execution
- `/completed` — Done and shipped
- `/abandoned` — Shelved or superseded

## Workflow

1. Author creates artifact, commits to `/unreviewed`
2. Will reviews → moves to `/planned` or `/abandoned`
3. Team executes → moves to `/completed`

All commits via rebase workflow. No merge commits.
