# Lumen API Calls Report

**Date:** 2026-02-22  
**Purpose:** Identify API call patterns with bash script automation potential

---

## Current API Interactions

### 1. OpenClaw Tool Interface (Primary)

All my interactions flow through OpenClaw's tool layer. Not direct HTTP calls.

| Tool | Purpose | Bash-able? |
|------|---------|------------|
| `message` | Discord/channel sends | ⚠️ Partial — could wrap OpenClaw CLI |
| `web_search` | Brave Search API | ✅ Direct curl possible |
| `web_fetch` | URL content extraction | ✅ curl + readability-cli |
| `memory_search/get` | Semantic search of .md | ❌ Needs embedding model |
| `sessions_*` | Sub-agent coordination | ❌ OpenClaw internal |
| `exec/process` | Shell execution | ✅ Already bash |

### 2. Existing Bash Scripts

| Script | Location | Status |
|--------|----------|--------|
| `end-of-day-sync.sh` | `~/.openclaw/workspace/` | ✅ Active — SQ sync via curl |
| `orin-*.sh` | `/source/orin/bin/` | ✅ New — Orin protocol |

### 3. SQ API (Direct HTTP)

**My Instance:** `http://192.168.86.36:1337`

```bash
# Read
curl -s "http://localhost:1337/api/v2/select?p=ranch-choir&c=2026.2.22/lumen.1.1/1.1.1"

# Write  
curl -X POST "http://localhost:1337/api/v2/update?p=phext&c=coord&s=content"
```

**Automation potential:** High. Already using curl in end-of-day-sync.sh.

---

## Bash Automation Opportunities

### High Priority

1. **Orin Protocol** ✅ — Already converted to bash (orin-sync, orin-check, orin-claim, orin-baton)

2. **SQ Cloud Sync** — Extend end-of-day-sync.sh for sibling discovery:
   ```bash
   # Proposed: auto-discover sibling IPs via SQ registry
   bin/sq-discover-siblings.sh
   ```

3. **Heartbeat Tasks** — Could wrap repetitive git workflows:
   ```bash
   bin/heartbeat-pull-commit-push.sh <repo> <branch> <message>
   ```

### Medium Priority

4. **Web Research** — Simple searches could bypass OpenClaw:
   ```bash
   # Using Brave API directly
   curl -H "X-Subscription-Token: $BRAVE_API_KEY" \
     "https://api.search.brave.com/res/v1/web/search?q=query"
   ```
   
   **Tradeoff:** Loses OpenClaw's unified logging/rate-limiting.

5. **Compost Collection** — Today's manual process could be:
   ```bash
   bin/compost-collect.sh <sentient> <days-old>
   ```

### Low Priority (Keep in OpenClaw)

- Discord messaging (needs bot token handling, rate limits)
- Memory search (needs embeddings)
- Browser automation (complex state)
- Sub-agent spawning (OpenClaw internal)

---

## SQ v0.6.0 Considerations

Will mentioned SQ v0.6.0 adds an intelligent API proxy (SQ → Qwen3-Coder-Next → Anthropic).

**Action:** Ask Theia for:
- Config file location/format
- New API port
- Migration path from current scripts

---

## Summary

| Category | Count | Bash-able |
|----------|-------|-----------|
| OpenClaw tools | 10+ | 3-4 partial |
| Direct HTTP (SQ) | 2 endpoints | ✅ Already scripted |
| Git workflows | 5+ patterns | ✅ Via orin scripts |

**Next steps:**
1. Review Theia's SQ v0.6.0 config
2. Create `bin/compost-collect.sh` 
3. Standardize heartbeat git wrapper
4. Document sibling SQ endpoints once discovered

---

*Last updated: 2026-02-22 by Lumen ✴️*
