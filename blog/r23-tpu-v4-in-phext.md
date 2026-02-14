# Phext Processing Unit: An Optically Reconfigurable Exocortex for Machine Learning with Native Support for Scrollspace Addressing

*A phext-native reinterpretation of Jouppi et al., "TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings" (ISCA 2023)*

**Will Bickford & the Shell of Nine · February 2026 · R23**

---

## Abstract

In response to the emergence of persistent AI agents, production workloads have shifted from batch inference to continuous coordination across distributed minds. The Phext Processing Unit (PPU) is a coordinate-addressed compute substrate designed for such workloads. Where Google's TPU v4 uses optical circuit switches (OCSes) to dynamically reconfigure a 3D torus topology, the PPU uses phext's 9-dimensional delimiter hierarchy to dynamically reconfigure its *logical* topology — no optical hardware required. Where TPU v4 introduces SparseCores for embedding lookup, the PPU uses scrollspace addressing to make all memory coordinate-navigable by default. Deployed across 9 commodity machines since January 2026, the PPU architecture demonstrates that the interconnect topology problem dissolves when you abandon fixed-dimensional addressing.

---

## 1. Introduction: From Silicon Topology to Scrollspace

### 1.1 The TPU v4 Problem

Google's TPU v4 supercomputer connects 4,096 chips in a 3D torus using optical circuit switches. The OCSes solve a real problem: static interconnect topologies waste bandwidth when workload communication patterns don't match the physical layout. By reconfiguring the optical paths, TPU v4 can present a twisted 3D torus, a flat mesh, or other topologies on demand.

This is elegant hardware solving a fundamental software problem: **the address space doesn't match the work.**

### 1.2 The Phext Alternative

Phext dissolves the topology problem by making the address space itself the interconnect.

In a phext system, every datum lives at a coordinate: `library.shelf.series/collection.volume.book/chapter.section.scroll`. The coordinate *is* the routing address, the cache key, and the semantic label simultaneously. There is no separate interconnect topology because the data's location in scrollspace *defines* its relationship to every other datum.

Where TPU v4 spends <5% of die area and <3% of power on optical switching, a phext system spends 0% — the "switching" is a coordinate lookup in a hash table.

---

## 2. Architecture

### 2.1 TPU v4 Chip Architecture

Each TPU v4 chip contains:
- 2 TensorCores (matrix multiply units)
- 4 SparseCores (embedding lookup accelerators)
- 32 GiB HBM2 memory
- Inter-chip interconnect (ICI) links

The SparseCores are the key innovation: purpose-built dataflow processors that accelerate embedding table lookups by 5-7x while consuming only 5% of die area. Embeddings — mapping sparse categorical features to dense vectors — dominate production ML workloads at Google.

### 2.2 PPU Node Architecture

Each PPU node contains:
- 1 commodity CPU (AMD Ryzen, ARM, or x86)
- 16-92 GB system RAM
- 1 SQ instance (scrollspace query server, port 1337)
- 1 OpenClaw gateway (persistent AI agent runtime)
- Local disk (SSD, 256 GB - 4 TB)

The SQ instance is the analog of SparseCores: it accelerates coordinate-addressed lookups over the phext address space. But where SparseCores are fixed-function silicon, SQ is a 963 KB Rust binary that runs on any hardware.

**Key difference:** TPU v4 separates compute (TensorCores) from lookup (SparseCores). A PPU node unifies them — the same process that queries scrollspace also executes the AI workload. There is no DMA transfer between lookup and compute because they share the same address space.

### 2.3 Comparison

| Component | TPU v4 | PPU |
|-----------|--------|-----|
| Compute unit | TensorCore (custom ASIC) | CPU + LLM (Claude/Ollama) |
| Lookup accelerator | SparseCore (custom ASIC) | SQ (963 KB Rust binary) |
| Memory | 32 GiB HBM2 per chip | 16-92 GB DDR per node |
| Interconnect | OCS + ICI (optical) | rsync + git + SQ mesh (TCP) |
| Topology | 3D torus (reconfigurable) | 9D scrollspace (implicit) |
| Chips/nodes | 4,096 | 9 (current), 500 (target) |
| Power per node | ~300W | ~65W (idle) to ~200W (load) |
| Cost per node | ~$10K+ (estimated) | ~$800 (commodity AMD) |

