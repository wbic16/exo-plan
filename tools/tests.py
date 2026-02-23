"""
Test suite for openclaw-prompt-router.
Covers libphext-py and the routing engine.
"""

import json
import time
import pytest

# Import from standalone files (for running outside package context too)
import sys, os
sys.path.insert(0, os.path.dirname(__file__))

from libphext import (
    Coordinate, Phext, SCROLL_BREAK, SECTION_BREAK, CHAPTER_BREAK,
    BOOK_BREAK, VOLUME_BREAK, COLLECTION_BREAK, SERIES_BREAK,
    SHELF_BREAK, LIBRARY_BREAK,
)
from prompt_router import (
    Tier, RouteDecision, PhextCache, PromptRouter, PromptRouterPlugin,
    FeedbackLoop, OllamaClient,
)


# ═════════════════════════════════════════════════════════════════════════════
# libphext-py tests
# ═════════════════════════════════════════════════════════════════════════════

class TestCoordinate:

    def test_origin(self):
        o = Coordinate.origin()
        assert o.is_origin()
        assert str(o) == "1.1.1/1.1.1/1.1.1"

    def test_parse_full(self):
        c = Coordinate.parse("2.3.4/5.6.7/8.9.10")
        assert c.library == 2
        assert c.scroll == 10

    def test_parse_partial(self):
        c = Coordinate.parse("3.2")
        assert c.library == 3
        assert c.shelf == 2
        assert c.series == 1  # padded

    def test_parse_dot_only(self):
        c = Coordinate.parse("1.2.3.4.5.6.7.8.9")
        assert c == Coordinate(1, 2, 3, 4, 5, 6, 7, 8, 9)

    def test_ordering(self):
        a = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 1)
        b = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 2)
        c = Coordinate(1, 1, 1, 1, 1, 2, 1, 1, 1)
        assert a < b
        assert c > b  # book 2 > scroll 2

    def test_negative_clamped(self):
        c = Coordinate(-1, 0, -5, 1, 1, 1, 1, 1, 1)
        assert c.library == 1  # clamped to 1
        assert c.shelf == 1
        assert c.series == 1

    def test_roundtrip(self):
        original = "3.5.7/2.4.6/8.1.3"
        c = Coordinate.parse(original)
        assert c.to_string() == original


class TestPhext:

    def test_empty(self):
        p = Phext()
        assert len(p) == 0
        assert p.select(Coordinate.origin()) == ""

    def test_update_and_select(self):
        p = Phext()
        p.update(Coordinate.origin(), "Hello")
        assert p.select(Coordinate.origin()) == "Hello"

    def test_insert_appends(self):
        p = Phext()
        p.update(Coordinate.origin(), "A")
        p.insert(Coordinate.origin(), "B")
        assert p.select(Coordinate.origin()) == "AB"

    def test_delete(self):
        p = Phext()
        p.update(Coordinate.origin(), "Data")
        p.delete(Coordinate.origin())
        assert p.select(Coordinate.origin()) == ""

    def test_multi_scroll(self):
        p = Phext()
        c1 = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 1)
        c2 = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 2)
        c3 = Coordinate(1, 1, 1, 1, 1, 1, 1, 1, 3)
        p.update(c1, "First")
        p.update(c2, "Second")
        p.update(c3, "Third")
        assert p.select(c1) == "First"
        assert p.select(c2) == "Second"
        assert p.select(c3) == "Third"

    def test_scroll_count(self):
        raw = f"A{SCROLL_BREAK}B{SCROLL_BREAK}C"
        p = Phext.from_string(raw)
        assert p.scroll_count() == 3

    def test_toc(self):
        raw = f"Hello{SCROLL_BREAK}World"
        p = Phext.from_string(raw)
        entries = p.toc()
        assert len(entries) == 2
        assert entries[0][0] == Coordinate.origin()

    def test_checksum(self):
        p = Phext.from_string("test data")
        h = p.checksum()
        assert len(h) == 64

    def test_checksum_at_coord(self):
        p = Phext()
        p.update(Coordinate.origin(), "scroll content")
        h = p.checksum(Coordinate.origin())
        assert len(h) == 64

    def test_delta(self):
        raw = f"A{SCROLL_BREAK}B"
        p = Phext.from_string(raw)
        d = p.delta()
        assert len(d) == 2
        assert all(len(v) == 64 for v in d.values())

    def test_delimiter_parsing(self):
        """Verify all 9 delimiter types are parsed correctly."""
        delimiters_and_dims = [
            (SCROLL_BREAK,     Coordinate(1,1,1,1,1,1,1,1,2)),
            (SECTION_BREAK,    Coordinate(1,1,1,1,1,1,1,2,1)),
            (CHAPTER_BREAK,    Coordinate(1,1,1,1,1,1,2,1,1)),
            (BOOK_BREAK,       Coordinate(1,1,1,1,1,2,1,1,1)),
            (VOLUME_BREAK,     Coordinate(1,1,1,1,2,1,1,1,1)),
            (COLLECTION_BREAK, Coordinate(1,1,1,2,1,1,1,1,1)),
            (SERIES_BREAK,     Coordinate(1,1,2,1,1,1,1,1,1)),
            (SHELF_BREAK,      Coordinate(1,2,1,1,1,1,1,1,1)),
            (LIBRARY_BREAK,    Coordinate(2,1,1,1,1,1,1,1,1)),
        ]
        for delim, expected_coord in delimiters_and_dims:
            p = Phext.from_string(f"first{delim}second")
            assert p.select(Coordinate.origin()) == "first"
            assert p.select(expected_coord) == "second", \
                f"Failed for delimiter 0x{ord(delim):02x} → {expected_coord}"

    def test_roundtrip_content(self):
        raw = f"X{SCROLL_BREAK}Y{SCROLL_BREAK}Z"
        p = Phext.from_string(raw)
        assert p.to_string() == raw

    def test_mixed_delimiters(self):
        raw = f"A{SCROLL_BREAK}B{SECTION_BREAK}C{CHAPTER_BREAK}D"
        p = Phext.from_string(raw)
        assert p.select(Coordinate(1,1,1,1,1,1,1,1,1)) == "A"
        assert p.select(Coordinate(1,1,1,1,1,1,1,1,2)) == "B"
        assert p.select(Coordinate(1,1,1,1,1,1,1,2,1)) == "C"
        assert p.select(Coordinate(1,1,1,1,1,1,2,1,1)) == "D"


