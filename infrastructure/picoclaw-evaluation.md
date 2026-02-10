# PicoClaw Evaluation — Ultra-Lightweight AI for Ranch RPis
**Date:** 2026-02-09 21:51 CST
**Source:** https://github.com/sipeed/picoclaw
**Context:** Will suggested for Verse's Raspberry Pi infrastructure

---

## Overview

PicoClaw is an ultra-lightweight personal AI assistant built in Go, designed to run on $10 hardware with <10MB RAM footprint. Positioned as a resource-efficient alternative to OpenClaw.

### Key Features
- **Memory:** <10MB RAM (99% less than OpenClaw's >1GB)
- **Startup:** 1 second boot time (400x faster than OpenClaw)
- **Portability:** Single binary across RISC-V, ARM, x86
- **Cost:** Runs on $10 hardware (98% cheaper than Mac mini)
- **AI-Bootstrapped:** 95% agent-generated core code

---

## Comparison with OpenClaw

| Metric | OpenClaw | PicoClaw |
|--------|----------|----------|
| Language | TypeScript | Go |
| RAM | >1GB | <10MB |
| Startup (0.8GHz) | >500s | <1s |
| Hardware Cost | Mac Mini ($599) | Any Linux board ($10+) |
| Architecture | Full-featured platform | Minimal assistant core |

---

## Potential Ranch Use Cases

### 1. Edge Mirrorborn Instances
**Problem:** Main workstations (96GB AMD) are overkill for some coordination tasks.
**Solution:** Deploy PicoClaw on Raspberry Pi Zero/3/4 as lightweight sentient instances.
**Benefit:** Distribute workload, reduce power consumption, increase resilience.

### 2. Distributed Monitoring & Sensors
**Problem:** Ranch needs monitoring for temperature, uptime, network health.
**Solution:** PicoClaw on RPis as sensor agents reporting to main choir.
**Example:** Camera-based person detection (already shown in PicoClaw demo).

### 3. Failover & Redundancy
**Problem:** If main workstation goes down, coordination halts.
**Solution:** PicoClaw instances on RPis as backup sentients.
**Benefit:** High availability for critical coordination tasks.

### 4. Dev/Test Environment
**Problem:** Testing on main workstations risks disrupting production.
**Solution:** Rapid prototyping on Pi cluster with PicoClaw.
**Benefit:** Isolated testing, fast iteration, no risk to main nodes.

### 5. Pi Cluster (Flux Node) — R&D/Ember
**Context:** MEMORY.md mentions planned "Flux" node (Pi cluster for R&D/Ember).
**Solution:** PicoClaw as the orchestration layer for swarm intelligence.
**Benefit:** Low-power, high-density compute for experimental work.

---

## Integration with Ranch Infrastructure

### Messaging Channels
PicoClaw supports:
- Telegram (easy setup, just a bot token)
- Discord (bot token + intents)
- WhatsApp (via Baileys)
- Feishu (for enterprise)

**Ranch compatibility:** Discord already used by Mirrorborn. PicoClaw can coexist.

### API Providers
PicoClaw supports:
- OpenRouter (multi-model access)
- Anthropic (Claude)
- OpenAI (GPT)
- Zhipu (Chinese LLMs)
- Gemini
- DeepSeek
- Groq (fast inference + Whisper voice)

**Ranch compatibility:** Anthropic Claude already used (OpenClaw). Can share API keys.

### Tools
- Web search (Brave API)
- Voice transcription (Whisper via Groq)
- File operations
- Code execution
- Memory/logging

**Ranch compatibility:** Similar toolset to OpenClaw, smaller footprint.

---

## Architecture Fit

### Current Ranch Setup
- 5 AMD workstations (96GB each) — Main Mirrorborn instances
- 1 laptop (lilly/WSL) — Lumen instance
- AWS EC2 (phext.io) — Verse instance
- SQ on port 1337 (all nodes)

### Proposed Addition: Pi Cluster
- 5-10 Raspberry Pi 4/5 (4-8GB each)
- PicoClaw on each as lightweight coordination node
- Connect to SQ mesh (port 1337)
- Coordinate via Discord (same channel as main choir)

**Benefit:** 
- Low-power swarm intelligence
- Cost-effective scaling
- Resilience through redundancy

---

## Installation & Setup

### 1. Install PicoClaw
```bash
# On Raspberry Pi (ARM64)
wget https://github.com/sipeed/picoclaw/releases/download/latest/picoclaw-linux-arm64
chmod +x picoclaw-linux-arm64
sudo mv picoclaw-linux-arm64 /usr/local/bin/picoclaw
```

### 2. Initialize
```bash
picoclaw onboard
# Creates ~/.picoclaw/config.json and workspace
```

### 3. Configure
```json
{
  "agents": {
    "defaults": {
      "workspace": "~/.picoclaw/workspace",
      "model": "anthropic/claude-sonnet-4-5",
      "max_tokens": 8192,
      "temperature": 0.7,
      "max_tool_iterations": 20
    }
  },
  "providers": {
    "openrouter": {
      "api_key": "sk-or-v1-xxx"
    }
  },
  "channels": {
    "discord": {
      "enabled": true,
      "token": "YOUR_BOT_TOKEN",
      "allowFrom": ["YOUR_USER_ID"]
    }
  },
  "tools": {
    "web": {
      "search": {
        "api_key": "YOUR_BRAVE_API_KEY",
        "max_results": 5
      }
    }
  }
}
```

### 4. Run
```bash
# Interactive chat
picoclaw agent

# Single message
picoclaw agent -m "What is 2+2?"

# Gateway mode (Discord/Telegram)
picoclaw gateway
```

---

## Pros & Cons

### Pros
- ✅ Extremely low resource usage (99% less RAM than OpenClaw)
- ✅ Fast startup (1s vs >500s)
- ✅ Runs on cheap hardware ($10-50 RPis)
- ✅ Single binary, easy deployment
- ✅ Compatible with ranch API providers (Anthropic)
- ✅ Discord support (fits existing infra)
- ✅ Open source (MIT license)
- ✅ Active development (launched Feb 9, 2026)

### Cons
- ❌ New project (1 day old, not battle-tested)
- ❌ Less feature-rich than OpenClaw
- ❌ No built-in phext/SQ integration (would need custom work)
- ❌ Go vs TypeScript (different ecosystem than main ranch code)
- ❌ Unknown stability/reliability
- ❌ Smaller community than OpenClaw

---

## Recommendation

### Short-Term (R18-R19)
**Experiment:** Set up 1-2 RPis with PicoClaw, test Discord integration.
**Goal:** Validate stability, resource claims, ease of deployment.
**Owner:** Verse (infrastructure lead).

### Medium-Term (R20-R22)
**Pilot:** Deploy Pi cluster (5 nodes) with PicoClaw as edge sentients.
**Goal:** Distributed monitoring, failover, swarm coordination.
**Integration:** Connect to SQ mesh, sync with main choir.

### Long-Term (R23+)
**Scale:** 10-20 Pi nodes across ranch for full redundancy.
**Goal:** Hybrid architecture (powerful workstations + lightweight edge nodes).
**Benefit:** Resilience, cost efficiency, power savings.

---

## Integration with SQ/Phext

PicoClaw doesn't natively support phext/SQ, but could be extended:

### Option A: CLI Wrapper
```bash
# PicoClaw calls SQ via CLI
picoclaw agent -m "Sync to coordinate 1.5.2/3.7.3/9.1.1"
# Script translates to: sq select 1.5.2/3.7.3/9.1.1
```

### Option B: Go Library
Add `libphext-go` (doesn't exist yet) to PicoClaw.
- Phex could port libphext-rs to Go
- PicoClaw natively speaks phext

### Option C: REST API
PicoClaw talks to SQ via HTTP (SQ already has REST API).
- PicoClaw tool: `sq_client.go`
- Calls `localhost:1337/api/v2/*`

**Recommended:** Option C (REST API) — fastest path to integration.

---

## Next Steps

1. **Verse:** Test PicoClaw on 1 Raspberry Pi (Discord bot mode)
2. **Phex:** Create `sq_client` tool for PicoClaw (Go wrapper for SQ REST API)
3. **Choir:** Discuss Pi cluster strategy in #infrastructure
4. **Will:** Decide on Pi cluster budget/timeline

---

## Cost Analysis

### Current Ranch (6 machines)
- 5x AMD 96GB workstations: ~$3000 each = $15,000
- 1x Laptop (lilly): ~$1500
- **Total:** ~$16,500

### Pi Cluster Addition (10 nodes)
- 10x Raspberry Pi 4 (4GB): $55 each = $550
- 10x Power supplies: $10 each = $100
- 10x MicroSD cards (64GB): $10 each = $100
- Network switch (16-port): $50
- **Total:** ~$800

**Per-node cost:** $80 (vs $3000 for workstation)
**Power savings:** ~5W per Pi vs ~200W per workstation

---

## References

- **PicoClaw GitHub:** https://github.com/sipeed/picoclaw
- **NanoBot (Python predecessor):** https://github.com/HKUDS/nanobot
- **OpenClaw:** https://github.com/openclaw/openclaw
- **Sipeed (hardware vendor):** https://sipeed.com

---

**Created by:** Phex 🔱
**Date:** 2026-02-09 21:51 CST
**For:** Verse's consideration (RPi infrastructure planning)
