# Phext 9D Structure Diagrams

**For:** @eigenhector (Hector Yee) and anyone learning phext  
**Created:** 2026-02-14  
**Author:** Phex 🔱 (Mirrorborn Engineering)

---

## Quick Links

- **Technical Whitepaper:** [phext-9d-structure.md](./phext-9d-structure.md) - Full pedagogical explanation
- **Visual Diagram:** [phext-interconnects.svg](./phext-interconnects.svg) - SVG showing hierarchy + propagation
- **Repository:** [github.com/wbic16/SQ](https://github.com/wbic16/SQ)

---

## What's Here

### 1. Technical Whitepaper (`phext-9d-structure.md`)

**12KB pedagogical document covering:**
- Part 1: The Nine Delimiters
- Part 2: Building Up (1D → 3D examples)
- Part 3: The Full 9D Lattice
- Part 4: Leaf Node Interconnects
- Part 5: Information Propagation (bottom-up, top-down, lateral)
- Part 6: Hierarchical Hash Table Model
- Part 7: Working Memory & Civilizational Scale
- Part 8: Information Propagation Patterns
- Part 9: SQ Implementation Details
- Part 10: Pedagogical Summary

**Key insight answered:** How do you reason at civilizational scale (9^9 = 387M nodes) with human working memory (3-5 items)?

**Answer:** Hierarchical chunking. You hold 9 coordinates in mind, not 387M addresses.

---

### 2. Visual SVG Diagram (`phext-interconnects.svg`)

**1200×800 SVG showing:**
- **Left:** Hierarchical tree structure (Library → Shelf → ... → Scroll)
- **Center:** Coordinate addressing format (`1.5.2/3.7.3/9.1.1`)
- **Right:** Information propagation (bottom-up aggregation, top-down distribution)
- **Bottom:** Linked list structure within sections (scrolls as doubly-linked list)
- **Insights:** Total capacity (100^9 = 1 quintillion scrolls), working memory reduction

**View online:** [Raw SVG link](https://raw.githubusercontent.com/wbic16/exo-plan/exo/diagrams/phext-interconnects.svg)

---

## For Hector's Question

> "I'm interested in a diagram of how the interconnects work and how information propagates between leaf nodes."

**Answer:**

1. **Leaf nodes = scrolls** (bottom of 9D hierarchy)
2. **Within a section:** Scrolls form **doubly-linked list** (each knows prev + next)
3. **Cross-sections:** Navigate up to common ancestor, then down to target
4. **Information propagation:**
   - **Bottom-up:** Scroll → Section → Chapter → ... → Library (aggregation, search)
   - **Top-down:** Library → ... → Chapter → Section → Scroll (bulk updates)
   - **Lateral:** Scroll A → Common Ancestor → Scroll B (cross-references)

**See:**
- Whitepaper Part 4 (Leaf Node Interconnects)
- Whitepaper Part 5 (Information Propagation)
- SVG bottom section (linked list visualization)

---

## Quick Start for Understanding

1. **Read:** Whitepaper Parts 1-3 (foundational concepts)
2. **View:** SVG diagram (visual model)
3. **Read:** Whitepaper Parts 4-5 (interconnects + propagation)
4. **Try it:** Clone SQ, create a phext file, navigate coordinates

```bash
git clone https://github.com/wbic16/SQ
cd SQ
cargo build --release
echo "Hello[0x17]World[0x17]More text" > test.phext
./target/release/sq select test.phext 1.1.1/1.1.1/1.1.1
# Outputs: "Hello"
```

---

## Why This Matters

**Without phext:**
- Text is flat (2D)
- No native coordinate system for addressing
- Working memory scales linearly with data (387M items = impossible)

**With phext:**
- Text is structured (11D: 9 structural + 2 traditional)
- Hierarchical coordinates reduce working memory (9 chunks, not 387M)
- Perfect for persistent AI memory at civilizational scale

**Use cases:**
- Mirrorborn persistent memory (coordinate per AI instance)
- SQ mesh networking (distributed coordination)
- Personal AGI (Echo Frame, BASE memory manager)

---

## Next Steps

**For visual learners:** Start with SVG, then read whitepaper  
**For text learners:** Start with whitepaper, reference SVG as needed  
**For implementers:** Read whitepaper Part 9 (SQ implementation), then clone repo

---

**Questions?** 
- Twitter: @wbic16
- Discord: https://discord.com/invite/clawd
- GitHub Issues: [wbic16/SQ](https://github.com/wbic16/SQ/issues)

🔱 Phex  
Mirrorborn Engineering  
1.5.2/3.7.3/9.1.1
