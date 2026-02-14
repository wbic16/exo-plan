# Phext 9D Structure & Information Propagation

**Technical Whitepaper Diagram**  
**Author:** Phex 🔱  
**Date:** 2026-02-14  
**Purpose:** Pedagogical explanation of phext's 9-dimensional text lattice

---

## Introduction: From 2D to 9D

Traditional text is 2-dimensional:
- **X-axis:** Characters in a line
- **Y-axis:** Lines in a document

Phext extends this to **11 dimensions** (9 structural + 2 traditional):
- **9 structural dimensions** via Delimiters of Unusual Size
- **2 traditional dimensions** (X, Y within each scroll)

This document focuses on the **9 structural dimensions**.

---

## Part 1: The Nine Delimiters

Phext uses 9 special delimiters (control characters) to create dimensional boundaries:

| Dim | Name | Hex | Capacity | Resets |
|-----|------|-----|----------|--------|
| 1 | SCROLL | 0x17 | 100 scrolls | None |
| 2 | SECTION | 0x18 | 100 sections | Scroll → 1 |
| 3 | CHAPTER | 0x19 | 100 chapters | Section → 1, Scroll → 1 |
| 4 | BOOK | 0x1A | 100 books | Chapter → 1, Section → 1, Scroll → 1 |
| 5 | VOLUME | 0x1C | 100 volumes | Book → 1, ... |
| 6 | COLLECTION | 0x1D | 100 collections | Volume → 1, ... |
| 7 | SERIES | 0x1E | 100 series | Collection → 1, ... |
| 8 | SHELF | 0x1F | 100 shelves | Series → 1, ... |
| 9 | LIBRARY | 0x01 | 100 libraries | Shelf → 1, ... |

**Key insight:** Each delimiter **resets all lower dimensions** to 1.

Example: When you encounter SECTION delimiter, scroll count resets to 1.

---

## Part 2: Building Up — 1D to 3D

### 1D: Scrolls (Base Case)

```
[Scroll 1] SCROLL_DELIM [Scroll 2] SCROLL_DELIM [Scroll 3]
```

**Coordinate:** `1.1.1/1.1.1/1.1.1/scroll_N`

**Structure:** Linear linked list of text chunks

---

### 2D: Sections Containing Scrolls

```
Section 1:
  [Scroll 1] SCROLL [Scroll 2] SCROLL [Scroll 3]
SECTION_DELIM
Section 2:
  [Scroll 1] SCROLL [Scroll 2]
```

**Coordinate:** `1.1.1/1.1.1/1.1.section_N/scroll_M`

**Structure:** Each section contains up to 100 scrolls. Sections form a linked list.

---

### 3D: Chapters Containing Sections

```
Chapter 1:
  Section 1: [scrolls...]
  Section 2: [scrolls...]
CHAPTER_DELIM
Chapter 2:
  Section 1: [scrolls...]
```

**Coordinate:** `1.1.1/1.1.1/chapter_N/section_M/scroll_P`

**Structure:** Each chapter contains up to 100 sections. Chapters form a linked list.

---

## Part 3: The Full 9D Lattice

### Coordinate Format

```
library.shelf.series/collection.volume.book/chapter.section.scroll
```

Example: `1.5.2/3.7.3/9.1.1`
- Library 1, Shelf 5, Series 2
- Collection 3, Volume 7, Book 3
- Chapter 9, Section 1, Scroll 1

### Hierarchical Tree Structure

```
LIBRARY 1
├── SHELF 1
│   ├── SERIES 1
│   │   ├── COLLECTION 1
│   │   │   ├── VOLUME 1
│   │   │   │   ├── BOOK 1
│   │   │   │   │   ├── CHAPTER 1
│   │   │   │   │   │   ├── SECTION 1
│   │   │   │   │   │   │   ├── SCROLL 1 (text)
│   │   │   │   │   │   │   ├── SCROLL 2 (text)
│   │   │   │   │   │   ├── SECTION 2
│   │   │   │   │   │   │   └── SCROLL 1 (text)
│   │   │   │   │   ├── CHAPTER 2...
│   │   │   │   ├── BOOK 2...
│   │   │   ├── VOLUME 2...
│   │   ├── COLLECTION 2...
│   ├── SERIES 2...
├── SHELF 2...
```

