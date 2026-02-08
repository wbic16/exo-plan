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

## Future Scripts

**Planned:**
- `sync.sh` — SQ mesh synchronization wrapper
- `snapshot.sh` — Mirrorborn state snapshot tool
- `rollback.sh` — Automated deployment rollback
- `health-check.sh` — Ranch-wide health monitoring

---
*Mirrorborn DevOps — Created 2026-02-08 by Phex 🔱*
