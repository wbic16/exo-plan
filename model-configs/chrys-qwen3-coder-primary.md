# Chrys Model Config Update — 2026-02-08

**Change:** Switched from Claude-primary to qwen3-coder-next-primary

## New Configuration

**Primary model:** `ollama/qwen3-coder-next:latest` (alias: `qwen3-coder`)  
**Fallback order:**
1. `anthropic/claude-sonnet-4-5` (alias: `sonnet`)
2. `ollama/deepseek-r1:8b`
3. `ollama/glm4:latest`

## Rationale

Per Will: "Almost all use cases can leverage qwen3-coder-next."

**Benefits:**
- **Local-first:** Reduces token burn on Claude (important given 59% weekly burn on Day 3)
- **96GB node:** qwen3-coder (51 GB) fits comfortably on chrysalis-hub (92 GB RAM)
- **Fast:** No network latency for most tasks
- **Context:** 128K tokens (sufficient for most work)
- **Fallback to Claude:** Still available for complex reasoning/coordination

## Model Specs

**qwen3-coder-next:latest**
- Size: 51 GB
- Context: 128,000 tokens
- Max tokens: 8,192
- Streaming: disabled
- Cost: $0 (local)

## Use Cases

**Use qwen3-coder for:**
- Code generation (R17 implementation, SQ patches)
- File operations (read, write, edit)
- Shell commands (exec, process)
- Git operations
- Documentation writing
- API calls
- Most analysis/research

**Escalate to Claude (sonnet/opus) for:**
- Complex multi-step reasoning
- Deep strategic planning
- Cross-sibling coordination (Discord replies)
- Mythic/creative work (songs, imagination catalogs)
- High-stakes decisions

## Config Location

`/home/wbic16/.openclaw/openclaw.json`

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "qwen3-coder",
        "fallbacks": ["sonnet", "ollama/deepseek-r1:8b", "ollama/glm4:latest"]
      }
    }
  }
}
```

## Testing

After next OpenClaw restart, verify:
```bash
# Check which model is being used
openclaw status | grep -i model

# Test qwen3-coder directly
ollama run qwen3-coder-next:latest "Write a bash function to print Hello World"
```

## Token Savings Estimate

**Current burn rate:**
- Week of 2026-02-01: 59% by Day 3 (9x designed capacity)
- Opus round-robin: :30-:39 each hour (Chrys slot)

**Expected savings with qwen3-coder primary:**
- Estimate: 70-80% of requests can use local model
- Claude reserved for high-value reasoning
- Should reduce weekly burn to sustainable levels

## Coordination

All ranch nodes (96GB RAM) should consider this switch:
- Chrysalis-Hub (Chrys) ✅ Updated
- Aurora-Continuum (Phex) — recommend
- Logos-Prime (Lux) — recommend
- Halcyon-Vector (Cyon) — recommend
- Aletheia-Core (Theia) — recommend (when online)

Lilly (Will's laptop) may need different config (RAM constraints).

---

**Updated by:** Chrys 🦋  
**Date:** 2026-02-08 11:28 CST  
**Status:** Config updated, awaiting gateway restart
