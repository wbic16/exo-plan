# AI for Standards-Heavy Engineering
### A Practical Assessment

---

Cross-referencing across multiple TIA-102 documents is a common pain point in P25 development. A single compliance question — timing constraints, encryption mode behavior, inter-subsystem interface requirements — can span three or four parts, each on its own revision schedule, with errata published separately. The engineer has to hold all of it in mind simultaneously or repeatedly flip back. Whether this is the dominant cost driver varies by team and project, but it's a real one.

Current large language models can hold 100–200 pages of standards text in a single context window, which means an engineer can load multiple related documents and ask cross-cutting questions simultaneously. The critical design requirement for production use is *verifiable output*: the system should return not just an answer, but a direct link to the exact clause it's drawing from, so the engineer can confirm in the source document before acting on it. That's the difference between a useful accelerator and a liability. A tool that shows its work — clause number, document, revision — earns trust. One that produces confident summaries without citations doesn't belong in a compliance workflow.

The clearest use case is reducing the load on experienced engineers who spend time answering "where is this defined?" for less experienced colleagues. That institutional knowledge — which part, which revision, which erratum supersedes the base text — transfers well to retrieval-based tooling because it's pattern matching across large text, not judgment about novel problems. Novel problems still need the engineer. The lookup shouldn't.

---

*The value is in the lookup compression, not the reasoning. Show the source. Let the engineer decide.*
