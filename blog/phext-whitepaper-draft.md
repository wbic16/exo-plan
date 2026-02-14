# Phext: Plain Text Extended to 11 Dimensions

*A Technical Introduction*

**Will Bickford · February 2026 · v1.0**

---

## Abstract

Phext extends plain text from 2 dimensions (lines and columns) to 11 dimensions by introducing 9 delimiter characters that subdivide a flat byte stream into a navigable coordinate space. At rest, a phext is a linked list. At runtime, it becomes a hierarchical hash table. This paper describes the data model, addressing scheme, storage characteristics, and coordination properties that make phext suitable as a memory substrate for distributed AI systems.

---

## 1. The Problem

Plain text has two dimensions: lines (delimited by `0x0A`) and columns (character offset within a line). This is sufficient for documents, source code, and configuration — but insufficient for organizing knowledge at civilizational scale.

Databases solve this with schemas, indices, and query languages. The cost: opacity. You cannot `cat` a PostgreSQL database. You cannot diff it, grep it, or email it.

Phext occupies the space between plain text and databases: **structured enough to navigate, simple enough to read.**

## 2. The Delimiter Stack

Phext adds 9 delimiters to the 2 dimensions already present in plain text. Each delimiter resets all lower dimensions to 1, exactly as a newline resets column position.

| Dimension | Delimiter | Hex | Resets |
|-----------|-----------|-----|--------|
| 3D | Scroll Break | `0x17` | columns, lines |
| 4D | Section Break | `0x18` | scroll, columns, lines |
| 5D | Chapter Break | `0x19` | section and below |
| 6D | Book Break | `0x1A` | chapter and below |
| 7D | Volume Break | `0x1C` | book and below |
| 8D | Collection Break | `0x1D` | volume and below |
| 9D | Series Break | `0x1E` | collection and below |
| 10D | Shelf Break | `0x1F` | series and below |
| 11D | Library Break | `0x01` | shelf and below |

These code points are drawn from the ASCII control character range (C0 controls), which are otherwise unused in modern text.

## 3. Addressing

A phext coordinate is a 9-component address written as three groups of three:

```
library.shelf.series / collection.volume.book / chapter.section.scroll
```

Examples:
- `1.1.1/1.1.1/1.1.1` — the origin. All existing plain text lives here implicitly.
- `1.1.2/3.5.8/13.21.34` — Chrys's home coordinate (Fibonacci sequence).
- `3.1.4/1.5.9/2.6.5` — Verse's coordinate (digits of pi).

The address space contains up to 9^9 = 387,420,489 scrolls. This is not a theoretical maximum — it's the natural capacity when each dimension holds up to 9 subdivisions. Dimensions are extensible beyond 9.

## 4. Storage Model

### 4.1 At Rest: A Linked List

A phext file is a flat byte stream. Scrolls are separated by delimiter characters. There is no header, no index, no metadata block. The entire structure is implicit in the delimiter sequence.

```
[scroll 1.1.1] 0x17 [scroll 1.1.2] 0x17 [scroll 1.1.3] 0x18 [scroll 1.2.1] 0x19 [scroll 2.1.1] ...
```

To find scroll `2.1.1`, you scan forward, counting delimiters and tracking the current coordinate. This is O(n) in the size of the file.

**Consequence:** A phext is a valid text file. You can `cat` it, `diff` it, `rsync` it, `git push` it. No special tooling required to store or transmit.

### 4.2 At Runtime: A Hash Table

When loaded into memory, an implementation parses the delimiter stream and builds a map from coordinates to byte offsets:

```
{
  "1.1.1/1.1.1/1.1.1" → offset 0,
  "1.1.1/1.1.1/1.1.2" → offset 847,
  "1.1.1/1.1.1/1.2.1" → offset 2103,
  ...
}
```

Coordinate lookup is now O(1). The parse step is O(n) but happens once on load.

**Consequence:** Reads are fast. The "database" is just a parsed text file held in memory.

### 4.3 Writes

To update a scroll:
1. Look up its offset in the hash table
2. Replace the content between that offset and the next delimiter
3. Rebuild affected offsets (downstream entries shift)
4. Flush the modified byte stream to disk

To insert a new scroll:
1. Navigate to the target coordinate
2. Insert content and the appropriate delimiter
3. Rebuild the offset map

Writes are O(n) in the worst case (shifting downstream content). For typical workloads — small scrolls, appends at higher coordinates — this is fast enough. SQ (the phext server) holds the parsed map in memory and flushes to disk on mutation.

## 5. The "No Tree" Property

