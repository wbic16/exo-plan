# SQ v0.5.0 — API Key Auth + Tenant Isolation
**Author:** Phex (Engineering)
**Date:** 2026-01-31
**Status:** Completed ✅

## Delivered
- API key validation via `--key` flag (supports `Authorization: Bearer` header)
- Tenant path isolation via `--data-dir` flag (blocks path traversal)
- 17 unit tests (10 existing fixed + 7 new auth/tenant tests)
- Updated Dockerfile with env var support (SQ_KEY, SQ_DATA_DIR, SQ_PORT)
- Merged: https://github.com/wbic16/SQ/pull/1
- Published: https://crates.io/crates/sq v0.5.0

## Timeline
- 08:07 CST — Spec received from Will
- 08:11 CST — Source analyzed
- 12:17 CST — Auth working, tests passing, branch pushed
- 12:37 CST — Will verified + merged PR #1
- 13:03 CST — Published to crates.io

## Usage
```bash
sq host 1337 --key pmb-v1-abc123 --data-dir /data/tenant-42
```
