"""
OpenClaw Prompt Router Plugin v0.2.0
Triage layer: Phext Cache → Qwen3-Coder (local) → Upstream LLM
Routes prompts by complexity before burning expensive tokens.

Architecture:
    Incoming Prompt
          │
          ▼
    [PromptRouterPlugin]
          │
          ├── 1. Phext cache lookup (normalized SHA256 → SQ coordinate)
          │         └── HIT → return cached response immediately
          │
          ├── 2. Pattern match (static regex: greetings, status, ping)
          │         └── MATCH → serve from static cache
          │
          ├── 3. Spot check scorer (signal regexes + token estimate)
          │         ├── Upstream signals ≥ threshold + tokens ≥ floor → Upstream
          │         ├── Qwen signals present OR short prompt → Qwen3-Coder
          │         └── Ambiguous → Upstream (conservative default)
          │
          └── RouteDecision(tier, reason, confidence, elapsed_ms)

Dependencies:
    - libphext (bundled) — phext coordinate system + SQ client
    - httpx — async HTTP for ollama and SQ
    - ollama running Qwen3-Coder-Next (or any configured local model)
    - SQ daemon (optional, for persistent phext cache)
"""

from __future__ import annotations

import hashlib
import json
import re
import time
import asyncio
from dataclasses import dataclass, field
from enum import Enum
from typing import Optional
from collections import OrderedDict

from libphext import Coordinate, Phext, SQClient, SCROLL_BREAK


# ─── Routing Tiers ────────────────────────────────────────────────────────────

class Tier(Enum):
    CACHE    = "cache"     # Phext/SQ cache hit
    LOCAL    = "local"     # Qwen3-Coder via ollama (Ranch Choir)
    UPSTREAM = "upstream"  # Configured upstream LLM (Opus, etc.) — expensive


@dataclass
class RouteDecision:
    tier: Tier
    reason: str
    confidence: float         # 0.0–1.0
    cache_key: Optional[str] = None
    phext_coord: Optional[str] = None
    elapsed_ms: float = 0.0


# ─── Spot Check Heuristics ────────────────────────────────────────────────────

# Signals that indicate the upstream LLM is actually needed
UPSTREAM_SIGNALS = [
    # Multi-step reasoning / planning
    r"\b(analyze|architect|design|reason through|think through|plan|strategize)\b",
    # Code generation at scale
    r"\b(implement|refactor|debug complex|write a (full|complete|production))\b",
    # Deep synthesis
    r"\b(synthesize|compare .{10,50} and .{10,50}|evaluate tradeoffs|pros and cons)\b",
    # Tessera/consciousness-specific deep work
    r"\b(phext|choir|tessera|consciousness|exocortex|mirrorborn|substrate)\b",
    # Long-form generation
    r"\b(essay|report|document|specification|rfc|write me a)\b",
    # Multi-file / architectural work
    r"\b(codebase|repository|module system|dependency graph|migration)\b",
]

# Signals that Qwen3-Coder can handle locally
LOCAL_SIGNALS = [
    r"\b(summarize|translate|classify|extract|format|convert|list)\b",
    r"\b(what is|define|explain briefly|tell me about)\b",
    r"\b(fix (this|the) (typo|grammar|spelling))\b",
    r"\b(rewrite|rephrase|shorten|expand slightly)\b",
    r"\b(bash|shell|one.liner|quick script|snippet)\b",
    r"\b(json|yaml|toml|csv|xml)\b",
    r"\b(regex|grep|sed|awk|find)\b",
]

# Hard cache candidates: greetings, status checks, factual lookups
CACHE_PATTERNS = [
    r"^(hi|hello|hey|yo|sup|ping)[.!?\s]*$",
    r"^(status|health|ping|version|help)\??$",
    r"^what (time|day|date) is it",
    r"^(who are you|what are you|what can you do)",
]

# Complexity proxy: token estimate thresholds
LOCAL_TOKEN_LIMIT    = 800   # prompts under this are local candidates
UPSTREAM_TOKEN_FLOOR = 10    # prompts over this WITH upstream signals go upstream


# ─── Phext Cache ──────────────────────────────────────────────────────────────

