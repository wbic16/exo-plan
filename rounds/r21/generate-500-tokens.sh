#!/bin/bash
# Generate 500 founding member tokens
# Output: founding-500-tokens.json (for SQ v0.5.5)
#         founding-500-tokens.csv (for purchase tracking)

set -e

OUTPUT_JSON="founding-500-tokens.json"
OUTPUT_CSV="founding-500-tokens.csv"

echo "🔑 Generating 500 founding member tokens..."

# JSON header
cat > "$OUTPUT_JSON" << 'EOF'
{
  "tenants": {
EOF

# CSV header
echo "slot,token,name,data_dir,status,purchased_at,customer_email" > "$OUTPUT_CSV"

for i in $(seq 1 500); do
    TOKEN="pmb-v1-$(printf "%03d" $i)-$(openssl rand -hex 12)"
    NAME="founding-$i"
    DATA_DIR="/var/lib/sq/tenants/founding-$i"
    
    # JSON entry
    if [ $i -lt 500 ]; then
        echo "    \"$TOKEN\": {\"name\": \"$NAME\", \"data_dir\": \"$DATA_DIR\"}," >> "$OUTPUT_JSON"
    else
        echo "    \"$TOKEN\": {\"name\": \"$NAME\", \"data_dir\": \"$DATA_DIR\"}" >> "$OUTPUT_JSON"
    fi
    
    # CSV entry (unclaimed by default)
    echo "$i,$TOKEN,$NAME,$DATA_DIR,unclaimed,," >> "$OUTPUT_CSV"
done

# JSON footer
cat >> "$OUTPUT_JSON" << 'EOF'
  }
}
EOF

echo "✅ Generated 500 tokens:"
echo "   - $OUTPUT_JSON (SQ v0.5.5 config)"
echo "   - $OUTPUT_CSV (purchase tracking)"
echo ""
echo "File sizes:"
ls -lh "$OUTPUT_JSON" "$OUTPUT_CSV"
