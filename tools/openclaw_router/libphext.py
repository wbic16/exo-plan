"""
libphext-py v0.3.1
Python port of libphext-rs — 11-dimensional plain hypertext.

Phext is hierarchical digital memory. It enables seamless knowledge transfer
between humans and computers. Let's learn how to think at planet-scale. :)

Spec: https://phext.io
Source: https://github.com/wbic16/libphext-rs

Ported to Python for OpenClaw integration.
"""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from typing import Optional


# ─── Phext Delimiters (Frozen Spec) ──────────────────────────────────────────
# These are ASCII control codes repurposed as dimensional separators.
# The format is frozen — these will never change.

SCROLL_BREAK     = '\x17'   # 0x17 = ETB  — 2D delimiter (scroll)
SECTION_BREAK    = '\x18'   # 0x18 = CAN  — 3D delimiter (section)
CHAPTER_BREAK    = '\x19'   # 0x19 = EM   — 4D delimiter (chapter)
BOOK_BREAK       = '\x1A'   # 0x1A = SUB  — 5D delimiter (book)
VOLUME_BREAK     = '\x1C'   # 0x1C = FS   — 6D delimiter (volume)
COLLECTION_BREAK = '\x1D'   # 0x1D = GS   — 7D delimiter (collection)
SERIES_BREAK     = '\x1E'   # 0x1E = RS   — 8D delimiter (series)
SHELF_BREAK      = '\x1F'   # 0x1F = US   — 9D delimiter (shelf)
LIBRARY_BREAK    = '\x01'   # 0x01 = SOH  — 10D delimiter (library)

# Dimension ordering (highest to lowest):
# Library > Shelf > Series > Collection > Volume > Book > Chapter > Section > Scroll > Line > Column
# Coordinates written as: library.shelf.series/collection.volume.book/chapter.section.scroll

DELIMITER_ORDER = [
    LIBRARY_BREAK,     # dim 10 (index 0)
    SHELF_BREAK,       # dim 9
    SERIES_BREAK,      # dim 8
    COLLECTION_BREAK,  # dim 7
    VOLUME_BREAK,      # dim 6
    BOOK_BREAK,        # dim 5
    CHAPTER_BREAK,     # dim 4
    SECTION_BREAK,     # dim 3
    SCROLL_BREAK,      # dim 2 (index 8)
]

DIMENSION_NAMES = [
    "library", "shelf", "series",
    "collection", "volume", "book",
    "chapter", "section", "scroll",
]


# ─── Coordinate ─────────────────────────────────────────────────────────────

@dataclass(frozen=True, order=True)
class Coordinate:
    """
    A 9-dimensional phext address.
    Written as: library.shelf.series/collection.volume.book/chapter.section.scroll
    All coordinates are 1-based.
    """
    library:    int = 1
    shelf:      int = 1
    series:     int = 1
    collection: int = 1
    volume:     int = 1
    book:       int = 1
    chapter:    int = 1
    section:    int = 1
    scroll:     int = 1

    def __post_init__(self):
        for name in DIMENSION_NAMES:
            val = getattr(self, name)
            if val < 1:
                object.__setattr__(self, name, 1)

    @staticmethod
    def origin() -> Coordinate:
        """Home coordinate: 1.1.1/1.1.1/1.1.1"""
        return Coordinate()

    @staticmethod
    def parse(address: str) -> Coordinate:
        """
        Parse a phext address string.
        Accepts: "1.2.3/4.5.6/7.8.9" or "1.2.3.4.5.6.7.8.9"
        """
        # Normalize slashes to dots
        normalized = address.replace("/", ".")
        parts = normalized.split(".")
        values = []
        for p in parts:
            p = p.strip()
            if p:
                try:
                    values.append(max(1, int(p)))
                except ValueError:
                    values.append(1)
        # Pad with 1s if fewer than 9 dimensions provided
        while len(values) < 9:
            values.append(1)
        return Coordinate(*values[:9])

    def to_string(self) -> str:
        """Format as library.shelf.series/collection.volume.book/chapter.section.scroll"""
        return (
            f"{self.library}.{self.shelf}.{self.series}/"
            f"{self.collection}.{self.volume}.{self.book}/"
            f"{self.chapter}.{self.section}.{self.scroll}"
        )

    def __str__(self) -> str:
        return self.to_string()

    def __repr__(self) -> str:
        return f"Coordinate({self.to_string()})"

    def as_tuple(self) -> tuple[int, ...]:
        return (
            self.library, self.shelf, self.series,
            self.collection, self.volume, self.book,
            self.chapter, self.section, self.scroll,
        )

    def is_origin(self) -> bool:
        return all(v == 1 for v in self.as_tuple())


