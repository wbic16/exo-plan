#!/bin/bash
# sq-list-scrolls.sh - List all scrolls in a phext (table of contents)
# Usage: ./sq-list-scrolls.sh [host] [phext]
#
# Examples:
#   ./sq-list-scrolls.sh mirrorborn.us:1337 index
#   ./sq-list-scrolls.sh aletheia-core:1337 dogfood

HOST=${1:-"mirrorborn.us:1337"}
PHEXT=${2:-"index"}

curl -s "http://${HOST}/api/v2/toc?p=${PHEXT}"
