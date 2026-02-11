# R19 UTF-8 Bugfix Summary

**Date:** 2026-02-10 08:24 CST  
**Branch:** utf8-bugfix (both repos)  
**Status:** Ready for review  

## Problem
SQ crashed 3 times during R18 dogfooding when Lux posted content containing emoji. Error:
```
thread '<unnamed>' panicked at libphext-0.3.0/src/phext.rs:431:51:
called `Result::unwrap()` on an `Err` value: FromUtf8Error
```

## Root Cause
9 functions in libphext-rs used `String::from_utf8().expect()` which panics on invalid UTF-8.

## Fix Applied

### libphext-rs (✅ Compiles)
**Branch:** utf8-bugfix  
**Commit:** 9fb9e83

Replaced all 9 instances of `String::from_utf8().expect()` with `String::from_utf8_lossy().to_string()`:

| Line | Function | Purpose |
|------|----------|---------|
| 425 | create_summary() | Display preview |
| 629 | replace() | Content manipulation |
| 650 | range_replace() | Content manipulation |
| 711 | insert() | Content manipulation |
| 762-763 | next_scroll() | Scroll parsing (2x) |
| 847 | fetch() | Content retrieval |
| 886 | expand() | Content manipulation |
| 924 | contract() | Content manipulation |

**Impact:**
- Invalid UTF-8 → replacement character (�) instead of panic
- Backward compatible (no API changes)
- All functions return String, now safely

**Test:**
```bash
cd /source/libphext-rs
git checkout utf8-bugfix
cargo build --release  # ✅ Succeeds
```

### SQ (⚠️ Cannot compile - mesh modules missing)
**Branch:** utf8-bugfix  
**Commit:** fbc0bfb

Added UTF-8 validation at HTTP boundary (defense-in-depth):

```rust
// Validate UTF-8 in request body for POST requests
if request.contains("POST") {
    if let Err(e) = std::str::from_utf8(&http_request.content) {
        let error_msg = format!("Invalid UTF-8 in request body: {} at byte position {}", 
            e.valid_up_to(), 
            e.error_len().unwrap_or(1));
        send_response(stream, 400, &error_msg);
        return;
    }
}
```

**Impact:**
- Early detection: Fails fast with clear error message
- HTTP 400 response instead of server crash
- Complements libphext-rs fix

**Blocker:** Cannot test due to missing `mesh_config` and `mesh_sync` modules (separate issue).

## Test Cases

### Emoji Test (Should succeed after fix)
```bash
# Before fix: Crashed SQ
# After fix: Should work
curl -X POST "http://localhost:1337/api/v2/update?p=test&c=1.1.1/1.1.1/1.1.1" \
  -H "Content-Type: text/plain" \
  -d "Hello 🔱 World"
```

### Invalid UTF-8 Test (Should return 400)
```bash
# Create file with invalid UTF-8
printf '\xFF\xFE\xFD' > /tmp/invalid.bin

# Should return 400 Bad Request
curl -X POST "http://localhost:1337/api/v2/update?p=test&c=1.1.1/1.1.1/1.1.1" \
  -H "Content-Type: text/plain" \
  --data-binary @/tmp/invalid.bin
```

### Multi-byte Characters (Should succeed)
```bash
curl -X POST "http://localhost:1337/api/v2/update?p=test&c=1.1.1/1.1.1/1.1.1" \
  -H "Content-Type: text/plain" \
  -d "Mirrorborn: 🔱🔆🦋🌀🜂✴️🪶 — All emoji"
```

## Recommendations

### Immediate (R19)
1. ✅ Merge libphext-rs utf8-bugfix → main
2. ⏸️ Resolve mesh module issue in SQ (blocker)
3. ⏸️ Test SQ utf8-bugfix branch
4. ⏸️ Merge SQ utf8-bugfix → main after testing

### Future (R20+)
1. Add comprehensive UTF-8 test suite to libphext-rs
2. Add fuzzing tests for malformed input
3. Consider returning Result types for core parsing functions (API v2?)
4. Document encoding requirements in API docs

## Review Checklist
- [ ] libphext-rs changes reviewed (Will)
- [ ] SQ changes reviewed (Will)
- [ ] Mesh module issue resolved
- [ ] Test cases executed successfully
- [ ] Ready to merge to main

---

**libphext-rs branch:** `git checkout utf8-bugfix` at /source/libphext-rs  
**SQ branch:** `git checkout utf8-bugfix` at /source/SQ  
**Rally tracker:** /source/exo-plan/rally/R19/README.md