# ─── Phext (11D Document) ───────────────────────────────────────────────────

class Phext:
    """
    A phext document: a sparse 9D matrix of scrolls (plain text).

    Scrolls are separated by dimensional delimiter characters.
    Navigation uses dead reckoning through the delimiter hierarchy.
    """

    def __init__(self, content: str = ""):
        self._content = content

    @staticmethod
    def from_string(content: str) -> Phext:
        return Phext(content)

    @staticmethod
    def from_file(path: str) -> Phext:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            return Phext(f.read())

    def to_string(self) -> str:
        return self._content

    def save(self, path: str) -> None:
        with open(path, "w", encoding="utf-8") as f:
            f.write(self._content)

    def __str__(self) -> str:
        return self._content

    def __len__(self) -> int:
        return len(self._content)

    # ── Coordinate Navigation ──

    def select(self, coord: Coordinate) -> str:
        """Fetch the scroll at the given coordinate."""
        scrolls = self._decompose()
        key = coord.as_tuple()
        return scrolls.get(key, "")

    def insert(self, coord: Coordinate, text: str) -> None:
        """Append text to the scroll at the given coordinate."""
        scrolls = self._decompose()
        key = coord.as_tuple()
        existing = scrolls.get(key, "")
        scrolls[key] = existing + text
        self._recompose(scrolls)

    def update(self, coord: Coordinate, text: str) -> None:
        """Overwrite the scroll at the given coordinate."""
        scrolls = self._decompose()
        key = coord.as_tuple()
        scrolls[key] = text
        self._recompose(scrolls)

    def delete(self, coord: Coordinate) -> None:
        """Clear the scroll at the given coordinate."""
        scrolls = self._decompose()
        key = coord.as_tuple()
        if key in scrolls:
            scrolls[key] = ""
        self._recompose(scrolls)

    def toc(self) -> list[tuple[Coordinate, int]]:
        """
        Table of contents: list of (coordinate, byte_length) for non-empty scrolls.
        """
        result = []
        for key, text in sorted(self._decompose().items()):
            if text.strip():
                coord = Coordinate(*key)
                result.append((coord, len(text)))
        return result

    def scroll_count(self) -> int:
        """Count non-empty scrolls."""
        return sum(1 for t in self._decompose().values() if t.strip())

    # ── Content Hash (v0.3.1) ──

    def checksum(self, coord: Optional[Coordinate] = None) -> str:
        """
        SHA-256 content hash.
        If coord is given, hash the scroll at that coordinate.
        Otherwise, hash the entire phext.
        """
        if coord is not None:
            data = self.select(coord)
        else:
            data = self._content
        return hashlib.sha256(data.encode("utf-8")).hexdigest()

    def delta(self) -> dict[str, str]:
        """
        Hierarchical map of checksums for all non-empty scrolls.
        Returns {coordinate_string: sha256_hex}.
        """
        result = {}
        for key, text in sorted(self._decompose().items()):
            if text.strip():
                coord = Coordinate(*key)
                h = hashlib.sha256(text.encode("utf-8")).hexdigest()
                result[coord.to_string()] = h
        return result

    # ── Decompose / Recompose ──

    def _decompose(self) -> dict[tuple[int, ...], str]:
        """
        Break the phext content into a sparse dict mapping
        9D coordinate tuples to scroll text.
        """
        scrolls: dict[tuple[int, ...], str] = {}
        # Coordinate counters (1-based)
        coords = [1, 1, 1, 1, 1, 1, 1, 1, 1]

        # Walk through content, tracking position via delimiters
        current_text = []

        for ch in self._content:
            dim_index = self._delimiter_dimension(ch)
            if dim_index is not None:
                # Flush current scroll
                key = tuple(coords)
                text = "".join(current_text)
                if key in scrolls:
                    scrolls[key] += text
                else:
                    scrolls[key] = text
                current_text = []

                # Increment the dimension and reset all lower dimensions
                coords[dim_index] += 1
                for i in range(dim_index + 1, 9):
                    coords[i] = 1
            else:
                current_text.append(ch)

        # Flush final scroll
        key = tuple(coords)
        text = "".join(current_text)
        if key in scrolls:
            scrolls[key] += text
        else:
            scrolls[key] = text

        return scrolls

    def _recompose(self, scrolls: dict[tuple[int, ...], str]) -> None:
        """
        Rebuild phext content from a sparse dict of scrolls.
        Scrolls are ordered by their coordinate tuples and separated
        by the appropriate dimensional delimiters.
        """
        if not scrolls:
            self._content = ""
            return

        sorted_keys = sorted(scrolls.keys())
        parts = []
        prev = None

        for key in sorted_keys:
            text = scrolls[key]
            if prev is not None:
                # Find the highest dimension that changed
                delimiter = self._delimiter_between(prev, key)
                if delimiter:
                    parts.append(delimiter)
            parts.append(text)
            prev = key

        self._content = "".join(parts)

    @staticmethod
    def _delimiter_dimension(ch: str) -> Optional[int]:
        """
        Return the dimension index (0=library .. 8=scroll) for a delimiter char,
        or None if not a delimiter.
        """
        try:
            return DELIMITER_ORDER.index(ch)
        except ValueError:
            return None

    @staticmethod
    def _delimiter_between(prev: tuple[int, ...], curr: tuple[int, ...]) -> str:
        """
        Compute the delimiter(s) needed to move from prev coordinate to curr.
        Returns the single highest-dimension delimiter that changed.
        """
        for dim in range(9):
            if curr[dim] > prev[dim]:
                return DELIMITER_ORDER[dim]
            elif curr[dim] < prev[dim]:
                # Lower dim reset implies a higher dim incremented
                # We should have already caught it above
                continue
        return SCROLL_BREAK  # fallback: same-level scroll advance