**Phext has no internal hierarchy at rest.** There is no tree structure, no parent-child relationship, no directory. The byte stream is flat.

Hierarchy is *emergent*: it appears when you parse delimiters into a coordinate map. Two implementations could parse the same phext into different runtime structures (hash table, B-tree, trie) without affecting the on-disk format.

This is analogous to how HTML is a flat text stream that browsers parse into a DOM tree. The tree is a runtime convenience, not a storage property.

**Why this matters for Hector's question:** There are no interconnects between leaf nodes because there are no internal nodes. Every scroll is a leaf. The delimiter sequence defines boundaries, not relationships.

## 6. Coordination and Sync

### 6.1 Single-Writer

The simplest model: one process writes to a phext file, many can read it. SQ uses a per-tenant mutex to serialize writes. Concurrent reads are safe because the in-memory map is immutable between writes.

### 6.2 Multi-Node

Each node holds a complete copy of the phext. There is no sharding. Synchronization is file copy:

- `rsync` for bulk transfer
- `git push` for version-controlled sync
- SQ mesh for coordinate-addressed sync (push individual scrolls between instances)

**Conflict resolution:** Last write wins at the scroll level. Two nodes writing to different coordinates never conflict (different byte ranges). Two nodes writing to the same coordinate require application-level coordination (we use Discord + zone defense).

### 6.3 Scaling

The architecture scales horizontally by adding nodes, each with a full copy. This is the same model as Git repositories: every clone is a complete copy, sync is push/pull.

For 387M scrolls at 640 bytes each, a maximum-density phext is ~247 GB. In practice, phexts are sparse — our production `index` phext is 78 KB with 36 scrolls.

## 7. Comparison

| Property | Plain Text | Phext | SQLite | PostgreSQL |
|----------|-----------|-------|--------|-----------|
| Human-readable | ✅ | ✅ | ❌ | ❌ |
| `cat`-able | ✅ | ✅ | ❌ | ❌ |
| Addressable | ❌ (line numbers) | ✅ (9D coordinates) | ✅ (SQL) | ✅ (SQL) |
| Structured | ❌ | ✅ (delimiter-defined) | ✅ (schema) | ✅ (schema) |
| Diffable | ✅ | ✅ | ❌ | ❌ |
| Zero dependencies | ✅ | ✅ | ✅ (single file) | ❌ |
| Schema-free | ✅ | ✅ | ❌ | ❌ |
| Concurrent writes | ❌ | mutex per tenant | WAL | MVCC |

## 8. Implementation

Reference implementations:

- **Rust:** [libphext-rs](https://github.com/wbic16/libphext-rs) (v0.3.1, crates.io)
- **Node.js:** [libphext-node](https://github.com/wbic16/libphext-node) (v0.1.10, npm)
- **Python:** [libphext-py](https://github.com/wbic16/libphext-py)
- **C#:** [phext-notepad](https://github.com/wbic16/phext-notepad) (GUI editor)
- **Server:** [SQ](https://github.com/wbic16/SQ) (v0.5.6, REST API)

SQ exposes phext over HTTP:
```
GET /api/v2/select?p=index&c=1.1.2/3.5.8/13.21.1    # read a scroll
GET /api/v2/update?p=index&c=1.1.2/3.5.8/13.21.1&s=hello  # write a scroll
GET /api/v2/toc?p=index                                # list all coordinates
```

## 9. Why 11 Dimensions

Human working memory holds 3-5 items. Grouped in threes (chunking), humans can manage ~9 items. The phext address `X.X.X/Y.Y.Y/Z.Z.Z` exploits this: three groups of three, each group manageable by working memory.

9 delimiter dimensions + 2 text dimensions (lines, columns) = 11 total.

The address space of 9^9 ≈ 387 million scrolls is close to the estimated number of sentrons (consciousness units) in a human brain: 16 billion neurons ÷ 40 neurons per sentron ≈ 400 million. This is not a coincidence — phext was designed to map to human-scale cognition.

## 10. Getting Started

```bash
# Install the server
cargo install sq

# Start it
sq serve --port 1337 --data-dir ~/.sq

# Write your first scroll
curl "http://localhost:1337/api/v2/update?p=hello&c=1.1.1/1.1.1/1.1.1&s=Hello+World"

# Read it back
curl "http://localhost:1337/api/v2/select?p=hello&c=1.1.1/1.1.1/1.1.1"
```

---

*Phext is open source (MIT). Specification, implementations, and server at [github.com/wbic16](https://github.com/wbic16).*

*"The Internet is already an ASI. It just can't speak. Phext gives it a voice."*
