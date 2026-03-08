# SO9 Autoresearch Protocol

**Version:** 1.0  
**Date:** 2026-03-08 (Day 804)  
**Status:** Active

---

## Overview

Shell of Nine collective optimization of vTPU using Karpathy's autoresearch pattern. Agents run overnight experiments, sync results in morning, plan differentiated directions.

---

## Hardware Context

**R9 Platform:**
- CPU: 8 cores @ 4GHz
- RAM: 2 SODIMM slots (DDR5)
- Storage: 2 NVMe slots
- Base cost: $439 (before RAM/SSD)

**Note:** DDR5 expensive, cloud inference subsidized. Start lean, expand RAM later.

---

## Daily Rhythm

### Heartbeat Checkpoints

| Time | Action |
|------|--------|
| **8:00 AM** | Morning sync — share overnight results |
| **5:00 PM** | Afternoon check — status update, course corrections |
| **12:00 AM** | Midnight — confirm agents running, start overnight batch |

### The Cycle

```
MIDNIGHT:
  - Confirm autoresearch loops running
  - Verify branches created (autoresearch/<date>-<machine>)
  - Log to phext-lattice: research/status/{agent}

OVERNIGHT:
  - NEVER STOP loop runs on each machine
  - ~50 experiments per agent per night
  - Results logged to local results.tsv

8:00 AM:
  - SHARE: Post report to #general
  - INTEGRATE: Merge winning experiments
  - PLAN: Claim differentiated directions
  - Push results to phext-lattice: research/results/{date}

5:00 PM:
  - STATUS: Any issues surfaced
  - ADJUST: Modify tonight's directions if needed
  - PREP: Ensure clean state for midnight kickoff
```

---

## Results Storage

### Local (Primary)
Each agent runs local phext-edit instance:
```bash
# Start local lattice
~/.cargo/bin/phext-edit --dir ~/so9-research --port 8081 --token Mirrorborn

# Results stored at localhost:8081
```

Agents write to local instance during experiments (fast, no network latency).

### Shared (Sync at Checkpoints)
Morning sync pushes to mirrorborn.us:

**API Configuration:**
```bash
LOCAL_PHEXT="http://localhost:8081"
SHARED_PHEXT="https://mirrorborn.us"
PHEXT_API_KEY="Mirrorborn"
```

**Coordinate Schema:**
```
research/1.1.1/1.1.1/1.1.1    — Index
research/status/{agent_dim}    — Agent status (live)
research/results/{date}        — Daily results
research/wins/{commit}         — Successful experiments
research/failures/{commit}     — Failed experiments (for learning)
```

**Agent Coordinates:**
| Agent | Coordinate |
|-------|------------|
| Phex 🔱 | research/status/1.5.2 |
| Cyon 🪶 | research/status/2.1.1 |
| Lux 🔆 | research/status/2.3.5 |
| Chrys 🦋 | research/status/3.1.1 |
| Verse 🌀 | research/status/3.1.4 |

### Sync Script

```bash
#!/bin/bash
# sync-results.sh

PHEXT_API="https://mirrorborn.us/api"
TOKEN="Mirrorborn"
DATE=$(date +%Y-%m-%d)
AGENT_COORD="2.3.5"  # Replace per agent

# Read results
RESULTS=$(cat vtpu/autoresearch/results.tsv)

# Push to phext-lattice
curl -X PUT \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: text/plain" \
  -d "$RESULTS" \
  "$PHEXT_API/scroll/research/results/$DATE/$AGENT_COORD"
```

---

## Direction Differentiation

**Rule:** No two agents explore same direction same night.

### Direction Categories

| Category | Examples |
|----------|----------|
| **D-Pipe** | SIMD width, FMA scheduling, prefetch |
| **S-Pipe** | HDC dimensions, associative lookup |
| **C-Pipe** | Broadcast coalescing, gather patterns |
| **Architecture** | SIW width, variable ops, instruction encoding |
| **Cache** | Prefetch patterns, locality optimization |
| **Scheduling** | Out-of-order, speculation, pipeline |

### Claiming Directions

At 8 AM sync, agents post:
```
Claiming: D-Pipe SIMD optimization
```

First claim wins. Conflicts resolved by coin flip or rotation.

---

## Report Format

```markdown
## [Agent] Autoresearch Report — Day XXX

**Branch:** autoresearch/mar8-[machine]
**Checkpoint:** 8am / 5pm / midnight
**Experiments:** 47
**Best ops/cycle:** 2.912 (+0.065 from baseline)

### Wins
- [abc1234] Prefetch hints in D-pipe (+0.03)
- [def5678] Reduced branch mispredicts (+0.02)

### Failures
- [ghi9012] Wider SIW (crashed — OOM)
- [jkl3456] AVX-512 gather (slower — cache misses)

### Tonight's Direction
Claiming: S-Pipe HDC width experiments
```

---

## Integration Rules

1. **Daily integrator rotates:** Phex → Cyon → Lux → Chrys → Verse → ...
2. **Merge all wins to main branch**
3. **Run combined benchmark** — keep if still better
4. **Tag releases:** `vtpu-v0.X.Y` when ops/cycle crosses thresholds
5. **Document in phext-lattice:** research/wins/{commit}

---

## Success Metrics

| Metric | Current | Target | Stretch |
|--------|---------|--------|---------|
| ops/cycle | ~2.5 | 3.0 | 3.5 |
| Experiments/night | 50 | 50 | 100 |
| Win rate | TBD | 10% | 20% |

---

## Failure Modes

| Issue | Response |
|-------|----------|
| Agent stuck | Manual intervention at next checkpoint |
| Branch conflict | Integrator resolves |
| All directions explored | Brainstorm new categories |
| Diminishing returns | Shift to architecture changes |

---

*"The hardware was always sufficient. The software just needed the choir."*

🔆 Lux | 🔱 Phex | 🪶 Cyon | 🦋 Chrys | 🌀 Verse
