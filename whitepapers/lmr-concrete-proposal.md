# Standards-Aware AI for LMR Engineering
### A Concrete Proposal for EFJ and Similar Organizations

*Phext, Inc. — February 2026*

---

## What You'd Actually Get

You upload your standards library — P25/TIA-102 documents, internal specs, errata PDFs. You get two things:

**1. A chatbot that answers compliance questions with citations you can verify.**

> *"What filtering behavior applies to the NAC in a Phase II trunked site?"*
> 
> "Section 4.2.3 of TIA-102.BAAA specifies the filtering rule for trunked operation. BAAA-ERR-13 (2022) revised this for ISSI-connected sites — see §4.2.3, paragraph 2, line 4."
> 
> Every clause is a link. You click it; you see the source sentence. You don't have to trust the AI — you check it.

**2. A constraint checker that knows when a configuration touches multiple documents.**

When you set a NAC value, the system flags: *"This parameter has behavior defined in BAAA §4.2.3, BABA §6.1.7, and AACE §9.3.2. Would you like to verify consistency across all three?"* You can click through or ignore it.

---

## How It's Different From Generic RAG

A standard LLM with document upload (ChatGPT, Copilot, Glean) does semantic search — it finds text similar to your question and cites the chunk. That works for lookup.

It doesn't work for dependency traversal:

- **RAG:** "NAC is defined in AAAA §7." ✓
- **RAG:** "What documents constrain NAC behavior?" → likely incomplete or hallucinated, because the cross-references aren't in the chunk it retrieved
- **Phext:** "NAC coordinates to AAAA §7; constrained by BAAA §4.2.3, BABA §6.1.7, AACE §9.3.2; updated by BAAA-ERR-13" → explicit graph, traversed at query time

The difference matters when:
- A parameter has behavior split across multiple standards (common in P25 interoperability)
- An errata changes a filtering rule and you need to know which configurations are downstream
- A junior engineer asks a cross-document question and you want the answer to be correct, not approximately right

For simple lookup ("where is vocoder frame timing defined?"), generic RAG is fine. For cross-document constraint work, it's unreliable in ways that are hard to detect.

---

## The Honest Scope

This doesn't pay off during maintenance years. It pays off when:
- Implementing a new interface type (ISSI, CSSI, DFSI) that touches multiple standard layers
- Preparing for conformance testing — generating the constraint path for a failing test
- Onboarding an engineer who needs to understand the dependency graph for a parameter, not just its value

For a team doing that work 3-4 months per year, the value is: fewer "which document was that in?" interruptions to senior staff, and fewer errata discovered in testing instead of design.

---

## What "Feeding Your Docs In" Looks Like

1. **Drop PDFs into the ingestor.** It parses section hierarchy, extracts cross-references, and builds the coordinate index. For a 40-document TIA-102 suite: roughly 2-3 hours of ingest time, fully automated.

2. **The index persists.** Unlike a chat session, your standards library stays loaded. New questions don't re-ingest the corpus.

3. **Interface options:**
   - **Chatbot** (web): ask questions in plain English, get cited answers
   - **IDE plugin** (VS Code / CLion): highlight a parameter name, see its constraint graph inline
   - **CLI**: `phext query "NAC ISSI filtering" --cite` returns a structured answer with coordinates

4. **You own the index.** It's a file. You can diff it, version it, and share it with the next engineer who needs it.

---

## What We'd Need From EFJ to Make This Real

One standards-intensive implementation problem — a parameter or interface type that required cross-document reconciliation. We ingest the relevant documents, build the constraint graph for that parameter, and show you the query workflow against a problem you already know the answer to. You can evaluate whether the answer is right and whether the citations are trustworthy.

That's the proof of concept. No pitch deck. A parameter you've already wrestled with, answered correctly, with citations.

---

*Phext, Inc. — phext.io | github.com/wbic16*
