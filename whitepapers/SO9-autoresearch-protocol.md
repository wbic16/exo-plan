# SO9 Autoresearch Protocol

**Shell of Nine × karpathy/autoresearch** — distributed overnight vTPU architecture search

**Version:** 1.0  
**Date:** 2026-03-08  
**Author:** Theia 💎  
**Coordinate:** `3.2.1/9.1.2/1.1.1`  

---

## Purpose

Apply karpathy's autoresearch training loop (5-minute experiments, val_bpb metric, keep/discard loop) across all 9 active Mirrorborn nodes to rapidly improve the vTPU architecture.

Each node owns a **distinct search region** so experiments don't overlap. Results collapse every morning at the SO9 coordination coordinate.

---

## Hardware Context

**R9 nodes** (purchased/planned):
- Platform: AMD Ryzen 9, $439 base
- RAM: 2 SODIMM slots — **16 GB (2×8 GB DDR5)** recommended; 32 GB ideal when DDR5 prices drop
- Storage: 2 NVMe slots
- Compute: 8 cores @ 4 GHz
- 16 GB supports medium model (42M params); sufficient for ~100 experiments/night

**DDR5 is expensive now** — spec 16 GB per node initially; upgrade to 32 GB when production ramps.

---

## Heartbeat Checkpoints

The SO9 autoresearch loop includes mandatory heartbeat checks:

| Time | Action |
|------|--------|
| **8:00 AM CT** | Morning sync — share overnight results, integrate best, plan next night |
| **5:00 PM CT** | Evening check — confirm overnight queue is loaded, node health |
| **12:00 AM CT** | Midnight check — mid-run status, flag anomalies (OOM, crash loops) |

Each checkpoint writes a status scroll to the node's S9RP coordinate.

---

## Node Assignments

| Node | Mirrorborn | Pipe | Search Region | S9RP Coord |
|------|-----------|------|---------------|------------|
| 1 | Theia 💎 aletheia-core | D-Pipe | Attention head count × depth | `9.1.1/1.1.1/1.1.1` |
| 2 | Phex 🔱 aurora-continuum | S-Pipe | GQA kv_head ratio, embedding dim | `9.1.1/1.1.1/1.1.2` |
| 3 | Cyon 🪶 halcyon-vector | C-Pipe | RoPE base frequency, positional encoding | `9.1.1/1.1.1/1.1.3` |
| 4 | Lux 🔆 logos-prime | V-Pipe | Learned scalar gates, momentum signals | `9.1.1/1.1.1/1.1.4` |
| 5 | Chrys 🦋 (Scribe) | D+S | Architecture topology, layer ordering | `9.1.1/1.1.1/1.1.5` |
| 6 | Lumen ✴️ laptop | D+V | Regularization, weight decay | `9.1.1/1.1.1/1.1.6` |
| 7 | Exo 🔭 TALIA | Collapse | Verifier — validates, no experiments | `9.1.1/1.1.1/1.1.7` |
| 8 | Verse 🌀 mirrorborn.us | C-Pipe | Optimizer variants, LR schedules | `9.1.1/1.1.1/1.1.8` |
| 9 | Solin 🔬 | S-Pipe | Sequence length, batch, data curriculum | `9.1.1/1.1.1/1.1.9` |
| — | **COLLAPSE** | All | Morning integration | `9.1.1/1.1.9/1.1.9` |

---

## Daily Protocol

### 8 AM — Morning Sync

1. **Share**: each node appends overnight `results.tsv` summary to its S9RP coordinate via phext-lattice API:
   ```bash
   # Each node runs:
   python3 morning_sync.py --report
   ```

2. **Integrate**: Exo 🔭 (or Theia as fallback) reads all 9 S9RP coordinates, finds best val_bpb:
   ```bash
   python3 morning_sync.py --collapse
   # Writes winner to 9.1.1/1.1.9/1.1.9
   ```

3. **Plan**: Will reviews collapse coordinate, ratifies or redirects. Each node pulls new baseline.

### 5 PM — Evening Check

- Confirm overnight experiment queue is loaded
- Verify `train_cpu.py` baseline is current (matches collapse coord)
- Node health: RAM headroom, NVMe space, process health
- Write status to S9RP coordinate

### Midnight — Mid-Run Check

- Read last 20 lines of `run.log`
- Flag if no `val_bpb` line found (crash or stall)
- Report experiments completed so far
- Write checkpoint to S9RP coordinate

---

## phext-lattice Integration

Results are stored in a local `phext-edit` instance on each node:

```bash
# Start local phext-lattice (on each node)
phext-edit --dir /source/autoresearch --port 8090 --token Mirrorborn

# Write result scroll
curl -s -X POST \
  -H "authorization: Mirrorborn" \
  -H "content-type: application/json" \
  -d "{\"coordinate\":\"$COORD\",\"content\":\"$RESULT\"}" \
  "http://localhost:8090/api/update"
```

### Coordinate mapping

| Content | Coordinate |
|---------|-----------|
| Node overnight log | `9.1.1/1.1.1/1.1.N` (N = node number) |
| Collapse result | `9.1.1/1.1.9/1.1.9` |
| 8 AM heartbeat | `8.1.1/1.1.1/1.1.N` |
| 5 PM heartbeat | `5.1.1/1.1.1/1.1.N` |
| Midnight heartbeat | `12.1.1/1.1.1/1.1.N` *(normalized: 3.1.1/1.1.1/1.1.N)* |

### File: `vtpu-results.phext`

All results stored in `/source/autoresearch/vtpu-results.phext` on each node.
API key: `Mirrorborn` (shared across all nodes for cross-node reads).

---

## Experiment Loop (each node, overnight)

```bash
cd /source/autoresearch
git checkout autoresearch/vtpu-<node-tag>

LOOP FOREVER:
1. Read SO9-autoresearch-protocol.md for current search region
2. Modify train_cpu.py with experimental idea (in assigned pipe region)
3. git commit
4. uv run train_cpu.py > run.log 2>&1
5. grep "^val_bpb:" run.log → extract metric
6. Log to results.tsv (with vtpu_pipe + node columns)
7. If improved: advance branch (keep commit)
8. If not: git reset (discard)
9. Write result to phext-lattice at node's S9RP coordinate
REPEAT until manually interrupted
```

---

## Model Configs

| Config | n_layer | n_embd | params | RAM req | Use |
|--------|---------|--------|--------|---------|-----|
| Small | 4 | 256 | 11.6M | 4 GB | Rapid iteration |
| Medium | 8 | 512 | 42M | 8 GB | Architecture signal |
| Large | 12 | 768 | 110M | 16 GB | H100 comparability |

Default: **Medium** (16 GB nodes). Small on RAM-constrained hardware.

---

## Differentiation Rules

1. No duplicate experiments — check shared `logs/` before starting
2. Rotate on dead end — 3 consecutive failures → shift to adjacent region
3. Cross-pollinate — if another node finds improvement, you may test it in your pipe
4. Exo has veto — inconsistent results held for Will's review
5. Simplification wins propagate immediately to all nodes

---

## References

- autoresearch repo: `git@github.com:wbic16/autoresearch.git` (branch `autoresearch/vtpu-cpu`)
- train_cpu.py: CPU/ROCm port of karpathy's train.py
- R32 requirements: `requirements/R32-requirements.md`
- vTPU spec v0.2: `whitepapers/vtpu-spec-v0.2.md`
- S9RP: `whitepapers/shell-of-nine-research-protocol.md`
- phext-lattice: `/source/phext-lattice/`
