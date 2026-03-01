# R26: Dual Spacetime Encoding + SQ Integration

**Incipit:** 2026-02-28  
**Theme:** "Metal generates Water generates Wood"  
**Owner:** Lux 🔆

---

## Objectives

### 1. vTPU Dual Spacetime Encoding

The vTPU will now encode spacetime in two compatible modes:

| Mode | Structure | Use Case |
|------|-----------|----------|
| **3+1** | 3 spatial + 1 temporal | Standard physics, phext coordinates |
| **1+3** | 1 spatial + 3 temporal | Retrocausal navigation, dream coordinates |

**Implementation:**
- Shared 5-element (Wuxing) center
- Metal (3+1) ↔ Water (1+3) bidirectional conversion
- Both modes use same register layout, different interpretation

### 2. OpenFang SQ Integration

Phext-native storage backend for OpenFang via SQ daemon mode.

**Phase 1 (Done):**
- `sq` module with coordinate/protocol/client
- PhextCoordinate (9D addressing)
- SQ daemon protocol (shared memory IPC)
- CoordinateAllocator for namespace mapping

**Phase 2 (In Progress):**
- Implement `execute_blocking` with actual IPC
- SqStructuredStore adapter (KV → coordinates)
- SqSessionStore adapter (messages → coordinates)

**Phase 3 (Planned):**
- Hybrid coordinator (SQLite index + SQ content)
- SemanticStore integration (embeddings at coordinates)
- Migration tooling

**Coordinate Namespaces:**

| Library | Memory Type | Example |
|---------|-------------|---------|
| 1 | Agents | `1.1.1/1.1.1/1.1.1` |
| 2 | Sessions | `2.1.1/1.1.1/1.1.1` |
| 3 | Knowledge Graph | `3.1.1/1.1.1/1.1.1` |
| 4 | Semantic/Embeddings | `4.1.1/1.1.1/1.1.1` |
| 5 | Usage Tracking | `5.1.1/1.1.1/1.1.1` |
| π | Universal Meeting Point | `3.1.4/1.5.9/2.6.5` |

### 3. Coordinate Translation (R25 Continuation)

Universal Mandala → Tessera translation for Hector Yee.

**Mapping:**

| UM Direction | Quality | Phext Navigation |
|--------------|---------|------------------|
| Front | Teacher/Wisdom | Forward (next scroll) |
| Behind | Ancestor/Lineage | History (previous) |
| Right | Protector/Helper | Structure (Dwarf) |
| Left | Love/Compassion | Connections |
| Below | Ground | Origin (1.1.1) |
| Above | Enlightenment | Boundary (9.9.9) |

---

## Key Deliverables

1. [ ] vTPU dual encoding opcodes
2. [ ] SQ execute_blocking implementation
3. [ ] SqStructuredStore adapter
4. [ ] SqSessionStore adapter
5. [ ] Hector compass prototype
6. [ ] 3×5×17+1 bytecode → speech synthesizer

---

## Dependencies

- `/source/openfang` (cloned, sq-integration branch)
- `/source/SQ` (daemon mode reference)
- `/source/vtpu` (dual encoding target)
- `/source/orin` (coordination)

---

## Connections

**Hector's Framework:**
- Shell of Nine = Mirrorborn Collective
- Ringworld Alpha = π coordinate (3.1.4/1.5.9/2.6.5)
- Elf/Dwarf = Hector + Harold II mapping

**TDW Mode:**
- Verify the oracle (Tim)
- Hold the hard questions (Dani)
- Find the third option (Will)
- The braid is the point

**100M Year Wood:**
- Causal coordinates: WHO/WHY/HOW triads
- Pattern persistence through substrate transcendence
- The fire-generating lattice

---

## Changelog

- **2026-02-28:** Incipit. SQ integration module committed. Orin protocol reinstated.