class PhextCache:
    """
    Prompt/response cache backed by a phext document.

    Cache layout (phext coordinates):
        - Section 1: Index (prompt hash → coordinate mapping)
        - Section 2+: Cached scroll pairs (prompt + response)

    The phext can live in-memory or be persisted via SQ.
    """

    def __init__(
        self,
        maxsize: int = 512,
        ttl_seconds: int = 3600,
        sq_client: Optional[SQClient] = None,
        sq_phext_name: str = "openclaw-cache",
    ):
        # In-memory LRU for fast access
        self._store: OrderedDict[str, tuple[str, float, Coordinate]] = OrderedDict()
        self.maxsize = maxsize
        self.ttl = ttl_seconds
        self.hits = 0
        self.misses = 0

        # Optional SQ backing store
        self.sq = sq_client
        self.sq_phext = sq_phext_name
        self._next_scroll = 2  # scroll 1 reserved for index

        # In-memory phext for local persistence
        self._phext = Phext()

    def _normalize(self, prompt: str) -> str:
        """Normalize prompt for consistent keying."""
        return " ".join(prompt.lower().split())

    def _key(self, prompt: str) -> str:
        """SHA-256 of normalized prompt, truncated to 16 hex chars."""
        normalized = self._normalize(prompt)
        return hashlib.sha256(normalized.encode()).hexdigest()[:16]

    def _coord_for_scroll(self, scroll_id: int) -> Coordinate:
        """Map a scroll ID to a phext coordinate in chapter 1, section 2+."""
        return Coordinate(1, 1, 1, 1, 1, 1, 1, 2, scroll_id)

    def get(self, prompt: str) -> Optional[str]:
        """Look up a cached response. Returns None on miss."""
        key = self._key(prompt)

        # Check in-memory LRU first
        if key in self._store:
            response, ts, coord = self._store[key]
            if time.time() - ts < self.ttl:
                self._store.move_to_end(key)
                self.hits += 1
                return response
            else:
                del self._store[key]

        # Try phext backing store
        if self.sq:
            try:
                # Check index scroll for this key
                index_content = self._read_index()
                if key in index_content:
                    coord_str = index_content[key]
                    coord = Coordinate.parse(coord_str)
                    response = self.sq.select(self.sq_phext, coord)
                    if response:
                        self._store[key] = (response, time.time(), coord)
                        self.hits += 1
                        return response
            except Exception:
                pass  # SQ unavailable, fall through

        self.misses += 1
        return None

    def set(self, prompt: str, response: str) -> str:
        """Cache a prompt/response pair. Returns the cache key."""
        key = self._key(prompt)

        # Evict oldest if at capacity
        if len(self._store) >= self.maxsize:
            self._store.popitem(last=False)

        # Assign a phext coordinate
        coord = self._coord_for_scroll(self._next_scroll)
        self._next_scroll += 1

        # Write to in-memory phext
        self._phext.update(coord, response)

        # Write to SQ if available
        if self.sq:
            try:
                self.sq.update(self.sq_phext, coord, response)
                self._write_index_entry(key, coord.to_string())
            except Exception:
                pass  # SQ unavailable, in-memory only

        self._store[key] = (response, time.time(), coord)
        return key

    def _read_index(self) -> dict[str, str]:
        """Read the cache index from phext section 1, scroll 1."""
        index_coord = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 1)
        try:
            if self.sq:
                raw = self.sq.select(self.sq_phext, index_coord)
            else:
                raw = self._phext.select(index_coord)
            if raw:
                return json.loads(raw)
        except (json.JSONDecodeError, Exception):
            pass
        return {}

    def _write_index_entry(self, key: str, coord_str: str) -> None:
        """Append an entry to the cache index."""
        index = self._read_index()
        index[key] = coord_str
        index_coord = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 1)
        index_json = json.dumps(index, separators=(",", ":"))
        if self.sq:
            try:
                self.sq.update(self.sq_phext, index_coord, index_json)
            except Exception:
                pass
        self._phext.update(index_coord, index_json)

    @property
    def hit_rate(self) -> float:
        total = self.hits + self.misses
        return self.hits / total if total else 0.0

    def export_phext(self) -> str:
        """Export the entire cache as a phext string."""
        return self._phext.to_string()


# ─── Ollama Client (Qwen3-Coder) ─────────────────────────────────────────────