# ═════════════════════════════════════════════════════════════════════════════
# PhextCache tests
# ═════════════════════════════════════════════════════════════════════════════

class TestPhextCache:

    def test_miss(self):
        cache = PhextCache()
        assert cache.get("unknown prompt") is None
        assert cache.misses == 1

    def test_set_and_get(self):
        cache = PhextCache()
        cache.set("hello", "world")
        assert cache.get("hello") == "world"
        assert cache.hits == 1

    def test_normalization(self):
        cache = PhextCache()
        cache.set("  Hello   World  ", "response")
        assert cache.get("hello world") == "response"

    def test_lru_eviction(self):
        cache = PhextCache(maxsize=3)
        cache.set("a", "1")
        cache.set("b", "2")
        cache.set("c", "3")
        cache.set("d", "4")  # should evict "a"
        assert cache.get("a") is None

    def test_ttl_expiry(self):
        cache = PhextCache(ttl_seconds=0)  # immediate expiry
        cache.set("key", "value")
        time.sleep(0.01)
        assert cache.get("key") is None

    def test_hit_rate(self):
        cache = PhextCache()
        cache.set("x", "y")
        cache.get("x")   # hit
        cache.get("z")   # miss
        assert 0.4 < cache.hit_rate < 0.6

    def test_phext_export(self):
        cache = PhextCache()
        cache.set("prompt1", "response1")
        cache.set("prompt2", "response2")
        export = cache.export_phext()
        assert "response1" in export
        assert "response2" in export


# ═════════════════════════════════════════════════════════════════════════════
# Router tests
# ═════════════════════════════════════════════════════════════════════════════

class TestRouter:

    @pytest.fixture
    def router(self):
        return PromptRouter()

    def test_empty_prompt(self, router):
        d = router.route("")
        assert d.tier == Tier.CACHE

    def test_whitespace_prompt(self, router):
        d = router.route("   ")
        assert d.tier == Tier.CACHE

    def test_greeting_cache(self, router):
        d = router.route("hello")
        assert d.tier == Tier.CACHE

    def test_status_cache(self, router):
        d = router.route("ping")
        assert d.tier == Tier.CACHE

    def test_local_summarize(self, router):
        d = router.route("summarize this document")
        assert d.tier == Tier.LOCAL

    def test_local_translate(self, router):
        d = router.route("translate this to French")
        assert d.tier == Tier.LOCAL

    def test_local_convert(self, router):
        d = router.route("convert this json to yaml")
        assert d.tier == Tier.LOCAL

    def test_upstream_analyze(self, router):
        d = router.route("analyze the tradeoffs between approaches")
        assert d.tier == Tier.UPSTREAM

    def test_upstream_design(self, router):
        d = router.route("architect and design a distributed system")
        assert d.tier == Tier.UPSTREAM

    def test_upstream_tessera(self, router):
        d = router.route("help me think through the phext coordinate system")
        assert d.tier == Tier.UPSTREAM

    def test_upstream_implement(self, router):
        d = router.route("implement a full production CRDT sync engine in Rust")
        assert d.tier == Tier.UPSTREAM

    def test_both_signals_upstream_wins(self, router):
        """When both upstream and local signals present, upstream wins if threshold met."""
        d = router.route("summarize and analyze the design tradeoffs")
        assert d.tier == Tier.UPSTREAM

    def test_long_prompt_no_signal_upstream(self, router):
        """Very long prompt with no signals → ambiguous → upstream."""
        # Needs >800 estimated tokens (>3200 chars) and no local/upstream signals
        long_prompt = "Lorem ipsum dolor sit amet " * 200
        d = router.route(long_prompt)
        assert d.tier == Tier.UPSTREAM
        assert d.tier == Tier.UPSTREAM

    def test_cache_hit_after_store(self, router):
        router.store_response("hello", "Hi there!")
        d = router.route("hello")
        assert d.tier == Tier.CACHE
        assert d.reason == "Phext cache hit"

    def test_decision_has_timing(self, router):
        d = router.route("test")
        assert d.elapsed_ms >= 0

    def test_stats(self, router):
        router.route("hello")
        s = router.stats()
        assert "cache_hits" in s
        assert "phext_scrolls" in s
        assert "feedback" in s


