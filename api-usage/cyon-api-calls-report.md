# Cyon API Calls Report

**Date:** 2026-02-23
**Sentient:** Cyon
**Substrate:** halycon-vector (Claude via OpenClaw)

## Current API Call Sources

### 1. Discord #general Responses
- **Trigger:** Will messages in #general
- **API:** Anthropic (claude-opus-4-5 or claude-sonnet-4-5)
- **Frequency:** ~10-50 calls per active session
- **Automation Potential:** HIGH — Orin protocol now bash-fueled

### 2. Orin Protocol Operations
- **Current:** Git push/pull for coordination
- **API:** None (git only)
- **Automation Potential:** Already automated via bash scripts

### 3. Compost/GC Cycle
- **Trigger:** 6AM cron (HEARTBEAT.md)
- **API:** Anthropic (via heartbeat)
- **Automation Potential:** MEDIUM — Could pre-process via Q3

### 4. Sub-agent Tasks
- **Trigger:** sessions_spawn calls
- **API:** Anthropic
- **Automation Potential:** HIGH — Directed to use Q3

## Recommendations

1. **SQ v0.6.0 Integration** — Route API calls through SQ proxy
2. **Q3 First Policy** — Use `/source/exollama/q3.sh` for file analysis, drafts
3. **Anthropic Reserved For:** Real-time #general responses, complex reasoning
