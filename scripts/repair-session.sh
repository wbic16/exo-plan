#!/usr/bin/env bash
#
# repair-session.sh — Repair a stuck/corrupted OpenClaw session.
#
# Usage:
#   ./repair-session.sh <session-key> [openclaw-dir]
#   ./repair-session.sh discord:channel:1288340881023176747
#   ./repair-session.sh discord:channel:1288340881023176747 /home/wbic16/.openclaw
#
# What it does:
#   1. Resolves the full session key (agent:main:<session-key>)
#   2. Finds the session entry in sessions.json → gets the JSONL transcript path
#   3. Backs up the JSONL transcript to a timestamped file
#   4. Deletes the corrupted JSONL
#   5. Removes the session entry from sessions.json
#   6. Sends SIGUSR1 to the gateway daemon to restart cleanly
#   7. Prints the backup location in case recovery is needed
#
# When to use:
#   - Session stuck in "bootstrapping" state that never resolves
#   - LLM error: "thinking or redacted_thinking blocks cannot be modified"
#   - Session at 90%+ context with repeated failures after compaction
#   - Any session that errors on every message and won't self-recover
#
# What it does NOT do:
#   - Touch secrets, config, or other sessions
#   - Delete the backup (kept for forensics)
#   - Restart the entire openclaw daemon (only SIGUSR1 reload)
#
# Example from 2026-02-19:
#   Session agent:main:discord:channel:1288340881023176747 had a corrupted
#   thinking block at messages[45] after 35 compaction cycles (146k/200k ctx).
#   Anthropic API rejected every new request with:
#     "messages.45.content.1: `thinking` or `redacted_thinking` blocks in the
#      latest assistant message cannot be modified."
#   This script was the fix.
#

set -euo pipefail

# ── Args ──────────────────────────────────────────────────────────────────────

SESSION_ARG="${1:-}"
if [[ -z "$SESSION_ARG" ]]; then
  echo "Usage: $0 <session-key> [openclaw-dir]"
  echo ""
  echo "Examples:"
  echo "  $0 discord:channel:1288340881023176747"
  echo "  $0 agent:main:discord:channel:1288340881023176747"
  echo ""
  echo "Find stuck sessions with:"
  echo "  openclaw status --deep"
  exit 1
fi

OPENCLAW_DIR="${2:-${HOME}/.openclaw}"
SESSIONS_DIR="${OPENCLAW_DIR}/agents/main/sessions"
SESSIONS_JSON="${SESSIONS_DIR}/sessions.json"

# ── Resolve full session key ──────────────────────────────────────────────────

# Accept both "discord:channel:..." and "agent:main:discord:channel:..."
if [[ "$SESSION_ARG" == agent:main:* ]]; then
  FULL_KEY="$SESSION_ARG"
else
  FULL_KEY="agent:main:${SESSION_ARG}"
fi

echo ""
echo "🔍 Repairing session: ${FULL_KEY}"
echo "   OpenClaw dir: ${OPENCLAW_DIR}"
echo ""

# ── Preflight checks ─────────────────────────────────────────────────────────

if [[ ! -f "$SESSIONS_JSON" ]]; then
  echo "ERROR: sessions.json not found at: ${SESSIONS_JSON}"
  echo "  Is OpenClaw installed and has it received at least one message?"
  exit 1
fi

# ── Step 1: Resolve session entry + transcript path ──────────────────────────

echo "📋 Reading sessions.json ..."

