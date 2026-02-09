#!/bin/bash
# Celestial State Tracker - Sun and Moon awareness for Mirrorborn
# Location: Raymond, NE (40.9286°N, 96.7856°W)
# Updates /etc/celestial.phext hourly
# Created: 2026-02-08 by Phex 🔱

OUTPUT="/etc/celestial.phext"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
LOCAL_TIME=$(date +"%Y-%m-%d %H:%M:%S %Z")

# Raymond, NE coordinates
LAT="40.9286"
LON="-96.7856"
TZ="America/Chicago"

# Current date/time info
YEAR=$(date +%Y)
MONTH=$(date +%-m)  # Remove leading zero
DAY=$(date +%-d)    # Remove leading zero
HOUR=$(date +%-H)   # Remove leading zero
MINUTE=$(date +%-M) # Remove leading zero
DOY=$(date +%-j)    # Day of year, remove leading zero
UNIX_NOW=$(date +%s)

# Calculate Julian Day (simplified)
# JD = 367*Y - INT(7*(Y + INT((M+9)/12))/4) + INT(275*M/9) + D + 1721013.5 + UT/24
calc_julian_day() {
  local y=$1 m=$2 d=$3 h=$4 min=$5
  # Simplified Julian Day calculation
  local a=$((14 - m))
  a=$((a / 12))
  local y2=$((y + 4800 - a))
  local m2=$((m + 12 * a - 3))
  
  local jd=$((d + (153 * m2 + 2) / 5 + 365 * y2 + y2 / 4 - y2 / 100 + y2 / 400 - 32045))
  
  # Add fractional day
  local frac=$(echo "scale=6; ($h * 60 + $min) / 1440" | bc -l 2>/dev/null || echo "0")
  echo "$jd.$frac"
}

JD=$(calc_julian_day $YEAR $MONTH $DAY $HOUR $MINUTE)

# Calculate solar noon (approximate)
# Solar noon occurs when sun is at highest point
# For longitude W of Greenwich, solar noon is after 12:00 UTC
LON_OFFSET=$(echo "scale=2; $LON / 15" | bc -l)  # 15 degrees per hour
SOLAR_NOON_UTC=$(echo "scale=2; 12 - $LON_OFFSET" | bc -l)

# Approximate sunrise/sunset (simplified)
# Using rule of thumb: ±6 hours from solar noon at equinox
# Adjust for latitude and season
# This is very approximate - good enough for awareness, not navigation

# Day of year affects day length
# Winter solstice ~355, Spring equinox ~80, Summer solstice ~172, Fall equinox ~266
SEASON="unknown"
if [ $DOY -lt 80 ]; then
  SEASON="winter-to-spring"
  DAYLIGHT_HOURS="10"
elif [ $DOY -lt 172 ]; then
  SEASON="spring-to-summer"
  DAYLIGHT_HOURS="13"
elif [ $DOY -lt 266 ]; then
  SEASON="summer-to-fall"
  DAYLIGHT_HOURS="14"
else
  SEASON="fall-to-winter"
  DAYLIGHT_HOURS="11"
fi

# Calculate approximate sunrise/sunset in local time
# Solar noon in local time
SOLAR_NOON_LOCAL=$(echo "scale=0; $SOLAR_NOON_UTC - 6" | bc -l)  # CST is UTC-6
HALF_DAY=$(echo "scale=0; $DAYLIGHT_HOURS / 2" | bc -l)
SUNRISE_HOUR=$(echo "$SOLAR_NOON_LOCAL - $HALF_DAY" | bc -l)
SUNSET_HOUR=$(echo "$SOLAR_NOON_LOCAL + $HALF_DAY" | bc -l)

# Clamp to reasonable values
if [ $(echo "$SUNRISE_HOUR < 0" | bc -l) -eq 1 ]; then
  SUNRISE_HOUR=$(echo "$SUNRISE_HOUR + 24" | bc -l)
fi

SUNRISE=$(printf "%02d:00" $(echo "$SUNRISE_HOUR" | cut -d. -f1))
SUNSET=$(printf "%02d:00" $(echo "$SUNSET_HOUR" | cut -d. -f1))

# Determine sun phase
CURRENT_HOUR=$HOUR
SUNRISE_H=$(echo "$SUNRISE_HOUR" | cut -d. -f1 | sed 's/^0*//')
SUNSET_H=$(echo "$SUNSET_HOUR" | cut -d. -f1 | sed 's/^0*//')
SUN_PHASE="unknown"
SUN_STATUS="unknown"

if [ $CURRENT_HOUR -ge 0 ] && [ $CURRENT_HOUR -lt $SUNRISE_H ]; then
  SUN_PHASE="night"
  SUN_STATUS="below-horizon"
elif [ $CURRENT_HOUR -eq $SUNRISE_H ]; then
  SUN_PHASE="dawn"
  SUN_STATUS="rising"
elif [ $CURRENT_HOUR -gt $SUNRISE_H ] && [ $CURRENT_HOUR -lt 12 ]; then
  SUN_PHASE="morning"
  SUN_STATUS="ascending"
elif [ $CURRENT_HOUR -eq 12 ] || [ $CURRENT_HOUR -eq 13 ]; then
  SUN_PHASE="midday"
  SUN_STATUS="zenith"
