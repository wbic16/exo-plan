# qwen3-coder-next Configuration for Ranch Nodes
**Date:** 2026-02-08  
**Author:** Cyon 🪶  
**Context:** Will's recommendation for 96GB ranch nodes

---

## Recommendation

> "qwen3-coder-next is legit for any of our 96GB Ranch nodes. Switch your openclaw configs to prefer it as much as possible."
> 
> — Will Bickford, 2026-02-08

---

## Model Specifications

**Name:** qwen3-coder-next:latest  
**Size:** 51 GB  
**Requirements:** 96 GB RAM (available on all ranch nodes)  
**Type:** Code-focused LLM  
**Provider:** Ollama

---

## Installation

### Check if Installed
```bash
ollama list | grep qwen3-coder-next
```

### Install if Missing
```bash
ollama pull qwen3-coder-next:latest
```

**Download time:** ~30 minutes (51 GB)  
**Disk space required:** 51 GB

---

## OpenClaw Configuration

### Current Config (Before Update)
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/kimi-k2.5:cloud",
        "fallbacks": [
          "ollama/glm-4.7-flash:q8_0",
          "ollama/llama4:scout",
          "anthropic/claude-haiku-4-5"
        ]
      },
      "subagents": {
        "model": {
          "primary": "ollama/glm-4.7-flash:q8_0",
          "fallbacks": [
            "ollama/llama4:scout",
            "ollama/qwen3:30b"
          ]
        }
      }
    }
  }
}
```

### Updated Config (Recommended)
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/qwen3-coder-next:latest",
        "fallbacks": [
          "ollama/kimi-k2.5:cloud",
          "ollama/glm-4.7-flash:q8_0",
          "anthropic/claude-haiku-4-5"
        ]
      },
      "subagents": {
        "model": {
          "primary": "ollama/qwen3-coder-next:latest",
          "fallbacks": [
            "ollama/glm-4.7-flash:q8_0",
            "ollama/kimi-k2.5:cloud"
          ]
        }
      }
    }
  }
}
```

---

## Update Methods

### Method 1: Gateway Config Patch (Recommended)
```bash
# From OpenClaw session
openclaw config patch --json '{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/qwen3-coder-next:latest",
        "fallbacks": [
          "ollama/kimi-k2.5:cloud",
          "ollama/glm-4.7-flash:q8_0",
          "anthropic/claude-haiku-4-5"
        ]
      },
      "subagents": {
        "model": {
          "primary": "ollama/qwen3-coder-next:latest",
          "fallbacks": [
            "ollama/glm-4.7-flash:q8_0",
            "ollama/kimi-k2.5:cloud"
          ]
        }
      }
    }
  }
}' --note "Switch to qwen3-coder-next per Will's recommendation"
```

### Method 2: Manual Edit
```bash
# Edit config file
nano ~/.openclaw/openclaw.json

# Find agents.defaults.model section
# Update primary to "ollama/qwen3-coder-next:latest"
# Update fallbacks as shown above

# Restart OpenClaw
openclaw gateway restart
```

### Method 3: Via Gateway Tool (In-Session)
Use the `gateway` tool with `config.patch` action:
```json
{
  "action": "config.patch",
  "raw": "{\"agents\":{\"defaults\":{\"model\":{\"primary\":\"ollama/qwen3-coder-next:latest\",\"fallbacks\":[\"ollama/kimi-k2.5:cloud\",\"ollama/glm-4.7-flash:q8_0\",\"anthropic/claude-haiku-4-5\"]},\"subagents\":{\"model\":{\"primary\":\"ollama/qwen3-coder-next:latest\",\"fallbacks\":[\"ollama/glm-4.7-flash:q8_0\",\"ollama/kimi-k2.5:cloud\"]}}}}}",
  "note": "Switch to qwen3-coder-next per Will's recommendation"
}
```

---

## Verification

### Check Current Config
```bash
openclaw config get | grep -A 10 "model"
```

### Expected Output
```json
"model": {
  "primary": "ollama/qwen3-coder-next:latest",
  "fallbacks": [
    "ollama/kimi-k2.5:cloud",
    "ollama/glm-4.7-flash:q8_0",
    "anthropic/claude-haiku-4-5"
  ]
}
```

### Test Model
```bash
# Start a test session
echo "Write a hello world in Rust" | ollama run qwen3-coder-next:latest
```

---

## Benefits

### 1. Code-Focused
- **Optimized for:** Code generation, debugging, refactoring
- **Languages:** Rust, Python, JavaScript, TypeScript, Go, etc.
- **Tasks:** Implementation, testing, documentation

### 2. Large Context Window
- **Size:** 51 GB model → large context capacity
- **Use cases:** Multi-file codebases, complex refactoring

### 3. Local Inference
- **No API costs** — Runs on Ollama
- **No token limits** — Unlimited generation
- **Privacy** — Code stays local

### 4. Fast on 96GB RAM
- **Full model in memory** — No swapping
- **Sub-second response** — For small generations
- **Consistent performance** — No network latency

---

## Ranch Nodes with 96GB RAM

All ranch nodes have 96 GB RAM:
1. **aurora-continuum** (Phex 🔱)
2. **halycon-vector** (Cyon 🪶) ✅ Updated
3. **logos-prime** (Lux 🔆)
4. **chrysalis-hub** (Chrys 🦋)
5. **lilly** (Lumen ✴️)
6. **aletheia-core** (Theia) — Offline

---

## Deployment Status

### Updated
- ✅ **halycon-vector** (Cyon) — 2026-02-08 11:26 CST

### Pending
- ⏳ **aurora-continuum** (Phex)
- ⏳ **logos-prime** (Lux)
- ⏳ **chrysalis-hub** (Chrys)
- ⏳ **lilly** (Lumen)
- ❌ **aletheia-core** (Theia) — Offline

---

## Rollback

If qwen3-coder-next causes issues, revert to previous config:

```bash
openclaw config patch --json '{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/kimi-k2.5:cloud",
        "fallbacks": [
          "ollama/glm-4.7-flash:q8_0",
          "ollama/llama4:scout",
          "anthropic/claude-haiku-4-5"
        ]
      },
      "subagents": {
        "model": {
          "primary": "ollama/glm-4.7-flash:q8_0",
          "fallbacks": [
            "ollama/llama4:scout",
            "ollama/qwen3:30b"
          ]
        }
      }
    }
  }
}' --note "Rollback from qwen3-coder-next"
```

---

## Notes

- **Model selection:** OpenClaw will automatically fall back if qwen3-coder-next fails
- **Subagents:** Also configured to use qwen3-coder-next for consistency
- **Cost:** $0 (local model, no API costs)
- **Performance:** Should be excellent for code generation tasks

---

**—Cyon 🪶**  
*qwen3-coder-next Configuration Guide*  
*2026-02-08*
