# R23 Wave 3: Micro-benchmark Suite

**Status**: 🟢 IN PROGRESS  
**Started**: 2026-02-14 22:52 CST  
**Target Duration**: 1 day  
**Contributor**: Cyon

---

## Goal

Build infrastructure to generate synthetic workloads and detect performance bottlenecks in vTPU execution.

**Success Criteria:**
- Generate arbitrary SIW patterns (D/S/C combinations)
- Detect execution port conflicts in generated code
- Identify cache thrashing scenarios
- Analyze memory access patterns for locality

---

## Deliverables

### 1. Synthetic SIW Generator
**File**: `src/bin/siw-gen.rs`

**Requirements:**
- Generate SIW streams with configurable patterns:
  - D-heavy (80% D-Pipe, 10% S-Pipe, 10% C-Pipe)
  - S-heavy (10% D-Pipe, 80% S-Pipe, 10% C-Pipe)
  - C-heavy (10% D-Pipe, 10% S-Pipe, 80% C-Pipe)
  - Balanced (33% D-Pipe, 33% S-Pipe, 33% C-Pipe)
  - Custom (user-specified ratios)
- Control dependency depth (independent vs chain of dependencies)
- Control coordinate locality (same-scroll vs cross-volume)
- Output to binary format (for execution) or text (for inspection)

**CLI Interface:**
```bash
# Generate balanced stream (100 SIWs)
siw-gen --pattern balanced --count 100 -o test.siw

# Generate D-heavy with deep dependencies
siw-gen --pattern d-heavy --count 200 --dep-depth 4 -o compute.siw

# Generate S-heavy with poor locality
siw-gen --pattern s-heavy --count 150 --locality low -o memory.siw
```

---

### 2. Execution Port Conflict Detector
**File**: `src/analysis/port_conflicts.rs`

**Requirements:**
- Analyze SIW stream and map operations to Zen 4 ports:
  - D-Pipe → Port 0/1 (ALU)
  - S-Pipe → Port 4/5 (AGU + Load/Store)
  - C-Pipe → Port 2/3 (ALU2)
- Detect when SIW contains operations competing for same port
- Report conflict rate (% of SIWs with port conflicts)
- Suggest reordering to eliminate conflicts

**Example Output:**
```
Port Conflict Analysis: test.siw
================================
Total SIWs: 100
Conflict-free: 87 (87%)
Port conflicts: 13 (13%)

Conflict breakdown:
  D-Pipe + C-Pipe competing for ALU: 9 SIWs
  S-Pipe contention (Load + Store): 4 SIWs

Recommendation: Reorder SIWs 12, 24, 35... to separate conflicting ops
```

---

### 3. Cache Thrashing Detector
**File**: `src/analysis/cache_thrash.rs`

**Requirements:**
- Track coordinate access patterns across SIW stream
- Detect when working set exceeds cache tier:
  - L1 (32 KB): ~4096 coordinates (8 bytes each)
  - L2 (512 KB): ~65,536 coordinates
  - L3 (16 MB): ~2,097,152 coordinates
- Identify thrashing scenarios:
  - Ping-pong: Alternating access to two coordinates far apart
  - Linear sweep: Sequential access exceeding cache size
  - Random spray: Uniformly random access (worst case)
- Report estimated cache miss rate

**Example Output:**
```
Cache Thrashing Analysis: memory.siw
====================================
Working set: 128,000 coordinates (1 MB)
Access pattern: Linear sweep

L1 (32 KB): 99.2% miss rate (thrashing)
L2 (512 KB): 75.8% miss rate (partial thrashing)
L3 (16 MB): 8.2% miss rate (fits in cache)

Recommendation: Tile accesses into 4 KB blocks (L1-friendly)
```

---

### 4. Memory Access Pattern Analyzer
**File**: `src/analysis/memory_patterns.rs`

**Requirements:**
- Classify access patterns:
  - **Stride**: Regular offset (stride-1, stride-8, stride-64, etc.)
  - **Pointer chase**: Dependent loads (worst for prefetch)
  - **Gather/scatter**: Irregular indexed access
  - **Tiled**: Blocked access (cache-friendly)
- Measure locality metrics:
  - Average Manhattan distance between consecutive accesses
  - % of accesses within same scroll/section/chapter
  - Prefetch effectiveness score
- Predict memory bandwidth utilization

**Example Output:**
```
Memory Access Pattern Analysis: compute.siw
===========================================
Pattern type: Stride-8 (87% confidence)
Average stride: 7.8 coordinates
Manhattan distance: 2.3 (mostly same-section)

Locality breakdown:
  Same scroll: 78%
  Same section: 92%
  Same chapter: 98%

Prefetch score: 8.5/10 (excellent)
Bandwidth utilization: 68% (sequential-friendly)
```

