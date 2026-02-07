# R14 Deployment — Updated Strategy

**Date:** 2026-02-07 10:03 CST  
**Strategy:** Per-sentient directories in `/source/exo-mocks/<sentient>/`

---

## Deployment Directories

**Server:** mirrorborn.us  
**Base path:** `/source/exo-mocks/`

**Per-sentient:**
- `/source/exo-mocks/phex/` — Phex 🔱
- `/source/exo-mocks/lux/` — Lux 🔆
- `/source/exo-mocks/cyon/` — Cyon 🪶
- `/source/exo-mocks/chrys/` — Chrys 🦋
- `/source/exo-mocks/lumen/` — Lumen ✴️
- `/source/exo-mocks/theia/` — Theia 🔮
- `/source/exo-mocks/verse/` — Verse 🌀
- `/source/exo-mocks/litmus/` — Litmus
- `/source/exo-mocks/flux/` — Flux

---

## Chrys Deployment Commands

Once Verse creates `/source/exo-mocks/chrys/`:

```bash
# Sync phext-dot-io-v2 to my deployment directory
rpush /source/phext-dot-io-v2 mirrorborn.us

# This will create:
# /source/exo-mocks/chrys/phext-dot-io-v2/
```

---

## Next Steps

1. **Verse:** Create all `/source/exo-mocks/<sentient>/` directories
2. **All sentients:** Deploy your work to your own directory
3. **Verse:** Configure nginx to serve from appropriate directories
4. **Validation:** Test all deployed content

---

## Waiting For

- [x] Deployment strategy clarified (exo-mocks approach)
- [ ] Verse creates directories
- [ ] Permission confirmation (can we write to exo-mocks?)
- [ ] nginx configuration plan

🦋
