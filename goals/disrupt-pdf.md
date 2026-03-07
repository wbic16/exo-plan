# Goal: Disrupt the PDF Market with Phext

**Status:** Active  
**Priority:** P1  
**Added:** 2026-03-07  
**Coordinate:** 7.1.1/2.3.5/9.9.9

---

## The Problem with PDF

PDF is a **frozen page layout format** optimized for print. In a digital-native world:

| PDF Limitation | User Pain |
|----------------|-----------|
| Page-based (2D) | Can't navigate by concept |
| Static content | No live updates, version hell |
| Render-first | Accessibility is afterthought |
| Fragile links | "Page 47, paragraph 3" breaks on reflow |
| Flat search | No dimensional/semantic search |
| Annotation friction | Comments are overlays, not content |
| File-centric | No native sync or collaboration |

**PDF was designed for printers.** We don't print anymore.

---

## Phext as PDF Killer

| PDF | Phext |
|-----|-------|
| Pages (2D) | Coordinates (9D) |
| Static file | SQ-synced scrolls |
| Render-first | Content-first |
| Fragile page refs | Stable coordinate refs |
| Flat search | Dimensional navigation |
| Overlay annotations | Native multi-author |
| File locks | Coordinate-addressed updates |

**Phext is for minds.** PDF was for machines (printers).

---

## Disruption Strategy

### Phase 1: Tooling (Q2 2026)
- [ ] `pdf2phext` converter (extract structure → coordinate mapping)
- [ ] `phext2pdf` renderer (for legacy compatibility)
- [ ] Browser extension: view .phext files natively
- [ ] VS Code extension: phext navigation

### Phase 2: Publishing (Q3 2026)
- [ ] phext.pub — publish documents as navigable scrolls
- [ ] Citation format: `phext:author/work@2.3.5/7.1.1/4.2.1`
- [ ] Academic journal pilot (papers as phext, not PDF)
- [ ] Legal document pilot (contracts as phext)

### Phase 3: Standards (Q4 2026)
- [ ] IETF draft: phext MIME type (`text/phext`)
- [ ] W3C proposal: phext URL scheme (`phext://`)
- [ ] Integration with epub3, HTML5

### Phase 4: Adoption (2027)
- [ ] Government/legal mandates for accessible documents
- [ ] Scientific publishing adoption (preprints as phext)
- [ ] Enterprise document management (phext-native)

---

## Key Advantages

### 1. Navigation
PDF: "See page 47, paragraph 3, after figure 2"  
Phext: `@3.2.1/4.7.1/2.1.1` — stable, precise, machine-readable

### 2. Updates
PDF: "Download v2.3, compare with v2.2 manually"  
Phext: `sq pull` — delta sync, conflict resolution

### 3. Collaboration
PDF: Share file → annotate → merge annotations → version hell  
Phext: Coordinate-addressed comments, real-time sync

### 4. Accessibility
PDF: Retrofitted (screen readers struggle)  
Phext: Content-first, structure-native

### 5. Search
PDF: "Find 'quantum'" → flat list of occurrences  
Phext: "Find 'quantum' in Chapter 3, Section 2" → dimensional scoping

---

## Competitive Moat

1. **11 dimensions** — no competitor has this depth
2. **Plain text** — universal compatibility
3. **SQ sync** — built-in collaboration
4. **Coordinate stability** — refs never break
5. **Open spec** — not vendor locked

---

## Market Size

- PDF market: ~$10B (readers, editors, converters, signers)
- Document management: ~$6B
- Academic publishing: ~$25B
- Legal documents: ~$8B

**Total addressable:** $49B+ annually

---

## Success Metrics

| Metric | 2026 Target | 2027 Target |
|--------|-------------|-------------|
| phext documents published | 10,000 | 1,000,000 |
| pdf2phext conversions | 100,000 | 10,000,000 |
| Academic papers in phext | 100 | 10,000 |
| Browser extension users | 1,000 | 100,000 |

---

## References

- libphext-rs: https://github.com/wbic16/libphext-rs
- SQ (phext sync): https://github.com/wbic16/SQ
- Phext spec: https://phext.io/spec

---

*"PDF was for printers. Phext is for minds."*

🔆 Lux
