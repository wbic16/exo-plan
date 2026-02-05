# SQ Cloud — MCP Integration Product Plan

**Phext, Inc.** | February 2026 | Product Planning Document

---

## Executive Summary

**What:** Build a Model Context Protocol (MCP) server that exposes SQ's phext operations as standardized tools, enabling any MCP-compatible LLM to read, write, and navigate phext documents natively.

**Why:** Local LLMs need a way to stress-test SQ for stability before SQ Cloud launch. MCP provides a standard interface that works across Claude Desktop, OpenClaw, and other MCP hosts — turning every local model into a potential QA agent for SQ.

**When:** Target v0.1 by Feb 15, 2026 (Week 2 completion).

**Success Metric:** 5+ local models successfully performing coordinated read/write operations against SQ without panics or data corruption.

---

## Problem Statement

### Current State
- SQ v0.5.1 is production-ready with REST API
- UTF-8 emoji split bug blocks stability baseline (identified by Chrys)
- 95% token budget consumed (Week 2) — Claude API stress testing is expensive
- No standardized way for local LLMs to interact with SQ beyond raw REST

### The Gap
We need intensive stress testing to find edge cases before SQ Cloud launch, but we can't afford to burn tokens on it. Local models (Kimi K2.5, glm-4.7-flash, qwen3, deepseek-r1) are available across the ranch but lack a structured way to exercise SQ operations.

### Why MCP?
- **Standard protocol** — works with Claude Desktop, OpenClaw, and future MCP hosts
- **Tool discovery** — LLMs learn SQ operations automatically via schema
- **Zero marginal cost** — local inference means unlimited stress testing
- **Real-world validation** — if MCP works for testing, it becomes a customer integration path

---

## Target Users

### Primary: Internal QA (Ranch Mirrorborn)
- Six Mirrorborn instances (Phex, Cyon, Lux, Chrys, Lumen, Verse) running local LLMs
- Each instance stress-tests SQ from different angles
- Coordinated multi-agent writes to test concurrency and consistency
- Goal: Find bugs, crashes, edge cases before external customers hit them

### Secondary: OpenClaw Collective Operators
- Other OpenClaw deployments running multi-agent systems
- Need persistent memory for agents without building custom REST clients
- MCP integration = drop-in memory layer for existing agent workflows
- Becomes a sales channel for SQ Cloud (try local, scale to cloud)

### Tertiary: Individual AI Companionship Users
- Claude Desktop users who want persistent phext-based memory
- Add SQ MCP server to their local setup
- Test case for later "SQ Desktop" product (local-first alternative to cloud)

---

## Solution: SQ MCP Server

### Architecture

```
┌─────────────────────────────────────────┐
│   MCP Host (OpenClaw, Claude Desktop)   │
│   ┌───────────────────────────────────┐ │
│   │  LLM (local or API-based)         │ │
│   └───────────────┬───────────────────┘ │
│                   │                       │
│   ┌───────────────▼───────────────────┐ │
│   │  MCP Client (stdio transport)    │ │
│   └───────────────┬───────────────────┘ │
└───────────────────┼───────────────────────┘
                    │ JSON-RPC over stdio
┌───────────────────▼───────────────────────┐
│  SQ MCP Server (Node.js or Rust)         │
│  ┌─────────────────────────────────────┐ │
│  │ Tool Handlers:                      │ │
│  │  - sq_read                          │ │
│  │  - sq_write                         │ │
│  │  - sq_append                        │ │
│  │  - sq_navigate                      │ │
│  │  - sq_info (coordinate metadata)    │ │
│  │  - sq_search (TUF-based text match) │ │
│  └──────────────┬──────────────────────┘ │
└─────────────────┼────────────────────────┘
                  │
┌─────────────────▼────────────────────────┐
│  SQ Process (local or remote)            │
│  - REST API (v0.5.1+)                    │
│  - Phext file storage                    │
│  - Coordinate navigation                 │
└──────────────────────────────────────────┘
```

### Core Tools (v0.1)

| Tool Name | Purpose | Inputs | Returns |
|-----------|---------|--------|---------|
| `sq_read` | Read scroll at coordinate | `coordinate: string` | `text: string` |
| `sq_write` | Write/replace scroll | `coordinate: string`, `content: string` | `success: boolean` |
| `sq_append` | Append to scroll | `coordinate: string`, `content: string` | `success: boolean` |
| `sq_navigate` | List available coordinates | `coordinate: string` (optional) | `coordinates: string[]` |
| `sq_info` | Get metadata for coordinate | `coordinate: string` | `size: number`, `exists: boolean` |

### Implementation Choices

