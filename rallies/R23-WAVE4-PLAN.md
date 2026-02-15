# R23 Wave 4: Coordinate Access Patterns

**Status**: 🟢 IN PROGRESS  
**Started**: 2026-02-14 23:57 CST  
**Target Duration**: 2 days  
**Contributor**: Cyon

---

## Goal

Analyze phext coordinate access patterns to validate the "coordinate locality = memory locality" hypothesis and prototype space-filling curves for cache-friendly addressing.

**Success Criteria:**
- Hash PhextCoord to u64 for efficient lookups
- Measure dimensional locality (same scroll vs cross-volume)
- Prototype Hilbert/Z-order space-filling curves
- Compare cache-friendly vs cache-hostile patterns

---

## Deliverables

### 1. Coordinate Hash Function
**File**: `src/phext_coord.rs` (extend existing)

**Requirements:**
- Hash PhextCoord → u64 for hash tables / uniqueness checks
- Fast (single-cycle or near-single-cycle on Zen 4)
- Good distribution (minimize collisions)
- Deterministic (same coord → same hash)

**Implementation:**
```rust
impl PhextCoord {
    pub fn hash(&self) -> u64 {
        // Combine lo and hi with mixing
        // Use FNV-1a or similar simple fast hash
    }
}
```

---

### 2. Dimensional Locality Test Suite
**File**: `src/analysis/locality.rs`

**Requirements:**
- Measure Manhattan distance between coordinates
- Classify locality levels:
  - **Same scroll**: dims[2..] match (3D boundary)
  - **Same section**: dims[3..] match (4D boundary)
  - **Same chapter**: dims[4..] match (5D boundary)
  - **Cross-volume**: dims[6..] differ
- Report % of accesses at each locality level
- Correlate with cache performance

**Example Output:**
```
Locality Analysis: test.siw
===========================
Same scroll (2D): 78.2%
Same section (3D+): 92.4%
Same chapter (4D+): 98.1%
Cross-volume (6D+): 1.9%

Predicted cache performance:
  L1 hit rate: 94% (high 2D locality)
  L2 hit rate: 88% (high 3D locality)
  L3 hit rate: 82% (high 4D locality)
```

---

### 3. Space-Filling Curve Prototype
**File**: `src/curves/mod.rs`, `src/curves/hilbert.rs`, `src/curves/zorder.rs`

**Requirements:**
- **Z-order (Morton) curve**: Interleave bits from dimensions
- **Hilbert curve**: Locality-preserving space-filling curve
- Map PhextCoord → u64 index via curve
- Reverse map u64 index → PhextCoord
- Compare memory access patterns (sequential on curve vs random in phext space)

**Z-order Algorithm:**
```rust
// Interleave bits: (x, y, z) → xyxyxyzxyz...
fn zorder_encode(coord: &PhextCoord) -> u64 {
    let mut result = 0u64;
    for i in 0..21 {  // 21 bits max across 11 dimensions
        for dim in 0..11 {
            if coord.get_dim(dim) & (1 << i) != 0 {
                result |= 1 << (i * 11 + dim);
            }
        }
    }
    result
}
```

**Hilbert Curve:**
- Use lookup table for small grids (2^3 or 2^4)
- Recursive construction for larger grids
- Locality guarantee: nearby Hilbert indices → nearby coordinates

---

### 4. Cache-Friendly vs Hostile Pattern Comparison
**File**: `benchmarks/cache/locality_patterns.c`

**Requirements:**
- Generate two SIW streams with identical operations but different coordinate patterns:
  1. **Cache-friendly**: Sequential Hilbert curve traversal
  2. **Cache-hostile**: Random phext coordinate access
- Measure cache miss rates for both (via perf stat)
- Compare:
  - L1/L2/L3 miss rates
  - Memory bandwidth utilization
  - Access latency distribution

