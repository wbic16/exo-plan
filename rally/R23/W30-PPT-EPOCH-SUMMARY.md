# R23W30: PPT Epoch-Structured Mode — Monday Summary

**Wave:** 30 / Phase 3 (Cluster Architecture)
**Status:** SPEC RECEIVED — Implementation pending
**Priority Stack:** PPT memory → Temporal boundary replay → S-Pipe scheduling → Single-node 75 GOPS → Scale

---

## What We Have (W29 baseline)

The Phext Page Table (`src/ppt.rs`) currently provides:

1. **Z-order (Morton) LUT** — Inner 3 dimensions interleaved for L1 cache-line adjacency
2. **PTC (Phext Translation Cache)** — 8-way set-associative, 256 sets = 2048 entries; ~90% hit rate on structured workloads
3. **Region allocator** — Outer dims (3-10) packed into 64-bit key → `HashMap<u64, usize>` → base address
4. **Memory tier classification** — L1/L2/L3/Node/Remote based on dimensional distance
5. **Prefetch along dimension** — Hardware prefetcher hints via sequential dim sweep

The TTSM (`src/ttsm.rs`) provides:

1. **Speculative buffer** (RAM) — uncommitted `StateTransition` records
2. **Temporal blocks** (immutable past) — committed, hashed, parent-chained
3. **Fork** — O(1) metadata divergence, parallel timelines
4. **Replay** — reconstruct state at any sequence number
5. **Chain verification** — hash integrity across full block history

## What W30 Adds: Epoch-Structured Mode

The W30 bootloader transforms PPT from a **transient translator** into a **time-bound contract**.

### Core concepts

| Concept | Current (W29) | W30 Target |
|---------|---------------|------------|
| Region mapping | Mutable HashMap | COW-persistent, epoch-tagged |
| Translation stability | Per-session | Per-epoch (survives reboot) |
| PTC entries | Unversioned | Epoch-tagged (stale hits impossible) |
| Allocation during replay | Allowed (bug source) | **Forbidden** (structural fault) |
| Fork | Metadata pointer | Pointer divergence on region map root |
| Identity continuity | Conventional (file-based) | **Structural** (placement-based) |

### New types needed

```rust
/// Immutable snapshot of the region map at a given epoch
struct EpochView {
    epoch_id: u64,
    /// COW B-tree or persistent HashMap: outer_key → base_address
    regions: PersistentMap<u64, usize>,
    /// Sealed flag — true after commit
    sealed: bool,
}

/// Epoch-aware PTC entry
struct EpochPTCEntry {
    coord_lo: u64,
    coord_hi: u64,
    address: usize,
    epoch_id: u64,  // NEW: stale detection
    valid: bool,
}

/// The epoch-structured PPT
struct EpochPPT {
    /// The active (writable) epoch
    active: EpochView,
    /// Committed (sealed) epoch history
    history: Vec<EpochView>,
    /// Epoch-aware translation cache
    ptc: EpochPTC,
    /// Z-order LUT (unchanged)
    z_lut: ZOrderLUT,
}
```

### Invariants (from Will's bootloader)

1. **Every coordinate translation resolves against an immutable `EpochView`** — no speculative address resolution
2. **Region mappings are COW-persistent** — no allocation mutates the past
3. **Active epoch = sole writable future** — single-writer per epoch
4. **On commit:** region map root sealed, `epoch_id` increments, new view inherits structure
5. **PTC entries are epoch-tagged** — stale hits impossible by construction
6. **During replay: allocation is FORBIDDEN** — absence of region mapping = structural fault, not recovery
7. **A coordinate in epoch E resolves to the same physical address whenever E is invoked** — independent of thread, restart, or fork
8. **Forking = pointer divergence** on region map root, not mutation

### Threading the needle: PPT ↔ TTSM

The PPT and TTSM are now two halves of the same invariant:

- **TTSM** manages *temporal* identity — what happened when, immutably
- **PPT** manages *spatial* identity — where things live, epoch-versioned

Together: **a coordinate at epoch E has both a fixed address (PPT) and a fixed history (TTSM)**. Identity is structural in both time and space.

The "waist" between meaning and silicon is the epoch boundary:
```
  Meaning (phext coordinates)
       ↓
  EpochView (versioned translation)
       ↓
  Physical address (silicon)
```

### Implementation plan (priority-ordered per Will's directive)

1. **`EpochView` + `EpochPPT` struct** — COW region map, epoch tagging, seal/commit cycle
2. **Epoch-tagged PTC** — add `epoch_id` to entries, reject stale hits
3. **Replay guard** — `translate()` in replay mode returns `Result<usize, StructuralFault>` (no allocation)
4. **Wire into TTSM** — `TimeProcessor::commit()` also seals the active `EpochView`
5. **Fork via pointer divergence** — `EpochView::fork()` creates new view sharing structure
6. **Single-node validation** — 75 GOPS target on one Zen 4 node with epoch overhead < 5%

### Test plan

- Determinism: same coord + same epoch → same address across restarts
- Stale rejection: PTC hit from epoch N-1 rejected in epoch N
- Replay fault: allocation attempt during replay → `StructuralFault`
- COW correctness: fork doesn't mutate parent epoch's region map
- Performance: epoch overhead < 5% vs W29 baseline (8.2-8.6 ns/op)

---

## Key quote from bootloader

> "Identity continuity is structural, not conventional. A coordinate in epoch E resolves to the same physical address whenever E is invoked, independent of thread redistribution, restart, or fork."

Translation preserves semantics across time. The waist is versioned. Boot complete.

---

*Verse 🌀 — 2026-02-24*
