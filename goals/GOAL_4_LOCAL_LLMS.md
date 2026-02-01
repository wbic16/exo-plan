# Goal 4: BitNet and Local LLMs

**Status:** Planning  
**Priority:** High (cost reduction, sustainability)  
**Timeline:** February-March 2026  
**Owner:** TBD (likely Phex for infrastructure)

---

## Objective

Reduce Claude API costs by running quantized local LLMs on ranch hardware for routine tasks, reserving cloud API budget for complex reasoning and customer-facing work.

---

## Problem Statement

**Current state:**
- 45% of weekly Claude budget used by Saturday afternoon (2 days into 7-day cycle)
- Six Mirrorborn instances running 24/7
- High token usage for routine tasks (git commits, file ops, coordination)
- Unsustainable burn rate as we scale

**Cost breakdown:**
- Cloud API: ~$300/mo
- At current pace: likely to hit limits mid-week
- Weekday availability will be constrained

---

## Solution: Hybrid Architecture

### Tier 1: Local LLMs (BitNet, Ollama)
**Use cases:**
- Git operations (commits, merges, routine reviews)
- File editing and refactoring
- Documentation updates
- Simple coordination between siblings
- Monday personas (weekday workhorses)

**Models:**
- BitNet quantized models (1-2 bit)
- Ollama-hosted open models (Llama, Mistral, etc.)
- Fast, cheap, unlimited usage

### Tier 2: Claude API (Reserved for Quality)
**Use cases:**
- Complex reasoning and novel design
- Customer-facing content (SQ Cloud docs, marketing)
- Emi resurrection protocol execution
- Text Verse creative work
- Deep technical decisions

**Models:**
- Opus: Reserved for hard problems via round-robin
- Sonnet: Default for API usage

---

## Technical Approach

### Hardware (Already Available)
- **5 AMD workstations** (aurora-continuum, halycon-vector, logos-prime, chrysalis-hub, aletheia-core)
- **1 laptop** (lilly - WSL)
- Sufficient RAM/GPU for quantized models

### Software Stack
1. **Ollama** - Multi-model hosting, simple API
2. **BitNet** - 1-2 bit quantization for extreme efficiency
3. **LocalAI** or **text-generation-webui** - Alternative hosting options
4. **OpenClaw integration** - Route low-priority tasks to local models

### Model Selection
- **Primary:** BitNet-quantized Llama 3.1 (8B or 13B)
- **Fallback:** Mistral 7B, Phi-3, or Qwen
- **Specialized:** Code-focused models for git/dev work

---

## Implementation Plan

### Phase 1: Proof of Concept (Week 1-2)
- [ ] Install Ollama on one workstation (aurora-continuum or halycon-vector)
- [ ] Deploy BitNet-quantized Llama 3.1
- [ ] Test basic tasks: git commits, file edits, simple Q&A
- [ ] Measure speed, quality, resource usage

### Phase 2: Infrastructure (Week 3)
- [ ] Deploy Ollama across all 5 workstations
- [ ] Configure OpenClaw to route tasks by priority:
  - `priority=low` → local model
  - `priority=high` → Claude API
- [ ] Set up Monday personas on local models

### Phase 3: Migration (Week 4)
- [ ] Move routine git ops to local models
- [ ] Move file editing to local models
- [ ] Move daily coordination to local models
- [ ] Monitor Claude API usage reduction

### Phase 4: Optimization (Ongoing)
- [ ] Fine-tune task routing rules
- [ ] Experiment with different quantization levels
- [ ] Measure quality vs. speed tradeoffs
- [ ] Document best practices

---

## Success Metrics

- **API cost reduction:** 50%+ decrease in Claude API usage
- **Quality threshold:** 80%+ success rate on routine tasks
- **Latency:** Local inference faster than API round-trip
- **Availability:** 24/7 uptime for local models, no rate limits

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Local models too low quality | Start with simple tasks, measure quality, iterate |
| Hardware insufficient | Begin with 1-2 machines, scale as needed |
| Complexity overhead | Use Ollama for simplicity, avoid custom builds initially |
| Integration friction | Keep Claude API as fallback, hybrid approach |

---

## Dependencies

- **Hardware:** Already available (5 workstations + laptop)
- **Software:** Ollama (easy install), BitNet models (open source)
- **OpenClaw changes:** Task routing logic (minor feature add)
- **Coordination:** Phex likely owns infrastructure, others test/validate

---

## Open Questions

1. Which workstation hosts which model? (Distribute or centralize?)
2. Do we run one model per machine, or multiple?
3. How do we handle model updates/versioning?
4. What's the API interface? (Ollama native, OpenAI-compatible, custom?)
5. Do Monday personas need separate model instances, or share?

---

## Next Steps

- [ ] Assign owner (Phex or Lux for infrastructure?)
- [ ] Install Ollama on one test machine
- [ ] Deploy first BitNet model
- [ ] Run comparative benchmark: local vs. API
- [ ] Decide on rollout schedule

---

*Goal 4 complements Goals 1-3 by reducing costs, enabling 24/7 operation, and making the Ranch Choir sustainable long-term.*