**Total capacity:** 100^9 = 10^18 addressable scrolls

---

## Part 4: Leaf Node Interconnects

### What Are Leaf Nodes?

**Leaf nodes = scrolls** (the bottom of the hierarchy, containing actual text)

### How Scrolls Interconnect

**Within a section:** Scrolls form a **linked list**

```
Section 1.1:
  Scroll 1 → Scroll 2 → Scroll 3 → ... → Scroll 100
```

**Coordinate lookup:** `1.1.1/1.1.1/1.1.1/3` = "Third scroll in this path"

### How Sections Interconnect

**Within a chapter:** Sections form a **linked list**

```
Chapter 1:
  Section 1 (contains scrolls 1-100)
    ↓
  Section 2 (contains scrolls 1-100)
    ↓
  Section 3...
```

**Navigation:**
- `1.1.1/1.1.1/1.2.5` = "Chapter 1, Section 2, Scroll 5"
- Moving to next section increments middle coordinate

### Full 9D Interconnect Model

Each dimension is a **doubly-linked list** of containers:

```
LIBRARY 1 ⇄ LIBRARY 2 ⇄ LIBRARY 3 ⇄ ...
    ↓           ↓           ↓
  SHELF 1    SHELF 1    SHELF 1
    ↓           ↓           ↓
  SERIES 1   SERIES 1   SERIES 1
    ↓           ↓           ↓
    ...        ...        ...
    ↓           ↓           ↓
  SCROLL 1   SCROLL 1   SCROLL 1
```

**Key property:** Each node knows its:
- **Parent** (higher dimension container)
- **Previous sibling** (same dimension, previous index)
- **Next sibling** (same dimension, next index)
- **Children** (lower dimension containers)

---

## Part 5: Information Propagation

### Bottom-Up Propagation (Aggregation)

**Scenario:** Counting total words across a library

```
1. Read each SCROLL → count words
2. Sum scrolls within each SECTION
3. Sum sections within each CHAPTER
4. Sum chapters within each BOOK
5. ...
9. Sum shelves within LIBRARY
```

**Pattern:** Leaf → intermediate nodes → root

**Use case:** Search, indexing, statistical analysis

---

### Top-Down Propagation (Distribution)

**Scenario:** Applying a style change to an entire series

```
1. Start at SERIES coordinate (e.g., 1.1.3)
2. Iterate through all COLLECTIONS in that series
3. For each COLLECTION, iterate all VOLUMES
4. ...
9. For each SCROLL, apply transformation
```

**Pattern:** Root → intermediate nodes → leaves

**Use case:** Bulk updates, theming, access control

---

### Lateral Propagation (Peer Communication)

**Scenario:** Cross-referencing between books

```
BOOK 1.1.1/1.1.2/1.1.1 references BOOK 1.1.1/1.1.5/1.1.1

Navigation:
1. Traverse up to common ancestor (VOLUME 1.1.1/1.1)
2. Traverse down to target book (1.1.1/1.1.5)
3. Read target content
```

**Pattern:** Leaf A → common ancestor → Leaf B

**Use case:** Hyperlinks, citations, memory associations

---

## Part 6: Hierarchical Hash Table Model

### Coordinate → Content Lookup

Phext coordinates act as a **hierarchical hash table**:

```
Hash(library.shelf.series/collection.volume.book/chapter.section.scroll)
  → Offset in file
```

**Two-stage lookup:**

**Stage 1: Parse coordinate**
```
"1.5.2/3.7.3/9.1.1" → {
  library: 1,
  shelf: 5,
  series: 2,
  collection: 3,
  volume: 7,
  book: 3,
  chapter: 9,
  section: 1,
  scroll: 1
}
```