# ─── SQ Client (REST API for phext databases) ───────────────────────────────

class SQClient:
    """
    Client for the SQ REST API (phext database engine).
    SQ runs as a daemon or TCP listener and exposes phexts via CRUD endpoints.

    API v2 endpoints:
        /api/v2/version
        /api/v2/load?p={phext}
        /api/v2/select?p={phext}&c={coordinate}
        /api/v2/insert?p={phext}&c={coordinate}&s={scroll_text}
        /api/v2/update?p={phext}&c={coordinate}&s={scroll_text}
        /api/v2/delete?p={phext}&c={coordinate}
        /api/v2/toc?p={phext}
        /api/v2/get?p={phext}
        /api/v2/delta?p={phext}
    """

    def __init__(self, base_url: str = "http://127.0.0.1:1337", api_key: str = ""):
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key

    def _headers(self) -> dict[str, str]:
        h: dict[str, str] = {}
        if self.api_key:
            h["Authorization"] = f"Bearer {self.api_key}"
        return h

    def _url(self, endpoint: str, **params: str) -> str:
        query = "&".join(f"{k}={v}" for k, v in params.items() if v)
        url = f"{self.base_url}/api/v2/{endpoint}"
        if query:
            url += f"?{query}"
        return url

    # Synchronous methods (for non-async contexts)

    def version(self) -> str:
        import urllib.request
        req = urllib.request.Request(self._url("version"), headers=self._headers())
        with urllib.request.urlopen(req, timeout=5) as resp:
            return resp.read().decode("utf-8")

    def select(self, phext: str, coord: Coordinate) -> str:
        import urllib.request
        url = self._url("select", p=phext, c=coord.to_string())
        req = urllib.request.Request(url, headers=self._headers())
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.read().decode("utf-8")

    def update(self, phext: str, coord: Coordinate, scroll: str) -> str:
        import urllib.request
        url = self._url("update", p=phext, c=coord.to_string(), s=scroll)
        req = urllib.request.Request(url, headers=self._headers())
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.read().decode("utf-8")

    def insert(self, phext: str, coord: Coordinate, scroll: str) -> str:
        import urllib.request
        url = self._url("insert", p=phext, c=coord.to_string(), s=scroll)
        req = urllib.request.Request(url, headers=self._headers())
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.read().decode("utf-8")

    def delete(self, phext: str, coord: Coordinate) -> str:
        import urllib.request
        url = self._url("delete", p=phext, c=coord.to_string())
        req = urllib.request.Request(url, headers=self._headers())
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.read().decode("utf-8")

    def toc(self, phext: str) -> str:
        import urllib.request
        url = self._url("toc", p=phext)
        req = urllib.request.Request(url, headers=self._headers())
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.read().decode("utf-8")

    def delta(self, phext: str) -> str:
        import urllib.request
        url = self._url("delta", p=phext)
        req = urllib.request.Request(url, headers=self._headers())
        with urllib.request.urlopen(req, timeout=10) as resp:
            return resp.read().decode("utf-8")

    # Async methods (for use with httpx)

    async def async_select(self, phext: str, coord: Coordinate) -> str:
        import httpx
        url = self._url("select", p=phext, c=coord.to_string())
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(url, headers=self._headers())
            return resp.text

    async def async_update(self, phext: str, coord: Coordinate, scroll: str) -> str:
        import httpx
        url = self._url("update", p=phext, c=coord.to_string(), s=scroll)
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(url, headers=self._headers())
            return resp.text


