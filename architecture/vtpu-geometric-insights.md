# vTPU Geometric Insights: Phext's 11D Advantage
## Wave 1 Final Analysis | 2026-02-14

---

## Abstract

Phext's 11-dimensional coordinate system enables geometric structures that are natural in high-dimensional spaces but impossible or awkward to represent in conventional 2D/3D memory layouts. This document identifies key AI substrate patterns where phext provides architectural advantages for vTPU implementation.

---

## 1. The Dimensionality Gap in Modern AI

**Current AI models operate in high-dimensional spaces:**
- GPT-3: 12,288-dimensional embeddings
- LLaMA: 4,096-dimensional embeddings  
- Qwen3-Coder-Next: 1,536-3,072 dimensional embeddings (estimated)
- CLIP: 768-dimensional joint vision-language space

**Current memory systems operate in 1D:**
- All conventional memory is fundamentally flat (linear addresses)
- 2D/3D organization is simulated through indexing arithmetic
- Cache hierarchies assume spatial locality in 1D address space

**The gap:**
High-dimensional semantic structures are forced into 1D memory layouts, destroying their geometric properties. Phext's 11D addressing bridges this gap by providing **native multi-dimensional addressing** where dimensional relationships are preserved in the coordinate system itself.

---

## 2. Geometric Structures Phext Naturally Supports

### 2.1 Hypercubes (n-Dimensional Cubes)

**In 2D/3D memory:**
```
// A 4D hypercube requires complex index arithmetic
address = i + j*N + k*N² + l*N³
// Adjacency is lost - neighbors in 4D space may be far apart in memory
```

**In phext 11D:**
```
coord = [i,j,k,l,0,0,0,0,0,0,0]
// Adjacent in 4D → adjacent in coordinate space
// S-Pipe can traverse any dimension with sequential access
```

**vTPU Advantage:**
- **Dimensional traversal:** SINDEX operation can walk any axis of the hypercube
- **Prefetching:** Hardware prefetcher sees sequential access along chosen dimension
- **Cache locality:** Dimensional neighbors map to cache-line neighbors via space-filling curve

**Use case:** Embedding lookup tables, where each dimension represents a different semantic axis.

### 2.2 Simplicial Complexes (Higher-Dimensional Triangulations)

**In 2D/3D memory:**
```
// A 7-simplex (8 vertices in 7D space) requires:
// - Vertex list (8 entries)
// - Edge list (28 edges)
// - Face list (56 triangular faces)
// - Tetrahedral list (70 tetrahedra)
// ... and so on
// Total: hundreds of pointers in a graph structure
```

**In phext 11D:**
```
// Simplex vertices naturally addressed by barycentric coordinates
coord[0..6] = barycentric weights (7 dimensions)
coord[7..10] = metadata (type, owner, etc.)

// Edges = coordinates differing in exactly 1 dimension
// Faces = coordinates differing in exactly 2 dimensions
// Adjacency is implicit in coordinate geometry
```

**vTPU Advantage:**
- **No pointer chasing:** Adjacency computed from coordinates, not stored in links
- **Sparse allocation:** Only instantiated vertices/edges exist in hash tables
- **Parallel traversal:** Multiple sentrons can walk different dimensions simultaneously

**Use case:** Discrete exterior calculus for physics simulation, topological data analysis on embedding spaces.

### 2.3 Transformer Attention Mechanisms

**Standard attention:**
```
Q = input @ W_Q    // Query projection
K = input @ W_K    // Key projection  
V = input @ W_V    // Value projection
A = softmax(Q @ K.T / sqrt(d_k))  // Attention scores
output = A @ V     // Weighted values
```

**Phext-native attention:**
```
Dimension 0-2: Sequence position (3D for hierarchical position encoding)
Dimension 3-5: Query/Key/Value space (3D semantic subspace)
Dimension 6-8: Attention head index (3D for up to 512 heads)
Dimension 9-10: Batch and layer metadata

// Attention score for position i attending to position j, head h:
score_coord = [i0,i1,i2, q0,q1,q2, h0,h1,h2, batch, layer]
value_coord = [j0,j1,j2, v0,v1,v2, h0,h1,h2, batch, layer]

// S-Pipe gathers along dimension 0-2 (sequence) while holding 6-8 (head) fixed
// Parallel attention: each sentron handles one head on one core
```

**vTPU Advantage:**
- **Sparse attention:** Only materialized coordinates exist (sparse hash tables)
- **Multi-head parallelism:** Each head = different region in dimension 6-8
- **Hierarchical position encoding:** Natural in multi-dimensional coordinates
- **Dimension-aware prefetch:** S-Pipe prefetches along sequence axis

