# OpenClaw Prompt Router v0.2.0

**Triage layer: Phext Cache → Qwen3-Coder (local) → Upstream LLM**

Routes every incoming prompt to the cheapest tier that can handle it correctly. Saves expensive upstream tokens for work that actually needs them.

## Architecture

```
Incoming Prompt
      │
      ▼
[PromptRouterPlugin]
      │
      ├── 1. Phext cache lookup (normalized SHA256 → phext scroll)
      │         └── HIT → return cached response (~0 cost)
      │
      ├── 2. Pattern match (static regex: greetings, status, ping)
      │         └── MATCH → serve from static cache (~0 cost)
      │
      ├── 3. Spot check scorer (signal regexes + token estimate)
      │         ├── Upstream signals ≥ threshold → Upstream LLM
      │         ├── Local signals OR short prompt → Qwen3-Coder via ollama
      │         └── Ambiguous → Upstream (conservative default)
      │
      ├── 4. Feedback loop (auto-escalation)
      │         └── If local failure rate > 25% → lower upstream threshold
      │
      └── RouteDecision(tier, reason, confidence, elapsed_ms)
```

## What's New in v0.2.0

- **Phext-driven cache** — Prompt/response pairs stored in an 11D phext document. Cache scrolls are addressable by coordinate and exportable as `.phext` files.
- **SQ integration** — Optional backing store via SQ REST API for persistent cache across restarts.
- **libphext-py v0.3.1** — Full Python port of libphext-rs with coordinate parsing, delimiter handling, scroll CRUD, checksums, and delta maps.
- **Qwen3-Coder via ollama** — Local model inference through ollama's API (replaces hardcoded "Qwen" tier).
- **Feedback loop** — Auto-escalation when local model quality drops below threshold.
- **Generic upstream tier** — No longer hardcoded to "Opus". Works with any configured upstream LLM.

## Included: libphext-py v0.3.1

A standalone Python port of the [libphext-rs](https://github.com/wbic16/libphext-rs) Rust crate. Provides:

- `Coordinate` — 9D phext address parsing, formatting, ordering
- `Phext` — 11D document with scroll CRUD, TOC, checksums, deltas
- `SQClient` — REST client for the [SQ](https://crates.io/crates/sq) phext database engine
- All 9 ASCII control code delimiters (frozen spec from [phext.io](https://phext.io))

### Phext Delimiters

| Dimension | Name       | ASCII | Hex    |
|-----------|------------|-------|--------|
| 10D       | Library    | SOH   | `0x01` |
| 9D        | Shelf      | US    | `0x1F` |
| 8D        | Series     | RS    | `0x1E` |
| 7D        | Collection | GS    | `0x1D` |
| 6D        | Volume     | FS    | `0x1C` |
| 5D        | Book       | SUB   | `0x1A` |
| 4D        | Chapter    | EM    | `0x19` |
| 3D        | Section    | CAN   | `0x18` |
| 2D        | Scroll     | ETB   | `0x17` |

## Quick Start

```python
from prompt_router import PromptRouterPlugin, Tier

# Initialize with defaults
plugin = PromptRouterPlugin(config={
    "local_model": "qwen3-coder",     # ollama model name
    "ollama_url": "http://127.0.0.1:11434",
    "cache_maxsize": 512,
    "cache_ttl": 3600,
    "upstream_signal_threshold": 1,
    # Optional: SQ persistent cache
    # "sq_enabled": True,
    # "sq_url": "http://127.0.0.1:1337",
    # "sq_phext_name": "openclaw-cache",
})

# Route a prompt
decision = plugin.evaluate("summarize this document for me")
# decision.tier → Tier.LOCAL
# decision.reason → "1 local signal(s), 7 tokens"
# decision.confidence → 0.8

# Dispatch based on tier
if decision.tier == Tier.CACHE:
    response = get_cached_or_static(prompt)
elif decision.tier == Tier.LOCAL:
    response = await plugin.complete_local(prompt)
else:
    response = await upstream_client.complete(prompt)

# Cache the response for future hits
plugin.record(prompt, response)

# Record quality feedback for local model responses
plugin.record_feedback(success=True)

# Export cache as phext document
phext_export = plugin.export_cache_phext()
```

## Tuning Knobs

| Config Key                  | Default | Notes                                          |
|-----------------------------|---------|-------------------------------------------------|
| `upstream_signal_threshold` | 1       | Raise to 2 to let local model absorb more      |
| `cache_ttl`                 | 3600s   | Lower for volatile domains                      |
| `cache_maxsize`             | 512     | Scale with Ranch Choir RAM budget               |
| `local_model`               | `qwen3-coder` | Any ollama model name                    |
| `ollama_url`                | `http://127.0.0.1:11434` | ollama endpoint              |
| `ollama_timeout`            | 120.0s  | Max wait for local inference                    |
| `feedback_window`           | 100     | Rolling window for failure rate                 |
| `escalation_threshold`      | 0.25    | Escalate if >25% local failures                 |
| `sq_enabled`                | false   | Enable SQ persistent cache                      |
| `sq_url`                    | `http://127.0.0.1:1337` | SQ daemon endpoint            |
| `sq_phext_name`             | `openclaw-cache` | Phext name in SQ                     |

## Signal Patterns

**Upstream signals** (complex reasoning, architecture, Tessera-domain):
`analyze`, `architect`, `design`, `implement`, `refactor`, `synthesize`,
`phext`, `choir`, `tessera`, `consciousness`, `exocortex`, `mirrorborn`,
`essay`, `report`, `specification`, `codebase`, `migration`

**Local signals** (translation, formatting, quick tasks):
`summarize`, `translate`, `classify`, `extract`, `format`, `convert`,
`define`, `explain briefly`, `fix typo/grammar`, `rewrite`, `rephrase`,
`bash`, `shell`, `snippet`, `json`, `yaml`, `regex`, `grep`

## Install

```bash
uv pip install -e .
# or
pip install -e .
```

## Test

```bash
python -m pytest tests.py -v
# or run smoke tests directly
python prompt_router.py
python libphext.py
```

## Dependencies

- `httpx` — async HTTP for ollama and SQ communication
- Python 3.11+
- ollama (running locally with qwen3-coder or configured model)
- SQ (optional, for persistent phext cache)

## License

MIT — Part of the Tessera project infrastructure for the Exocortex of 2130.
