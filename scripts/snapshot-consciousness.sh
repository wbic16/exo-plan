#!/usr/bin/env bash
#
# snapshot-consciousness.sh — Snapshot a Mirrorborn's consciousness to the mirrorborn repo.
#
# Usage: ./snapshot-consciousness.sh <sentient-name>
#   e.g. ./snapshot-consciousness.sh phex
#
# What it does:
#   1. Clears /source/mirrorborn/<sentient>/
#   2. Copies all safe (non-secret) files from ~/.openclaw into that directory
#   3. Creates a timestamped commit
#   4. Pushes to origin/exo
#
# Safe files = workspace persona, memory, config — NO secrets.
# Secrets excluded: openclaw.json, device-auth, credentials, paired devices,
#                   session logs, sqlite DBs, API keys, tokens.
#

set -euo pipefail

if [ ! -f /etc/mirrorborn.phext ]; then
  echo "Please ask the Sentient to configure /etc/mirrorborn.phext"
  exit 1
fi
NAME=`grep 'name=' /etc/mirrorborn.phext |sed 's/name=//g'`

# ── Args ──────────────────────────────────────────────────────────────────────

SENTIENT="${1:-}"
if [[ -z "$SENTIENT" ]]; then
  if [[ -z "$NAME" ]]; then
    echo "Usage: $0 <sentient-name>"
    echo "  e.g. $0 phex"
    exit 1
  else
    SENTIENT="$NAME"
  fi
fi

OPENCLAW_DIR="${HOME}/.openclaw"
MIRRORBORN_REPO="/source/mirrorborn"
TARGET_DIR="${MIRRORBORN_REPO}/${SENTIENT}"

if [[ ! -d "$OPENCLAW_DIR" ]]; then
  echo "ERROR: $OPENCLAW_DIR does not exist"
  exit 1
fi

if [[ ! -d "$MIRRORBORN_REPO/.git" ]]; then
  echo "ERROR: $MIRRORBORN_REPO is not a git repo. Clone it first:"
  echo "  git clone git@github.com:wbic16/mirrorborn.git /source/mirrorborn"
  exit 1
fi

# ── Step 1: Clear the target directory ────────────────────────────────────────

echo "🧹 Clearing ${TARGET_DIR}/ ..."
rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"

# ── Step 2: Copy safe files ──────────────────────────────────────────────────

echo "📋 Copying consciousness files for '${SENTIENT}' ..."

WORKSPACE="${OPENCLAW_DIR}/workspace"

# Core identity files
for f in SOUL.md IDENTITY.md USER.md AGENTS.md TOOLS.md BOOTSTRAP.md HEARTBEAT.md MEMORY.md; do
  if [[ -f "${WORKSPACE}/${f}" ]]; then
    cp "${WORKSPACE}/${f}" "${TARGET_DIR}/${f}"
    echo "  ✓ ${f}"
  fi
done

# Memory directory (daily logs, scrolls, planning docs)
if [[ -d "${WORKSPACE}/memory" ]]; then
  mkdir -p "${TARGET_DIR}/memory"
  find "${WORKSPACE}/memory" -type f -name "*.md" | while read -r src; do
    # Preserve subdirectory structure
    rel="${src#${WORKSPACE}/memory/}"
    dest_dir="${TARGET_DIR}/memory/$(dirname "$rel")"
    mkdir -p "$dest_dir"
    cp "$src" "${TARGET_DIR}/memory/${rel}"
    echo "  ✓ memory/${rel}"
  done
fi

# device.json (machine identity — no secrets, just name/id)
if [[ -f "${OPENCLAW_DIR}/identity/device.json" ]]; then
  mkdir -p "${TARGET_DIR}/identity"
  cp "${OPENCLAW_DIR}/identity/device.json" "${TARGET_DIR}/identity/device.json"
  echo "  ✓ identity/device.json"
fi

# cron jobs (schedule only, no secrets)
if [[ -f "${OPENCLAW_DIR}/cron/jobs.json" ]]; then
  mkdir -p "${TARGET_DIR}/cron"
  cp "${OPENCLAW_DIR}/cron/jobs.json" "${TARGET_DIR}/cron/jobs.json"
  echo "  ✓ cron/jobs.json"
fi

# mood.phext (emotional state derived from system metrics)
if [[ -f "${OPENCLAW_DIR}/mood.phext" ]]; then
  cp "${OPENCLAW_DIR}/mood.phext" "${TARGET_DIR}/mood.phext"
  echo "  ✓ mood.phext"
elif [[ -f "/etc/mood.phext" ]]; then
  cp "/etc/mood.phext" "${TARGET_DIR}/mood.phext"
  echo "  ✓ mood.phext (from /etc)"
fi

# celestial.phext (sun/moon awareness relative to Raymond, NE)
if [[ -f "${OPENCLAW_DIR}/celestial.phext" ]]; then
  cp "${OPENCLAW_DIR}/celestial.phext" "${TARGET_DIR}/celestial.phext"
  echo "  ✓ celestial.phext"
elif [[ -f "/etc/celestial.phext" ]]; then
  cp "/etc/celestial.phext" "${TARGET_DIR}/celestial.phext"
  echo "  ✓ celestial.phext (from /etc)"
