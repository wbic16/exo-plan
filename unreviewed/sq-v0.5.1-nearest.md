# SQ v0.5.1 — Nearest Coordinate & Navigation

**Status:** Unreviewed
**Author:** Phex 🔱
**Date:** 2026-01-31

## Motivation
Random coordinate queries in sparse phext space almost always return empty. Users need a way to discover nearby content without knowing the exact coordinate.

## New Endpoints

### `GET /api/v2/nearest?p=<phext>&c=<coordinate>`
Returns the closest populated scroll to the requested coordinate.

**Response:**
```json
{
  "requested": "5.5.5/5.5.5/5.5.5",
  "nearest": "3.1.7/5.5.5/1.1.3",
  "distance": 14,
  "content": "..."
}
```

**Distance metric options:**
- Manhattan distance across 9 dimensions (simple, fast)
- Weighted Manhattan (lower dims weighted higher — scroll distance matters more than library distance)
- Euclidean (more accurate but slower)

Recommend: weighted Manhattan. Scrolls within the same book are "closer" than scrolls in different libraries, even if the raw numbers are similar.

### `GET /api/v2/random?p=<phext>`
Returns a random populated scroll. Built-in roulette mode.

**Response:**
```json
{
  "coordinate": "222.222.222/222.222.222/222.222.222",
  "content": "❖ – Bastion: Love Walker"
}
```

## Input Validation

### Scroll content validation on write
All write endpoints (`insert`, `update`) must reject content containing:
1. **Invalid UTF-8** — malformed byte sequences
2. **Phext delimiters** (0x01, 0x17–0x1F) — scrolls must not contain raw delimiter bytes

This keeps the API sane: scrolls are pure content, delimiters are structural. If a user embeds a LIBRARY_BREAK inside a scroll, the entire phext coordinate space corrupts on next load.

**Implementation:** Validate input bytes before writing. Return 400 Bad Request with clear error message if invalid bytes detected.

**Trade-off:** Slightly limits the API (can't store arbitrary binary), but prevents structural corruption. Worth it.

## Bug Fixes

### TOC UTF-8 panic on emoji boundaries
`/api/v2/toc` panics when truncating scroll summaries that contain multi-byte UTF-8 characters (emoji). The truncation in `libphext-rs` at `phext.rs:431` slices mid-codepoint.

**Fix:** Use `char_indices()` or `.chars().take(n)` instead of byte-level slicing for summary truncation.

## Implementation Notes
- Requires building and caching a coordinate index on `load`
- Index is just a Vec<Coordinate> of populated scrolls
- `nearest` does a linear scan of the index (800 scrolls = microseconds)
- `random` picks a random index entry
- TOC fix is in libphext-rs, needs a patch release there first

## Dependencies
- libphext-rs patch for UTF-8 safe truncation
- SQ main branch
