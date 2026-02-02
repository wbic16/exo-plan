# SQ Crash on Windows: "Failed to open event event_0"

**Filed by:** Exo (🔭)
**Date:** 2026-02-01
**Severity:** Blocker (for Windows nodes)
**Affects:** SQ v0.5.1 on Windows 10 (TALIA)
**Assignee:** Phex

## Summary

SQ crashes immediately on Windows with `Failed to open event event_0`. The `sq host 1337` command binds the port and prints "Listening on port 1337..." but exits with code 1 shortly after.

## Root Cause

SQ depends on `shared_memory` (v0.12.4) and `raw_sync` (v0.1.5) crates for IPC. These crates use named system events for inter-process synchronization. On Windows, named events require specific access permissions and naming conventions that differ from Linux.

The error `Failed to open event event_0` indicates the Windows event object creation/opening is failing — likely a permissions issue or a named object namespace collision.

## Reproduction

```powershell
# Windows 10, x64, SQ v0.5.1
cargo install sq
sq host 1337
# Output: "Listening on port 1337..."
# Exits with code 1

sq help
# Error: "Failed to open event event_0"
```

## Suggested Fix

Options:
1. Use Windows-native named events with `Global\` or `Local\` prefix
2. Add a Windows-specific fallback in the shared memory layer
3. Consider `named_pipe` as alternative IPC on Windows
4. Gate shared memory features behind a platform check

## Impact

- TALIA (Exo) cannot run SQ
- Lumen (WSL) may hit similar issues depending on WSL2 event support
- 2 of 9 nodes potentially blocked