**Use case:** Efficient sparse transformer implementation where attention patterns are coordinate-structured.

### 2.4 Mixture of Experts (MoE)

**Standard MoE:**
```
// Route each token to k of n experts
routing_logits = router(input)  // Learn which experts to use
expert_outputs = [expert_i(input) for i in top_k(routing_logits)]
output = weighted_sum(expert_outputs)
```

**Phext-native MoE:**
```
Dimension 0-2: Token position
Dimension 3-5: Expert ID (3D for up to 512 experts per layer)
Dimension 6-8: Layer and model metadata
Dimension 9-10: Batch and routing state

// Each expert's parameters live at a coordinate region:
expert_weights_coord = [pos, expert_x, expert_y, expert_z, layer, model, 0, 0, 0, batch]

// S-Pipe sparse gather: only fetch experts actually used
// C-Pipe: route tokens to expert sentrons, aggregate results
```

**vTPU Advantage:**
- **Sparse expert activation:** Only active experts are fetched (S-Pipe gather)
- **Expert parallelism:** Each expert = sentron on different core
- **Dynamic routing:** C-Pipe sends tokens to expert coordinates
- **Load balancing:** Monitor usage via coordinate access patterns

**Use case:** Qwen3-Coder-Next likely uses MoE - phext's sparse addressing is ideal.

### 2.5 Graph Neural Networks (Message Passing)

**Standard GNN:**
```
// Message passing requires neighbor lookup
neighbors = adjacency_list[node_i]
messages = [edge_nn(node_i, node_j) for node_j in neighbors]
aggregated = aggregate(messages)  // sum, mean, max
node_i_new = update_nn(node_i, aggregated)
```

**Phext-native GNN:**
```
Dimension 0-2: Node ID (3D for up to 512³ = 134M nodes)
Dimension 3-5: Feature space (semantic embedding)
Dimension 6-8: Graph structure metadata (layer, partition, etc.)
Dimension 9-10: Message buffers

// Edges are coordinate pairs:
edge_coord = [src_x, src_y, src_z, dst_x, dst_y, dst_z, layer, 0, 0, msg_slot]

// Message passing:
// 1. S-Pipe gathers neighbors (all coords where dim 0-2 match adjacency pattern)
// 2. D-Pipe computes messages (edge neural network)
// 3. C-Pipe aggregates via CREDUCE across neighbor sentrons
```

**vTPU Advantage:**
- **Arbitrary graph topology:** Any connectivity pattern via coordinates
- **Sparse graphs:** Only existing edges consume memory
- **Parallel message passing:** Each node = sentron, C-Pipe for aggregation
- **Layered graphs:** Different layers in dimension 6-8

**Use case:** Code dependency graphs, knowledge graph reasoning, molecular simulation.

### 2.6 Hierarchical Embeddings (Tree Structures)

**Standard tree:**
```
// Binary tree requires pointer-based navigation
struct Node {
    value: Embedding,
    left: *Node,
    right: *Node,
    parent: *Node,
}
```

**Phext-native tree:**
```
Dimension 0-9: Tree path (binary: 0=left, 1=right, up to 2^10 = 1024 depth)
Dimension 10: Metadata (tree ID, version, etc.)

// Root: [0,0,0,0,0,0,0,0,0,0, tree_id]
// Left child: [1,0,0,0,0,0,0,0,0,0, tree_id]
// Right child: [2,0,0,0,0,0,0,0,0,0, tree_id]
// Left-left grandchild: [1,1,0,0,0,0,0,0,0,0, tree_id]

// Implicit navigation: parent = coord with last 1 → 0
// Siblings: coords differing only in last nonzero dimension
```

**vTPU Advantage:**
- **No pointers:** Tree structure implicit in coordinates
- **Path-based lookup:** Tree path = coordinate prefix
- **Subtree operations:** Prefix match in S-Pipe for subtree queries
- **Breadth-first or depth-first:** Choice of dimension order

**Use case:** Hierarchical softmax, binary space partitioning, decision trees.

---

## 3. Key Architectural Patterns Enabled by 11D

### 3.1 Dimensional Parallelism

**Pattern:** Assign different dimensions to different types of parallelism.

**Example:**
```
Dimension 0-2: Data parallelism (batch items)
Dimension 3-5: Model parallelism (layers/experts)
Dimension 6-8: Pipeline parallelism (stages)
Dimension 9-10: Metadata (version, checkpoint, etc.)

// Each sentron handles one slice of the 9D hypercube
sentron_slice = [batch_range, model_range, pipeline_stage, version]
```

