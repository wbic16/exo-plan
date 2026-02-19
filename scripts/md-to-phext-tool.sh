#!/bin/bash
# MD → Phext Reasoning Space Tool

MD_DIR=$1
PHEXT_COORD=$2 || \"1.1.1/docs\"
OUT_DIR=\"/tmp/phext-$RANDOM\"

mkdir -p $OUT_DIR

# 1. TOC coords from MD hierarchy
find $MD_DIR -name '*.md' | sort | nl -nln | awk '{printf \"%s/%d.%d.%d\n\", ENVIRON[\"PHEXT_COORD\"], $1%100, ($1/100)%100, $1/10000}' | while read coord file; do
  mkdir -p $(dirname $OUT_DIR/$coord)
  cp $file $OUT_DIR/$coord.md
done

# 2. SQ push
sq write $OUT_DIR $PHEXT_COORD

# 3. Reasoning query
echo \"Query space: $PHEXT_COORD\"

# Usage: ./md-to-phext-tool.sh /docs/p25 3.3.3/P25