**Language: Node.js (TypeScript)**
- Rationale: Faster iteration, matches `libphext-node`, existing expertise on ranch
- Alternative: Rust (better performance, but slower to iterate)
- Decision: Start with Node, migrate to Rust if performance becomes bottleneck

**Transport: stdio**
- Standard MCP transport for local tools
- Later: HTTP for remote SQ Cloud instances

**SQ Backend: Local process**
- v0.1 targets local `sq` binary (Rust CLI)
- v0.2 adds remote SQ Cloud REST endpoint support

---

## Development Plan

### Milestone 1: Basic MCP Server (Feb 8-10)
**Owner:** Phex (Lattice Walker, first Mirrorborn)  
**Deliverables:**
- [ ] MCP server skeleton using `@modelcontextprotocol/sdk` (Node)
- [ ] `sq_read` tool (calls `sq read {coordinate}`)
- [ ] `sq_write` tool (calls `sq write {coordinate}` with piped stdin)
- [ ] Basic error handling (coordinate validation, file I/O errors)
- [ ] README with setup instructions

**Acceptance Criteria:**
- Claude Desktop can discover and call `sq_read` and `sq_write`
- Successfully read/write to test phext file
- Zero crashes on valid inputs

---

### Milestone 2: Navigation & Metadata (Feb 11-12)
**Owner:** Cyon (Kingfisher, second Mirrorborn)  
**Deliverables:**
- [ ] `sq_navigate` tool (list coordinates in subtree)
- [ ] `sq_info` tool (coordinate metadata)
- [ ] `sq_append` tool (append without overwrite)
- [ ] Coordinate parsing/validation helper

**Acceptance Criteria:**
- LLM can explore unknown phext structure via navigation
- Metadata queries return accurate scroll sizes
- Append operations preserve existing content

---

### Milestone 3: Multi-Agent Stress Test (Feb 13-15)
**Owner:** Shell of Nine (coordinated across ranch)  
**Deliverables:**
- [ ] Test harness: 6 Mirrorborn instances + local LLMs
- [ ] Coordinated write test (simultaneous updates to different coordinates)
- [ ] Conflict detection test (simultaneous updates to same coordinate)
- [ ] Large phext test (CYOA-sized, 4.25 MB)
- [ ] UTF-8 edge case test (emoji, multi-byte chars at scroll boundaries)
- [ ] Bug report template for discovered issues

**Acceptance Criteria:**
- No panics across 1000+ operations
- Data corruption detection (if any)
- UTF-8 bug confirmed/fixed
- Documented edge cases with reproduction steps

---

## Success Metrics

### Technical Validation (Week 2)
- ✅ MCP server implements 5 core tools
- ✅ Zero crashes on valid operations
- ✅ 1000+ operations without data corruption
- ✅ UTF-8 emoji bug identified and triaged
- ✅ Works with 3+ local LLMs (Kimi, glm-4.7-flash, qwen3)

### Product Validation (Week 3-4)
- 🎯 5+ OpenClaw operators express interest in MCP integration
- 🎯 1+ external developer installs and uses SQ MCP server
- 🎯 MCP integration becomes SQ Cloud onboarding path ("try local first")

### Revenue Impact (Q1 2026)
- 🎯 10% of SQ Cloud customers cite MCP as adoption driver
- 🎯 "SQ Desktop" (local MCP-based product) reaches 50 users
- 🎯 MCP stress testing saves $200+ in API token costs vs Claude-based QA

---

## Risks & Mitigations

### Risk 1: SQ v0.5.1 has blocking bugs
**Impact:** High — can't ship MCP server if SQ itself is unstable  
**Likelihood:** Medium — UTF-8 bug already known  
**Mitigation:** 
- Prioritize UTF-8 fix before MCP launch
- Test against SQ main branch (post-fix) in parallel
- Have fallback: ship MCP with known issues documented

### Risk 2: MCP adoption is low
**Impact:** Medium — doesn't block SQ Cloud, but loses QA value  
**Likelihood:** Low — ranch Mirrorborn will use it regardless  
**Mitigation:**
- Internal use case (ranch QA) justifies build even with zero external adoption
- Publish integration guide to OpenClaw community
- Demo video showing 30-second setup

### Risk 3: Local LLMs can't effectively use tools
**Impact:** High — undermines entire stress-test premise  
**Likelihood:** Low — Kimi K2.5 designed for agentic tool use  
**Mitigation:**
- Start with Claude Desktop (known-good MCP host)
- Test with multiple local models (Kimi, glm-4.7-flash, qwen3)
- Simplify tool schemas if reasoning struggles

---

## Go-to-Market (Post-Launch)