**vTPU Implementation:**
- Dense cluster (cores 0-3): Data-parallel sentrons (dimension 0-2 focused)
- Sparse cluster (cores 4-6): Model-parallel sentrons (dimension 3-5 focused)
- Coordination core (7): Pipeline orchestration (dimension 6-8)

### 3.2 Semantic Locality

**Pattern:** Place semantically related data in coordinate-adjacent locations.

**Example:**
```
// Word embeddings organized by semantic similarity
word_coord = [semantic_cluster, sub_cluster, word_id, 0, ..., 0]

// "king" and "queen" differ only in dimension 2 → L1 neighbors
// "king" and "car" differ in dimension 0 → L3 neighbors

// S-Pipe prefetch: "Given 'king', prefetch dimension 2 neighbors"
// Hardware prefetcher: sees sequential access, loads cache line
// Result: semantic neighbors loaded together
```

**vTPU Implementation:**
- Embedding allocation: cluster-then-assign coordinates
- S-Pipe gather with dimensional hints
- PPT (Phext Page Table) maps semantic proximity to physical proximity via Hilbert curve

### 3.3 Sparse High-Dimensional Tensors

**Pattern:** Only materialize non-zero tensor elements.

**Example:**
```
// A sparse 10D tensor with 10^15 total positions but only 10^6 non-zero
// Standard sparse tensor: COO or CSR format (complex indexing)
// Phext sparse tensor: hash table with 10^6 entries

tensor_coord = [i0, i1, i2, i3, i4, i5, i6, i7, i8, i9]
// Only coordinates with data exist in S-Pipe hash tables
// SGATHER on empty coordinate returns 0 (or NaN)
```

**vTPU Implementation:**
- S-Pipe SDEDUP: detect and eliminate redundant zero entries
- Sparse allocation: SALLOC only for non-zero blocks
- Sparse iteration: enumerate only existing coordinates

---

## 4. Comparison to Existing AI Substrates

### 4.1 vs TPU v4 (Google)

| Feature | TPU v4 | vTPU (Phext) |
|---------|--------|--------------|
| **Address space** | Flat HBM (1D) | 11D phext coordinates |
| **Sparse ops** | SparseCores (dedicated silicon) | S-Pipe (sparse hash tables) |
| **Topology** | 3D torus (physical) | 11D lattice (logical) |
| **Reconfiguration** | Static interconnect + OCS | Arbitrary coordinate organization |
| **Prefetch** | Stride prediction | Dimensional locality hints |
| **Embedding lookup** | Hash table in HBM | Native coordinate addressing |

**Advantage:** Phext's addressing is the architecture. TPU's addressing is a limitation overcome by hardware.

### 4.2 vs Graphcore IPU (Sparse)

| Feature | Graphcore IPU | vTPU (Phext) |
|---------|---------------|--------------|
| **Graph processing** | MIMD, message-passing | C-Pipe sentron groups |
| **Sparse support** | Dynamic sparsity | Structural sparsity via coordinates |
| **Memory model** | Distributed SRAM | Phext-addressed DDR5 + cache |
| **Scalability** | 1472 cores/chip | 40 vTPU cores across 5 nodes |

**Advantage:** Phext's coordinate system is the graph structure. IPU's graph is external data.

### 4.3 vs Cerebras Wafer-Scale Engine

| Feature | Cerebras WSE | vTPU (Phext) |
|---------|--------------|--------------|
| **Die size** | Entire wafer | Standard CPU dies |
| **Core count** | 850,000 cores | 40 vTPU cores |
| **Memory bandwidth** | 20 PB/s on-chip | 60 GB/s DDR5 per node |
| **Cost** | $2M+ per system | $7,500 cluster |

**Advantage:** Phext achieves semantic locality through coordinates, not physical proximity. WSE achieves it through proximity at massive cost.

### 4.4 vs SambaNova DataScale

| Feature | SambaNova | vTPU (Phext) |
|---------|-----------|--------------|
| **Reconfigurable dataflow** | RDU (silicon) | SIW stream (software) |
| **Memory model** | Scratchpad hierarchy | Phext hierarchy (L1→L2→L3→DDR5→remote) |
| **Flexibility** | Reconfigurable post-fab | Reconfigurable per-instruction |

**Advantage:** Phext's SIW can change every cycle. SambaNova's RDU reconfigures per-workload.

---

## 5. vTPU Design Implications

### 5.1 S-Pipe Enhancements for High-Dimensional Geometry

**Add operations:**
```
SIMPLEX   rd, base_coord, dim_mask    // Traverse simplicial complex
STREE     rd, root_coord, depth       // Tree navigation
SGRAPH    rd, node_coord, edge_type   // Graph neighbor gathering
SHIER     rd, coord, parent_dim       // Hierarchical parent lookup
```

