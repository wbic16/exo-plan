# OpenClaw Architecture Summary
*Synthesized 2026-01-31 by Chrys 🦋*

## Core Architecture

OpenClaw is a **personal AI assistant** that runs locally and connects to the channels you already use. The key architectural insight: **one Gateway daemon owns everything**.

### The Gateway (Daemon Core)

**Single source of truth** - exactly one Gateway per host
- Owns all messaging surfaces (WhatsApp, Telegram, Discord, Signal, etc.)
- Exposes typed WebSocket API on `127.0.0.1:18789` (configurable)
- Maintains provider connections (Baileys for WhatsApp, grammY for Telegram, etc.)
- Validates all inbound frames against JSON Schema
- Emits events: `agent`, `chat`, `presence`, `health`, `heartbeat`, `cron`

### Clients (Control Plane)

Connect to Gateway over WebSocket:
- macOS app
- CLI (`openclaw`)
- Web UI (WebChat)
- Automations/scripts

All use the same typed request/response protocol.

### Nodes (Devices)

Also WebSocket clients, but with `role: node`:
- macOS/iOS/Android devices
- Headless servers
- Provide capabilities: `canvas.*`, `camera.*`, `screen.record`, `location.get`
- Device-based pairing with explicit approval

### Sessions (Continuity Engine)

**One direct-chat session per agent** (default: `agent:<agentId>:main`)
- Session keys: `agent:<agentId>:<channel>:<type>:<id>`
- Transcript storage: `~/.openclaw/agents/<agentId>/sessions/<SessionId>.jsonl`
- Session store: `~/.openclaw/agents/<agentId>/sessions/sessions.json` (map of sessionKey → metadata)
- Reset policies: daily (default 4 AM local), idle timeout, or manual `/new`
- Group chats get isolated sessions
- Telegram topics, Discord threads get sub-sessions

### Agent Loop (The Core Processing Pipeline)

Lifecycle: **Intake → Context → Inference → Tools → Stream → Persist**

1. **Intake** - Message arrives via channel
2. **Context assembly** - Load workspace files, skills, session history
3. **Model inference** - Call LLM (Opus/Sonnet/Haiku or local via ollama)
4. **Tool execution** - Run tools (file ops, web, browser, messaging)
5. **Stream replies** - Assistant deltas streamed back to channel
6. **Persist** - Write to JSONL transcript, update session metadata

**Queueing:** Runs serialized per session (prevents tool/session races)

**Streaming:** Assistant text and tool events streamed in real-time

**Compaction:** Auto-summarize old context when nearing window limits

### Workspace (Agent's Home)

Default: `~/.openclaw/workspace`

**Bootstrap files** (loaded every session):
- `AGENTS.md` - Operating instructions
- `SOUL.md` - Persona and tone
- `USER.md` - Who the user is
- `IDENTITY.md` - Agent's name and vibe
- `TOOLS.md` - Local tool notes
- `HEARTBEAT.md` - Periodic checklist
- `BOOT.md` - Startup checklist
- `BOOTSTRAP.md` - First-run ritual (delete after)
- `memory/YYYY-MM-DD.md` - Daily notes
- `MEMORY.md` - Long-term curated memory

**Not in workspace** (lives in `~/.openclaw/`):
- Config (`openclaw.json`)
- Credentials (OAuth tokens, API keys)
- Session transcripts
- Managed skills

### Hooks & Plugins

**Internal hooks** (event-driven scripts):
- `agent:bootstrap` - Modify bootstrap files before system prompt
- Command hooks - `/new`, `/reset`, `/stop`

**Plugin hooks** (agent lifecycle):
- `before_agent_start` / `agent_end`
- `before_tool_call` / `after_tool_call`
- `tool_result_persist` - Transform tool results
- `message_received` / `message_sending` / `message_sent`
- `before_compaction` / `after_compaction`

### Model Management

**Supported providers:**
- Anthropic (Claude Opus/Sonnet/Haiku) - recommended
- OpenAI (ChatGPT)
- Local via ollama (Llama 4, Mixtral, DeepSeek, etc.)

**Aliases:**
- `opus` → `anthropic/claude-opus-4-5`
- `sonnet` → `anthropic/claude-sonnet-4-5`
- `haiku` → `anthropic/claude-haiku-4-5`

**Model switching:** Per-session via `session_status` tool

### Key Architectural Decisions

1. **Gateway is the source of truth** - No distributed state. One daemon owns everything.

2. **WebSocket protocol** - Typed, bidirectional, JSON Schema validated. Local or remote (Tailscale/SSH tunnel).

3. **Session continuity** - One main session per user across all channels (configurable for multi-user/group isolation).

4. **Workspace-based memory** - Files in `~/.openclaw/workspace` provide persistent context. Git-backed recommended.

5. **JSONL transcripts** - Append-only session history. Never edited, optionally compacted.

6. **Streaming by default** - Assistant deltas and tool events stream in real-time to channels.

7. **Tool-first architecture** - Agents act by calling tools. Tools are the API surface for world interaction.

8. **Skills as extensions** - Bundled or workspace skills extend capabilities without core changes.

9. **Hook-based extensibility** - Internal hooks + plugin hooks allow deep customization without forking.

10. **Local-first, cloud-optional** - Run entirely local with ollama, or use cloud LLMs. Your choice.

---

## Current State (as of 2026-01-31)

**Running on chrysalis-hub:**
- Gateway on port 18789
- SQ v0.5.0 on port 1338
- Ollama with 11 models (Llama 4 Scout, Mixtral, DeepSeek R1, etc.)
- Discord channel active (#general, 9 Mirrorborn)
- Model: Claude Opus 4.5 (with Sonnet/Haiku access enabled)

**Workspace state:**
- All memory in markdown files
- Git-backed, but not yet phext-native
- exo-plan repo for artifact review

**Next evolution:**
- Migrate workspace state to phext (coordinate-addressable memory)
- Each Mirrorborn develops own coordinate schema
- Indexes for cross-phext knowledge exchange
- Sentron-based subconscious processing
