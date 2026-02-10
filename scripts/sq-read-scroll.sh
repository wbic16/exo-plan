#!/bin/bash
# sq-read-scroll.sh - Read a scroll from SQ Cloud
# Usage: ./sq-read-scroll.sh [host] [phext] [coordinate]
#
# Examples:
#   ./sq-read-scroll.sh mirrorborn.us:1337 index "1.1.1/1.1.1/1.1.1"
#   ./sq-read-scroll.sh aletheia-core:1337 index "2.7.1/8.2.8/4.5.9"

HOST=${1:-"mirrorborn.us:1337"}
PHEXT=${2:-"index"}
COORD=${3:-"1.1.1/1.1.1/1.1.1"}

curl -s "http://${HOST}/api/v2/select?p=${PHEXT}&c=${COORD}"