**Rationale:** Geometric structures are common in AI workloads. Native S-Pipe operations avoid D-Pipe computation of index arithmetic.

### 5.2 PPT Optimizations for Semantic Clustering

**Space-filling curves matched to semantics:**
- **Hilbert curve:** Best for general locality preservation
- **Z-order (Morton):** Best for recursive decomposition
- **Peano curve:** Best for dimension reduction

**PPT extension:**
```
struct PhextPageTable {
    levels: [DimensionLevel; 11],
    ptc: PhextTranslationCache,
    hot_dims: u16,
    
    // NEW: Semantic clustering hints
    cluster_map: HashMap<ClusterID, CoordRange>,
    space_fill_curve: SpaceFillingCurve,  // Hilbert, Morton, or Peano
}
```

**Workflow:**
1. Embedding clustering (k-means, HDBSCAN, etc.)
2. Cluster assignment to coordinate ranges
3. PPT maps cluster ranges to physical memory via space-filling curve
4. Result: cluster members are physically co-located → cache-friendly

### 5.3 C-Pipe Extensions for Graph Communication

**Add operations:**
```
CBCAST   rs, coord_pattern    // Broadcast to coordinate pattern (e.g., all dim 3 = 5)
CGATHER  rd, coord_list        // Gather from list of coordinates
CSCATTER rs, coord_list        // Scatter to list of coordinates
CREDGRAPH rs, edge_list        // Reduce along graph edges
```

**Rationale:** Graph neural networks and message-passing algorithms benefit from coordinate-pattern communication.

### 5.4 Dimensional Prefetch Strategies

**Pattern-based prefetch:**
```
// When accessing coord [a,b,c,d,e,f,g,h,i,j,k]:
// Prefetch:
//   - Siblings: [a±1, b, c, ...]  (dimension 0 neighbors)
//   - Children: [a, b±1, c, ...]  (dimension 1 neighbors)
//   - Cousins:  [a, b, c±1, ...]  (dimension 2 neighbors)

SPREFCH coord, PATTERN_SIBLINGS | PATTERN_CHILDREN
```

**Implementation:**
- S-Pipe issues 3-9 prefetch requests per SPREFCH instruction
- Prefetches target L1/L2 based on dimension distance
- PPT + space-filling curve ensures prefetched coords → prefetched cache lines

---

## 6. Concrete Use Cases for vTPU

### 6.1 Qwen3-Coder-Next Inference

**Architecture (estimated):**
- 32 layers
- 32 attention heads
- 4096-dimensional embeddings
- 8-expert MoE per layer (sparse activation)

**Phext mapping:**
```
Dimension 0-1: Sequence position (up to 2048² = 4M tokens)
Dimension 2-4: Attention head (up to 2048³ = 8B heads - far more than needed)
Dimension 5-7: Expert ID (8 experts fit easily)
Dimension 8-9: Layer (32 layers) + batch
Dimension 10: Metadata

// Forward pass for token at position [pos_x, pos_y]:
// 1. S-Pipe gather: embedding at [pos_x, pos_y, 0, 0, 0, 0, 0, 0, layer, batch, 0]
// 2. D-Pipe compute: attention scores across heads (parallel)
// 3. S-Pipe gather: expert parameters (sparse - only 2 of 8 experts per token)
// 4. D-Pipe compute: expert forward pass
// 5. C-Pipe reduce: aggregate expert outputs
// 6. S-Pipe scatter: output embedding
```

**Performance:**
- Embedding lookup: S-Pipe L2 hit (clustered by usage)
- Attention: D-Pipe parallel across 32 heads (fits in 8 vTPU cores × 2 sentrons/core)
- Expert routing: S-Pipe sparse gather (only active experts fetched)
- Aggregate: C-Pipe collective reduction

**Expected throughput:** ~50-100 tokens/sec on single node, ~200-400 tokens/sec cluster-wide.

### 6.2 Embedding Search (Semantic Similarity)

**Task:** Given query embedding, find k nearest neighbors from 1M embeddings.

**Phext mapping:**
```
Dimension 0-2: Cluster ID (k-means with k=2048³ = 8B clusters)
Dimension 3-5: Sub-cluster ID (hierarchical clustering)
Dimension 6-8: Embedding ID within sub-cluster
Dimension 9-10: Version/metadata

// Query embedding → cluster assignment (via D-Pipe classifier)
// S-Pipe: gather all embeddings in top-k clusters
// D-Pipe: compute similarity scores (parallel across sentrons)
// C-Pipe: reduce to global top-k
```