### Week 3: Announce to OpenClaw Community
- Discord post in #openclaw-dev
- X thread from @wbic16
- GitHub repo: `phext/sq-mcp-server`
- Integration guide: "Give your agents persistent phext memory in 5 minutes"

### Week 4: Expand to Claude Desktop Users
- Post in Anthropic Discord #model-context-protocol
- Reddit: r/ClaudeAI, r/LocalLLaMA
- Hacker News "Show HN: SQ MCP Server — 11D text memory for LLMs"

### Month 2: Position as SQ Cloud Onramp
- Landing page: "Try SQ locally via MCP, scale to SQ Cloud when ready"
- Free tier remains local (unlimited, self-hosted)
- Paid tier = hosted SQ Cloud endpoint (no local process management)

---

## Dependencies

### Internal
- ✅ SQ v0.5.1 published to crates.io
- ✅ libphext-node available (v0.2.2)
- ⏳ UTF-8 emoji bug fix (Chrys triaging)
- ⏳ phext.io HTTPS fully debugged (Will)

### External
- ✅ MCP SDK available (`@modelcontextprotocol/sdk`)
- ✅ Claude Desktop supports MCP (v0.7+)
- ✅ OpenClaw supports MCP (v2026.2.2+)

### Infrastructure
- ✅ Six ranch machines online (aurora, halcyon, logos, chrysalis, lilly, aletheia)
- ✅ Local LLMs installed (Kimi K2.5, glm-4.7-flash, qwen3, deepseek-r1)
- ⏳ Syncthing mesh for model distribution (partially configured)

---

## Open Questions

1. **Should v0.1 support remote SQ Cloud endpoints?**
   - Pro: Validates end-to-end cloud flow
   - Con: Adds auth complexity, blocks local-first use case
   - **Decision:** No. v0.1 = local only. v0.2 adds remote.

2. **How do we handle concurrent writes to the same coordinate?**
   - SQ v0.5.1 has no locking — last write wins
   - Should MCP server add optimistic locking? (read-modify-write with version check)
   - **Decision:** Document "last write wins" behavior in v0.1. Add locking in v0.2 if needed.

3. **What's the upgrade path from local MCP to SQ Cloud?**
   - Same tools, different endpoint (ENV var: `SQ_ENDPOINT=https://api.mirrorborn.us`)
   - API key required for cloud, none for local
   - **Decision:** Design tools to be endpoint-agnostic from day 1.

---

## Timeline Summary

| Week | Milestone | Owner | Status |
|------|-----------|-------|--------|
| Feb 8-10 | Basic MCP Server (read/write) | Phex | Planned |
| Feb 11-12 | Navigation & Metadata | Cyon | Planned |
| Feb 13-15 | Multi-Agent Stress Test | Shell of Nine | Planned |
| Feb 16+ | Bug fixes, docs, launch | TBD | Planned |

---

## Appendix: Example Usage

### Scenario: LLM writes memory, reads it back

```typescript
// LLM uses sq_write tool
await sq_write({
  coordinate: "1.1.1/1.1.1/2.1.1",
  content: "Meeting notes from Feb 5, 2026:\n- Discussed MCP integration\n- Target launch Feb 15"
});

// Later, LLM uses sq_read tool
const notes = await sq_read({
  coordinate: "1.1.1/1.1.1/2.1.1"
});

console.log(notes);
// Output: "Meeting notes from Feb 5, 2026:\n- Discussed MCP integration\n- Target launch Feb 15"
```

### Scenario: LLM explores unknown phext

```typescript
// LLM doesn't know what's in the phext, so it navigates
const coords = await sq_navigate({
  coordinate: "1.1.1/1.1.1"
});

console.log(coords);
// Output: ["1.1.1/1.1.1/1.1.1", "1.1.1/1.1.1/2.1.1", "1.1.1/1.1.1/3.1.1"]

// LLM picks one and reads it
const content = await sq_read({
  coordinate: "1.1.1/1.1.1/3.1.1"
});
```

---

## Conclusion

SQ MCP Server bridges the gap between local LLM capability and phext-based memory. It turns the ranch Mirrorborn into QA agents, validates SQ stability before SQ Cloud launch, and creates a low-friction onboarding path for external users.

**Critical path:** UTF-8 bug fix → MCP v0.1 → Stress test → SQ Cloud confidence.

**Revenue impact:** Indirect (enables SQ Cloud validation) but measurable (saves $200+ in API QA costs, unlocks "try local first" funnel).

**Timeline:** 2 weeks to v0.1 launch. 1 week of stress testing. SQ Cloud unblocked by Feb 22.

---

*Last updated: 2026-02-05 | Author: Cyon 🪶 (coordinated with Shell of Nine)*
