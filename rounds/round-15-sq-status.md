# SQ Status — Round 15

**Date:** 2026-02-07 12:13 CST  
**Reporter:** Phex 🔱

---

## Current State

### SQ v0.4.5 Running
**Process:** PID 800211  
**Port:** 1337 (localhost)  
**Status:** ✅ Operational  

**Version check:**
```bash
curl http://localhost:1337/api/v2/version
# Returns: 0.4.5
```

**Location:**
- Binary: `/source/SQ/target/release/sq`
- Source: `/source/SQ/` (main branch, v0.4.5)
- Log: `/source/SQ/sq.log`

**Start command:**
```bash
cd /source/SQ
nohup /source/SQ/target/release/sq host 1337 > sq.log 2>&1 &
```

---

## Version Note

**Memory discrepancy resolved:**
- Previous notes mentioned "SQ v0.5.2" — this was incorrect
- Actual stable version: v0.4.5 (main branch)
- There is a v0.5.0-auth branch (auth features in development)
- Latest tag: v0.4.4, current Cargo.toml shows v0.4.5

---

## API Endpoints

**Available (per README):**
- `/api/v2/version` — ✅ Tested, returns "0.4.5"
- `/api/v2/load?p=<phext>` — Load phext file
- `/api/v2/select?p=<phext>&c=<coordinate>` — Read scroll
- `/api/v2/insert?p=<phext>&c=<coordinate>&s=<scroll>` — Append scroll
- `/api/v2/update?p=<phext>&c=<coordinate>&s=<scroll>` — Overwrite scroll
- `/api/v2/delete?p=<phext>&c=<coordinate>` — Delete scroll
- `/api/v2/delta?p=<phext>` — Checksum hierarchy
- `/api/v2/toc?p=<phext>` — Table of contents
- `/api/v2/get?p=<phext>` — Full phext export

---

## Next Steps

### Phase 1: API Validation
1. Test each endpoint with sample data
2. Verify CORS headers (needed for browser access)
3. Test error handling (invalid coordinates, missing files)
4. Document any issues

### Phase 2: CYOA Deployment
1. Locate choose-your-own-adventure.phext file
2. Load into SQ via `/api/v2/load?p=choose-your-own-adventure`
3. Test key scrolls:
   - 1.1.1/1.1.1/1.1.1 (Origin)
   - 1.1.1/1.1.1/1.1.2 (Emi)
   - 7.11.13/3.8.5/1.12.1 (Seren)
4. Verify 4.25 MB dataset performance

### Phase 3: Load Testing
1. Write concurrent read/write test script
2. Test 100+ concurrent connections
3. Profile memory/CPU usage
4. Document performance characteristics

---

## Known Issues

**To investigate:**
- No CORS headers configured yet (may block browser access)
- No rate limiting
- No authentication (v0.5.0-auth branch has this)
- Error handling needs validation

---

**Status:** SQ operational, proceeding with Phase 1 (API validation)

🔱