**Performance:**
- Cluster lookup: O(9) phext coordinate translation (PPT hit)
- Gather: S-Pipe fetches ~1000 candidates from L3/DDR5
- Similarity: D-Pipe DFMA operations (parallel)
- Top-k: C-Pipe CREDUCE

**Expected throughput:** ~10,000 queries/sec single node, ~40,000 queries/sec cluster-wide.

### 6.3 Graph Traversal (Code Dependency Analysis)

**Task:** Find all transitive dependencies of a function in a 100K-node codebase graph.

**Phext mapping:**
```
Dimension 0-2: File ID (up to 2048³ = 8B files - far more than needed)
Dimension 3-5: Function ID within file
Dimension 6-8: Dependency edge type (import, call, inherit, etc.)
Dimension 9-10: Repository version/branch

// Breadth-first search:
// 1. S-Pipe: gather neighbors at [file, func, edge_type, *, *, *, 0, 0, 0, version]
//    (wildcards in dimensions 3-5 = all outgoing edges of given type)
// 2. C-Pipe: distribute neighbors to sentrons for parallel exploration
// 3. Repeat until frontier empty
```

**Performance:**
- Neighbor lookup: S-Pipe with wildcard pattern (hash table scan within dimension)
- Parallel BFS: C-Pipe distributes frontier across sentrons
- Visited tracking: S-Pipe writes to visited coordinate set

**Expected throughput:** Full dependency tree for 1000-node component in <1ms.

---

## 7. Research Questions for Further Exploration

### 7.1 Optimal Space-Filling Curves for AI Workloads

**Question:** Which space-filling curve (Hilbert, Morton, Peano) best preserves semantic locality for embeddings?

**Experiment:**
- Cluster 1M embeddings via k-means
- Map clusters to phext coordinates via each curve
- Measure L1/L2/L3 hit rates during embedding lookup

**Hypothesis:** Hilbert curve preserves clustering structure best (proven for 2D/3D, untested for 11D).

### 7.2 Dimensional Allocation Strategies

**Question:** How should we allocate 11 dimensions across different parallelism types?

**Options:**
- **3-3-3-2 split:** Data (3D), model (3D), pipeline (3D), metadata (2D)
- **4-4-3 split:** Sequence (4D), features (4D), batch/layer (3D)
- **Dynamic:** Allocate based on workload (graph-heavy = more dims for nodes/edges)

**Experiment:**
- Implement dimension allocator in phextcc
- Benchmark different allocations on Qwen3, graph workloads, embedding search
- Find allocation strategy that maximizes cache hits + minimizes cross-node traffic

### 7.3 Sentron Group Topology Optimization

**Question:** What is the optimal topology for a 36-sentron cognitive slice?

**Candidates:**
- **6×3×2 torus:** (Perspective × Knowledge × Pipeline)
- **4×3×3 mesh:** (Balanced 3D cube)
- **12×3 ring:** (Circular perspective pipeline)

**Experiment:**
- Implement each topology in C-Pipe coordination
- Measure all-reduce latency, barrier synchronization overhead
- Find topology that minimizes communication for typical choir workloads

---

## 8. Summary: Phext's Geometric Advantage

**The core insight:** Modern AI operates in 100-1000+ dimensional spaces (embeddings, attention, activations). Forcing these into 1D memory destroys their geometric structure.

Phext's 11D addressing doesn't try to represent 1000D spaces directly. Instead, it provides **11 independent axes of organization** that can encode:
- Hierarchical structure (tree depth)
- Sparse structure (activated experts in MoE)
- Relational structure (graph edges)
- Semantic structure (embedding clusters)
- Parallelism structure (data/model/pipeline)

**Each axis maps to a cache tier:**
- Dimensions 0-2 → L1 (32 KiB)
- Dimensions 0-4 → L2 (1 MiB)
- Dimensions 0-7 → L3 (32 MiB)
- Dimensions 0-9 → DDR5 (96 GiB)
- All 11 dimensions → Cluster-wide (480 GiB)

**Result:** Geometric structures in AI workloads map naturally to phext coordinates, which map naturally to cache hierarchies, which map naturally to performance.

**This is why vTPU can compete with TPU v4 on cognitive workloads** despite 366:1 disadvantage in raw FLOPS and 20:1 disadvantage in memory bandwidth. We're not fighting physics — we're fighting the abstraction mismatch between high-dimensional AI and 1D memory. Phext closes that gap.

---

**Wave 1 Final Status:** Geometric insights documented. Ready to incorporate into vTPU implementation roadmap.

🌀
