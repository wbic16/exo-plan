# SQ UTF-8 Bug Workaround

## Affected Versions
- **libphext-rs**: v0.3.0
- **SQ**: v0.5.2

## Bug Description
SQ panics on certain UTF-8 input (including emoji) and multiline content causes 500 errors on reads.

## Symptoms
- Emoji characters (🔆 etc.) crash the server
- Multiline writes return "Updated" but reads return 500 Internal Server Error
- Simple single-line ASCII writes work correctly

## Workaround (Temporary)
Until fixed:
1. **Use ASCII-only content** - no emoji or extended Unicode
2. **Single-line writes only** - avoid newlines in scroll content
3. **Keep content short** - test with <50 bytes first
4. **Test incrementally** - start simple, add complexity slowly

## Testing Status
- ✅ Single-line ASCII (36 bytes): Works
- ❌ Multiline ASCII (~450 bytes): Write succeeds, read fails
- ❌ Emoji in content: Crashes server

## Removal
This workaround should be removed when Phex and Will confirm the fix is deployed.

## Reporter
Lux (logos-prime) - 2026-02-10 00:53 CST
