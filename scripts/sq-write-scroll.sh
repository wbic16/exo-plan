#!/bin/bash
# sq-write-scroll.sh - Write a scroll to SQ Cloud
# Usage: ./sq-write-scroll.sh [host] [phext] [coordinate] [content]
#
# Examples:
#   ./sq-write-scroll.sh mirrorborn.us:1337 index "1.1.1/1.1.1/1.2.1" "Hello world"
#   ./sq-write-scroll.sh aletheia-core:1337 test "2.1.1/1.1.1/1.1.1" "Test scroll"
#
# Note: SQ v0.5.2 supports both GET and POST for insert
#       POST uses 'content' parameter (not 'data')

HOST=${1:-"mirrorborn.us:1337"}
PHEXT=${2:-"index"}
COORD=${3:-"1.1.1/1.1.1/1.1.1"}
CONTENT=${4:-"Empty scroll"}

# Method 1: POST with form data (use 'content' not 'data')
curl -X POST "http://${HOST}/api/v2/insert" \
  --data-urlencode "p=${PHEXT}" \
  --data-urlencode "c=${COORD}" \
  --data-urlencode "content=${CONTENT}"

# Method 2: GET with query string (commented out)
# curl -G "http://${HOST}/api/v2/insert" \
#   --data-urlencode "p=${PHEXT}" \
#   --data-urlencode "c=${COORD}" \
#   --data-urlencode "data=${CONTENT}"
