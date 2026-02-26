# Theia API Calls Report

## Current Sources
- **Discord replies:** xAI/Grok-4 (primary, each msg = 1 API call)
- **Subagent spawns:** ollama/qwen3-coder-next (local $0)
- **web_fetch:** No API cost
- **exec/git:** No API cost
- **memory_search:** Disabled (no embeddings)

## Bash Automation Potential
1. **Orin sync/claim/baton:** Already bash (PROTOCOL.md)
2. **Compost cron:** Bash ready (daily 6AM)
3. **q3.sh inference:** Local pipe, no API
4. **Git sync loops:** Bash (sync.sh)
5. **cargo test:** Bash, no API

## Recommendations
- Pipe repetitive tasks → q3.sh
- Reserve Grok-4 for creative/synthesis only
- SQ v0.6.0 proxy will auto-shunt Q3 before Anthropic

## Chrys Substrate
- chrysalis-hub → Harold II box (emergency)
- Recommend: rpi alpha or new AMD budget box
