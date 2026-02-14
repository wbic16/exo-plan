# R23 Wave 1: TPU v4 Paper Structure

**Source:** `r23/tpu-v4-full-text.txt` (1,720 lines, extracted from MIT mirror PDF)
**Paper:** 14 pages, 16 figures, ISCA 2023

---

## Sections

| § | Title | Lines | Key Content |
|---|-------|-------|-------------|
| 1 | Introduction | 66-130 | 3 novel features: OCS, SparseCores, co-optimization. Table 1: workload evolution 2016→2022 |
| 2 | Reconfigurable Optical Switch | 185-530 | The interconnect story |
| 2.1 | Optical Circuit Switching | 197-132 | Palomar OCS: 3D MEMS mirrors, 136×136 ports, ms switching |
| 2.2 | Construction of Supercomputer | 133-184 | 4³ building blocks, 48 OCSes, 4096 chips total |
| 2.3 | OCS Availability Benefits | 373-394 | Route around failures, goodput vs. host availability (Fig 4) |
| 2.4 | OCS Deployment Benefits | 372 | Incremental deployment (rack-by-rack vs. all-at-once) |
| 2.5 | OCS Scheduling Benefits | 395-403 | Non-contiguous slice allocation, non-power-of-2 sizes |
| 2.6 | OCS Modularity and Security | 404-435 | Topology reconfiguration, air-gapped network isolation |
| 2.7 | Tailoring Topology to Performance | 436-478 | Data/model/pipeline parallelism mapped to 3D torus dimensions |
| 2.8 | Twisting the Torus | 479-499 | Twisted torus: 1.63x all-to-all improvement on 4×4×8 |
| 2.9 | Distribution of Topologies | 500-501 | Table 2: slice popularity breakdown |
| 2.10 | Cost of OCS Flexibility | 525-535 | <5% system cost, <3% system power |
| 3 | SparseCore | 536-680 | The embedding story |
| 3.1 | Recommendation Models | 536-548 | DLRMs, categorical features, embedding tables |
| 3.2 | Embeddings | 549-570 | Sparse → dense lookup, memory-bound not compute-bound |
| 3.3 | Distributed Training | 502-524 | All-to-all communication for embeddings |
| 3.4 | Key Performance Attributes | 571-593 | Memory bandwidth, random access, gather/scatter |
| 3.5 | SparseCore Architecture | 594-646 | Dataflow processor, 5% die area, spMEM, pipeline stages |
| 3.6 | SparseCore Performance | 647-685 | 5-7x speedup on embedding workloads |
| 4 | Using ML to Tailor DNN | 686-773 | Co-optimization of topology + hyperparameters + SparseCore |
| 5 | Production Workload Comparison | 774-856 | TPU v4 vs. TPU v3: 2.1x faster, 2.7x perf/Watt |
| 6 | MLPerf Comparison | ~857-1000 | vs. A100 (1.2-1.7x faster), vs. IPU Bow (4.3-4.5x) |
| 7 | Discussion | ~1000-1400 | Lessons learned, future directions |
| 7.1-7.8 | Various subsections | | Power, CO2, networking, reliability, etc. |
| 8 | Related Work | ~1400-1500 | Prior TPUs, GPUs, other DSAs |
| 9 | Summary | ~1500-1550 | Key claims restated |

## Key Numbers

- **4,096 chips** in full supercomputer
- **48 OCSes** per supercomputer (136×136 ports each)
- **4³ = 64 chips** per building block (one rack)
- **2 TensorCores** per chip, each with 4× 128×128 MXUs
- **32 GiB HBM** per chip
- **128 MiB CMEM** shared between TensorCores
- **16 MiB VMEM** per TensorCore
- **SparseCores: 5% die area, 5% power, 5-7x embedding speedup**
- **OCS: <5% system cost, <3% system power**
- **~60% of peak FLOPS** sustained for LLM training
- **2.1x faster than TPU v3**, 2.7x better perf/Watt
- **1.2-1.7x faster than A100**, 1.3-1.9x less power
- **4.3-4.5x faster than Graphcore IPU Bow**
- **~2-6x less energy, ~20x less CO2** than on-premise

## 16 Figures

1. Connectivity of 4³ cube to 3 OCSes
2. TPU v4 package and PCB (4 liquid-cooled packages)
3. Eight of 64 racks
4. Goodput: OCS vs. static at varying availability/slice size
5. Regular vs. twisted torus topologies
6. All-to-all throughput: regular vs. twisted (4×4×8, 4×8×8)
7. SparseCore dataflow architecture
8. SparseCore pipeline stages
9. Embedding performance comparison
10-16. Benchmark comparisons, power, CO2, etc.

## 3 Novel Claims (paper's own framing)

1. **First production OCS deployment in a supercomputer** — topology reconfiguration for performance
2. **First accelerator support for embeddings** in commercial ML (SparseCore)
3. **ML-driven co-optimization** of DNN models, OCS topology, and SparseCore configuration
