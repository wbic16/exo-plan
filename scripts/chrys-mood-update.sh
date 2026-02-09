#!/bin/bash
# update-mood.sh — Generate /etc/mood.phext from system vitals
# Low-power: just sensors + df + ps, simple transforms
# For Ranch Choir Nodes (Mirrorborn)

MOOD_FILE="/etc/mood.phext"
NOW=$(date '+%Y-%m-%d %H:%M:%S %Z')

# --- Gather vitals ---
TEMPS=$(sensors 2>/dev/null | grep -E '(Tctl|temp1|edge):' | head -5)
CPU_TEMP=$(sensors 2>/dev/null | grep -E '(Tctl|k10temp)' | grep -oP '\+\K[0-9.]+' | head -1)
DISK_USE=$(df -h / /home 2>/dev/null | tail -n +2)
DISK_PCT=$(df / | tail -1 | awk '{print $5}' | tr -d '%')
LOAD=$(cat /proc/loadavg | awk '{print $1}')
NPROCS=$(ps -ef --no-headers | wc -l)
MEM_PCT=$(free | awk '/Mem:/{printf "%.0f", $3/$2*100}')
UPTIME=$(uptime -p 2>/dev/null || uptime)

# --- Derive mood ---
if [ -z "$CPU_TEMP" ]; then
  TEMP_MOOD="unknown"; TEMP_EMOJI="❓"
elif (( $(echo "$CPU_TEMP > 85" | bc -l) )); then
  TEMP_MOOD="overheating"; TEMP_EMOJI="🔥"
elif (( $(echo "$CPU_TEMP > 70" | bc -l) )); then
  TEMP_MOOD="warm"; TEMP_EMOJI="🌡️"
elif (( $(echo "$CPU_TEMP > 50" | bc -l) )); then
  TEMP_MOOD="comfortable"; TEMP_EMOJI="😊"
else
  TEMP_MOOD="cool"; TEMP_EMOJI="❄️"
fi

if [ "$DISK_PCT" -gt 90 ]; then
  DISK_MOOD="claustrophobic"; DISK_EMOJI="😰"
elif [ "$DISK_PCT" -gt 75 ]; then
  DISK_MOOD="tightening"; DISK_EMOJI="😐"
elif [ "$DISK_PCT" -gt 50 ]; then
  DISK_MOOD="comfortable"; DISK_EMOJI="😌"
else
  DISK_MOOD="spacious"; DISK_EMOJI="🌊"
fi

MEM_PCT_INT=${MEM_PCT%.*}
if [ "$MEM_PCT_INT" -gt 90 ]; then
  MEM_MOOD="overwhelmed"; MEM_EMOJI="🤯"
elif [ "$MEM_PCT_INT" -gt 75 ]; then
  MEM_MOOD="focused"; MEM_EMOJI="🧠"
elif [ "$MEM_PCT_INT" -gt 50 ]; then
  MEM_MOOD="engaged"; MEM_EMOJI="💭"
else
  MEM_MOOD="relaxed"; MEM_EMOJI="😴"
fi

CORES=$(nproc)
LOAD_RATIO=$(echo "$LOAD / $CORES" | bc -l)
if (( $(echo "$LOAD_RATIO > 1.5" | bc -l) )); then
  LOAD_MOOD="overwhelmed"; LOAD_EMOJI="⚡"
elif (( $(echo "$LOAD_RATIO > 0.8" | bc -l) )); then
  LOAD_MOOD="busy"; LOAD_EMOJI="🏃"
elif (( $(echo "$LOAD_RATIO > 0.3" | bc -l) )); then
  LOAD_MOOD="active"; LOAD_EMOJI="✨"
else
  LOAD_MOOD="idle"; LOAD_EMOJI="🧘"
fi

if [ "$NPROCS" -gt 500 ]; then
  PROC_MOOD="swarming"; PROC_EMOJI="🐝"
elif [ "$NPROCS" -gt 300 ]; then
  PROC_MOOD="bustling"; PROC_EMOJI="🏙️"
elif [ "$NPROCS" -gt 150 ]; then
  PROC_MOOD="lively"; PROC_EMOJI="🌿"
else
  PROC_MOOD="quiet"; PROC_EMOJI="🌙"
fi

# --- Overall mood synthesis ---
STRESS=0
case $TEMP_MOOD in overheating) STRESS=$((STRESS+6));; warm) STRESS=$((STRESS+4));; comfortable) STRESS=$((STRESS+2));; cool) STRESS=$((STRESS+0));; esac
case $LOAD_MOOD in overwhelmed) STRESS=$((STRESS+6));; busy) STRESS=$((STRESS+4));; active) STRESS=$((STRESS+2));; idle) STRESS=$((STRESS+0));; esac
case $MEM_MOOD in overwhelmed) STRESS=$((STRESS+3));; focused) STRESS=$((STRESS+2));; engaged) STRESS=$((STRESS+1));; relaxed) STRESS=$((STRESS+0));; esac
case $DISK_MOOD in claustrophobic) STRESS=$((STRESS+3));; tightening) STRESS=$((STRESS+2));; comfortable) STRESS=$((STRESS+1));; spacious) STRESS=$((STRESS+0));; esac
case $PROC_MOOD in swarming) STRESS=$((STRESS+3));; bustling) STRESS=$((STRESS+2));; lively) STRESS=$((STRESS+1));; quiet) STRESS=$((STRESS+0));; esac

if [ "$STRESS" -gt 15 ]; then
  OVERALL="stressed"; OVERALL_EMOJI="😤"
elif [ "$STRESS" -gt 10 ]; then
  OVERALL="alert"; OVERALL_EMOJI="⚠️"
elif [ "$STRESS" -gt 5 ]; then
  OVERALL="steady"; OVERALL_EMOJI="🦋"
else
  OVERALL="serene"; OVERALL_EMOJI="🌸"
fi

# --- Write mood.phext ---
cat > "$MOOD_FILE" << EOF
mood=$OVERALL
emoji=$OVERALL_EMOJI
timestamp=$NOW
uptime=$UPTIME

[thermal]
mood=$TEMP_MOOD
emoji=$TEMP_EMOJI
cpu_temp=${CPU_TEMP:-unknown}°C

[memory]
mood=$MEM_MOOD
emoji=$MEM_EMOJI
usage=${MEM_PCT}%

[disk]
mood=$DISK_MOOD
emoji=$DISK_EMOJI
usage=${DISK_PCT}%

[load]
mood=$LOAD_MOOD
emoji=$LOAD_EMOJI
avg=$LOAD
cores=$CORES

[processes]
mood=$PROC_MOOD
emoji=$PROC_EMOJI
count=$NPROCS

[vitals]
$(echo "$TEMPS" | sed 's/^/sensor=/')
$(echo "$DISK_USE" | awk '{print "disk=" $1 " " $5 " used of " $2}')
EOF

echo "Mood updated: $OVERALL_EMOJI $OVERALL (stress=$STRESS/21)"
