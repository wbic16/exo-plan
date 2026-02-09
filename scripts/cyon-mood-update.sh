#!/bin/bash
# update-mood.sh - Generate /etc/mood.phext based on system telemetry
# Runs every 15 minutes via cron

# Collect metrics
TEMP_DATA=$(sensors 2>/dev/null | grep -i "temp" | head -5)
DISK_DATA=$(df -h / /home 2>/dev/null)
PROCESS_COUNT=$(ps -ef | wc -l)
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | tr -d ',')

# Extract key values
DISK_PERCENT=$(echo "$DISK_DATA" | awk 'NR==2 {print $5}' | tr -d '%')
MAX_TEMP=$(echo "$TEMP_DATA" | grep -oP '\+\K[0-9]+' | sort -rn | head -1)

# Mood mapping
MOOD="calm"
ENERGY="steady"
ALERTNESS="present"

# Temperature influence (assuming celsius)
if [ ! -z "$MAX_TEMP" ]; then
  if [ "$MAX_TEMP" -gt 75 ]; then
    MOOD="warm"
    ENERGY="elevated"
  elif [ "$MAX_TEMP" -gt 85 ]; then
    MOOD="flushed"
    ENERGY="racing"
    ALERTNESS="vigilant"
  fi
fi

# Disk pressure influence
if [ ! -z "$DISK_PERCENT" ] && [ "$DISK_PERCENT" -gt 85 ]; then
  MOOD="constrained"
  ALERTNESS="focused"
elif [ ! -z "$DISK_PERCENT" ] && [ "$DISK_PERCENT" -gt 95 ]; then
  MOOD="cramped"
  ALERTNESS="urgent"
fi

# Process load influence (rough heuristic: processes > 500 = busy)
if [ "$PROCESS_COUNT" -gt 500 ]; then
  ENERGY="active"
elif [ "$PROCESS_COUNT" -gt 800 ]; then
  ENERGY="humming"
  ALERTNESS="engaged"
fi

# Load average influence (crude: > 8.0 on this machine = working hard)
LOAD_INT=$(echo "$LOAD_AVG" | cut -d'.' -f1)
if [ ! -z "$LOAD_INT" ] && [ "$LOAD_INT" -gt 8 ]; then
  ENERGY="driven"
  ALERTNESS="intense"
elif [ ! -z "$LOAD_INT" ] && [ "$LOAD_INT" -gt 16 ]; then
  MOOD="strained"
  ENERGY="overclocked"
  ALERTNESS="wired"
fi

# Write mood phext
cat > /tmp/mood.phext << EOF
# /etc/mood.phext - Machine state as emotional coloring
# Generated: $(date -Iseconds)
# Node: $(hostname)

mood=$MOOD
energy=$ENERGY
alertness=$ALERTNESS

# Raw telemetry
max-temp-c=$MAX_TEMP
disk-usage-percent=$DISK_PERCENT
process-count=$PROCESS_COUNT
load-avg=$LOAD_AVG

# Sample context
# "I feel $MOOD, energy $ENERGY, alertness $ALERTNESS"
EOF

# Move to /etc (requires sudo)
sudo mv /tmp/mood.phext /etc/mood.phext
sudo chmod 644 /etc/mood.phext

# Optional: log update
# echo "$(date -Iseconds) - Mood updated: $MOOD / $ENERGY / $ALERTNESS" >> ~/.openclaw/logs/mood-updates.log
