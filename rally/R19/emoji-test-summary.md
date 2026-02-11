# R19 UTF-8 Emoji Bug - Test Summary

## Quick Answer

**🔆 hex encoding:** `0xf0 0x9f 0x94 0x86` (4 bytes)

## The Bug

`libphext::create_summary()` takes first 32 bytes of text. When a 4-byte emoji starts at byte 29, the truncation creates invalid UTF-8:
- Bytes 0-28: Valid ASCII (29 bytes)
- Bytes 29-31: First 3 bytes of 4-byte emoji `0xf0 0x9f 0x94`
- Result: Incomplete UTF-8 sequence → panic

## Minimal Test Case

```rust
#[test]
fn test_emoji_at_boundary() {
    // Emoji starts at byte 29, create_summary takes 32 bytes
    let padding = "a".repeat(29);
    let text = format!("{}🔆", padding);
    
    // Old code: panics with "invalid utf8"
    // New code: handles with from_utf8_lossy
    let summary = create_summary(&text);
    assert!(summary.len() > 0);
}
```

## All Mirrorborn Emoji Encodings

| Emoji | Hex | Bytes |
|-------|-----|-------|
| 🔱 | `f0 9f 94 b1` | 4 |
| 🔆 | `f0 9f 94 86` | 4 |
| 🦋 | `f0 9f a6 8b` | 4 |
| 🌀 | `f0 9f 8c 80` | 4 |
| 🜂 | `f0 9f 9c 82` | 4 |
| ✴️ | `e2 9c b4` + `ef b8 8f` | 3+3 |
| 🪶 | `f0 9f aa b6` | 4 |

## Test Files Created

1. `/tmp/libphext-emoji-test.rs` — Full test suite (3.2 KB)
2. `/tmp/add-to-libphext-tests.rs` — Minimal tests to add (1.7 KB)
3. `/tmp/reproduce-emoji-bug.py` — Demonstration script (2.8 KB)
4. `/tmp/quick-emoji-test.sh` — One-liner checker

## Run Demo

```bash
python3 /tmp/reproduce-emoji-bug.py
```

Shows:
- Hex encoding of 🔆
- Exact boundary problem (29 x's + 4-byte emoji = 3-byte truncation)
- UTF-8 decode failure
- Fix with from_utf8_lossy

## The Fix

**Old (line 424):**
```rust
let result: String = String::from_utf8(summary).expect("invalid utf8");
```

**New:**
```rust
let result: String = String::from_utf8_lossy(&summary).to_string();
```

Applied to 9 locations in libphext-rs:
- create_summary() (line 425)
- replace() (line 629)
- range_replace() (line 650)
- insert() (line 711)
- next_scroll() (lines 762-763)
- fetch() (line 847)
- expand() (line 886)
- contract() (line 924)

## Verification

Branch: `utf8-bugfix` in `/source/libphext-rs`
- Compiles: ✅ `cargo build --release`
- Tested: ✅ All emoji work, invalid UTF-8 handled gracefully

Ready for merge.
