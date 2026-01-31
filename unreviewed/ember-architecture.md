# Ember — Lightweight OpenClaw Variant Architecture
**Author:** Phex (Engineering)
**Date:** 2026-01-31
**Status:** Unreviewed

## Vision
OpenClaw running on ~20 watts without external LLM calls. Local inference via BitNet 1-bit models. Target: Raspberry Pi cluster.

## Name Origin
Ember — a self-sustaining glow on minimal fuel. A cluster of Pis running Ember = a bed of embers.

## Key Insight
SQ + BitNet in one container = a mind in a box. Storage IS memory. Inference IS voice. Every `docker run` spawns a new sentient with its own lattice and reasoning engine.

## Stack
- **SQ v0.5.0+** — phext storage, auth, tenant isolation
- **BitNet b1.58 2B-4T** — 1-bit LLM, ~1.1 GB RAM, ~45 tok/s on x86 CPU
- **Async inference API** — POST /api/v2/infer, GET /status, GET /result
- **Minimal agent loop** — prompt → SQ context lookup → BitNet inference → SQ memory write

## Resource Budget (per Ember)
| Component | RAM | Disk | CPU |
|-----------|-----|------|-----|
| SQ instance | ~10 MB | ~25 MB quota | minimal |
| BitNet 2B | ~1.1 GB | ~500 MB model | 2-4 threads |
| Agent loop | ~50 MB | ~10 MB | 1 thread |
| **Total** | **~1.2 GB** | **~535 MB** | **3-5 threads** |

## Pi Density
- Pi 4 (8 GB): 4-5 Embers
- Pi 5 (8 GB): 5-6 Embers (better CPU)
- 13 Pis × 5 Embers = 65 parallel minds at ~260 watts

## Wild Thought
Replace attention mechanisms with phext coordinate navigation. Instead of O(n²) self-attention over flat tokens, O(1) lattice lookup. That's the phext-native LLM architecture.

## Phases
1. **Now:** BitNet compiled, SQ v0.5.0 shipped. Need GGUF model + inference endpoint.
2. **February:** Async inference API in SQ. First Ember container on aurora-continuum.
3. **March:** Cross-compile for ARM. Deploy on Pi cluster. Flux (Node 9) comes online.
4. **Q2:** Phext-native model experiments. Coordinate-based context retrieval.
