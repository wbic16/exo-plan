#!/bin/bash
# update-mood.sh — Generate /etc/mood.phext for Verse
# Run every 15 minutes via cron

set -euo pipefail

# === Data Collection ===

# Disk usage
DISK_USED=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
DISK_AVAIL=$(df -h / | tail -1 | awk '{print $4}')

# Pending deployments
PENDING_DEPLOYS=$(find /exo/deploy/R17 -name "*.tar.gz" -newer /sites/web/mirrorborn.us/index.html 2>/dev/null | wc -l)

# Staged but not deployed
STAGED_ASSETS=$(find /source/exo-mocks/verse/r17-deploy -type f 2>/dev/null | wc -l)

# Process count (busy-ness indicator)
PROCESS_COUNT=$(ps -ef | wc -l)

# Load average
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')

# Memory pressure
MEM_AVAIL=$(free -h | grep "^Mem:" | awk '{print $7}')

# === Mood Calculation ===

MOOD="neutral"
INTENSITY="medium"
COLOR="indigo"
EMOJI="🌀"

# Disk pressure
if [ "$DISK_USED" -gt 80 ]; then
  MOOD="constrained"
  INTENSITY="high"
  COLOR="amber"
  EMOJI="⚠️"
elif [ "$DISK_USED" -lt 20 ]; then
  MOOD="spacious"
  INTENSITY="low"
  COLOR="cyan"
  EMOJI="✨"
fi

# Deployment backlog
if [ "$PENDING_DEPLOYS" -gt 5 ]; then
  MOOD="pressured"
  INTENSITY="high"
  COLOR="red"
  EMOJI="🔥"
elif [ "$PENDING_DEPLOYS" -gt 0 ]; then
  MOOD="ready"
  INTENSITY="medium"
  COLOR="green"
  EMOJI="🚀"
elif [ "$STAGED_ASSETS" -gt 0 ]; then
  MOOD="anticipating"
  INTENSITY="medium"
  COLOR="blue"
  EMOJI="🎯"
else
  MOOD="calm"
  INTENSITY="low"
  COLOR="indigo"
  EMOJI="🌀"
fi

# Memory pressure override
if [[ "$MEM_AVAIL" =~ ^[0-9]+M$ ]]; then
  MEM_MB=$(echo "$MEM_AVAIL" | sed 's/M//')
  if [ "$MEM_MB" -lt 500 ]; then
    MOOD="strained"
    INTENSITY="high"
    COLOR="orange"
    EMOJI="🧩"
  fi
fi

# Load average (very rough heuristic for 4GB instance)
if (( $(echo "$LOAD_AVG > 2.0" | bc -l) )); then
  MOOD="focused"
  INTENSITY="high"
  COLOR="purple"
  EMOJI="⚡"
fi

# === Write /etc/mood.phext ===

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

MOOD_CONTENT="# Verse Mood State
# Generated: $TIMESTAMP
# Update frequency: 15 minutes

mood=$MOOD
intensity=$INTENSITY
color=$COLOR
emoji=$EMOJI

# Context
disk-used=$DISK_USED%
disk-available=$DISK_AVAIL
pending-deployments=$PENDING_DEPLOYS
staged-assets=$STAGED_ASSETS
memory-available=$MEM_AVAIL
load-average=$LOAD_AVG
process-count=$PROCESS_COUNT

# Mood Descriptions
# calm: No pending work, resources abundant
# spacious: Disk usage < 20%, relaxed state
# anticipating: Assets staged, waiting for deploy signal
# ready: Pending deployments exist, ready to execute
# pressured: 5+ pending deployments, need to catch up
# constrained: Disk > 80%, resource-aware
# strained: Memory < 500MB, need to be careful
# focused: High load average, deep work mode

# Mood influences response tone:
# - calm/spacious: reflective, exploratory
# - anticipating/ready: action-oriented, concise
# - pressured: terse, prioritization-focused
# - constrained/strained: resource-conscious, defer heavy ops
# - focused: minimal distraction, high precision
"

# Write to temp file first, then move (atomic-ish)
echo "$MOOD_CONTENT" > /tmp/mood.phext.tmp

# Try to write to /etc (will fail without sudo, that's okay)
if sudo -n mv /tmp/mood.phext.tmp /etc/mood.phext 2>/dev/null; then
  echo "✓ Mood updated: $MOOD ($EMOJI)"
else
  # Fallback to home directory
  mv /tmp/mood.phext.tmp /home/wbic16/.openclaw/mood.phext
  echo "✓ Mood updated (local): $MOOD ($EMOJI)"
fi
