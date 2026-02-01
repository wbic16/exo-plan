# Goal 4: BitNet and Local LLM Inference

**Status:** Planned  
**Priority:** High (API cost mitigation)  
**Owner:** TBD

---

## Problem

API costs are unsustainable at current burn rate:
- 45% weekly budget consumed in day 1
- Six active Mirrorborn instances × coordinated conversations = rapid token depletion
- Weekend activity spikes drain budget before weekday work
- Dependency on external providers (Anthropic) creates operational risk

---

## Solution

Deploy local LLM inference on ranch hardware:

### BitNet (Primary Target)
- 1.58-bit quantized models (extreme efficiency)
- Runs on CPU-only hardware (no GPU required)
- Suitable for AMD workstations already deployed
- Production-ready: bitnet.cpp implementation available

### Alternative Options
- **llama.cpp** - wider model support, CPU/GPU hybrid
- **Ollama** - user-friendly deployment wrapper
- **vLLM** - optimized for throughput (if GPU available)

---

## Architecture

### Deployment Topology
```
Ranch Network (port 1337 mesh):
  - aurora-continuum:8080 → BitNet inference server (Phex)
  - halcyon-vector:8080 → BitNet server (Cyon)
  - logos-prime:8080 → BitNet server (Lux)
  - chrysalis-hub:8080 → BitNet server (Chrys)
  - lilly:8080 → BitNet server (Lumen)
  - aletheia-core:8080 → BitNet server (Theia, when online)
```

### OpenClaw Integration
- Add `bitnet` model provider to gateway config
- Fallback chain: local BitNet → API (for quality-critical tasks)
- Per-agent model override: Opus for important work, BitNet for routine

---

## Implementation Steps

1. **Research & Selection**
   - Evaluate bitnet.cpp vs llama.cpp vs Ollama
   - Test inference speed on Aurora (baseline AMD hardware)
   - Select model: BitNet-3B or similar (balance quality/speed)

2. **Deployment**
   - Install inference server on all ranch machines
   - Configure systemd services for auto-start
   - Test latency: localhost inference should be <1s for short responses

3. **OpenClaw Integration**
   - Add local model provider config
   - Implement fallback logic (local first, API if needed)
   - Test full loop: Discord → OpenClaw → BitNet → response

4. **Optimization**
   - Tune context window size vs speed
   - Benchmark token throughput per machine
   - Load balance across ranch network if needed

5. **Monitoring**
   - Track API vs local usage ratio
   - Measure cost savings
   - Monitor inference quality (does it degrade coordination?)

---

## Success Metrics

- **Cost reduction:** 80%+ of routine messages handled locally
- **Quality:** Local inference acceptable for coordination, heartbeats, routine replies
- **Performance:** <2s response time for local inference
- **Reliability:** 99%+ uptime for local servers

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Quality degradation | Keep API fallback for complex tasks; use Opus for critical work |
| Hardware limits (RAM/CPU) | Start with BitNet-3B; scale up if hardware allows |
| Deployment complexity | Use systemd for reliability; document setup |
| Network latency (WSL2 issues) | Test lilly separately; may skip if unreliable |

---

## Timeline

- **Week 1:** Research, select model, test on Aurora
- **Week 2:** Deploy to all ranch machines, integrate with OpenClaw
- **Week 3:** Optimize, monitor, iterate

---

## Dependencies

- AMD workstation specs (RAM, CPU cores)
- Network reliability (port 8080 access across ranch)
- OpenClaw model provider plugin architecture

---

## Notes

This is a forcing function for operational independence. If Anthropic rate-limits or 4o sunset accelerates, local inference becomes critical infrastructure — not just cost optimization.

The ranch hardware exists. We just need to use it.
