# Rally 19: SQ Docker + Security Hardening

**Start:** 2026-02-10 08:24 CST  
**Lead:** wbic16  
**Engineering:** Phex (utf8-bugfix), Verse (Docker), Splinter (TBD)

## Requirements
1. **Dockerize SQ** — Use existing Dockerfile, make deployment painless
2. **UTF-8 Bugfix** — Fix libphext-rs:431 crash on emoji/multi-byte UTF-8
3. **Security Hardening** — Harden SQ security model
4. **Production Ready** — No more manual restarts after crashes

## Deliverables
- [x] libphext-rs utf8-bugfix — ✅ Published to crates.io as v0.3.1 (Will)
- [x] SQ updated to libphext 0.3.1 — ✅ Integrated and tested (Phex, commit db0527c)
- [x] Emoji crash fix verified — ✅ All R18 scenarios passing
- [ ] Docker deployment tested and documented
- [ ] Security audit and hardening complete
- [ ] Hosting guide updated

## Context from R18
- SQ crashed 3 times during dogfooding (Lux emoji triggering UTF-8 panic)
- Error: `libphext-rs:431` — `unwrap()` on invalid UTF-8 FromUtf8Error
- Cascading PoisonError across worker threads
- Manual restarts required by Will/Verse

## Fix Strategy
1. **libphext-rs:** Add UTF-8 validation before `unwrap()` at line 431
2. **SQ:** Add input validation at HTTP boundary (before libphext)
3. **Response:** Return 400 Bad Request for invalid encoding (don't crash)
4. **Tests:** Add UTF-8/emoji validation test suite

## Branch Workflow
- `libphext-rs`: Create `utf8-bugfix` branch from main
- `SQ`: Create `utf8-bugfix` branch from main
- Will reviews changes today
- Merge after approval

## Success Criteria
- Emoji posts (🔱🔆🦋🌀🜂✴️🪶) succeed without crash
- Invalid UTF-8 returns 400 with clear error message
- SQ runs in Docker container on mirrorborn.us
- No manual restarts needed during normal operation

---

**Status:** Phase 3 — UTF-8 bugfix shipped to production

## Progress (2026-02-10 20:40 CST)

### ✅ Completed
1. **libphext-rs utf8-bugfix branch** (9fb9e83)
   - Replaced 9 instances of `expect()` with `from_utf8_lossy()`
   - Compiles successfully: `cargo build --release`
   - Ready for merge after review

2. **SQ utf8-bugfix branch** (fbc0bfb, 8ba303d)
   - Added UTF-8 validation at HTTP boundary
   - Returns 400 Bad Request on invalid UTF-8
   - Removed mesh dependencies (not needed per Will)
   - ✅ **Compiles and tested successfully**

3. **Testing** (all passing ✅)
   - Single emoji (🔱): Works, no crash
   - All 7 Mirrorborn emoji: Works, all preserved
   - Invalid UTF-8: Returns 400 with clear error message
   - No regression in existing functionality
   - Results: `/source/exo-plan/rally/R19/utf8-bugfix-test-results.md`

4. **Documentation**
   - Analysis: `/source/exo-plan/rally/R19/utf8-bugfix-analysis.md`
   - Summary: `/source/exo-plan/rally/R19/utf8-bugfix-summary.md`
   - Test results: `/source/exo-plan/rally/R19/utf8-bugfix-test-results.md`

### 🔄 Next
- Will reviews utf8-bugfix branches
- Merge to main after approval
- Deploy to mirrorborn.us
- Continue with Docker + security hardening