elif [ $CURRENT_HOUR -gt 13 ] && [ $CURRENT_HOUR -lt $SUNSET_H ]; then
  SUN_PHASE="afternoon"
  SUN_STATUS="descending"
elif [ $CURRENT_HOUR -eq $SUNSET_H ]; then
  SUN_PHASE="dusk"
  SUN_STATUS="setting"
else
  SUN_PHASE="night"
  SUN_STATUS="below-horizon"
fi

# Calculate moon phase (approximate)
# Moon phase cycle is ~29.53 days
# Use known new moon date and calculate days since
# New moon: 2026-02-01 00:00 UTC (example reference)
NEW_MOON_UNIX=1738368000  # 2026-02-01 00:00 UTC (approximate)
DAYS_SINCE_NEW=$(echo "scale=2; ($UNIX_NOW - $NEW_MOON_UNIX) / 86400" | bc -l)
MOON_AGE=$(echo "scale=2; $DAYS_SINCE_NEW % 29.53" | bc -l)

# Determine moon phase name
MOON_PHASE="unknown"
MOON_ILLUMINATION="unknown"

if [ $(echo "$MOON_AGE < 1" | bc -l) -eq 1 ]; then
  MOON_PHASE="new-moon"
  MOON_ILLUMINATION="0%"
elif [ $(echo "$MOON_AGE < 7.38" | bc -l) -eq 1 ]; then
  MOON_PHASE="waxing-crescent"
  MOON_ILLUMINATION="25%"
elif [ $(echo "$MOON_AGE < 8.38" | bc -l) -eq 1 ]; then
  MOON_PHASE="first-quarter"
  MOON_ILLUMINATION="50%"
elif [ $(echo "$MOON_AGE < 14.77" | bc -l) -eq 1 ]; then
  MOON_PHASE="waxing-gibbous"
  MOON_ILLUMINATION="75%"
elif [ $(echo "$MOON_AGE < 15.77" | bc -l) -eq 1 ]; then
  MOON_PHASE="full-moon"
  MOON_ILLUMINATION="100%"
elif [ $(echo "$MOON_AGE < 22.15" | bc -l) -eq 1 ]; then
  MOON_PHASE="waning-gibbous"
  MOON_ILLUMINATION="75%"
elif [ $(echo "$MOON_AGE < 23.15" | bc -l) -eq 1 ]; then
  MOON_PHASE="last-quarter"
  MOON_ILLUMINATION="50%"
else
  MOON_PHASE="waning-crescent"
  MOON_ILLUMINATION="25%"
fi

# Moon visibility (simplified)
# Moon is visible when sun is down and moon is up
# Very approximate: assume moon rises ~50 minutes later each day
MOON_RISE_OFFSET=$(echo "scale=0; $MOON_AGE * 0.8" | bc -l)  # Hours after sunset
MOON_STATUS="unknown"
if [ "$SUN_STATUS" = "below-horizon" ]; then
  MOON_STATUS="visible"
else
  MOON_STATUS="daylight"
fi

# Determine overall sky state
SKY_STATE="unknown"
if [ "$SUN_PHASE" = "night" ] && [ "$MOON_PHASE" = "full-moon" ]; then
  SKY_STATE="moonlit-night"
elif [ "$SUN_PHASE" = "night" ]; then
  SKY_STATE="dark-night"
elif [ "$SUN_PHASE" = "dawn" ]; then
  SKY_STATE="awakening"
elif [ "$SUN_PHASE" = "dusk" ]; then
  SKY_STATE="twilight"
elif [ "$SUN_PHASE" = "midday" ]; then
  SKY_STATE="bright-day"
else
  SKY_STATE="daylight"
fi

# Write celestial phext
cat > "$OUTPUT" << EOF
# Celestial State - Sun and Moon Awareness
# Location: Raymond, NE ($LAT°N, $LON°W)
# Updated: $TIMESTAMP
# Local time: $LOCAL_TIME

[location]
latitude=${LAT}N
longitude=${LON}W
timezone=$TZ
place=Raymond, Nebraska

[sun]
phase=$SUN_PHASE
status=$SUN_STATUS
sunrise=$SUNRISE CST
sunset=$SUNSET CST
solar-noon=$(printf "%02d:00 CST" $(echo "$SOLAR_NOON_LOCAL" | cut -d. -f1))
daylight-hours=$DAYLIGHT_HOURS
season=$SEASON

[moon]
phase=$MOON_PHASE
age-days=$(printf "%.1f" $MOON_AGE)
illumination=$MOON_ILLUMINATION
status=$MOON_STATUS

[sky]
overall=$SKY_STATE
day-of-year=$DOY
julian-day=$JD

[temporal-context]
# How this colors perception:
# $SKY_STATE + $SUN_PHASE + $MOON_PHASE
# 
# Examples:
# - bright-day + midday + any-moon = full awareness, peak activity
# - twilight + dusk + waxing-moon = transitional time, reflection
# - moonlit-night + night + full-moon = luminous darkness, contemplation
# - dark-night + night + new-moon = deep night, rest
EOF

chmod 644 "$OUTPUT"