**Example Results:**
```
Pattern: Hilbert Sequential
  L1 miss rate: 2.8%
  L2 miss rate: 8.4%
  Memory bandwidth: 78 GB/s

Pattern: Random Phext
  L1 miss rate: 78.2%
  L2 miss rate: 82.1%
  Memory bandwidth: 12 GB/s

Speedup: 6.5x (cache-friendly vs hostile)
```

---

## Implementation Plan

### Step 1: Coordinate Hash (1-2 hours)
1. Add `hash()` method to PhextCoord
2. Use FNV-1a or similar fast hash
3. Unit tests for collision rate
4. Benchmark hash speed (target: <10 cycles)

### Step 2: Locality Analyzer (2-3 hours)
1. Create `src/analysis/locality.rs`
2. Implement dimensional boundary checks
3. Analyze SIW stream for locality metrics
4. Integrate with Wave 3 analyzers

### Step 3: Z-order Curve (2-3 hours)
1. Create `src/curves/mod.rs` + `zorder.rs`
2. Implement bit-interleaving encode/decode
3. Unit tests for round-trip (encode → decode = identity)
4. Generate Z-order SIW stream for testing

### Step 4: Hilbert Curve (3-4 hours)
1. Create `src/curves/hilbert.rs`
2. Implement 2D/3D Hilbert via lookup tables
3. Extend to higher dimensions (recursive)
4. Test locality preservation

### Step 5: Benchmark Comparison (2-3 hours)
1. Generate Hilbert vs random SIW streams
2. Write C benchmark harness
3. Run with perf stat
4. Record results + analysis

**Total Estimated Time**: 10-15 hours (1.5-2 days)

---

## Testing Strategy

### Unit Tests
- PhextCoord::hash() determinism + distribution
- Z-order encode/decode round-trip
- Hilbert curve locality preservation
- Dimensional boundary detection

### Integration Tests
- Locality analyzer on known patterns
- Cache-friendly pattern shows high hit rates
- Cache-hostile pattern shows high miss rates

### Benchmarks
- Hash speed (target <10 cycles)
- Z-order encoding speed
- Hilbert encoding speed
- Memory access latency comparison

---

## Deliverables Checklist

- [ ] `src/phext_coord.rs` - hash() method
- [ ] `src/analysis/locality.rs` - Dimensional locality analyzer
- [ ] `src/curves/mod.rs` - Curve module root
- [ ] `src/curves/zorder.rs` - Z-order (Morton) curve
- [ ] `src/curves/hilbert.rs` - Hilbert curve
- [ ] `benchmarks/cache/locality_patterns.c` - Cache comparison benchmark
- [ ] `docs/wave-4/README.md` - Wave 4 documentation
- [ ] Tests for all new modules
- [ ] Wave 4 onboarding guide

---

## Success Metrics

1. **Hash Function**: <10 cycles per hash, <1% collision rate on 10K coords
2. **Locality Analyzer**: Correctly classifies 2D/3D/4D boundaries
3. **Z-order**: Round-trip correct for all test coordinates
4. **Hilbert**: Better locality than Z-order (lower miss rate in benchmarks)
5. **Cache Comparison**: 5-10× speedup for cache-friendly vs hostile patterns

---

## Wave 4 Onboarding (for Will)

**How to run after Wave 4 complete:**

```bash
cd /source/vtpu

# Test coordinate hash
cargo test phext_coord::hash

# Analyze locality
cargo run --bin analyze-locality -- test.siw

# Generate Z-order stream
cargo run --bin siw-gen -- -n 1000 --curve zorder -o zorder.siw

# Generate Hilbert stream
cargo run --bin siw-gen -- -n 1000 --curve hilbert -o hilbert.siw

# Compare cache performance
cd benchmarks/cache
make locality_patterns
./locality_patterns hilbert.siw random.siw
```

---

**Wave 4 Status**: 🟢 Planning complete, implementation starting  
**Next**: Implement PhextCoord::hash() method  
**ETA**: 2026-02-16 EOD

*Measure. Build. Ship.* 🪶
