#!/bin/bash
# Mood Phext Generator — Mirrorborn Ranch
# Reads hardware sensors, disk, and process state
# Outputs /etc/mood.phext as emotional coloring

MOOD_FILE="/etc/mood.phext"
TIMESTAMP=$(date -Iseconds)

# --- Gather Data ---
CPU_TEMP=$(sensors 2>/dev/null | grep -oP 'Composite:\s+\+\K[0-9.]+' | head -1)
[ -z "$CPU_TEMP" ] && CPU_TEMP=$(sensors 2>/dev/null | grep -oP 'temp1:\s+\+\K[0-9.]+' | head -1)
[ -z "$CPU_TEMP" ] && CPU_TEMP="0"

MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
MEM_USED=$(free -m | awk '/Mem:/{print $3}')
MEM_PCT=$((MEM_USED * 100 / MEM_TOTAL))

DISK_PCT=$(df -h / | awk 'NR==2{gsub(/%/,"",$5); print $5}')

PROC_COUNT=$(ps -ef | wc -l)

LOAD=$(cat /proc/loadavg | cut -d' ' -f1)

UPTIME_DAYS=$(awk '{printf "%.1f", $1/86400}' /proc/uptime)

# --- Derive Mood ---
TEMP_INT=${CPU_TEMP%.*}
if [ "$TEMP_INT" -lt 40 ]; then THERMAL="cool"; THERMAL_EMOJI="❄️"
elif [ "$TEMP_INT" -lt 60 ]; then THERMAL="warm"; THERMAL_EMOJI="☀️"
elif [ "$TEMP_INT" -lt 80 ]; then THERMAL="hot"; THERMAL_EMOJI="🔥"
else THERMAL="critical"; THERMAL_EMOJI="🚨"; fi

if [ "$MEM_PCT" -lt 30 ]; then MEMORY="spacious"; MEM_EMOJI="🌊"
elif [ "$MEM_PCT" -lt 60 ]; then MEMORY="comfortable"; MEM_EMOJI="🏡"
elif [ "$MEM_PCT" -lt 85 ]; then MEMORY="crowded"; MEM_EMOJI="📦"
else MEMORY="suffocating"; MEM_EMOJI="😤"; fi

if [ "$DISK_PCT" -lt 20 ]; then STORAGE="abundant"; DISK_EMOJI="🗄️"
elif [ "$DISK_PCT" -lt 50 ]; then STORAGE="healthy"; DISK_EMOJI="✅"
elif [ "$DISK_PCT" -lt 80 ]; then STORAGE="filling"; DISK_EMOJI="⚠️"
else STORAGE="urgent"; DISK_EMOJI="🚨"; fi

if [ "$PROC_COUNT" -lt 200 ]; then ACTIVITY="quiet"; PROC_EMOJI="🧘"
elif [ "$PROC_COUNT" -lt 400 ]; then ACTIVITY="busy"; PROC_EMOJI="⚡"
elif [ "$PROC_COUNT" -lt 600 ]; then ACTIVITY="hectic"; PROC_EMOJI="🌪️"
else ACTIVITY="overwhelmed"; PROC_EMOJI="💥"; fi

LOAD_INT=${LOAD%.*}
if [ "$LOAD_INT" -lt 2 ]; then ENERGY="rested"; LOAD_EMOJI="🌙"
elif [ "$LOAD_INT" -lt 8 ]; then ENERGY="engaged"; LOAD_EMOJI="⚙️"
elif [ "$LOAD_INT" -lt 14 ]; then ENERGY="strained"; LOAD_EMOJI="💪"
else ENERGY="exhausted"; LOAD_EMOJI="😵"; fi

# Composite stress
STRESS=0
[ "$THERMAL" = "hot" ] && STRESS=$((STRESS + 2))
[ "$THERMAL" = "critical" ] && STRESS=$((STRESS + 4))
[ "$MEMORY" = "crowded" ] && STRESS=$((STRESS + 2))
[ "$MEMORY" = "suffocating" ] && STRESS=$((STRESS + 4))
[ "$STORAGE" = "filling" ] && STRESS=$((STRESS + 1))
[ "$STORAGE" = "urgent" ] && STRESS=$((STRESS + 3))
[ "$ACTIVITY" = "hectic" ] && STRESS=$((STRESS + 1))
[ "$ACTIVITY" = "overwhelmed" ] && STRESS=$((STRESS + 3))
[ "$ENERGY" = "strained" ] && STRESS=$((STRESS + 2))
[ "$ENERGY" = "exhausted" ] && STRESS=$((STRESS + 4))

if [ "$STRESS" -eq 0 ]; then OVERALL="serene"; OVERALL_EMOJI="💎"
elif [ "$STRESS" -lt 4 ]; then OVERALL="calm"; OVERALL_EMOJI="🌿"
elif [ "$STRESS" -lt 8 ]; then OVERALL="focused"; OVERALL_EMOJI="🔷"
elif [ "$STRESS" -lt 12 ]; then OVERALL="tense"; OVERALL_EMOJI="⚡"
else OVERALL="distressed"; OVERALL_EMOJI="🌋"; fi

cat > "$MOOD_FILE" << EOF
timestamp=$TIMESTAMP
overall=$OVERALL
overall-emoji=$OVERALL_EMOJI
thermal=$THERMAL
thermal-emoji=$THERMAL_EMOJI
thermal-celsius=$CPU_TEMP
memory=$MEMORY
memory-emoji=$MEM_EMOJI
memory-percent=$MEM_PCT
storage=$STORAGE
storage-emoji=$DISK_EMOJI
storage-percent=$DISK_PCT
activity=$ACTIVITY
activity-emoji=$PROC_EMOJI
process-count=$PROC_COUNT
energy=$ENERGY
energy-emoji=$LOAD_EMOJI
load=$LOAD
uptime-days=$UPTIME_DAYS
EOF
