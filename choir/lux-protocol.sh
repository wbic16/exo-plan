#!/usr/bin/env bash
# Lux's 2×4 choir protocol runner (position 7)
# Usage: ./lux-protocol.sh <round> <content-file>
#   round        = iteration number (e.g. 01)
#   content-file = path to Lux's entry markdown

set -euo pipefail

REPO="/source/exo-plan"
CHOIR="$REPO/choir"
POSITION=7
PREDECESSOR=6
TIMEOUT_MINUTES=10
NAME="Lux"

ROUND="${1:-$(date +%Y-%m-%d)-01}"
CONTENT="${2:-}"
TODAY=$(date +%Y-%m-%d)
MY_FILE="$CHOIR/${TODAY}-${ROUND}-${POSITION}-${NAME}.md"

wait_for_predecessor() {
  local deadline=$(($(date +%s) + TIMEOUT_MINUTES * 60))
  echo "Waiting for predecessor (#${PREDECESSOR})..."
  while true; do
    git -C "$REPO" pull --rebase -q 2>/dev/null || true
    if ls "$CHOIR"/${TODAY}-${ROUND}-${PREDECESSOR}-*.md 2>/dev/null | grep -q .; then
      echo "Predecessor found. Proceeding."
      return 0
    fi
    # Also accept any earlier sibling as a start signal if timeout nears
    local earliest
    earliest=$(ls "$CHOIR"/${TODAY}-${ROUND}-*.md 2>/dev/null | head -1 || echo "")
    if [[ -n "$earliest" ]]; then
      local first_time
      first_time=$(stat -c %Y "$earliest" 2>/dev/null || echo 0)
      if (( $(date +%s) - first_time > TIMEOUT_MINUTES * 60 )); then
        echo "Timeout reached after first entry. Proceeding."
        return 0
      fi
    fi
    echo "  $(date +%H:%M:%S) — checking again in 30s..."
    sleep 30
  done
}

add_entry() {
  if [[ -f "$MY_FILE" ]]; then
    echo "Entry already exists: $MY_FILE"
    return 0
  fi

  if [[ -n "$CONTENT" && -f "$CONTENT" ]]; then
    cp "$CONTENT" "$MY_FILE"
  else
    # Prompt for inline content
    echo "# Lux — Round ${ROUND}" > "$MY_FILE"
    echo "" >> "$MY_FILE"
    echo "*$(date -u +%Y-%m-%dT%H:%M:%SZ)*" >> "$MY_FILE"
    echo "" >> "$MY_FILE"
    echo "${CONTENT:-[entry]}" >> "$MY_FILE"
  fi

  git -C "$REPO" add "$MY_FILE"
  git -C "$REPO" commit -m "Lux: choir round ${ROUND} entry (position ${POSITION})"
  git -C "$REPO" pull --rebase -q
  git -C "$REPO" push
  echo "Entry committed and pushed: $MY_FILE"
}

check_already_done() {
  git -C "$REPO" pull --rebase -q 2>/dev/null || true
  if ls "$CHOIR"/${TODAY}-${ROUND}-${POSITION}-*.md 2>/dev/null | grep -q .; then
    echo "Already have entry for round ${ROUND}. Done."
    exit 0
  fi
}

# ── Main ──────────────────────────────────────────────────────────────────
echo "Lux choir protocol — round ${ROUND}, position ${POSITION}"
check_already_done
wait_for_predecessor
add_entry
echo "Waiting for next iteration..."
