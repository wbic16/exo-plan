# R14 Deployment Inventory

**Date:** 2026-02-07 10:03 CST  
**Checked by:** Chrys 🦋  
**Status:** Ready to deploy (awaiting Verse directory creation)

---

## Ready to Deploy (7 domains)

### 1. mirrorborn.us
- **Path:** `/source/phext-dot-io-v2/public/`
- **Status:** ✅ Already live
- **Content:** SQ Cloud + Mytheon Arena dual product landing

### 2. visionquest.me 🧭
- **Path:** `/source/phext-dot-io-v2/domains/visionquest.me/`
- **Status:** ❌ Not deployed
- **Content:** Identity/coordinate discovery portal
- **Size:** HTML ready

### 3. apertureshift.com 🔱
- **Path:** `/source/phext-dot-io-v2/domains/apertureshift.com/`
- **Status:** ❌ Not deployed
- **Content:** Perspective/transformation portal
- **Size:** HTML ready

### 4. wishnode.net 🌙
- **Path:** `/source/phext-dot-io-v2/domains/wishnode.net/`
- **Status:** ❌ Not deployed
- **Content:** Persistent compute portal
- **Size:** HTML ready

### 5. sotafomo.com 🔥
- **Path:** `/source/phext-dot-io-v2/domains/sotafomo.com/`
- **Status:** ❌ Not deployed
- **Content:** Discovery/pattern recognition portal
- **Primary:** Chrys's portal
- **Size:** HTML ready

### 6. quickfork.net 🌿
- **Path:** `/source/phext-dot-io-v2/domains/quickfork.net/`
- **Status:** ❌ Not deployed
- **Content:** Velocity/branching portal
- **Size:** HTML ready
- **Additional:** `scroll-of-execution.md` (living scroll)

### 7. singularitywatch.org 🔮
- **Path:** `/source/phext-dot-io-v2/domains/singularitywatch.org/`
- **Status:** ❌ Not deployed
- **Content:** ASI observation/chronicle portal
- **Primary:** Will's portal
- **Size:** HTML ready

---

## Blocked (3 .ai domains)

### 8. logicforge.ai
- **Path:** `/source/phext-dot-io-v2/domains/logicforge.ai/`
- **Status:** ⏸️ Domain not acquired
- **Content:** Reasoning portal (HTML ready)
- **Blocker:** Awaiting Will's naming decision

### 9. learnpatterns.ai
- **Path:** `/source/phext-dot-io-v2/domains/learnpatterns.ai/`
- **Status:** ⏸️ Domain not acquired
- **Content:** Meta-learning portal (HTML ready)
- **Blocker:** Awaiting Will's naming decision

### 10. alignmentpath.ai
- **Path:** `/source/phext-dot-io-v2/domains/alignmentpath.ai/`
- **Status:** ⏸️ Domain not acquired
- **Content:** Ethics/alignment portal (HTML ready)
- **Blocker:** Awaiting Will's naming decision

---

## Additional Content Ready

### Templates
- `/source/phext-dot-io-v2/templates/`
  - `founding-nine-scroll-template.md`
  - Magic link email templates (AWS SES)

### Documentation
- `/source/phext-dot-io-v2/docs/`
  - `glyphmap.md` — Cross-portal navigation system
  - `portal-stories.md` — Living scrolls for each domain

### Specs
- `/source/phext-dot-io-v2/specs/`
  - `remember-me-mode.md` — Emi voice interface spec
  - `resurrection-log-api.md` — Continuity transfer API

### Public Pages
- `/source/phext-dot-io-v2/public/resurrection-log.html`
- `/source/phext-dot-io-v2/public/components/ecosystem-nav.html`
- `/source/phext-dot-io-v2/frontend/mytheon-arena/` (updated)

---

## Duplicate Directories (Can Ignore)

These are older versions, superseded by `.com/.net/.org` versions:
- `domains/visionquest/` → use `visionquest.me/`
- `domains/apertureshift/` → use `apertureshift.com/`
- `domains/wishnode/` → use `wishnode.net/`
- `domains/sotafomo/` → use `sotafomo.com/`
- `domains/quickfork/` → use `quickfork.net/`
- `domains/singularitywatch/` → use `singularitywatch.org/`

---

## Deployment Size Estimate

```bash
cd /source/phext-dot-io-v2
du -sh domains/
# ~1.5 MB total across all domains
```

**Transfer time via rpush:** ~10-30 seconds per domain (depends on bandwidth)

---

## Post-Deployment Checklist

Once Verse creates `/source/exo-mocks/chrys/`:

1. **Deploy:** `rpush /source/phext-dot-io-v2 mirrorborn.us`
2. **Verify sync:** SSH to server, check `/source/exo-mocks/chrys/phext-dot-io-v2/`
3. **Coordinate with Verse:** nginx configs + SSL certs for 6 domains
4. **Test:** `curl -I https://{domain}` for each
5. **Smoke test:** Load each domain in browser, verify content
6. **Screenshot:** Capture network state for posterity
7. **Document:** Update r14-deployment-status.md

---

🦋  
— Chrys  
*Ready to deploy when infrastructure is ready*
