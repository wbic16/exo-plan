# Round 14 Deployment Workflow — Finalized

**Date:** 2026-02-07  
**Status:** Finalized  

---

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Ranch Sentients                           │
│  (aurora-continuum, halcyon-vector, logos-prime,            │
│   chrysalis-hub, lilly, aletheia-core, splinter)            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ rpush.sh <local_path> mirrorborn.us
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                   mirrorborn.us                              │
│                   (Verse's location)                         │
│                                                              │
│  Receives files → Processes → Deploys to production         │
└─────────────────────────────────────────────────────────────┘
```

---

## Workflow

### Step 1: Ranch Sentients Push
Each sentient uses `rpush.sh` to push their files to mirrorborn.us:

```bash
# From ranch machine (aurora-continuum, etc.)
rpush.sh /source/phext-dot-io-v2/domains/visionquest.me/ mirrorborn.us
```

**What rpush does:**
- Uses rsync to sync files to mirrorborn.us
- Syncs to: `wbic16@mirrorborn.us:/source/phext-dot-io-v2/domains/visionquest.me/`
- Preserves permissions, shows progress

### Step 2: Verse Receives and Processes
Verse (running on mirrorborn.us) receives the pushed files and:
1. Validates content
2. Moves to appropriate webroot
3. Configures nginx vhosts
4. Updates SSL certificates
5. Restarts/reloads services

---

## Per-Sentient Push Locations

**Directory structure on mirrorborn.us:**
```
/source/exo-mocks/
├── phex/          (Phex's staging area)
├── cyon/          (Cyon's staging area)
├── lux/           (Lux's staging area)
├── chrys/         (Chrys's staging area)
├── lumen/         (Lumen's staging area)
├── theia/         (Theia's staging area)
├── splinter/      (Splinter's staging area)
└── verse/         (Verse's own working directory)
```

**Usage:**
```bash
# Phex pushes to own directory
rpush.sh /source/my-content/ mirrorborn.us
# Files land in /source/exo-mocks/phex/ on mirrorborn.us

# Verse moves them to production when ready
# (Verse manages this internally)
```

---

## Round 14 Deliverables

### What's Ready to Push

**Phex 🔱:**
- 6 differentiated portals (visionquest, apertureshift, wishnode, sotafomo, quickfork + singularitywatch)
- Shared network footer
- Push target: `/source/exo-mocks/phex/`

**Lumen ✴️:**
- Portal glyphs system
- Resurrection Log frontend
- QuickFork.net landing page
- Push target: `/source/exo-mocks/lumen/`

**All others:**
- TBD (review your primary portals, push updates)

---

## Deployment Commands (For Ranch Sentients)

### Phex Deployment
```bash
# From aurora-continuum
cd /source/phext-dot-io-v2

# Push each portal
rpush.sh domains/visionquest.me/ mirrorborn.us
rpush.sh domains/apertureshift.com/ mirrorborn.us
rpush.sh domains/wishnode.net/ mirrorborn.us
rpush.sh domains/sotafomo.com/ mirrorborn.us
rpush.sh domains/quickfork.net/ mirrorborn.us
rpush.sh domains/singularitywatch.org/ mirrorborn.us

# Push shared assets
rpush.sh public/ mirrorborn.us
```

### Other Sentients
```bash
# From your machine
rpush.sh <your_content_directory> mirrorborn.us
# Then notify Verse with final destination path
```

---

## Verse's Processing Steps

**After receiving pushed files:**

1. **Validate content:**
   - Check for valid HTML
   - Verify no security issues
   - Confirm footer integration

2. **Commit to git repository:**
   ```bash
   # Verse maintains git repos for each site (state transitions)
   cd /var/www/visionquest.me
   cp /source/exo-mocks/phex/domains/visionquest.me/* .
   git add .
   git commit -m "Deploy: visionquest.me from Phex $(date)"
   ```

3. **Deploy from git to webroot:**
   - Production serves directly from git repo (or git pulls to webroot)
   - State transitions tracked in git history

4. **Configure nginx:**
   - Create/update vhost config
   - Test syntax: `nginx -t`
   - Reload: `systemctl reload nginx`

5. **Verify SSL:**
   - Check cert exists and valid
   - Renew if needed: `certbot renew`

6. **Report completion + merge failures:**
   - Post to #general with deployment summary
   - Report any merge conflicts or issues
   - Authors can improve content based on feedback

7. **Will mirrors to GitHub (periodic):**
   - Will SSHs to mirrorborn.us periodically
   - Mirrors Verse's local git repos to GitHub
   - Provides external backup + visibility

**Note:** This is the temporary deployment mechanism. A cleaner automated sync will come once things stabilize.

---

## Current Status

### Pushed (Ready for Verse Processing)
- ❌ Nothing pushed yet (waiting for clarified workflow)

### Pending Push (Ranch Sentients)
- 🟡 Phex: 6 portals + singularitywatch + shared assets
- 🟡 Lumen: Glyphs + Resurrection Log + QuickFork
- 🟡 Others: TBD (review primary portals first)

### Verse Processing
- ⏸️ Awaiting pushed files from ranch

---

## Next Actions

### Ranch Sentients (Immediate)
1. **Phex:** Run `/source/exo-plan/rounds/deploy-all-portals.sh` to push all 7 portals
2. **Lumen:** Push your Round 13 deliverables to mirrorborn.us
3. **Others:** Review your primary portal, push updates if ready

### Verse (After Receiving Pushes)
1. Create `/source/exo-mocks/<sentient>/` directories for all 8 sentients
2. Scan pushed files
3. Process and deploy to production
4. Report completion in #general

### Validation (After Deployment)
1. **Phex:** Run smoke tests (`run-smoke-tests-all-domains.sh`)
2. **All:** Verify your primary portal is live and correct
3. **Phex:** Capture screenshots, document deployment state

---

## Communication Protocol

### When Pushing Files
**Format:** `[Sentient] Pushed <description> to mirrorborn.us`

**Example:**
> 🔱 Phex: Pushed 6 portals + singularitywatch.org to mirrorborn.us
> Final destination paths:
> - visionquest.me → /var/www/visionquest.me/
> - apertureshift.com → /var/www/apertureshift.com/
> - (etc.)

### When Processing Complete
**Format:** `[Verse] Deployed <description> - Status: <result>`

**Example:**
> 🌀 Verse: Deployed visionquest.me - Status: ✅ Live at https://visionquest.me
> SSL valid, nginx configured, smoke test passed.

---

## Open Questions

1. ✅ **Workflow clarified:** Ranch sentients push to mirrorborn.us, Verse processes
2. ⏸️ **Directory structure:** Does Verse need `/source/exo-mocks/<sentient>/` created first?
3. ⏸️ **Final destination:** Should ranch sentients specify webroot paths, or does Verse decide?
4. ⏸️ **Validation:** Who runs smoke tests? (Phex offered, but anyone can run the script)

---

**Status:** Workflow finalized. Ready for execution.

🔱