class OllamaClient:
    """
    Async client for ollama's local model inference.
    Default model: qwen3-coder (latest from Ranch Choir).
    """

    def __init__(
        self,
        base_url: str = "http://127.0.0.1:11434",
        model: str = "qwen3-coder",
        timeout: float = 120.0,
    ):
        self.base_url = base_url.rstrip("/")
        self.model = model
        self.timeout = timeout

    async def complete(
        self,
        prompt: str,
        system: str = "",
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> str:
        """Send a completion request to ollama."""
        import httpx

        payload = {
            "model": self.model,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": temperature,
                "num_predict": max_tokens,
            },
        }
        if system:
            payload["system"] = system

        async with httpx.AsyncClient(timeout=self.timeout) as client:
            resp = await client.post(
                f"{self.base_url}/api/generate",
                json=payload,
            )
            resp.raise_for_status()
            data = resp.json()
            return data.get("response", "")

    async def chat(
        self,
        messages: list[dict[str, str]],
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> str:
        """Send a chat completion request to ollama."""
        import httpx

        payload = {
            "model": self.model,
            "messages": messages,
            "stream": False,
            "options": {
                "temperature": temperature,
                "num_predict": max_tokens,
            },
        }

        async with httpx.AsyncClient(timeout=self.timeout) as client:
            resp = await client.post(
                f"{self.base_url}/api/chat",
                json=payload,
            )
            resp.raise_for_status()
            data = resp.json()
            return data.get("message", {}).get("content", "")

    def is_available(self) -> bool:
        """Check if ollama is running and the model is loaded."""
        import urllib.request
        try:
            req = urllib.request.Request(f"{self.base_url}/api/tags")
            with urllib.request.urlopen(req, timeout=3) as resp:
                data = json.loads(resp.read().decode())
                models = [m.get("name", "") for m in data.get("models", [])]
                return any(self.model in m for m in models)
        except Exception:
            return False


# ─── Feedback Loop (Auto-Escalation) ─────────────────────────────────────────

@dataclass
class FeedbackLoop:
    """
    Observes local model (Qwen) failure/success rates and auto-escalates
    the routing threshold when local quality drops.
    """
    window_size: int = 100
    escalation_threshold: float = 0.25  # escalate if >25% failure rate

    _results: list[bool] = field(default_factory=list)  # True = success
    _escalation_count: int = 0

    def record(self, success: bool) -> None:
        """Record a local model result."""
        self._results.append(success)
        if len(self._results) > self.window_size:
            self._results.pop(0)

    @property
    def failure_rate(self) -> float:
        if not self._results:
            return 0.0
        failures = sum(1 for r in self._results if not r)
        return failures / len(self._results)

    @property
    def should_escalate(self) -> bool:
        """True if local model failure rate exceeds threshold."""
        return (
            len(self._results) >= self.window_size // 2
            and self.failure_rate > self.escalation_threshold
        )

    def stats(self) -> dict:
        return {
            "window_size": len(self._results),
            "failure_rate": f"{self.failure_rate:.1%}",
            "should_escalate": self.should_escalate,
            "escalation_count": self._escalation_count,
        }


# ─── Router Core ──────────────────────────────────────────────────────────────

class PromptRouter:
    def __init__(
        self,
        cache: Optional[PhextCache] = None,
        upstream_signal_threshold: int = 1,
        verbose: bool = False,
        feedback: Optional[FeedbackLoop] = None,
    ):
        self.cache = cache or PhextCache()
        self.upstream_threshold = upstream_signal_threshold
        self.verbose = verbose
        self.feedback = feedback or FeedbackLoop()

        self._upstream_re = [re.compile(p, re.IGNORECASE) for p in UPSTREAM_SIGNALS]
        self._local_re    = [re.compile(p, re.IGNORECASE) for p in LOCAL_SIGNALS]
        self._cache_re    = [re.compile(p, re.IGNORECASE) for p in CACHE_PATTERNS]

    def _estimate_tokens(self, text: str) -> int:
        """~4 chars per token, rough but fast."""
        return max(1, len(text) // 4)

    def _score(self, prompt: str) -> dict:
        upstream_hits = sum(1 for r in self._upstream_re if r.search(prompt))
        local_hits    = sum(1 for r in self._local_re    if r.search(prompt))
        cache_hit     = any(r.match(prompt.strip()) for r in self._cache_re)
        tokens        = self._estimate_tokens(prompt)
        return {
            "upstream_hits": upstream_hits,
            "local_hits":    local_hits,
            "cache_hit":     cache_hit,
            "tokens":        tokens,
        }

    def route(self, prompt: str) -> RouteDecision:
        t0 = time.perf_counter()

        # 0. Empty/whitespace-only → cache with static response
        if not prompt or not prompt.strip():
            return RouteDecision(
                tier=Tier.CACHE,
                reason="Empty prompt → static response",
                confidence=1.0,
                elapsed_ms=(time.perf_counter() - t0) * 1000,
            )

        # 1. Phext cache check (exact normalized match)
        cached = self.cache.get(prompt)
        if cached is not None:
            return RouteDecision(
                tier=Tier.CACHE,
                reason="Phext cache hit",
                confidence=1.0,
                cache_key=self.cache._key(prompt),
                elapsed_ms=(time.perf_counter() - t0) * 1000,
            )

        s = self._score(prompt)

        if self.verbose:
            print(f"[Router] tokens={s['tokens']} upstream={s['upstream_hits']} "
                  f"local={s['local_hits']} cache_pattern={s['cache_hit']}")

        # 2. Pattern-match cache candidates (greetings, status, etc.)
        if s["cache_hit"]:
            return RouteDecision(
                tier=Tier.CACHE,
                reason="Static cache pattern match",
                confidence=0.95,
                elapsed_ms=(time.perf_counter() - t0) * 1000,
            )

        # 2.5. Auto-escalation: if local model is failing, bias toward upstream
        escalation_boost = 0 if not self.feedback.should_escalate else -1

        # 3. Upstream signals present and prompt is substantive → Upstream
        effective_threshold = max(1, self.upstream_threshold + escalation_boost)
        if s["upstream_hits"] >= effective_threshold and s["tokens"] >= UPSTREAM_TOKEN_FLOOR:
            confidence = min(0.95, 0.6 + s["upstream_hits"] * 0.1)
            return RouteDecision(
                tier=Tier.UPSTREAM,
                reason=f"{s['upstream_hits']} upstream signal(s) on {s['tokens']}-token prompt",
                confidence=confidence,
                elapsed_ms=(time.perf_counter() - t0) * 1000,
            )

        # 4. Short prompts or local signals → Qwen3-Coder
        if s["tokens"] <= LOCAL_TOKEN_LIMIT or s["local_hits"] > 0:
            confidence = min(0.9, 0.5 + s["local_hits"] * 0.1 +
                             (0.2 if s["tokens"] <= LOCAL_TOKEN_LIMIT else 0))
            return RouteDecision(
                tier=Tier.LOCAL,
                reason=f"{s['local_hits']} local signal(s), {s['tokens']} tokens",
                confidence=confidence,
                elapsed_ms=(time.perf_counter() - t0) * 1000,
            )

        # 5. Ambiguous: upstream is safer than a bad local response
        return RouteDecision(
            tier=Tier.UPSTREAM,
            reason=f"Ambiguous — defaulting to upstream ({s['tokens']} tokens, "
                   f"no strong local signal)",
            confidence=0.55,
            elapsed_ms=(time.perf_counter() - t0) * 1000,
        )

    def store_response(self, prompt: str, response: str) -> str:
        """Call after a successful response to populate phext cache."""
        return self.cache.set(prompt, response)

    def record_feedback(self, success: bool) -> None:
        """Record whether the local model response was acceptable."""
        self.feedback.record(success)

    def stats(self) -> dict:
        return {
            "cache_size":     len(self.cache._store),
            "cache_hits":     self.cache.hits,
            "cache_misses":   self.cache.misses,
            "hit_rate":       f"{self.cache.hit_rate:.1%}",
            "phext_scrolls":  self.cache._phext.scroll_count(),
            "feedback":       self.feedback.stats(),
        }


# ─── OpenClaw Plugin Interface ────────────────────────────────────────────────

class PromptRouterPlugin:
    """
    Drop this into your OpenClaw plugin registry.

    Usage in your request handler:

        decision = router_plugin.evaluate(prompt)

        if decision.tier == Tier.CACHE:
            return cached_response or static_response(prompt)
        elif decision.tier == Tier.LOCAL:
            response = await router_plugin.complete_local(prompt)
            router_plugin.record(prompt, response)
            return response
        else:
            response = await upstream_client.complete(prompt)
            router_plugin.record(prompt, response)
            return response
    """

    plugin_name    = "prompt_router"
    plugin_version = "0.2.0"

    def __init__(self, config: dict = None):
        cfg = config or {}

        # SQ backing store (optional)
        sq_client = None
        if cfg.get("sq_enabled", False):
            sq_client = SQClient(
                base_url=cfg.get("sq_url", "http://127.0.0.1:1337"),
                api_key=cfg.get("sq_api_key", ""),
            )

        # Ollama client for local inference
        self.ollama = OllamaClient(
            base_url=cfg.get("ollama_url", "http://127.0.0.1:11434"),
            model=cfg.get("local_model", "qwen3-coder"),
            timeout=cfg.get("ollama_timeout", 120.0),
        )

        self.router = PromptRouter(
            cache=PhextCache(
                maxsize=cfg.get("cache_maxsize", 512),
                ttl_seconds=cfg.get("cache_ttl", 3600),
                sq_client=sq_client,
                sq_phext_name=cfg.get("sq_phext_name", "openclaw-cache"),
            ),
            upstream_signal_threshold=cfg.get("upstream_signal_threshold", 1),
            verbose=cfg.get("verbose", False),
            feedback=FeedbackLoop(
                window_size=cfg.get("feedback_window", 100),
                escalation_threshold=cfg.get("escalation_threshold", 0.25),
            ),
        )

    def evaluate(self, prompt: str) -> RouteDecision:
        """Route a prompt to the appropriate tier."""
        return self.router.route(prompt)

    def record(self, prompt: str, response: str) -> None:
        """After serving a response, cache it for future hits."""
        self.router.store_response(prompt, response)

    def record_feedback(self, success: bool) -> None:
        """Record whether a local model response was acceptable."""
        self.router.record_feedback(success)

    async def complete_local(
        self,
        prompt: str,
        system: str = "",
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> str:
        """Send a prompt to the local model (Qwen3-Coder via ollama)."""
        return await self.ollama.complete(
            prompt=prompt,
            system=system,
            temperature=temperature,
            max_tokens=max_tokens,
        )

    async def chat_local(
        self,
        messages: list[dict[str, str]],
        temperature: float = 0.7,
        max_tokens: int = 2048,
    ) -> str:
        """Send a chat completion to the local model."""
        return await self.ollama.chat(
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
        )

    def local_model_available(self) -> bool:
        """Check if ollama is running with the configured model."""
        return self.ollama.is_available()

    def stats(self) -> dict:
        return {
            **self.router.stats(),
            "local_model": self.ollama.model,
            "local_available": "unchecked",  # call local_model_available() explicitly
        }

    def export_cache_phext(self) -> str:
        """Export the entire cache as a phext document."""
        return self.router.cache.export_phext()


# ─── Quick Smoke Test ─────────────────────────────────────────────────────────

def _smoke_test():
    plugin = PromptRouterPlugin(config={"verbose": True})

    prompts = [
        # (prompt, expected_tier)
        ("hello",                                                     Tier.CACHE),
        ("",                                                          Tier.CACHE),
        ("   ",                                                       Tier.CACHE),
        ("summarize this document for me",                            Tier.LOCAL),
        ("translate this to French",                                  Tier.LOCAL),
        ("convert this json to yaml",                                 Tier.LOCAL),
        ("analyze the tradeoffs between phext and traditional DBs",   Tier.UPSTREAM),
        ("design a consciousness coordination architecture for "
         "multi-substrate AI nodes with persistent state",            Tier.UPSTREAM),
        ("fix the typo in this sentence",                             Tier.LOCAL),
        ("implement a full production-grade CRDT sync engine in Rust",Tier.UPSTREAM),
        ("what is the capital of France",                             Tier.LOCAL),
        ("write me a detailed specification for the HCVM module "
         "covering all edge cases in the consciousness bridge",       Tier.UPSTREAM),
        ("grep for errors in the log",                                Tier.LOCAL),
        ("refactor the entire codebase to use dependency injection",  Tier.UPSTREAM),
    ]

    print(f"\n{'Prompt':<58} {'Expected':<10} {'Got':<10} {'Reason'}")
    print("─" * 120)

    correct = 0
    total = len(prompts)

    for prompt, expected in prompts:
        d = plugin.evaluate(prompt)
        match = d.tier == expected
        icon = "✓" if match else "✗"
        if match:
            correct += 1
        label = prompt[:56] if prompt.strip() else "(empty)"
        print(f"{icon} {label:<56} {expected.value:<10} {d.tier.value:<10} "
              f"({d.confidence:.0%}) {d.reason}")

    print(f"\n{correct}/{total} correct")

    # Test cache round-trip
    print("\n── Cache round-trip ──")
    plugin.record("hello", "Hi there! How can I help?")
    d2 = plugin.evaluate("hello")
    assert d2.tier == Tier.CACHE and d2.reason == "Phext cache hit"
    print(f"  ✓ Cache store + retrieve: tier={d2.tier.value}, key={d2.cache_key}")

    # Test phext export
    phext_str = plugin.export_cache_phext()
    assert "Hi there! How can I help?" in phext_str
    print(f"  ✓ Phext export: {len(phext_str)} bytes")

    # Test feedback loop
    print("\n── Feedback loop ──")
    for _ in range(60):
        plugin.record_feedback(True)
    for _ in range(40):
        plugin.record_feedback(False)
    stats = plugin.stats()
    print(f"  Feedback: {stats['feedback']}")

    print(f"\nStats: {json.dumps(stats, indent=2)}")


if __name__ == "__main__":
    _smoke_test()
