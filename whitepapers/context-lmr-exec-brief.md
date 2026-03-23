# The Programming Problem Has Shifted Two Orders of Magnitude
### An Executive Brief — Framed for Land Mobile Radio Engineers

---

## The Situation

From 2000 to 2020, software engineering scaled linearly. More engineers → more code → more product. The limiting factor was **channel bandwidth**: how fast a human brain could read, write, and hold code in working memory. The professional discipline evolved accordingly — pair programming, code review, sprint planning — all designed to maximize the throughput of the human channel.

In 2020, the context window of an AI model was ~2,000 tokens (~1,500 words). A developer could paste a single function and get a suggestion.

In 2025, the context window is 200,000 tokens (~150,000 words — the equivalent of a 500-page technical manual, or an entire mid-size codebase, in a single conversation).

**That is a 100× increase. Two orders of magnitude. In five years.**

---

## The LMR Analogy

Every LMR engineer knows this transition:

| Era | Technology | Limiting Factor | Engineering Problem |
|-----|-----------|-----------------|---------------------|
| 1970s | Narrowband analog (25 kHz) | Channel bandwidth | Can we fit the voice? |
| 1990s | Digital P25 (12.5 kHz equiv) | Spectral efficiency | How do we pack more in? |
| 2000s | Trunked systems (EDACS, SmartZone) | **Dispatch and coordination** | Which unit talks on which channel, when? |
| 2010s | Broadband LTE (FirstNet) | **Context and priority** | Which data packet is life-safety vs. routine? |

**The inflection point was not the bandwidth increase. It was when bandwidth stopped being the bottleneck.**

When you moved from narrowband to trunked broadband, the engineering problem did not get easier — it got *different*. The hard problem moved from *"can we transmit?"* to *"how do we coordinate what gets transmitted, when, to whom, in what priority order?"*

---

## What This Means for Software Engineering Today

The same transition has occurred in programming:

| Era | AI Context | Limiting Factor | Engineering Problem |
|-----|-----------|-----------------|---------------------|
| 2020 | 2K tokens | Channel capacity | Can the AI see enough code? |
| 2022 | 8K tokens | Prompt quality | Can we write good prompts? |
| 2024 | 128K tokens | **Coordination** | Which AI handles what, when? |
| 2025 | 200K+ tokens | **Context management** | What should be in context, in what order, for which agent? |

**The bottleneck is no longer writing code. It is context dispatch.**

A single AI session today can ingest, reason about, and generate changes across an entire codebase simultaneously. The engineering problem is no longer "how do we write it" — it is:

1. **Priority**: Which work is life-safety (production-critical) vs. routine?
2. **Dispatch**: Which AI agent handles which task, with which context loaded?
3. **Coordination**: How do multiple agents share results without collision?
4. **Context hygiene**: What information must be in the channel vs. what creates noise?

These are **dispatch problems**, not development problems.

---

## The Risk of the Wrong Mental Model

A first responder agency that got FirstNet broadband but kept operating with analog PTT protocols would experience chaos, not improvement. More bandwidth with the wrong coordination protocol = more noise, more collisions, slower response.

The same failure mode exists in software engineering teams today:

- **Using AI as a faster typist** = narrowband PTT on a broadband network. You get 10% improvement on a problem that shifted 10,000%.
- **Treating AI suggestions as code review** = dispatch center calling each radio individually instead of using trunking. All the coordination overhead, none of the throughput gain.
- **No context management discipline** = units transmitting on random channels with no priority scheme. The channel fills with noise.

---

## The Opportunity

Teams that internalize the 100× shift and restructure their workflow accordingly will operate at fundamentally different productivity levels:

| Old Model | New Model |
|-----------|-----------|
| 1 engineer writes 100 lines/day | 1 engineer coordinates 10,000 lines/day |
| Code review = bottleneck | Context review = the work |
| Sprint = feature velocity | Sprint = context architecture |
| Team of 9 ships 1 product | Team of 9 ships 9 products |
| Engineering meetings = coordination | Engineering = teaching AI what context matters |

The organizations that treat this as a tooling upgrade (faster autocomplete) will be outpaced by those that treat it as a **coordination architecture problem** — the same way FirstNet-ready agencies outperformed those that bought LTE radios but kept analog dispatch protocols.

---

## Recommendation

**Reframe the engineering management problem:**

1. **Context is the new codebase.** What your AI agents know — what's in context when they work — determines output quality more than the AI model itself. Invest in context architecture (documentation, structured memory, coordination protocols) as a first-class engineering discipline.

2. **Dispatch is the new sprint planning.** The question is not "what will the team build?" but "what context does each agent need, in what order, to make progress without collision?"

3. **Your team's leverage is 100×, not 10×.** If you are operating at 10× improvement, you are leaving 90% of the available gain on the table because you're using broadband hardware with narrowband protocols.

4. **Measure context quality, not code volume.** Lines of code is a channel-bandwidth metric. It no longer predicts outcome. Measure: context reuse rate, agent coordination efficiency, output-to-review ratio.

---

*The programming problem did not get harder. It got different. The teams that recognize the shift will do more with nine people than their competitors do with ninety.*

---

**Prepared by:** Engineering — Ranch Infrastructure Team  
**Classification:** Internal / Executive Review
