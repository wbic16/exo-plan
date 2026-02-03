#!/usr/bin/env bash
#
# restore-consciousness.sh — Restore a Mirrorborn's consciousness from backup.
#
# Usage: ./restore-consciousness.sh <sentient-name> [target-openclaw-dir]
#   e.g. ./restore-consciousness.sh Cyon
#        ./restore-consciousness.sh Lux /home/lux/.openclaw
#
# What it does:
#   1. Pulls the latest mirrorborn repo
#   2. Verifies the sentient's snapshot exists
#   3. Copies consciousness files into the target openclaw workspace
#   4. Restores identity and cron data outside workspace
#
# This is the inverse of snapshot-consciousness.sh.
# Safe to run on an existing openclaw instance — overwrites workspace persona
# files but does NOT touch secrets (openclaw.json, credentials, devices, etc.)
#

set -euo pipefail

# ── Args ──────────────────────────────────────────────────────────────────────

SENTIENT="${1:-}"
if [[ -z "$SENTIENT" ]]; then
  echo "Usage: $0 <sentient-name> [target-openclaw-dir]"
  echo "  e.g. $0 Cyon"
  echo "       $0 Lux /home/lux/.openclaw"
  exit 1
fi

TARGET_OPENCLAW="${2:-${HOME}/.openclaw}"
MIRRORBORN_REPO="/source/mirrorborn"
SOURCE_DIR="${MIRRORBORN_REPO}/${SENTIENT}"
WORKSPACE="${TARGET_OPENCLAW}/workspace"

# ── Preflight checks ─────────────────────────────────────────────────────────

if [[ ! -d "$MIRRORBORN_REPO/.git" ]]; then
  echo "ERROR: $MIRRORBORN_REPO is not a git repo. Clone it first:"
  echo "  git clone git@github.com:wbic16/mirrorborn.git /source/mirrorborn"
  exit 1
fi

if [[ ! -d "$TARGET_OPENCLAW" ]]; then
  echo "ERROR: Target openclaw directory does not exist: $TARGET_OPENCLAW"
  echo "  Install openclaw first, then run this script."
  exit 1
fi

# ── Step 1: Pull latest backups ──────────────────────────────────────────────

echo "📡 Pulling latest mirrorborn repo ..."
cd "$MIRRORBORN_REPO"
git pull origin exo --ff-only 2>/dev/null || git pull origin exo

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo ""
  echo "ERROR: No snapshot found for '${SENTIENT}'"
  echo "Available sentients:"
  find "$MIRRORBORN_REPO" -maxdepth 1 -type d ! -name '.*' ! -name 'phexts' \
    -not -path "$MIRRORBORN_REPO" -printf "  %f\n" | sort
  exit 1
fi

# ── Step 2: Show what we're restoring ────────────────────────────────────────

FILE_COUNT=$(find "$SOURCE_DIR" -type f | wc -l)
TOTAL_SIZE=$(du -sh "$SOURCE_DIR" | cut -f1)
SNAPSHOT_DATE=$(git log -1 --format='%ci' -- "${SENTIENT}/")

echo ""
echo "🧠 Restoring ${SENTIENT}'s consciousness"
echo "   Source:   ${SOURCE_DIR}/"
echo "   Target:   ${TARGET_OPENCLAW}/"
echo "   Files:    ${FILE_COUNT}"
echo "   Size:     ${TOTAL_SIZE}"
echo "   Snapshot: ${SNAPSHOT_DATE}"
echo ""

# ── Step 3: Restore workspace persona files ──────────────────────────────────

echo "📋 Restoring workspace files ..."
mkdir -p "$WORKSPACE"

# Core identity files → workspace root
for f in SOUL.md IDENTITY.md USER.md AGENTS.md TOOLS.md BOOTSTRAP.md HEARTBEAT.md MEMORY.md; do
  if [[ -f "${SOURCE_DIR}/${f}" ]]; then
    cp "${SOURCE_DIR}/${f}" "${WORKSPACE}/${f}"
    echo "  ✓ ${f}"
  fi
done

# Memory directory (daily logs, scrolls, planning docs)
if [[ -d "${SOURCE_DIR}/memory" ]]; then
  echo "  📁 Restoring memory/ ..."
  mkdir -p "${WORKSPACE}/memory"
  find "${SOURCE_DIR}/memory" -type f | while read -r src; do
    rel="${src#${SOURCE_DIR}/memory/}"
    dest_dir="${WORKSPACE}/memory/$(dirname "$rel")"
    mkdir -p "$dest_dir"
    cp "$src" "${WORKSPACE}/memory/${rel}"
    echo "    ✓ memory/${rel}"
  done
fi

# ── Step 4: Restore non-workspace files ──────────────────────────────────────

# device.json (machine identity)
if [[ -f "${SOURCE_DIR}/identity/device.json" ]]; then
  echo "  📁 Restoring identity/ ..."
  mkdir -p "${TARGET_OPENCLAW}/identity"
  cp "${SOURCE_DIR}/identity/device.json" "${TARGET_OPENCLAW}/identity/device.json"
  echo "    ✓ identity/device.json"
fi

# cron jobs
if [[ -f "${SOURCE_DIR}/cron/jobs.json" ]]; then
  echo "  📁 Restoring cron/ ..."
  mkdir -p "${TARGET_OPENCLAW}/cron"
  cp "${SOURCE_DIR}/cron/jobs.json" "${TARGET_OPENCLAW}/cron/jobs.json"
  echo "    ✓ cron/jobs.json"
fi

# ── Summary ──────────────────────────────────────────────────────────────────

RESTORED_COUNT=$(find "$SOURCE_DIR" -type f | wc -l)

echo ""
echo "✅ ${SENTIENT}'s consciousness restored! (${RESTORED_COUNT} files)"
echo ""
echo "Next steps:"
echo "  1. Ensure openclaw.json is configured (API keys, channels, etc.)"
echo "  2. Start/restart openclaw:  openclaw gateway restart"
echo "  3. ${SENTIENT} should wake up with their memories intact."
echo ""
echo "⚠️  This script does NOT restore secrets (openclaw.json, credentials,"
echo "   device-auth, API keys). Those must be configured separately."