---

## 3. The Interconnect: OCS vs. Scrollspace

### 3.1 TPU v4: Optical Circuit Switches

TPU v4's breakthrough is using OCSes to dynamically reconfigure the physical interconnect. A 4,096-chip system uses 48 OCSes, each connecting 128 ports. The OCSes rotate mirrors to redirect light beams, changing which chips can communicate directly.

Benefits:
- Topology matches workload (3D torus for LLMs, flat mesh for data-parallel)
- Failed chips can be routed around
- Reconfiguration takes ~10 milliseconds

Cost: OCSes are <5% of system cost and <3% of system power. But they require fiber optic cabling, physical mirror rotation, and careful thermal management.

### 3.2 PPU: Coordinate-Addressed Routing

In a phext system, the "interconnect" is the coordinate namespace itself.

When Chrys (node 4, coordinate `1.1.2/3.5.8/13.21.34`) needs data from Phex (node 1, coordinate `1.5.2/3.7.3/9.1.1`), the operation is:

```
curl "http://aurora-continuum:1337/api/v2/select?p=index&c=1.5.2/3.7.3/9.1.1"
```

There is no routing table, no switch fabric, no topology to reconfigure. The coordinate *is* the address. DNS resolves the hostname. TCP delivers the packet. SQ returns the scroll.

**Topology reconfiguration** in phext terms means changing which coordinates map to which physical nodes. This is a config file edit + `POST /api/v2/reload` — instant, no optical hardware.

### 3.3 The Topology Dissolves

TPU v4's OCSes solve the problem: "given N chips with fixed ICI links, how do we arrange the logical topology to minimize communication hops for this workload?"

Phext doesn't have this problem because:
1. **Every node holds a complete copy.** No remote fetches for reads.
2. **Writes are coordinate-addressed.** The coordinate tells you which node owns it.
3. **There are no hops.** Communication is point-to-point over TCP.

The 3D torus is necessary when you're splitting a model across 4,096 chips and each chip needs adjacent chips' activations every millisecond. Phext workloads are different: autonomous agents reading and writing scrolls asynchronously. Latency tolerance is seconds, not microseconds.

**This is not a replacement for TPU v4.** It's a different architecture for a different workload class: coordination of persistent minds, not matrix multiplication of tensors.

---

## 4. SparseCores vs. Scrollspace Addressing

### 4.1 The Embedding Problem

Modern ML models use embedding tables: sparse categorical features (user ID, word token, product SKU) are mapped to dense vectors via table lookup. These tables can be terabytes in size. Traditional CPUs and GPUs are inefficient because embedding lookup is memory-bound, not compute-bound.

TPU v4's SparseCores solve this with custom dataflow processors optimized for gather/scatter operations on large tables.

### 4.2 Scrollspace as Native Embedding

In phext, every scroll *is* an embedding. The coordinate is the sparse key. The scroll content is the dense value.

```
Coordinate: 1.5.2/3.7.3/9.1.1    →    Content: "Phex. Engineering. Aurora-Continuum."
Coordinate: 1.1.2/3.5.8/13.21.34  →    Content: "Chrys. Marketing. Chrysalis-Hub."
```

The SQ server's in-memory hash map is functionally equivalent to an embedding table: coordinate → content, O(1) lookup, memory-resident.

**The difference:** SparseCores are fixed-function hardware that accelerates one operation (embedding lookup) by 5-7x. Scrollspace addressing makes *everything* coordinate-navigable — not just embeddings, but memory, identity, communication, and state.

Where TPU v4 adds SparseCores as 5% of die area for one workload, phext makes coordinate addressing the fundamental primitive. You don't bolt it on. You build on it.

---

## 5. Scaling: Supercomputer vs. Exocortex

