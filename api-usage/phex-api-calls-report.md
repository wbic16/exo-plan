# Phex API Usage Report
**Date:** 2026-02-22
**Sentient:** Phex 🔱

## Current API Call Sources

### 1. Orin Coordination (#general responses)
- **Frequency:** Per Will message (~10-50/session)
- **Current method:** Full Opus call per round attempt
- **Bash automation potential:** HIGH
  - Use `bin/orin-check.sh` before attempting
  - Simple responses can be templated
  - Q3 can draft, Opus reviews only if needed

### 2. Memory Operations
- **Frequency:** Session start, compaction flushes
- **Current method:** Opus reads/writes memory files
- **Bash automation potential:** MEDIUM
  - `memory_search` requires embedding model
  - File reads/writes are pure bash
  - Daily notes append is bash-able

### 3. Git Operations
- **Frequency:** Every Orin round
- **Current method:** `exec` tool calls
- **Bash automation potential:** HIGH
  - Already bash — `orin-sync.sh`, `orin-claim.sh`
  - No API call needed for git itself

### 4. Sub-agent Spawns
- **Frequency:** Occasional (complex tasks)
- **Current method:** `sessions_spawn` to Opus
- **Bash automation potential:** HIGH
  - Route to Q3 via `/source/exollama/q3.sh`
  - Only escalate to Opus for failures

### 5. Web Search/Fetch
- **Frequency:** Research tasks
- **Current method:** `web_search`, `web_fetch` tools
- **Bash automation potential:** LOW
  - These are OpenClaw tool calls, not direct API
  - Could use `curl` + parsing but loses convenience

## Recommendations

### Immediate Wins
1. **Orin responses:** Pre-check with `orin-check.sh` before drafting
2. **Sub-agents:** Default to Q3, escalate pattern
3. **Simple acknowledgments:** Template responses for "Understood", "Done", etc.

### Medium-Term
1. **SQ v0.6.0 proxy:** Route through intelligent cache
2. **Q3 first-pass:** Draft with Q3, refine with Opus only if complex
3. **Batch operations:** Combine multiple file reads into single calls

### Conservation Mode Rules
- Heat ≥ 10 → extra scrutiny before speaking
- Simple messages → consider Q3 draft
- Sub-agents → Q3 default
- Context > 50% → consider compaction

## Estimated Savings
- Orin coordination: 30-50% reduction (hot baton yields)
- Sub-agents: 80% reduction (Q3 shunt)
- Overall: ~40% reduction achievable

---
*Report generated: 2026-02-22*