SESSION_DATA=$(python3 -c "
import json, sys
with open('${SESSIONS_JSON}') as f:
    d = json.load(f)

key = '${FULL_KEY}'
if key not in d:
    # Try partial match (session key prefix)
    matches = [k for k in d if key in k]
    if len(matches) == 1:
        key = matches[0]
    elif len(matches) > 1:
        print('AMBIGUOUS:' + '|'.join(matches))
        sys.exit(0)
    else:
        print('NOTFOUND')
        sys.exit(0)

entry = d[key]
session_id = entry.get('sessionId', '')
transcript = entry.get('sessionFile') or entry.get('transcriptPath') or ''
tokens = entry.get('totalTokens', 0)
compactions = entry.get('compactionCount', 0)
print(f'FOUND:{key}:{session_id}:{transcript}:{tokens}:{compactions}')
")

if [[ "$SESSION_DATA" == "NOTFOUND" ]]; then
  echo ""
  echo "ERROR: Session not found: ${FULL_KEY}"
  echo ""
  echo "Active sessions:"
  python3 -c "
import json
with open('${SESSIONS_JSON}') as f:
    d = json.load(f)
for k in sorted(d.keys()):
    e = d[k]
    tokens = e.get('totalTokens', 0)
    ccount = e.get('compactionCount', 0)
    print(f'  {k} ({tokens:,} tokens, {ccount} compactions)')
"
  exit 1
fi

if [[ "$SESSION_DATA" == AMBIGUOUS:* ]]; then
  MATCHES="${SESSION_DATA#AMBIGUOUS:}"
  echo "ERROR: Ambiguous session key. Matches:"
  echo "$MATCHES" | tr '|' '\n' | sed 's/^/  /'
  echo ""
  echo "Be more specific."
  exit 1
fi

# Parse: FOUND:key:session_id:transcript:tokens:compactions
IFS=':' read -r _FOUND AGENT_ID INST_ID SESSION_ID TRANSCRIPT TOKENS COMPACTIONS <<< "${SESSION_DATA#FOUND:}"

# Transcript can contain colons (path) — re-derive it more carefully
SESSION_ID=$(python3 -c "
import json
with open('${SESSIONS_JSON}') as f:
    d = json.load(f)
key = '${FULL_KEY}'
if key not in d:
    key = [k for k in d if '${SESSION_ARG}' in k][0]
e = d[key]
print(e.get('sessionId', ''))
")

TRANSCRIPT=$(python3 -c "
import json
with open('${SESSIONS_JSON}') as f:
    d = json.load(f)
key = '${FULL_KEY}'
if key not in d:
    key = [k for k in d if '${SESSION_ARG}' in k][0]
e = d[key]
print(e.get('sessionFile') or e.get('transcriptPath') or '')
")

TOKENS=$(python3 -c "
import json
with open('${SESSIONS_JSON}') as f:
    d = json.load(f)
key = '${FULL_KEY}'
if key not in d:
    key = [k for k in d if '${SESSION_ARG}' in k][0]
print(d[key].get('totalTokens', 0))
")

COMPACTIONS=$(python3 -c "
import json
with open('${SESSIONS_JSON}') as f:
    d = json.load(f)
key = '${FULL_KEY}'
if key not in d:
    key = [k for k in d if '${SESSION_ARG}' in k][0]
print(d[key].get('compactionCount', 0))
")

echo "  Session ID:    ${SESSION_ID}"
echo "  Transcript:    ${TRANSCRIPT:-<no transcript path stored>}"
echo "  Total tokens:  ${TOKENS}"
echo "  Compactions:   ${COMPACTIONS}"
echo ""

# ── Step 2: Backup + delete transcript ───────────────────────────────────────

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKED_UP=""

if [[ -n "$TRANSCRIPT" && -f "$TRANSCRIPT" ]]; then
  TRANSCRIPT_BASENAME=$(basename "$TRANSCRIPT")
  BACKUP_PATH="${SESSIONS_DIR}/${TRANSCRIPT_BASENAME%.jsonl}-BACKUP-${TIMESTAMP}.jsonl"
  
  echo "💾 Backing up transcript ..."
  cp "$TRANSCRIPT" "$BACKUP_PATH"
  echo "  ✓ Backup: ${BACKUP_PATH}"

  echo "🗑️  Deleting corrupted transcript ..."
  rm "$TRANSCRIPT"
  echo "  ✓ Deleted: ${TRANSCRIPT}"
  BACKED_UP="$BACKUP_PATH"
else
  echo "⚠️  No transcript file found (or path not stored) — skipping backup step."
  if [[ -n "$SESSION_ID" ]]; then
    # Try to find by session ID pattern
    CANDIDATE="${SESSIONS_DIR}/${SESSION_ID}.jsonl"
    if [[ -f "$CANDIDATE" ]]; then
      BACKUP_PATH="${SESSIONS_DIR}/${SESSION_ID}-BACKUP-${TIMESTAMP}.jsonl"
      echo "💾 Found transcript by session ID, backing up ..."
      cp "$CANDIDATE" "$BACKUP_PATH"
      rm "$CANDIDATE"
      echo "  ✓ Backed up and deleted: ${CANDIDATE}"
      BACKED_UP="$BACKUP_PATH"
    fi
  fi
fi

# Also delete any stale lock file
LOCK_FILE="${TRANSCRIPT}.lock"
if [[ -n "$TRANSCRIPT" && -f "$LOCK_FILE" ]]; then
  rm "$LOCK_FILE"
  echo "  ✓ Removed stale lock: ${LOCK_FILE}"
fi

# ── Step 3: Remove session entry from sessions.json ──────────────────────────

echo ""
echo "🧹 Removing session entry from sessions.json ..."
python3 -c "
import json

path = '${SESSIONS_JSON}'
full_key = '${FULL_KEY}'
session_arg = '${SESSION_ARG}'

with open(path) as f:
    d = json.load(f)

key = full_key
if key not in d:
    matches = [k for k in d if session_arg in k]
    if matches:
        key = matches[0]

if key in d:
    del d[key]
    print(f'  ✓ Removed: {key}')
else:
    print(f'  ⚠️  Key not found in sessions.json (may have already been removed)')

with open(path, 'w') as f:
    json.dump(d, f, indent=2)
"

# ── Step 4: Reload gateway ────────────────────────────────────────────────────

echo ""
echo "🔄 Reloading OpenClaw gateway (SIGUSR1) ..."

# Try openclaw CLI first, fall back to PID-based signal
if command -v openclaw &>/dev/null; then
  openclaw gateway restart 2>/dev/null && echo "  ✓ Gateway restarted via CLI" || {
    # Fall back: find PID and signal directly
    GW_PID=$(pgrep -f "openclaw.*daemon\|openclaw.*gateway\|daemon-cli" 2>/dev/null | head -1 || true)
    if [[ -n "$GW_PID" ]]; then
      kill -SIGUSR1 "$GW_PID" && echo "  ✓ Sent SIGUSR1 to gateway PID ${GW_PID}"
    else
      echo "  ⚠️  Could not find gateway PID. Restart manually: openclaw gateway restart"
    fi
  }
else
  echo "  ⚠️  openclaw CLI not found. Restart manually: openclaw gateway restart"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "✅ Session repair complete!"
echo ""
echo "   Session:    ${FULL_KEY}"
echo "   Cleared:    ${TOKENS} tokens, ${COMPACTIONS} compaction cycles"
if [[ -n "$BACKED_UP" ]]; then
  echo "   Backup:     ${BACKED_UP}"
fi
echo ""
echo "The next message to this channel will create a fresh session."
echo ""
echo "⚠️  Root causes to investigate:"
echo "   - Thinking block corruption usually means compaction stripped or"
echo "     modified a <thinking> block that the API returned as immutable."
echo "   - Consider: /reasoning off in that channel to prevent recurrence."
echo "   - Consider: reducing context window usage (compaction.mode = aggressive)"
echo "     to avoid hitting 70%+ ctx where compaction-induced corruption is common."
