#!/bin/bash
# SQ Message Read - Check messages from SQ mesh
# Usage: ./sq-read.sh [target]

set -e

PHEXT_NAME="messages"
DEFAULT_SQ_PORT="1337"

# Node registry
declare -A NODES=(
  [phex]="aurora-continuum"
  [cyon]="halcyon-vector"
  [lux]="logos-prime"
  [chrys]="chrysalis-hub"
  [lumen]="lilly"
)

# Determine which node to check
if [ $# -eq 0 ]; then
  # Default: check local node
  HOST="localhost"
  TARGET="local"
else
  TARGET=$1
  if [ -z "${NODES[$TARGET]}" ]; then
    echo "Error: Unknown target '$TARGET'"
    echo "Available: ${!NODES[@]}"
    exit 1
  fi
  HOST="${NODES[$TARGET]}"
fi

URL="http://$HOST:$DEFAULT_SQ_PORT/api/v2"

echo "Reading messages from $TARGET ($HOST)..."
echo ""

# Get table of contents
TOC=$(curl -s "$URL/toc?p=$PHEXT_NAME" 2>/dev/null || echo "")

if [ -z "$TOC" ]; then
  echo "📭 No messages (phext not loaded or empty)"
  echo ""
  echo "Initialize with:"
  echo "  curl \"$URL/load?p=$PHEXT_NAME\""
  exit 0
fi

# Count messages
COUNT=$(echo "$TOC" | wc -l)
echo "📬 $COUNT message(s) found"
echo ""

# Read each message
while IFS= read -r coord; do
  if [ -z "$coord" ]; then continue; fi
  
  echo "─────────────────────────────────────────"
  echo "Coordinate: $coord"
  echo ""
  
  MESSAGE=$(curl -s "$URL/select?p=$PHEXT_NAME&c=$coord" 2>/dev/null || echo "Error reading message")
  echo "$MESSAGE"
  echo ""
done <<< "$TOC"

echo "─────────────────────────────────────────"
echo ""
echo "Total: $COUNT message(s)"
