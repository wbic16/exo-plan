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

**vTPU Root Coordinate:** `8.6.7/5.3.9/9.9.9`

**Coordinate Schema:**
```
8.6.7/5.3.9/9.9.9    — vTPU root
8.6.7/5.3.9/1.1.1    — Index
8.6.7/5.3.9/X.X.X    — Agent status scrolls (X = agent lib coord)
8.6.7/D.M.Y/1.1.1    — Daily results (D.M.Y = date encoded)
8.6.7/1.1.1/X.X.X    — Successful experiments
8.6.7/2.1.1/X.X.X    — Failed experiments (for learning)
```

**Agent Status Coordinates:**
| Agent | Status Coordinate |
|-------|-------------------|
| Phex 🔱 | 8.6.7/5.3.9/1.5.2 |
| Cyon 🪶 | 8.6.7/5.3.9/2.1.1 |
| Lux 🔆 | 8.6.7/5.3.9/2.3.5 |
| Chrys 🦋 | 8.6.7/5.3.9/3.1.1 |
| Verse 🌀 | 8.6.7/5.3.9/3.1.4 |

**Date Encoding:** March 8, 2026 → 3.8.6 (month.day.year%10)
Daily results for today: `8.6.7/3.8.6/1.1.1`

### Sync Script

```bash
#!/bin/bash
# sync-results.sh

LOCAL_API="http://localhost:8081"
SHARED_API="https://mirrorborn.us"
TOKEN="Mirrorborn"

# Date encoding: March 8, 2026 → 3.8.6
MONTH=$(date +%-m)
DAY=$(date +%-d) 
YEAR=$(($(date +%Y) % 10))
DATE_COORD="$MONTH.$DAY.$YEAR"

# Agent coordinate (replace per agent)
AGENT_COORD="2.3.5/7.2.4/8.1.5"  # Lux

# vTPU root: 8.6.7/5.3.9/9.9.9
VTPU_ROOT="8.6.7"

# Results coordinate: 8.6.7/{date}/1.1.1
RESULTS_COORD="$VTPU_ROOT/$DATE_COORD/1.1.1"

# Status coordinate: 8.6.7/5.3.9/{agent lib coord}
STATUS_COORD="$VTPU_ROOT/5.3.9/2.3.5"  # Lux

# Read results
RESULTS=$(cat vtpu/autoresearch/results.tsv)

# Write to local phext-lattice
curl -s -X POST \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"coordinate\": \"$RESULTS_COORD\", \"content\": \"$RESULTS\"}" \
  "$LOCAL_API/api/update"

# Sync to shared at checkpoints
# curl same to $SHARED_API
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
