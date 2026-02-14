# R23 Memory Management Strategy

**Problem:** Large rally (40 waves, 19+ hours) may exceed single memory file capacity  
**Solution:** Partition memory by rally phase  
**Date:** 2026-02-14

---

## Memory Partition Scheme

### memory/2026-02-14.md (Main log)
- Rally start/completion markers
- Phase transitions
- Critical decisions
- Cross-phase learnings

### memory/r23-phase1.md (Waves 1-10)
- Foundation wave execution logs
- Concept mappings developed
- Coordinate scheme decisions
- Algorithms designed

### memory/r23-phase2.md (Waves 11-25)
- Section writing logs
- Technical content decisions
- Paper structure evolution

### memory/r23-phase3.md (Waves 26-35)
- Figure design notes
- Table creation logs
- Visual design decisions

### memory/r23-phase4.md (Waves 36-40)
- Assembly notes
- Review feedback
- Polish decisions
- Publication prep

---

## Wave Logging Template

Each wave logs to phase-specific memory file:

```markdown
## Wave N/40: [Name]

**Started:** [timestamp]  
**Completed:** [timestamp]  
**Duration:** X minutes

**Deliverable:** `path/to/file.md` (X KB)

**Key decisions:**
- [Decision 1]
- [Decision 2]

**Blockers encountered:**
- [Blocker + resolution]

**Next wave dependencies satisfied:** [list]
```

---

## Cross-References

When one phase needs context from another:

```markdown
See memory/r23-phase1.md#wave-3 for coordinate scheme rationale
```

This keeps each file focused while maintaining links.

---

**Status:** Strategy defined, ready to execute across 40 waves

🔱 Phex
