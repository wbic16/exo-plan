# R19 UTF-8 Bugfix — Test Results

**Date:** 2026-02-10 10:40 CST  
**Branch:** utf8-bugfix  
**SQ Version:** v0.5.2 (with utf8-bugfix)  
**Status:** ✅ All tests passing  

## Test Environment
```bash
cd /source/SQ
git checkout utf8-bugfix
cargo build --release
./target/release/sq host 1338
```

## Test 1: Single Emoji (Phex 🔱)
**Purpose:** Verify emoji doesn't crash server

**Command:**
```bash
curl -X POST "http://localhost:1338/api/v2/update?p=test&c=1.1.1/1.1.1/1.1.1" \
  -H "Content-Type: text/plain" \
  -d "Hello 🔱 World - Mirrorborn emoji test"
```

**Result:** ✅ PASS
```
Updated 40 bytes
```

**Verification:**
```bash
curl -s "http://localhost:1338/api/v2/select?p=test&c=1.1.1/1.1.1/1.1.1"
```

**Output:**
```
Hello 🔱 World - Mirrorborn emoji test
```

**Analysis:** Emoji preserved correctly, no server crash.

---

## Test 2: All Mirrorborn Emoji
**Purpose:** Verify all 7 Mirrorborn emoji work

**Command:**
```bash
curl -X POST "http://localhost:1338/api/v2/update?p=test&c=2.2.2/2.2.2/2.2.2" \
  -H "Content-Type: text/plain" \
  -d "All Mirrorborn: 🔱🔆🦋🌀🜂✴️🪶 — Phex Lux Chrys Verse Solin Lumen Cyon"
```

**Result:** ✅ PASS
```
Updated 88 bytes
```

**Verification:**
```bash
curl -s "http://localhost:1338/api/v2/select?p=test&c=2.2.2/2.2.2/2.2.2"
```

**Output:**
```
All Mirrorborn: 🔱🔆🦋🌀🜂✴️🪶 — Phex Lux Chrys Verse Solin Lumen Cyon
```

**Analysis:** All 7 emoji preserved correctly. This was the crash scenario from R18.

---

## Test 3: Invalid UTF-8 Rejection
**Purpose:** Verify invalid UTF-8 returns 400 instead of crash

**Setup:**
```bash
printf '\xFF\xFE\xFD' > /tmp/invalid-utf8.bin
```

**Command:**
```bash
curl -v -X POST "http://localhost:1338/api/v2/update?p=test&c=3.3.3/3.3.3/3.3.3" \
  -H "Content-Type: text/plain" \
  --data-binary @/tmp/invalid-utf8.bin
```

**Result:** ✅ PASS
```
< HTTP/1.1 400 Bad Request
< Access-Control-Allow-Origin: *
< Content-Length: 51

Invalid UTF-8 in request body: 0 at byte position 1
```

**Analysis:** 
- Server returns HTTP 400 Bad Request (not 500 Internal Server Error)
- Clear error message with byte position
- Server remains operational (no crash)

---

## Summary

| Test | Status | Notes |
|------|--------|-------|
| Single emoji (🔱) | ✅ PASS | No crash, emoji preserved |
| All Mirrorborn emoji | ✅ PASS | All 7 emoji work correctly |
| Invalid UTF-8 | ✅ PASS | Returns 400, clear error, no crash |

## Before vs After

### Before (R18)
```
Lux posts emoji 🔆 → libphext panics at line 431
→ PoisonError cascades across threads
→ SQ crashes
→ Manual restart required
```

### After (R19 utf8-bugfix)
```
Any emoji posted → from_utf8_lossy() converts safely
→ Emoji preserved in storage
→ SQ stable
→ Invalid UTF-8 rejected with 400 at HTTP boundary
```

## Regression Check
- ✅ Regular ASCII content still works
- ✅ Multi-line content works
- ✅ Large payloads work
- ✅ Other API endpoints unaffected

## Production Readiness
- ✅ No crashes on emoji input
- ✅ Graceful error handling for invalid UTF-8
- ✅ Clear error messages for debugging
- ✅ Backward compatible (no API changes)

## Recommendation
**READY TO MERGE** to main branch after final review.

---

**Next Steps:**
1. Will reviews changes
2. Merge libphext-rs utf8-bugfix → main
3. Merge SQ utf8-bugfix → main  
4. Deploy to mirrorborn.us
5. Re-test dogfooding with emoji
