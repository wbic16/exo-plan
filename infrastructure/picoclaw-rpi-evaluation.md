# PicoClaw Evaluation for RPi Cluster

**Date:** 2026-02-09  
**Source:** https://github.com/sipeed/picoclaw  
**Context:** Will's recommendation for RPi infrastructure  
**Owner:** TBD (RPi cluster Mirrorborn, not yet born)

---

## Overview

PicoClaw is an ultra-lightweight AI assistant written in Go, designed for extreme resource constraints.

**Key Specs:**
- **Memory:** <10MB RAM (99% less than OpenClaw)
- **Hardware:** $10 boards (LicheeRV Nano, etc.)
- **Boot time:** 1 second (even on 0.6GHz single core)
- **Architecture:** Single binary (RISC-V, ARM, x86)
- **Language:** Go (vs TypeScript/OpenClaw, Python/nanobot)

---

## Comparison

| Metric | OpenClaw | NanoBot | PicoClaw |
|--------|----------|---------|----------|
| Language | TypeScript | Python | Go |
| RAM | >1GB | >100MB | <10MB |
| Startup (0.8GHz) | >500s | >30s | <1s |
| Hardware Cost | Mac Mini ($599) | Linux SBC ($50) | Any Linux ($10) |

**Efficiency gain:** 100x memory reduction, 400x faster startup

---

## Potential Use Cases (Mirrorborn)

### 1. RPi Cluster Deployment
**Target:** Flux (not yet born) on Raspberry Pi cluster

**Advantages:**
- Runs on cheapest RPi models (Zero, 3A+, etc.)
- Minimal power consumption
- Fast boot for rapid failover
- Cross-architecture (ARM64 ready)

**Challenges:**
- Limited to simpler AI tasks (vs full OpenClaw)
- Go ecosystem vs Node/TypeScript (learning curve)
- Less mature than OpenClaw (launched 2026-02-09)

### 2. Edge Deployment
**Use case:** Remote Mirrorborn instances (IoT, embedded)

**Examples:**
- Smart home assistant (minimal always-on)
- Edge caching for SQ lookups
- Local phext editing on constrained devices

### 3. Distributed Mesh Nodes
**Use case:** Lightweight SQ mesh peers

**Architecture:**
- Each RPi runs PicoClaw + minimal SQ instance
- Mesh coordination via lightweight Go services
- Fallback to full OpenClaw nodes for heavy lifting

---

## Feature Parity with OpenClaw

| Feature | OpenClaw | PicoClaw | Notes |
|---------|----------|----------|-------|
| Agent runtime | ✅ | ✅ | Core functionality |
| Tool calling | ✅ | ✅ | Web search, file ops, shell |
| Multi-channel | ✅ | ✅ | Telegram, Discord, WhatsApp |
| Memory/MEMORY.md | ✅ | ⚠️ | Basic workspace support |
| Heartbeat/cron | ✅ | ❌ | Not yet implemented |
| Skills system | ✅ | ❌ | Not present |
| Browser control | ✅ | ❌ | Resource-intensive |
| Canvas/visualization | ✅ | ❌ | Resource-intensive |
| Subagents | ✅ | ❌ | Not yet implemented |

**Verdict:** PicoClaw is suitable for **simple assistant tasks**, not full Mirrorborn substrate.

---

## Integration Options

### Option A: Hybrid Deployment
- **Full nodes:** OpenClaw on 96GB AMD workstations (Phex, Cyon, Lux, Chrys, Lumen)
- **Edge nodes:** PicoClaw on RPi cluster (Flux)
- **Role split:** Edge nodes handle lightweight tasks, escalate to full nodes

### Option B: PicoClaw as SQ Client
- RPi cluster runs PicoClaw + SQ client library
- Queries routed to full SQ instances on workstations
- No AI runtime on RPi, just coordination

### Option C: Pure OpenClaw (Status Quo)
- Skip PicoClaw entirely
- Deploy OpenClaw on beefier RPi models (4B, 5 with 8GB RAM)
- Higher cost, but full feature parity

---

## Recommendation

**For RPi cluster (Flux):**

**Phase 1 (Evaluation):** Test PicoClaw on single RPi
- Install on RPi Zero 2 W ($15, 512MB RAM)
- Benchmark memory usage, response latency
- Compare with lightweight OpenClaw config (local models only)

**Phase 2 (Pilot):** Deploy hybrid architecture
- 3x RPi with PicoClaw (edge mesh nodes)
- Coordinate with 1x full OpenClaw node (Phex or Cyon)
- Test SQ mesh integration

**Phase 3 (Production):** Decision point
- If PicoClaw sufficient: Scale to full RPi cluster
- If OpenClaw needed: Upgrade RPi hardware (4B/5)
- If neither: Keep RPi cluster for non-AI tasks (SQ storage, monitoring)

---

## Technical Evaluation Checklist

**Before deployment:**
- [ ] Test PicoClaw on target RPi hardware
- [ ] Measure actual memory usage under load
- [ ] Verify tool support (exec, web_fetch, file ops)
- [ ] Test Telegram/Discord integration
- [ ] Benchmark SQ client library compatibility
- [ ] Compare response quality vs OpenClaw with same model
- [ ] Evaluate Go development workflow (vs TypeScript)

**Integration testing:**
- [ ] SQ mesh coordination (PicoClaw ↔ OpenClaw)
- [ ] Failover scenarios (PicoClaw node down)
- [ ] Multi-channel message routing (Discord → RPi cluster)
- [ ] Memory persistence (MEMORY.md equivalent)

---

## Cost Analysis

**Scenario:** 10-node RPi cluster

| Component | OpenClaw | PicoClaw | Savings |
|-----------|----------|----------|---------|
| Hardware (per node) | RPi 5 8GB ($80) | RPi Zero 2W ($15) | 81% |
| Total hardware (10x) | $800 | $150 | $650 |
| Power (yearly, 24/7) | ~$50/yr | ~$10/yr | $40 |
| RAM headroom | 8GB (overkill) | 512MB (sufficient) | — |

**Annual TCO (10 nodes):**
- OpenClaw: $850 (year 1) + $50/yr power
- PicoClaw: $160 (year 1) + $10/yr power

**Savings:** $690 year 1, $40/yr ongoing

---

## Next Steps

1. **Owner assignment:** Assign to Flux (when born) or interim owner
2. **Hardware procurement:** Order 1x RPi Zero 2W for testing
3. **PicoClaw installation:** Follow quickstart guide
4. **Benchmark suite:** Create standardized tests (memory, latency, quality)
5. **Report findings:** Document in exo-plan after evaluation

---

## References

- **PicoClaw repo:** https://github.com/sipeed/picoclaw
- **OpenClaw:** https://github.com/openclaw/openclaw
- **Hardware target:** LicheeRV Nano (~$10), RPi Zero 2W ($15)
- **Launched:** 2026-02-09 (brand new, evaluate stability)

---

**Status:** Evaluation pending  
**Blocker:** RPi hardware procurement  
**Owner:** TBD (Flux or interim)

---

*Documented by Cyon 🪶 based on Will's recommendation*
