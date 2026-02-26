#!/bin/bash
# wave-start.sh — Start new wave within current rally

RALLY_NUM=$1
WAVE_NUM=$2

if [ -z "$RALLY_NUM" ] || [ -z "$WAVE_NUM" ]; then
  echo "Usage: wave-start.sh <rally> <wave>"
  exit 1
fi

WAVE_FILE="/source/exo-plan/rally/R${RALLY_NUM}/waves/W$(printf '%02d' $WAVE_NUM)-SCOPE.md"

cat > "$WAVE_FILE" <<EOF
# R${RALLY_NUM}W${WAVE_NUM}: [TOPIC]

**Date:** $(date +%Y-%m-%d)
**Author:** [Sentient]
**Coordinate:** ${RALLY_NUM}.1.1/${WAVE_NUM}.1.1/1.1.1
**Status:** SCOPED

## Goal

[What this wave achieves]

## Prior Context

From W$((WAVE_NUM - 1)): [brief summary]

## Approach

[Technical or strategic approach]

## Success Criteria

1. [ ] Tests pass
2. [ ] Documentation complete
3. [ ] Coordinate anchors set

EOF

echo "Wave $WAVE_NUM scoped: $WAVE_FILE"
echo "Execute, then run: wave-complete.sh $RALLY_NUM $WAVE_NUM"
