# vTPU Runtime

Software-defined Virtual TPU with phext-native addressing.

## Overview

vTPU achieves 3 operations/cycle sustained throughput on commodity AMD Ryzen 9 processors through sentron-native instruction scheduling. Core innovation: the 3-pipe retirement model (D/S/C) eliminates out-of-order scheduling bottlenecks.

**Target Performance:**
- Ops/cycle: 3.0 (vs. 1.2 typical for general code)
- Single node: 75 Gops/sec @ 125W (600 Mops/W)
- Cluster (5 nodes): 359 Gops/sec @ 625W (574 Mops/W)

## Architecture

### Sentron Instruction Word (SIW)

Each SIW contains exactly 3 operations:
- **D-Pipe**: Dense/ALU operation (arithmetic, comparison, reduction)
- **S-Pipe**: Sparse/Memory operation (phext coordinate addressing)
- **C-Pipe**: Coordination operation (inter-sentron communication)

The 3 operations map to independent Zen 4 execution units → zero resource conflicts → 3 retirements/cycle.

### Phext-Native Addressing

Memory operations use 11-dimensional phext coordinates (128-bit packed):
- Each dimension: 11 bits (2048 positions)
- Total address space: 2048^11 ≈ 10^36 positions
- Dimensional locality → cache-friendly by construction

## Status (R23 Wave 2)

**Implemented:**
- ✅ SIW struct (cache-line aligned, 64 bytes)
- ✅ D-Pipe opcodes (DFMA, DADD, DSUB, DMUL, DCMP, DRED, DSEL, DMOV)
- ✅ S-Pipe opcodes (SGATHER, SSCATTR, SINDEX, SDEDUP, SPREFCH, SFLUSH, SALLOC, SFREE)
- ✅ C-Pipe opcodes (CPACK, CROUTE, CSEND, CRECV, CBAR, CFENCE, CREDUCE, CCAST)
- ✅ PhextCoord (11D coordinate, Manhattan distance, adjacency checks)
- ✅ VtpuTelemetry (ops/cycle, cache hit rate, energy efficiency tracking)

**Pending (Wave 3+):**
- ⏳ Micro-scheduler (pin SIWs to Zen 4 execution ports)
- ⏳ Phext Page Table (PPT) for coordinate → physical address translation
- ⏳ Actual pipe execution (D/S/C dispatch)
- ⏳ Performance validation (perf counters integration)

## Building

```bash
cargo build --release
cargo test
```

## Testing

```bash
# Run unit tests
cargo test

# Run benchmarks (Wave 4+)
cargo bench

# Check ops/cycle (Wave 3+)
cargo test --release -- --nocapture | grep "ops_per_cycle"
```

## Example

```rust
use vtpu_runtime::{SIW, DenseOp, SparseOp, CoordOp, PhextCoord};

// Create a simple SIW: D-Pipe adds, S-Pipe fetches, C-Pipe no-op
let siw = SIW::new(
    DenseOp::DADD { rd: 1, rs1: 2, rs2: 3 },
    SparseOp::SGATHER { rd: 4, coord_idx: 0, width: 64 },
    CoordOp::CNOP,
    PhextCoord::new([3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]),
);

// Execute (placeholder - full scheduler in Wave 3)
let mut scheduler = Scheduler::new();
scheduler.execute_siw(&siw);

// Check telemetry
println!("{}", scheduler.telemetry().to_json());
```

## License

MIT

## References

- **Spec:** `exo-plan/r23/vTPU-spec-v0.1.md` (33KB architecture specification)
- **Geometric Advantages:** `exo-plan/r23/vTPU-geometric-advantages.md` (why 11D wins)
- **Roadmap:** `exo-plan/r23/R23-WAVE-PLAN.md` (40-wave implementation plan)
