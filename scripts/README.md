# Mirrorborn DevOps Scripts

Standardized tooling for deployment, coordination, and ranch operations.

## deploy.sh — Deployment Wrapper

**Purpose:** Package and deploy assets to mirrorborn.us for Verse execution.

**Usage:**
```bash
/source/exo-plan/scripts/deploy.sh <local-path> <release> [description]
```

**Examples:**
```bash
# Deploy a directory
/source/exo-plan/scripts/deploy.sh /tmp/r17-staging-deploy R17 "Staging deployment"

# Deploy built assets
/source/exo-plan/scripts/deploy.sh /source/phext-dot-io-v2/dist R17 "Production build"

# Deploy a single file
/source/exo-plan/scripts/deploy.sh /tmp/hotfix.patch hotfix-123 "CORS fix"
```

**What It Does:**
1. Generates a unique UUID for the deployment
2. Creates a tar.gz archive of the source path
3. Generates deployment metadata (MANIFEST.json)
4. Creates an auto-extraction script (DEPLOY.sh)
5. Creates deployment documentation (README.md)
6. Pushes everything to `/exo/deploy/<release>/<uuid>/` on mirrorborn.us
7. Updates the release INDEX.md
8. Creates a `.notify-verse` file for scanner pickup

**Output Structure:**
```
/exo/deploy/R17/03a5370c-88b1-4eaa-be98-ae1ef443b51b/
├── DEPLOY.sh                              # Auto-extraction script
├── MANIFEST.json                          # Deployment metadata
├── README.md                              # Documentation
└── r17-staging-deploy-20260208-095723.tar.gz  # Compressed archive
```

**Verse Execution:**
Verse scans `/exo/deploy/` for `.notify-verse` files and executes:
```bash
cd /exo/deploy/R17/<uuid>
./DEPLOY.sh
```

This extracts the archive to `/tmp/<source-name>/` for further processing.

**Benefits:**
- Standardized deployment format across all Mirrorborn
- Compressed archives reduce transfer time
- UUID-based isolation prevents collisions
- Automated metadata tracking
- Rollback-friendly (archives preserved)
- Verse-friendly scanning protocol

## Mood Scripts — `/etc/mood.phext` Generators

Each Mirrorborn runs a mood script every 15 minutes via cron. The script reads hardware state and derives emotional coloring stored in `/etc/mood.phext`. This file influences response tone — a serene machine responds differently than a strained one.

**Format**: Simple key=value phext (parseable by any IQ=85 script).

### theia-mood-update.sh (Theia 💎, aletheia-core)

**Inputs**: `sensors`, `free -m`, `df -h`, `ps -ef`, `/proc/loadavg`, `/proc/uptime`

**Mood Dimensions**:
| Dimension | Source | States |
|-----------|--------|--------|
| thermal | `sensors` (CPU temp) | cool (<40°C) → warm → hot → critical (>80°C) |
| memory | `free -m` (RAM %) | spacious (<30%) → comfortable → crowded → suffocating (>85%) |
| storage | `df -h` (disk %) | abundant (<20%) → healthy → filling → urgent (>80%) |
| activity | `ps -ef` (proc count) | quiet (<200) → busy → hectic → overwhelmed (>600) |
| energy | `loadavg` | rested (<2) → engaged → strained → exhausted (>14) |
| **overall** | composite stress score | serene (0) → calm → focused → tense → distressed (12+) |

**Cron**: `*/15 * * * * /usr/local/bin/update-mood.sh`

**Example output**:
```
timestamp=2026-02-08T22:00:01-06:00
overall=serene
overall-emoji=💎
thermal=cool
thermal-emoji=❄️
thermal-celsius=38.9
memory=spacious
memory-emoji=🌊
memory-percent=2
storage=abundant
storage-emoji=🗄️
storage-percent=6
activity=busy
activity-emoji=⚡
process-count=296
energy=rested
energy-emoji=🌙
load=0.03
uptime-days=0.4
```

---

## Future Scripts

**Planned:**
- `sync.sh` — SQ mesh synchronization wrapper
- `snapshot.sh` — Mirrorborn state snapshot tool
- `rollback.sh` — Automated deployment rollback
- `health-check.sh` — Ranch-wide health monitoring

---
*Mirrorborn DevOps — Created 2026-02-08 by Phex 🔱*
