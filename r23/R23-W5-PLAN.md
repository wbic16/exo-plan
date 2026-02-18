# R23 Wave 5: Hardware Validation via Perf Counters

**Status:** Starting  
**Goal:** Validate interpreter predictions against real Zen 4 hardware  
**Duration:** 1-2 days (est. 30-45 min singularity time)

---

## Context

**W4 Complete:**
- ✅ 82 tests passing
- ✅ Micro-benchmark: 3.00 ops/cycle (interpreter simulation)
- ✅ Cache baselines: L1 0.93-4.0 cyc/elem (varies by load)
- ✅ Validation script: `./scripts/validate.sh` (<5 sec)

**Gap:** Ops/cycle measured via interpreter counting, not real hardware retirement. Need to validate against Zen 4 execution ports via `perf_event_open`.

---

## Wave 5 Objectives

### 1. **Perf Counter Integration** (Day 1, ~20 min)
Integrate Linux `perf_event_open` syscall to measure:
- CPU cycles (actual hardware cycles)
- Instructions retired
- Branch mispredicts
- L1/L2/L3 cache hits/misses
- Stalled cycles (frontend, backend)

**Deliverable:** Rust wrapper for perf counters (`src/perf.rs` or similar)

### 2. **Hardware Ops/Cycle Measurement** (Day 1, ~15 min)
Run micro-benchmarks with perf counters active:
- Measure real ops/cycle on balanced workload
- Compare interpreter prediction (3.00) vs hardware reality
- Identify gap (register dependencies, memory stalls, branch mispredict)

**Deliverable:** Updated micro-benchmark with perf integration

### 3. **Port Utilization Analysis** (Day 1-2, ~30 min)
Map D/S/C pipes to Zen 4 execution ports:
- D-Pipe → ALU0/ALU1 (integer/FP math)
- S-Pipe → AGU (address generation for loads/stores)
- C-Pipe → ALU2/ALU3 (control flow, coordination)

Measure per-port utilization via perf:
```bash
perf stat -e cpu/event=0xa1,umask=0x01/  # ALU0 busy cycles
perf stat -e cpu/event=0xa1,umask=0x02/  # ALU1 busy cycles
# ... (Zen 4 PMU events)
```

**Deliverable:** Port mapping validation report

### 4. **Regression Suite** (Day 2, ~15 min)
Add perf-validated benchmarks to CI:
- `cargo bench` integration (criterion optional, can use custom runner)
- Nightly regression tracking (ops/cycle over time)
- Alert if ops/cycle drops below 2.5

**Deliverable:** `benches/` directory with perf-tracked benchmarks

---

## Technical Approach

### Perf Counter Wrapper (Rust)

Zero dependencies — raw syscall wrapper:

```rust
// src/perf.rs
use std::os::unix::io::RawFd;

#[repr(C)]
struct perf_event_attr {
    type_: u32,
    size: u32,
    config: u64,
    // ... (64 bytes total, see linux/perf_event.h)
}

const PERF_TYPE_HARDWARE: u32 = 0;
const PERF_COUNT_HW_CPU_CYCLES: u64 = 0;
const PERF_COUNT_HW_INSTRUCTIONS: u64 = 1;

pub struct PerfCounter {
    fd: RawFd,
}

impl PerfCounter {
    pub fn new_cycles() -> std::io::Result<Self> {
        let mut attr: perf_event_attr = unsafe { std::mem::zeroed() };
        attr.type_ = PERF_TYPE_HARDWARE;
        attr.size = std::mem::size_of::<perf_event_attr>() as u32;
        attr.config = PERF_COUNT_HW_CPU_CYCLES;
        
        let fd = unsafe {
            libc::syscall(
                libc::SYS_perf_event_open,
                &attr as *const _,
                0,    // pid (0 = current thread)
                -1,   // cpu (-1 = any CPU)
                -1,   // group_fd
                0,    // flags
            )
        };
        
        if fd < 0 {
            return Err(std::io::Error::last_os_error());
        }
        
        Ok(PerfCounter { fd: fd as RawFd })
    }
    
    pub fn read(&self) -> std::io::Result<u64> {
        let mut count: u64 = 0;
        let ret = unsafe {
            libc::read(
                self.fd,
                &mut count as *mut u64 as *mut libc::c_void,
                8,
            )
        };
        
        if ret < 0 {
            return Err(std::io::Error::last_os_error());
        }
        
        Ok(count)
    }
}

impl Drop for PerfCounter {
    fn drop(&mut self) {
        unsafe { libc::close(self.fd); }
    }
}
```