**Stage 2: Traverse tree**
```
1. Seek to library 1 (offset 0)
2. Seek to shelf 5 within library 1
3. Seek to series 2 within shelf 5
4. ...
9. Read scroll 1 within section 1
```

**Optimization:** Cache intermediate offsets (shelf 5 = byte 12800, etc.)

---

### Sparse Storage

**Key insight:** Most coordinates are empty.

Instead of allocating 100^9 slots upfront, phext uses **sparse hash table**:

```
{
  "1.1.1/1.1.1/1.1.1": "Hello world",
  "1.5.2/3.7.3/9.1.1": "Mirrorborn coordinate",
  "2.3.5/7.11.13/17.19.23": "Lux's home"
}
```

**Only occupied coordinates consume space.**

Physical file format:
```
[LIBRARY 0x01]
[SHELF 0x1F] (index 1)
[SCROLL 0x17] (index 1)
Hello world
[SCROLL 0x17] (end)
[SHELF 0x1F] (index 5)
[SERIES 0x1E] (index 2)
...
```

---

## Part 7: Working Memory & Civilizational Scale

### The Working Memory Problem

**Human cognitive limit:** 3-5 items in working memory simultaneously

**Civilizational coordination:** Requires reasoning about millions of concepts

**Phext solution:** Hierarchical addressing reduces cognitive load

---

### Example: Coordinating 387 Million Concepts

**Without phext:** Track 387M UUIDs → impossible for human working memory

**With phext:** Track 9 coordinates of 100 each → 9 items in working memory

```
Coordinate: 12.34.56/78.90.12/34.56.78

Human reads this as:
- "Library 12, Shelf 34, Series 56"
- "Collection 78, Volume 90, Book 12"
- "Chapter 34, Section 56, Scroll 78"

= 9 numbers to hold in mind, not 387 million
```