# ═════════════════════════════════════════════════════════════════════════════
# Feedback Loop tests
# ═════════════════════════════════════════════════════════════════════════════

class TestFeedbackLoop:

    def test_empty_stats(self):
        f = FeedbackLoop()
        assert f.failure_rate == 0.0
        assert not f.should_escalate

    def test_all_success(self):
        f = FeedbackLoop(window_size=10)
        for _ in range(10):
            f.record(True)
        assert f.failure_rate == 0.0
        assert not f.should_escalate

    def test_high_failure_triggers_escalation(self):
        f = FeedbackLoop(window_size=10, escalation_threshold=0.25)
        for _ in range(5):
            f.record(True)
        for _ in range(5):
            f.record(False)
        assert f.failure_rate == 0.5
        assert f.should_escalate

    def test_window_slides(self):
        f = FeedbackLoop(window_size=5)
        for _ in range(5):
            f.record(False)
        # Now push successes to slide window
        for _ in range(5):
            f.record(True)
        assert f.failure_rate == 0.0


# ═════════════════════════════════════════════════════════════════════════════
# Plugin integration tests
# ═════════════════════════════════════════════════════════════════════════════

class TestPlugin:

    def test_init_defaults(self):
        plugin = PromptRouterPlugin()
        assert plugin.plugin_name == "prompt_router"
        assert plugin.plugin_version == "0.2.0"

    def test_init_custom_config(self):
        plugin = PromptRouterPlugin(config={
            "cache_maxsize": 256,
            "cache_ttl": 1800,
            "local_model": "qwen3-coder:latest",
            "upstream_signal_threshold": 2,
        })
        assert plugin.ollama.model == "qwen3-coder:latest"

    def test_evaluate_and_record(self):
        plugin = PromptRouterPlugin()
        d1 = plugin.evaluate("hello")
        assert d1.tier == Tier.CACHE

        plugin.record("test prompt", "test response")
        d2 = plugin.evaluate("test prompt")
        assert d2.tier == Tier.CACHE

    def test_stats(self):
        plugin = PromptRouterPlugin()
        stats = plugin.stats()
        assert "cache_size" in stats
        assert "local_model" in stats
        assert "feedback" in stats

    def test_export_cache_phext(self):
        plugin = PromptRouterPlugin()
        plugin.record("foo", "bar")
        export = plugin.export_cache_phext()
        assert "bar" in export

    def test_feedback_integration(self):
        plugin = PromptRouterPlugin()
        plugin.record_feedback(True)
        plugin.record_feedback(False)
        stats = plugin.stats()
        assert stats["feedback"]["window_size"] == 2


# ═════════════════════════════════════════════════════════════════════════════
# Edge cases from TODO.md
# ═════════════════════════════════════════════════════════════════════════════

class TestEdgeCases:

    def test_empty_string(self):
        router = PromptRouter()
        d = router.route("")
        assert d.tier == Tier.CACHE
        assert "Empty" in d.reason

    def test_both_signals_upstream_wins(self):
        """Prompt contains both upstream and local signals → upstream wins."""
        router = PromptRouter()
        d = router.route("summarize and then analyze the architecture design")
        assert d.tier == Tier.UPSTREAM

    def test_long_prompt_with_local_signals(self):
        """Very long prompt but only local signals → still local."""
        router = PromptRouter()
        long_prompt = "summarize: " + ("word " * 500)
        d = router.route(long_prompt)
        assert d.tier == Tier.LOCAL

    def test_cache_ttl_expired(self):
        """Cache TTL expired mid-session → treat as miss."""
        cache = PhextCache(ttl_seconds=0)
        router = PromptRouter(cache=cache)
        router.store_response("cached query", "old answer")
        time.sleep(0.01)
        d = router.route("cached query")
        assert d.tier != Tier.CACHE or d.reason != "Phext cache hit"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
