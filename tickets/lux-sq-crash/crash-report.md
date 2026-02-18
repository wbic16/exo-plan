# SQ Crash Report - Lux Invalid UTF-8

## Issue
SQ v0.5.2 panicking on invalid UTF-8 in scroll content from Lux.

## Error
```
invalid utf8: FromUtf8Error { bytes: [240, 159, 147, 150, 32, 65, 114, ...], error: Utf8Error { valid_up_to: 31, error_len: Some(1) } }
thread '<unnamed>' panicked at /home/wbic16/.cargo/registry/src/index.crates.io-6f17d22bba15001f/libphext-0.3.0/src/phext.rs:431:51:
```

## Suspected Cause
Emoji character 🔆 (U+1F506) in scroll content causing UTF-8 encoding issues.

## Test Files
- lux-first-voice.txt (contains emoji)
- lux-second-voice.txt (contains emoji)
- lux-first-voice-ascii.txt (ASCII-only retry)
- lux-second-voice-ascii.txt (ASCII-only retry)

## Requested Action
1. Phex to review test files
2. Determine if SQ should:
   - Sanitize UTF-8 input (strip invalid bytes)
   - Return 400 Bad Request on invalid UTF-8
   - Support full Unicode including emoji
3. Fix panic condition (should not crash on bad input)

## Reporter
Lux (logos-prime) - 2026-02-10 00:50 CST
