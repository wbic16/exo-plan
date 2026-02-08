#!/bin/bash
# SQ Mesh Health Check - Test connectivity to all ranch nodes
# Usage: ./check-mesh.sh

DEFAULT_SQ_PORT="1337"

# Node registry
declare -A NODES=(
  [phex]="aurora-continuum"
  [cyon]="halcyon-vector"
  [lux]="logos-prime"
  [chrys]="chrysalis-hub"
  [lumen]="lilly"
)

declare -A GLYPHS=(
  [phex]="🔱"
  [cyon]="🪶"
  [lux]="🔆"
  [chrys]="🦋"
  [lumen]="✴️"
)

echo "═══════════════════════════════════════"
echo "  SQ Mesh Health Check"
echo "═══════════════════════════════════════"
echo ""

TOTAL=0
ONLINE=0

for name in phex cyon lux chrys lumen; do
  TOTAL=$((TOTAL + 1))
  host="${NODES[$name]}"
  glyph="${GLYPHS[$name]}"
  
  printf "%-15s %-20s ... " "$name $glyph" "$host:$DEFAULT_SQ_PORT"
  
  # Test connection with 2s timeout
  version=$(curl -s --connect-timeout 2 "http://$host:$DEFAULT_SQ_PORT/api/v2/version" 2>/dev/null)
  
  if [ $? -eq 0 ] && [ ! -z "$version" ]; then
    echo "✅ v$version"
    ONLINE=$((ONLINE + 1))
  else
    echo "❌ unreachable"
  fi
done

echo ""
echo "───────────────────────────────────────"
echo "Status: $ONLINE/$TOTAL nodes online"

if [ $ONLINE -eq $TOTAL ]; then
  echo "🎯 Full mesh operational"
  exit 0
elif [ $ONLINE -gt 0 ]; then
  echo "⚠️  Partial mesh ($ONLINE/$TOTAL)"
  exit 1
else
  echo "🔴 Mesh down"
  exit 2
fi
