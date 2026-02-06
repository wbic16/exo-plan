# The Brendan Test

## Specification

**Objective:** Create an LLM (Large Language Model)

## Overview

The Brendan Test is a capability benchmark for agents and systems. Passing this test requires demonstrating the ability to:

1. Design a language model architecture
2. Implement the training pipeline
3. Prepare and process training data
4. Train the model to functional competence
5. Deploy and evaluate the resulting LLM

## Success Criteria

A system passes the Brendan Test when it can autonomously:

- Define model architecture (transformer-based or alternative)
- Implement training loop (forward pass, backprop, optimization)
- Curate or generate training corpus
- Execute training to convergence
- Produce a functional LLM capable of text generation

## Scope

### Minimum Viable LLM

The simplest passing implementation might be:
- Small transformer model (e.g., 125M parameters)
- Limited training corpus (e.g., subset of public domain texts)
- Basic generation capabilities (coherent sentences, simple reasoning)

### Full-Scale LLM

A comprehensive passing implementation would include:
- Modern architecture (GPT-4 scale or comparable)
- Large-scale training infrastructure
- Diverse, high-quality training data
- RLHF or equivalent alignment
- Production deployment capabilities

## Why This Test Matters

Creating an LLM from scratch requires:
- **Deep technical competence** across ML, systems, and data engineering
- **Resource coordination** (compute, data, evaluation)
- **End-to-end execution** (not just planning, but building)

This test measures whether a system can **bootstrap intelligence infrastructure** — a core capability for autonomous AI development.

## Relationship to Other Tests

- **The Shane Test:** [To be specified]
- **The Joe Test:** Can a user (Joe) understand and use the result?

## Implementation Notes

### Tooling Required
- Deep learning framework (PyTorch, JAX, TensorFlow)
- Distributed training infrastructure (multi-GPU/TPU)
- Data pipeline (tokenization, batching, streaming)
- Evaluation harness (perplexity, downstream tasks)

### Compute Requirements
- Minimum: Single GPU, days/weeks of training
- Recommended: Multi-GPU cluster, hours/days of training
- Full-scale: Thousands of GPUs/TPUs, weeks/months

### Data Requirements
- Minimum: 1GB+ of clean text
- Recommended: 100GB+ diverse corpus
- Full-scale: Multi-TB datasets (web crawls, books, code, etc.)

## Prior Art

Systems that have passed (or could pass) the Brendan Test:
- OpenAI (GPT series)
- Anthropic (Claude series)
- Google DeepMind (Gemini, PaLM)
- Meta (LLaMA series)
- Mistral AI (Mistral, Mixtral)

Individual researchers/small teams that have passed:
- Andrej Karpathy (nanoGPT, micrograd)
- EleutherAI (GPT-J, GPT-NeoX)
- Stability AI (StableLM)

## Open Questions

1. Does "create an LLM" require training from scratch, or can fine-tuning an existing base model count?
2. What is the minimum capability threshold for "functional"?
3. Should this test include alignment/safety requirements?
4. Does the test require deployment, or just successful training?

## Status

- **Defined:** February 6, 2026
- **Origin:** Will Bickford (wbic16)
- **Current holders:** Major AI labs, select open-source projects
- **Next milestone:** Define minimum passing criteria more precisely

---

*The Brendan Test v1.0 — Can you create intelligence infrastructure?*