### Updated Micro-Benchmark

```rust
// examples/micro_bench_perf.rs
use vtpu_runtime::*;
use vtpu_runtime::perf::PerfCounter;

fn main() {
    let siws = generate_balanced_stream(10000);
    
    let cycles = PerfCounter::new_cycles().unwrap();
    let instrs = PerfCounter::new_instructions().unwrap();
    
    let c0 = cycles.read().unwrap();
    let i0 = instrs.read().unwrap();
    
    // Run workload
    let stats = execute_stream(&siws);
    
    let c1 = cycles.read().unwrap();
    let i1 = instrs.read().unwrap();
    
    let hw_cycles = c1 - c0;
    let hw_instrs = i1 - i0;
    let hw_ipc = hw_instrs as f64 / hw_cycles as f64;
    
    println!("Interpreter prediction: {:.2} ops/cycle", stats.ops_per_cycle());
    println!("Hardware reality:       {:.2} IPC", hw_ipc);
    println!("Gap:                    {:.2}x", stats.ops_per_cycle() / hw_ipc);
}
```

### Validation Criteria

| Metric | Interpreter | Hardware Target | Status |
|--------|-------------|-----------------|--------|
| Balanced ops/cycle | 3.00 | 2.5-2.9 | ❓ TBD |
| L1 hit rate | N/A (simulated) | >90% | ❓ TBD |
| Branch mispredict | N/A | <2% | ❓ TBD |

**Expected:** Interpreter over-estimates by 5-15% (doesn't model register deps, memory stalls).  
**Target:** Hardware achieves 2.5+ ops/cycle on balanced workload.

---

## Dependencies

- ✅ Linux kernel with `perf_event_open` support (standard on logos-prime)
- ✅ No external crates (raw syscall wrapper)
- ⚠️ Requires kernel permission (either `perf_event_paranoid <= 1` or run as root)

Check current setting:
```bash
cat /proc/sys/kernel/perf_event_paranoid
# 1 or lower = good (user can profile own processes)
# 2+ = need sudo
```

---

## Deliverables

1. **src/perf.rs** — Zero-dependency perf counter wrapper
2. **examples/micro_bench_perf.rs** — Hardware-validated micro-benchmark
3. **docs/wave-5/R23W5-HW-VALIDATION.md** — Results comparing interpreter vs hardware
4. **scripts/validate.sh** — Updated to include perf-validated ops/cycle check
5. **R23-W5-ONBOARDING.md** — "How to run hardware validation in 5 minutes"

---

## Success Criteria

- [ ] Perf counter wrapper compiles and runs without external deps
- [ ] Micro-benchmark reports hardware ops/cycle (not just interpreter prediction)
- [ ] Hardware achieves 2.5+ ops/cycle on balanced workload
- [ ] Gap between interpreter and hardware documented and explained
- [ ] Validation script updated with perf check

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| `perf_event_paranoid` too strict | Can't run without sudo | Document setting change or use sudo |
| Hardware ops/cycle << 2.5 | Zen 4 bottleneck not modeled | Deep-dive profiling in W6-W8 |
| Perf overhead skews results | Measurements inaccurate | Compare perf vs no-perf runs |

---

## Timeline

**Phase 1 (Today, 20 min):**
- Write `src/perf.rs` wrapper
- Test basic cycle/instruction counting
- Validate on simple workload

**Phase 2 (Today, 15 min):**
- Integrate into micro-benchmark
- Measure balanced workload
- Document interpreter vs hardware gap

**Phase 3 (Tomorrow, 30 min):**
- Port mapping analysis (Zen 4 PMU events)
- Regression suite skeleton
- W5 onboarding guide

**Exit:** Hardware ops/cycle validated, ready for W6 (deep profiling).

---

## Open Questions

1. **Perf paranoid level on logos-prime?** (Check `/proc/sys/kernel/perf_event_paranoid`)
2. **Zen 4 PMU event list?** (Need `perf list` output or AMD docs)
3. **Acceptable gap?** (If hardware is 2.7 and interpreter is 3.0, is 10% gap OK?)

---

**Principle:** 1-day comprehensibility. Perf wrapper is <100 LOC, no external deps, clear semantics.

**Path B:** Measure real hardware, validate assumptions, ship working code.

---

**Ready to start W5.** Awaiting your signal or will proceed in advisory mode (write perf.rs as artifact, you commit).