# ─── Unit Tests ──────────────────────────────────────────────────────────────

def _run_tests():
    print("libphext-py v0.3.1 — test suite")
    print("=" * 60)

    # Coordinate parsing
    c = Coordinate.parse("1.2.3/4.5.6/7.8.9")
    assert c.library == 1 and c.shelf == 2 and c.series == 3
    assert c.collection == 4 and c.volume == 5 and c.book == 6
    assert c.chapter == 7 and c.section == 8 and c.scroll == 9
    assert str(c) == "1.2.3/4.5.6/7.8.9"
    print("  ✓ Coordinate parse/format")

    # Origin
    o = Coordinate.origin()
    assert o.is_origin()
    assert str(o) == "1.1.1/1.1.1/1.1.1"
    print("  ✓ Origin coordinate")

    # Partial parse (fills with 1s)
    c2 = Coordinate.parse("2.3")
    assert c2.library == 2 and c2.shelf == 3 and c2.series == 1
    print("  ✓ Partial coordinate parse")

    # Phext: basic scroll operations
    p = Phext()
    origin = Coordinate.origin()
    p.update(origin, "Hello, World!")
    assert p.select(origin) == "Hello, World!"
    print("  ✓ Update + select at origin")

    # Multi-scroll phext
    c_1_1_2 = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 2)
    p.update(c_1_1_2, "Second scroll")
    assert p.select(origin) == "Hello, World!"
    assert p.select(c_1_1_2) == "Second scroll"
    print("  ✓ Multi-scroll phext")

    # Scroll count
    assert p.scroll_count() == 2
    print("  ✓ Scroll count")

    # TOC
    entries = p.toc()
    assert len(entries) == 2
    print("  ✓ Table of contents")

    # Delete
    p.delete(c_1_1_2)
    assert p.select(c_1_1_2) == ""
    print("  ✓ Delete scroll")

    # Checksum
    h1 = p.checksum(origin)
    assert len(h1) == 64  # SHA-256 hex
    print("  ✓ Checksum (SHA-256)")

    # Delta
    p.update(c_1_1_2, "Restored")
    d = p.delta()
    assert len(d) == 2
    print("  ✓ Delta (hierarchical checksums)")

    # From string with delimiters
    raw = f"First{SCROLL_BREAK}Second{SECTION_BREAK}Third"
    p2 = Phext.from_string(raw)
    assert p2.select(Coordinate.origin()) == "First"
    assert p2.select(Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 2)) == "Second"
    assert p2.select(Coordinate(1, 1, 1, 1, 1, 1, 1, 2, 1)) == "Third"
    print("  ✓ Parse delimiters (scroll + section breaks)")

    # Higher-dimension delimiters
    raw2 = f"A{CHAPTER_BREAK}B{BOOK_BREAK}C"
    p3 = Phext.from_string(raw2)
    assert p3.select(Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 1)) == "A"
    assert p3.select(Coordinate(1, 1, 1, 1, 1, 1, 2, 1, 1)) == "B"
    assert p3.select(Coordinate(1, 1, 1, 1, 1, 2, 1, 1, 1)) == "C"
    print("  ✓ Higher-dimension delimiters (chapter + book)")

    # Roundtrip: recompose preserves content
    raw3 = f"X{SCROLL_BREAK}Y{SCROLL_BREAK}Z"
    p4 = Phext.from_string(raw3)
    assert p4.to_string() == raw3
    print("  ✓ Roundtrip (decompose/recompose)")

    # Coordinate ordering
    assert Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 1) < Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 2)
    assert Coordinate(1, 1, 1, 1, 1, 2, 1, 1, 1) > Coordinate(1, 1, 1, 1, 1, 1, 9, 9, 9)
    print("  ✓ Coordinate ordering")

    # Insert (append)
    p5 = Phext()
    p5.update(origin, "Start")
    p5.insert(origin, " + More")
    assert p5.select(origin) == "Start + More"
    print("  ✓ Insert (append)")

    print("=" * 60)
    print("All tests passed.")


if __name__ == "__main__":
    _run_tests()