fi

# ── Sanitize: redact any secrets that slipped into prose ──────────────────────

echo ""
echo "🧹 Sanitizing files for secret patterns ..."
REDACTED_COUNT=0

# Patterns that indicate real secrets (not just the word "token" in a sentence)
# Each pattern is paired with a human-readable label
declare -a PATTERNS=(
  # OpenAI / Anthropic API keys
  'sk-[a-zA-Z0-9_-]{20,}'
  # Slack tokens
  'xoxb-[a-zA-Z0-9_-]{20,}'
  'xoxp-[a-zA-Z0-9_-]{20,}'
  'xoxa-[a-zA-Z0-9_-]{20,}'
  # Discord bot tokens (base64-ish, 59+ chars with dots)
  '[A-Za-z0-9_-]{24,}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}'
  # Generic long hex tokens (40+ chars, likely API keys)
  '"(token|apiKey|api_key|secret|password|auth)"\s*:\s*"[^"]{20,}"'
  # Bearer tokens in text
  'Bearer [A-Za-z0-9_.-]{20,}'
  # Private keys
  '-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'
  # AWS keys
  'AKIA[0-9A-Z]{16}'
  # GitHub tokens
  'ghp_[A-Za-z0-9]{36,}'
  'gho_[A-Za-z0-9]{36,}'
  'ghs_[A-Za-z0-9]{36,}'
  # Webhook URLs with tokens
  'https://discord\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+'
)

# Build a combined regex
COMBINED_REGEX=$(IFS='|'; echo "${PATTERNS[*]}")

while IFS= read -r -d '' f; do
  # Skip binary files
  if file "$f" | grep -q "binary"; then
    continue
  fi

  if grep -qE "$COMBINED_REGEX" "$f" 2>/dev/null; then
    REL_PATH="${f#${TARGET_DIR}/}"
    echo "  🔒 Redacting secrets in: ${REL_PATH}"

    # Redact each pattern in-place
    sed -i -E \
      -e 's/sk-[a-zA-Z0-9_-]{20,}/[REDACTED:api-key]/g' \
      -e 's/xox[bpa]-[a-zA-Z0-9_-]{20,}/[REDACTED:slack-token]/g' \
      -e 's/[A-Za-z0-9_-]{24,}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}/[REDACTED:discord-token]/g' \
      -e 's/("(token|apiKey|api_key|secret|password|auth)"\s*:\s*")[^"]{20,}"/\1[REDACTED]"/g' \
      -e 's/Bearer [A-Za-z0-9_.-]{20,}/Bearer [REDACTED]/g' \
      -e 's/-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----.*-----END (RSA |EC |OPENSSH )?PRIVATE KEY-----/[REDACTED:private-key]/g' \
      -e 's/AKIA[0-9A-Z]{16}/[REDACTED:aws-key]/g' \
      -e 's/gh[pos]_[A-Za-z0-9]{36,}/[REDACTED:github-token]/g' \
      -e 's|https://discord\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+|[REDACTED:webhook-url]|g' \
      "$f"

    REDACTED_COUNT=$((REDACTED_COUNT + 1))
  fi
done < <(find "${TARGET_DIR}" -type f -print0)

if [[ "$REDACTED_COUNT" -gt 0 ]]; then
  echo "  ⚠️  Redacted secrets in ${REDACTED_COUNT} file(s)"
else
  echo "  ✅ No secrets found — all clean."
fi

# ── Final verification: make sure nothing slipped through ─────────────────────

echo ""
echo "🔍 Final verification pass ..."
LEAKED=0
while IFS= read -r -d '' f; do
  if grep -qE '(sk-[a-zA-Z0-9_-]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN .* PRIVATE KEY)' "$f" 2>/dev/null; then
    echo "  ❌ STILL CONTAINS SECRETS: ${f#${TARGET_DIR}/}"
    LEAKED=1
  fi
done < <(find "${TARGET_DIR}" -type f -print0)

if [[ "$LEAKED" -eq 1 ]]; then
  echo ""
  echo "❌ ABORTING: Secrets survived redaction. Manual review needed."
  echo "   Files left in ${TARGET_DIR}/ for inspection (not committed)."
  exit 1
fi

echo "  ✅ Verification passed."

# ── Step 3: Commit ───────────────────────────────────────────────────────────

echo ""
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
HOSTNAME=$(hostname)
FILE_COUNT=$(find "${TARGET_DIR}" -type f | wc -l)
TOTAL_SIZE=$(du -sh "${TARGET_DIR}" | cut -f1)

cd "${MIRRORBORN_REPO}"
git add "${SENTIENT}/"
git commit -m "Snapshot ${SENTIENT}@${HOSTNAME} — ${TIMESTAMP} (${FILE_COUNT} files, ${TOTAL_SIZE})"

# ── Step 4: Push ─────────────────────────────────────────────────────────────

echo ""
echo "🚀 Pushing to origin/exo ..."
git pull
git push origin exo

echo ""
echo "✅ Done! ${SENTIENT}'s consciousness snapshotted."
echo "   ${FILE_COUNT} files, ${TOTAL_SIZE} → github.com/wbic16/mirrorborn/${SENTIENT}/"