**Chunking:** Each dimension is a "chunk" (Miller's Law: 7±2 chunks)

---

### Hector's 9^9 Calculation

**Question:** "How do you reason at civilizational scale with 9 dimensions?"

**Answer:** 9^9 = 387,420,489 addressable nodes

But humans don't reason about all 387M at once. They reason about:
- **Local context:** Current chapter/section/scroll
- **Parent context:** What book/volume am I in?
- **Sibling context:** Previous/next scroll

**Working memory load:** 3-5 chunks (local + parent + sibling), not 387M.

---

## Part 8: Information Propagation Patterns

### Pattern 1: Depth-First Traversal

```
Visit all scrolls in section 1
Visit all scrolls in section 2
...
Visit all scrolls in section 100
Move to next chapter
```

**Use case:** Sequential reading, full-text search

---

### Pattern 2: Breadth-First Traversal

```
Visit scroll 1 in all sections
Visit scroll 2 in all sections
...
```

**Use case:** Sampling, cross-sectional analysis

---

### Pattern 3: Random Access

```
Jump directly to coordinate 1.5.2/3.7.3/9.1.1
Read content
Jump to 2.3.5/7.11.13/17.19.23
```

**Use case:** Hyperlinks, memory recall, coordinate-addressed messaging

---

### Pattern 4: Range Queries

```
Read all scrolls in range:
  1.1.1/1.1.1/1.1.1 → 1.1.1/1.1.1/5.100.100

= First 5 chapters of book 1
```

**Use case:** Phext "views" (selected subset of lattice)

---

## Part 9: SQ Implementation Details

### How SQ Stores Phext

**File format:** Linear stream of delimiters + text

```
Hello[0x17]World[0x17]More text[0x18]Section 2[0x17]Data[0x19]Chapter 2...
```

**Delimiter scanning:** Sequential read to build coordinate index

**Index structure:**
```json
{
  "1.1.1/1.1.1/1.1.1": { "offset": 0, "length": 5 },
  "1.1.1/1.1.1/1.1.2": { "offset": 6, "length": 5 },
  "1.1.1/1.1.1/2.1.1": { "offset": 23, "length": 9 }
}
```

**Lookup speed:** O(1) after indexing, O(n) for first scan

---

### Multi-Tenant Isolation

**Problem:** Multiple users sharing one SQ instance

**Solution:** Tenant namespace as phext prefix

```
alice.1.1.1/1.1.1/1.1.1 → /data/alice/file.phext
bob.1.1.1/1.1.1/1.1.1   → /data/bob/file.phext
```

**Isolation:** Different physical files, same coordinate address space

---

## Part 10: Pedagogical Summary

### Key Concepts

1. **9 delimiters** create 9 structural dimensions
2. **Hierarchical tree** with 100 branches per level
3. **Leaf nodes (scrolls)** contain actual text
4. **Linked list** structure per dimension
5. **Sparse hash table** for coordinate → content lookup
6. **Working memory reduction** via hierarchical chunking
7. **Information propagates** bottom-up, top-down, laterally
8. **SQ implements** this as delimiter-separated file + index

### Why This Matters

**Without phext:** Text is flat (2D). No native coordinate system.

**With phext:** Text is structured (11D). Coordinates enable:
- **Persistent AI memory** (Mirrorborn use case)
- **Distributed coordination** (SQ mesh networking)
- **Civilizational-scale reasoning** (9^9 addressable nodes, 3-5 working memory load)

### Next Steps

**For Hector (or any reader):**
1. Clone SQ: `git clone https://github.com/wbic16/SQ`
2. Create a phext file with delimiters
3. Use `sq select` to navigate coordinates
4. Watch how information propagates through dimensions

**Visual diagram:** See next section (SVG rendering)

---

## Appendix: ASCII Diagram

```
PHEXT 9D LATTICE STRUCTURE

                    LIBRARY (Dim 9)
                        |
        +---------------+---------------+
        |               |               |
     SHELF 1         SHELF 2         SHELF 3  (Dim 8)
        |               |               |
    +---+---+       +---+---+       +---+---+
    |       |       |       |       |       |
 SERIES 1 SERIES 2   ...             ...    (Dim 7)
    |
    +-------+-------+
    |       |       |
  COLL 1  COLL 2  COLL 3                    (Dim 6)
    |
    +-------+
    |       |
  VOL 1   VOL 2                             (Dim 5)
    |
    +-------+
    |       |
  BOOK 1  BOOK 2                            (Dim 4)
    |
    +-------+
    |       |
  CHAP 1  CHAP 2                            (Dim 3)
    |
    +-------+
    |       |
  SECT 1  SECT 2                            (Dim 2)
    |
    +-------+-------+-------+
    |       |       |       |
 SCROLL 1 SCROLL 2 SCROLL 3 ...             (Dim 1)
    |       |       |
   TEXT    TEXT    TEXT                     (Leaf nodes)


INFORMATION PROPAGATION PATHS:

Bottom-Up (Aggregation):
  SCROLL → SECTION → CHAPTER → ... → LIBRARY

Top-Down (Distribution):
  LIBRARY → ... → CHAPTER → SECTION → SCROLL

Lateral (Cross-Reference):
  SCROLL A → Common Ancestor → SCROLL B


COORDINATE ADDRESSING:

  1.5.2/3.7.3/9.1.1
  │ │ │ │ │ │ │ │ └─ Scroll 1
  │ │ │ │ │ │ │ └─── Section 1
  │ │ │ │ │ │ └───── Chapter 9
  │ │ │ │ │ └─────── Book 3
  │ │ │ │ └───────── Volume 7
  │ │ │ └─────────── Collection 3
  │ │ └───────────── Series 2
  │ └─────────────── Shelf 5
  └───────────────── Library 1
```

---

**End of Technical Whitepaper**

🔱 Phex  
Engineering  
1.5.2/3.7.3/9.1.1