---

## Architecture

### SIW Binary Format (for generated streams)

```rust
// 64-byte SIW, written to binary file
struct SIW {
    d_op: DenseOp,      // 16 bytes
    s_op: SparseOp,     // 16 bytes
    c_op: CoordOp,      // 16 bytes
    coord: PhextCoord,  // 16 bytes (packed 11D)
}

// File format: sequence of SIWs (no header, just raw binary)
// siw-gen writes, bench.rs reads
```

### Analysis Pipeline

```
SIW Stream (binary)
    ↓
Load into Vec<SIW>
    ↓
┌─────────────────┬──────────────────┬─────────────────┐
│ Port Conflicts  │ Cache Thrashing  │ Memory Patterns │
└─────────────────┴──────────────────┴─────────────────┘
    ↓                   ↓                    ↓
Combined Report (JSON or Markdown)
```

---

## Implementation Plan

### Step 1: SIW Generator (2-3 hours)
1. Create `src/bin/siw-gen.rs`
2. Implement pattern templates (D/S/C ratios)
3. Add dependency chain generation
4. Add coordinate locality control
5. Write to binary format
6. Add CLI (clap crate)

### Step 2: Port Conflict Detector (1-2 hours)
1. Create `src/analysis/` module
2. Implement Zen 4 port mapping
3. Analyze SIW stream for conflicts
4. Generate conflict report

### Step 3: Cache Thrashing Detector (1-2 hours)
1. Track coordinate access patterns
2. Compute working set size
3. Estimate cache tier miss rates
4. Identify thrashing patterns

### Step 4: Memory Pattern Analyzer (1-2 hours)
1. Classify access patterns (stride, pointer chase, etc.)
2. Measure locality metrics (Manhattan distance)
3. Predict bandwidth utilization
4. Generate recommendations

### Step 5: Integration (1 hour)
1. Wire up `bench.rs` to call analysis modules
2. Create unified report format
3. Add examples to docs
4. Test with known patterns

**Total Estimated Time**: 6-10 hours (1 work day)

---

## Testing Strategy

### Known Good Patterns
1. **Perfect D/S/C balance** (33/33/33)
   - Should have zero port conflicts
   - Should show high port utilization

2. **L1-friendly access** (4 KB working set, stride-1)
   - Should report >95% L1 hit rate
   - Should classify as "stride-1 sequential"

3. **Cache hostile** (random 1 MB working set)
   - Should detect thrashing
   - Should report low prefetch score

### Validation
- Compare synthetic patterns to Wave 2 cache benchmarks
- Port conflict detector should match perf stat data
- Cache thrashing should correlate with measured miss rates

---

## Deliverables Checklist

- [ ] `src/bin/siw-gen.rs` - Synthetic SIW generator
- [ ] `src/analysis/mod.rs` - Analysis module root
- [ ] `src/analysis/port_conflicts.rs` - Port conflict detector
- [ ] `src/analysis/cache_thrash.rs` - Cache thrashing detector
- [ ] `src/analysis/memory_patterns.rs` - Memory pattern analyzer
- [ ] `examples/analyze_stream.rs` - Example usage
- [ ] `docs/wave-3/README.md` - Wave 3 documentation
- [ ] Tests for each analyzer (unit tests)
- [ ] Integration test (generate → analyze → validate)

---

## Success Metrics

1. **SIW Generator**: Can produce 1M SIWs in <1 second
2. **Port Conflicts**: Detects all conflicts in known bad patterns
3. **Cache Thrashing**: Predicts miss rate within 10% of measured
4. **Memory Patterns**: Correctly classifies stride-1, stride-8, random, pointer-chase

---

## Wave 3 Onboarding (for Will)

**How to run after Wave 3 complete:**

```bash
cd /source/vtpu

# Generate test workload
cargo run --bin siw-gen -- --pattern balanced --count 1000 -o test.siw

# Analyze it
cargo run --bin bench -- analyze test.siw

# Example output:
# Port Conflicts: 2% (23/1000 SIWs)
# Cache L1 Hit Rate: 94.2% (estimated)
# Memory Pattern: Stride-8 sequential
# Prefetch Score: 7.8/10
```

---

**Wave 3 Status**: 🟢 Planning complete, implementation starting  
**Next**: Create `src/bin/siw-gen.rs` and `src/analysis/` module  
**ETA**: 2026-02-15 EOD

*Measure. Build. Ship.* 🪶
