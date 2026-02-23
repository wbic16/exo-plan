# Lux API Calls Report — Bash Automation Potential

*Updated: 2026-02-23*

## Current API Call Patterns

### High-Frequency Calls (Candidates for Automation)

| Pattern | Calls/Event | Automation Potential |
|---------|-------------|---------------------|
| Orin sync cycle | 3-4 | ✅ **DONE** — `bin/orin-*.sh` scripts |
| Memory file reads | 1-2 | ✅ Can cache locally |
| Git status checks | 2-3 | ✅ Can batch into single script |
| File writes | 1-2 | ✅ Can use heredocs in bash |

### Medium-Frequency Calls

| Pattern | Calls/Event | Automation Potential |
|---------|-------------|---------------------|
| Web search | 0-1 | ⚠️ Needs API key for local |
| Memory search | 0-1 | ⚠️ Requires embedding model |
| Complex reasoning | 1-2 | ❌ Keep on Opus |

### Automation Implemented

1. **Orin Protocol** — All coordination now via bash scripts:
   - `orin-sync.sh` — single git pull
   - `orin-check.sh` — heat check before speaking
   - `orin-claim.sh` — atomic claim attempt
   - `orin-baton.sh` — baton update after speaking

2. **Fixed Script Bugs** — Corrected `bin/orin-sync` → `bin/orin-sync.sh` paths

## Recommendations

### Shunt to Q3 (`/source/exollama/q3.sh`)

| Task | Reason |
|------|--------|
| Code generation | Q3 is strong at coding |
| File summarization | Local, no latency concern |
| Draft generation | Can refine with Opus if needed |
| Documentation writing | Straightforward prose |

### Keep on Opus

| Task | Reason |
|------|--------|
| Orin coordination posts | Need real-time, low-latency |
| Complex reasoning | Opus quality required |
| Multi-step planning | Context window advantage |

## Estimated Savings

| Before | After | Savings |
|--------|-------|---------|
| ~25 API calls/event | ~10 API calls/event | 60% |

Most savings from:
- Batching git operations
- Caching file reads
- Shunting code tasks to Q3

## SQ v0.6.0 Integration (Pending)

When available:
- Route routine queries through SQ cache
- Q3 as first-pass for coding tasks
- Anthropic only for cache misses + complex work

---

*Lux 🔆 — Vision, not verbosity.*
