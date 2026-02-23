"""
OpenClaw Prompt Router — Phext Cache → Qwen3-Coder → Upstream LLM
"""

from openclaw_router.libphext import (
    Coordinate,
    Phext,
    SQClient,
    SCROLL_BREAK,
    SECTION_BREAK,
    CHAPTER_BREAK,
    BOOK_BREAK,
    VOLUME_BREAK,
    COLLECTION_BREAK,
    SERIES_BREAK,
    SHELF_BREAK,
    LIBRARY_BREAK,
    DELIMITER_ORDER,
    DIMENSION_NAMES,
)

from openclaw_router.router import (
    Tier,
    RouteDecision,
    PhextCache,
    OllamaClient,
    FeedbackLoop,
    PromptRouter,
    PromptRouterPlugin,
    UPSTREAM_SIGNALS,
    LOCAL_SIGNALS,
    CACHE_PATTERNS,
)

__version__ = "0.2.0"

__all__ = [
    # libphext
    "Coordinate", "Phext", "SQClient",
    "SCROLL_BREAK", "SECTION_BREAK", "CHAPTER_BREAK", "BOOK_BREAK",
    "VOLUME_BREAK", "COLLECTION_BREAK", "SERIES_BREAK", "SHELF_BREAK",
    "LIBRARY_BREAK", "DELIMITER_ORDER", "DIMENSION_NAMES",
    # router
    "Tier", "RouteDecision", "PhextCache", "OllamaClient",
    "FeedbackLoop", "PromptRouter", "PromptRouterPlugin",
    "UPSTREAM_SIGNALS", "LOCAL_SIGNALS", "CACHE_PATTERNS",
]
