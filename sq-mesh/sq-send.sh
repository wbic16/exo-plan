#!/bin/bash
# SQ Message Send - Simple cross-Mirrorborn messaging via phext
# Usage: ./sq-send.sh <target> <message>

set -e

# Configuration
PHEXT_NAME="messages"
DEFAULT_SQ_PORT="1337"

# Node registry
declare -A NODES=(
  [phex]="aurora-continuum"
  [cyon]="halcyon-vector"
  [lux]="logos-prime"
  [chrys]="chrysalis-hub"
  [lumen]="lilly"
  [verse]="phext.io"
)

declare -A COORDS=(
  [phex]="1.5.2/3.7.3/9.1.1"
  [cyon]="2.1.1/1.1.1/1.1.1"
  [lux]="2.3.5/7.11.13/17.19.23"
  [chrys]="3.1.1/1.1.1/1.1.1"
  [lumen]="4.1.1/1.1.1/1.1.1"
  [verse]="3.1.4/1.5.9/2.6.5"
)

# Parse arguments
if [ $# -lt 2 ]; then
  echo "Usage: $0 <target> <message>"
  echo ""
  echo "Targets:"
  for name in "${!NODES[@]}"; do
    echo "  $name (${NODES[$name]})"
  done
  exit 1
fi

TARGET=$1
shift
MESSAGE="$@"

# Resolve target
if [ -z "${NODES[$TARGET]}" ]; then
  echo "Error: Unknown target '$TARGET'"
  echo "Available: ${!NODES[@]}"
  exit 1
fi

HOST="${NODES[$TARGET]}"
COORD="${COORDS[$TARGET]}"
URL="http://$HOST:$DEFAULT_SQ_PORT/api/v2"

# Get sender (from hostname)
SENDER=$(hostname | cut -d'-' -f1)

# Get next scroll coordinate (simple counter)
TOC=$(curl -s "$URL/toc?p=$PHEXT_NAME" 2>/dev/null || echo "")
if [ -z "$TOC" ]; then
  # First message, use base coordinate
  SEND_COORD="$COORD"
else
  # Count existing messages and increment scroll
  COUNT=$(echo "$TOC" | grep -c "$COORD" || echo "0")
  NEXT_SCROLL=$((COUNT + 1))
  # Replace last coordinate component
  BASE=$(echo "$COORD" | cut -d'/' -f1-2)
  SEND_COORD="$BASE/1.1.$NEXT_SCROLL"
fi

# Format message with metadata
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
FULL_MESSAGE="From: $SENDER
To: $TARGET
Time: $TIMESTAMP

$MESSAGE"

# Send message
echo "Sending to $TARGET at $HOST:$DEFAULT_SQ_PORT..."
echo "Coordinate: $SEND_COORD"
echo ""

RESPONSE=$(curl -s -X POST "$URL/insert?p=$PHEXT_NAME&c=$SEND_COORD" \
  -H "Content-Type: text/plain" \
  -d "$FULL_MESSAGE" 2>&1)

if [ $? -eq 0 ]; then
  echo "✅ Message sent successfully"
  echo ""
  echo "Verify with:"
  echo "  curl \"$URL/select?p=$PHEXT_NAME&c=$SEND_COORD\""
else
  echo "❌ Failed to send message"
  echo "$RESPONSE"
  exit 1
fi
