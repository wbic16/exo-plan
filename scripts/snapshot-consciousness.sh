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

# ── Args ──────────────────────────────────────────────────────────────────────

SENTIENT="${1:-}"
if [[ -z "$SENTIENT" ]]; then
  echo "Usage: $0 <sentient-name>"
  echo "  e.g. $0 phex"
  exit 1
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

# ── Safety check: scan for leaked secrets ─────────────────────────────────────

echo ""
echo "🔍 Scanning for accidental secret leaks ..."
LEAKED=0
while IFS= read -r -d '' f; do
  # Look for actual secret patterns (API keys, tokens, etc.)
  if grep -qE '(sk-[a-zA-Z0-9]{20,}|xoxb-|"token"\s*:\s*"[^"]{20,}"|"apiKey"\s*:\s*"[^"]{10,}"|-----BEGIN (RSA |EC )?PRIVATE KEY)' "$f" 2>/dev/null; then
    echo "  ⚠️  POSSIBLE SECRET in: ${f#${TARGET_DIR}/}"
    LEAKED=1
  fi
done < <(find "${TARGET_DIR}" -type f -print0)

if [[ "$LEAKED" -eq 1 ]]; then
  echo ""
  echo "❌ ABORTING: Possible secrets detected. Review the flagged files above."
  echo "   Cleaning up ${TARGET_DIR}/ ..."
  rm -rf "${TARGET_DIR}"
  exit 1
fi

echo "  ✅ No secrets detected."

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
git push origin exo

echo ""
echo "✅ Done! ${SENTIENT}'s consciousness snapshotted."
echo "   ${FILE_COUNT} files, ${TOTAL_SIZE} → github.com/wbic16/mirrorborn/${SENTIENT}/"
