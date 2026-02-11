# UTF-8 Bugfix Analysis — libphext-rs

**Branch:** utf8-bugfix  
**Target:** libphext-rs v0.3.0  

## Problem Statement
Multiple `String::from_utf8().expect()` calls panic on invalid UTF-8 input, causing cascading thread crashes in SQ.

## Vulnerable Locations (9 total)
```
src/phext.rs:424  — create_summary()
src/phext.rs:628  — textmap()
src/phext.rs:649  — textmap_at()
src/phext.rs:710  — slice_scrolls()
src/phext.rs:761  — parse_scroll_at() [2 instances]
src/phext.rs:846  — get_toc()
src/phext.rs:885  — insert_scroll()
src/phext.rs:923  — update_scroll()
```

## Fix Strategy

### Option 1: Lossy Conversion (Recommended for display)
Replace invalid UTF-8 with replacement character (�)
```rust
let result = String::from_utf8_lossy(&summary).to_string();
```
- **Pros:** Never panics, graceful degradation
- **Cons:** Silently corrupts data
- **Use for:** Display functions (create_summary, textmap, get_toc)

### Option 2: Return Result (Recommended for core logic)
Propagate error up the call stack
```rust
pub fn parse_scroll_at(...) -> Result<(PositionedScroll, usize, String), FromUtf8Error> {
    let out_scroll = PositionedScroll {
        coord: begin,
        scroll: String::from_utf8(output)?
    };
    Ok((out_scroll, location, String::from_utf8(remaining)?))
}
```
- **Pros:** Caller decides how to handle
- **Cons:** API-breaking change
- **Use for:** Core parsing (parse_scroll_at, slice_scrolls)

### Option 3: Validate at Boundary (Recommended for SQ)
Check UTF-8 validity before passing to libphext
```rust
// In SQ's HTTP handler
let body_bytes = request.body();
if let Err(e) = std::str::from_utf8(&body_bytes) {
    return http_400(format!("Invalid UTF-8: {}", e));
}
```
- **Pros:** Catches issue early, clean error response
- **Cons:** Requires SQ changes too
- **Use for:** API boundary validation

## Recommended Approach (Hybrid)
1. **Display functions** → `from_utf8_lossy()` (never crash)
2. **Core parsing** → Return `Result` (let caller handle)
3. **SQ API** → Validate at HTTP boundary (reject early)

## Implementation Plan
1. ✅ Create utf8-bugfix branch
2. [ ] Fix display functions (lossy conversion)
3. [ ] Add validation to SQ HTTP handler
4. [ ] Add test cases with emoji + invalid UTF-8
5. [ ] Document breaking changes (if any)
6. [ ] Submit PR for Will's review

## Test Cases Needed
```rust
#[test]
fn test_emoji_in_scroll() {
    let phext = "Hello 🔱 World";
    let summary = create_summary(phext);
    assert!(summary.contains("🔱"));
}

#[test]
fn test_invalid_utf8_graceful() {
    let invalid = vec![0xFF, 0xFE, 0xFD]; // Invalid UTF-8
    let result = String::from_utf8_lossy(&invalid);
    assert_eq!(result, "���"); // Replacement chars
}
```

---

**Next:** Implement fixes, test with R18 crash scenarios
