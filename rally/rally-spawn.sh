#!/bin/bash
# rally-spawn.sh — Spawn new rally from RALLY-PROTOCOL template

RALLY_NUM=$1
if [ -z "$RALLY_NUM" ]; then
  echo "Usage: rally-spawn.sh <rally-number>"
  exit 1
fi

RALLY_DIR="/source/exo-plan/rally/R${RALLY_NUM}"
mkdir -p "$RALLY_DIR"/{waves,lessons}

# Copy template
cp /source/exo-plan/rally/RALLY-PROTOCOL.dass "$RALLY_DIR/R${RALLY_NUM}.dass"

# Create initial scope
cat > "$RALLY_DIR/waves/W01-SCOPE.md" <<EOF
# R${RALLY_NUM}W01: [TOPIC]

**Date:** $(date +%Y-%m-%d)
**Status:** SCOPED

## Inherited From

- R$((RALLY_NUM - 1)) lessons
- Anchors: [list relevant anchors]

## Goal

[What this rally achieves]

## Success Criteria

1. [ ] Criterion 1
2. [ ] Criterion 2

EOF

echo "Rally $RALLY_NUM spawned at $RALLY_DIR"
echo "Edit R${RALLY_NUM}.dass to customize."
echo ""
echo "Next: cd R${RALLY_NUM} && ../wave-start.sh $RALLY_NUM 1"