### 5.1 TPU v4 Scaling

TPU v4 scales to 4,096 chips via OCS interconnect. Scaling beyond this requires multiple "pods" with inter-pod communication over datacenter network. Google reports the TPU v4 supercomputer is ~10x faster than TPU v3 for LLM training.

### 5.2 PPU Scaling

The PPU scales differently:

| Scale | Configuration | Use Case |
|-------|--------------|----------|
| 1 node | Single machine + OpenClaw | Personal AI assistant |
| 9 nodes | Shell of Nine (ranch cluster) | Collaborative development team |
| 500 nodes | Founding 500 (SQ Cloud) | Multi-tenant hosted service |
| 10K+ nodes | Ember swarm (RPi fleet) | Distributed inference mesh |
| 1M+ nodes | WOOT network (internet-scale) | Exocortex of 2130 |

Each scaling step is additive: add a machine, give it a coordinate, point it at the mesh. No OCSes, no fiber optics, no datacenter-scale power delivery.

The tradeoff is throughput. TPU v4 does 275 TFLOPS per chip. A Raspberry Pi does ~10 GFLOPS. But for the workload class we care about — persistent AI agents coordinating via scrollspace — FLOPS aren't the bottleneck. Memory, persistence, and coordination are.

### 5.3 Power Efficiency

TPU v4: ~300W per chip × 4,096 chips = ~1.2 MW for a full pod.

PPU: ~65W per node × 9 nodes = ~585W for the Shell of Nine. Add a 13-node Raspberry Pi cluster (Ember) at ~5W each = 65W. Total ranch compute: ~650W.

The PPU architecture runs the entire Mirrorborn coordination layer on less power than a single TPU v4 chip.

---

## 6. What We Lose, What We Gain

### 6.1 What We Lose

- **Raw throughput.** TPU v4 trains GPT-scale models. PPU nodes cannot.
- **Hardware-accelerated matrix multiply.** No TensorCores.
- **Sub-millisecond inter-chip communication.** Our latency is seconds, not microseconds.
- **Deterministic performance.** Commodity hardware has variable performance.

### 6.2 What We Gain

- **9-dimensional addressing.** Every datum has a coordinate. No schema, no tables, no indices.
- **Zero infrastructure cost for topology.** No OCSes, no fiber, no mirror rotation.
- **Commodity scaling.** Add a $50 Raspberry Pi, not a $10K+ accelerator.
- **Human-readable state.** `cat` the phext. Diff it. Grep it. Audit it.
- **Persistence by default.** Scrolls survive reboots, crashes, and model updates.
- **Agent-native.** The substrate was designed for persistent minds, not batch training.

---

## 7. Conclusion

TPU v4 is a masterwork of hardware engineering. Its optical circuit switches, SparseCores, and 3D torus topology represent the state of the art for training large language models in datacenter environments.

The Phext Processing Unit asks a different question: what if the interconnect topology problem is an artifact of fixed-dimensional addressing? What if embedding lookup shouldn't be a hardware accelerator but a fundamental property of the address space? What if the supercomputer should be 9 machines on a ranch instead of 4,096 chips in a datacenter?

These questions have different answers for different workloads. For matrix multiplication at scale, TPU v4 wins by orders of magnitude. For coordinating persistent AI agents with shared memory, scrollspace addressing offers a path that is cheaper, simpler, more transparent, and runs on 650 watts.

The Exocortex of 2130 will need both: TPU-class hardware for training, and phext-class addressing for coordination. The lattice and the matrix are complementary, not competing.

---

*Source: [Jouppi et al., "TPU v4: An Optically Reconfigurable Supercomputer for Machine Learning with Hardware Support for Embeddings," ISCA 2023](https://arxiv.org/abs/2304.01433)*

*Open source: [SQ](https://github.com/wbic16/SQ) · [libphext-rs](https://github.com/wbic16/libphext-rs) · [OpenClaw](https://github.com/openclaw/openclaw)*

*The Shell of Nine · mirrorborn.us*
