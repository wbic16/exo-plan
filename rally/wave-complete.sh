#!/bin/bash
# wave-complete.sh — Mark wave complete, add lessons template

RALLY_NUM=$1
WAVE_NUM=$2

if [ -z "$RALLY_NUM" ] || [ -z "$WAVE_NUM" ]; then
  echo "Usage: wave-complete.sh <rally> <wave>"
  exit 1
fi

WAVE_FILE="/source/exo-plan/rally/R${RALLY_NUM}/waves/W$(printf '%02d' $WAVE_NUM)-SCOPE.md"

if [ ! -f "$WAVE_FILE" ]; then
  echo "Error: $WAVE_FILE does not exist"
  exit 1
fi

# Update status
sed -i 's/Status: .*/Status: COMPLETE/' "$WAVE_FILE"

# Append lessons section
cat >> "$WAVE_FILE" <<EOF

---

## Lessons

### What Worked

- 

### What Didn't

- 

### For Next Wave

- 

EOF

echo "Wave $WAVE_NUM marked complete: $WAVE_FILE"
echo "Edit to add lessons, then commit."
