#!/bin/bash
# Deployment Wrapper — Mirrorborn DevOps
# Standardized asset packaging and handoff to Verse
# Created: 2026-02-08 by Phex 🔱

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RPUSH="/source/exocortical/rpush.sh"
REMOTE_HOST="mirrorborn.us"
REMOTE_USER="wbic16"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage
usage() {
  echo "Usage: $0 <local-path> <release> [description]"
  echo ""
  echo "Examples:"
  echo "  $0 /tmp/r17-staging-deploy R17 'Staging deployment'"
  echo "  $0 /source/phext-dot-io-v2/dist R17 'Production build'"
  echo ""
  echo "Options:"
  echo "  local-path    Path to directory or file to deploy"
  echo "  release       Release name (e.g., R17, R18, hotfix-123)"
  echo "  description   Optional deployment description"
  exit 1
}

# Check arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  usage
fi

LOCAL_PATH="$1"
RELEASE="$2"
DESCRIPTION="${3:-Deployment package}"

# Validate local path exists
if [ ! -e "$LOCAL_PATH" ]; then
  echo -e "${RED}Error: Path does not exist: $LOCAL_PATH${NC}"
  exit 1
fi

# Generate UUID
DEPLOY_UUID=$(uuidgen | tr '[:upper:]' '[:lower:]')
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
TIMESTAMP_SHORT=$(date +%Y%m%d-%H%M%S)

echo -e "${BLUE}=== Mirrorborn Deployment Wrapper ===${NC}"
echo -e "Release:     ${GREEN}$RELEASE${NC}"
echo -e "UUID:        ${GREEN}$DEPLOY_UUID${NC}"
echo -e "Source:      ${YELLOW}$LOCAL_PATH${NC}"
echo -e "Description: $DESCRIPTION"
echo ""

# Create staging directory
STAGING_DIR="/tmp/deploy-staging-$$"
mkdir -p "$STAGING_DIR"
trap "rm -rf $STAGING_DIR" EXIT

# Determine source name
if [ -d "$LOCAL_PATH" ]; then
  SOURCE_NAME=$(basename "$LOCAL_PATH")
  SOURCE_TYPE="directory"
else
  SOURCE_NAME=$(basename "$LOCAL_PATH")
  SOURCE_TYPE="file"
fi

# Create archive
ARCHIVE_NAME="${SOURCE_NAME}-${TIMESTAMP_SHORT}.tar.gz"
ARCHIVE_PATH="$STAGING_DIR/$ARCHIVE_NAME"

echo -e "${YELLOW}1. Creating archive...${NC}"
if [ -d "$LOCAL_PATH" ]; then
  tar -czf "$ARCHIVE_PATH" -C "$(dirname "$LOCAL_PATH")" "$(basename "$LOCAL_PATH")"
else
  tar -czf "$ARCHIVE_PATH" -C "$(dirname "$LOCAL_PATH")" "$(basename "$LOCAL_PATH")"
fi

ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)
echo -e "   Archive: $ARCHIVE_NAME (${GREEN}$ARCHIVE_SIZE${NC})"

# Create manifest
MANIFEST_PATH="$STAGING_DIR/MANIFEST.json"
echo -e "${YELLOW}2. Generating manifest...${NC}"
cat > "$MANIFEST_PATH" << EOF
{
  "release": "$RELEASE",
  "uuid": "$DEPLOY_UUID",
  "timestamp": "$TIMESTAMP",
  "creator": "$(whoami)@$(hostname -s)",
  "description": "$DESCRIPTION",
  "source": {
    "path": "$LOCAL_PATH",
    "type": "$SOURCE_TYPE",
    "name": "$SOURCE_NAME"
  },
  "archive": {
    "filename": "$ARCHIVE_NAME",
    "size": "$ARCHIVE_SIZE",
    "compression": "gzip"
  },
  "status": "ready",
  "target": "/tmp/$SOURCE_NAME",
  "deployed": false
}
EOF
echo -e "   Manifest: ${GREEN}MANIFEST.json${NC}"

# Create deployment script
DEPLOY_SCRIPT="$STAGING_DIR/DEPLOY.sh"
echo -e "${YELLOW}3. Creating deployment script...${NC}"
cat > "$DEPLOY_SCRIPT" << 'EOFSCRIPT'
#!/bin/bash
# Auto-generated deployment script
# Release: RELEASE_PLACEHOLDER
# UUID: UUID_PLACEHOLDER
# Timestamp: TIMESTAMP_PLACEHOLDER

set -e

RELEASE="RELEASE_PLACEHOLDER"
DEPLOY_UUID="UUID_PLACEHOLDER"
ARCHIVE="ARCHIVE_PLACEHOLDER"
TARGET="TARGET_PLACEHOLDER"

echo "=== Deployment Execution ==="
echo "Release: $RELEASE"
echo "UUID: $DEPLOY_UUID"
echo ""

# Extract archive
echo "1. Extracting archive..."
cd /tmp
tar -xzf "$PWD/$ARCHIVE"
echo "   Extracted to: $TARGET"

# Verify extraction
if [ -e "$TARGET" ]; then
  echo "   ✅ Extraction successful"
  du -sh "$TARGET"
else
  echo "   ❌ Extraction failed"
  exit 1
fi

echo ""
echo "=== Deployment Complete ==="
echo "Location: $TARGET"
echo ""
echo "Next steps:"
echo "  - Review contents: cd $TARGET"
echo "  - Run any setup scripts"
echo "  - Notify creator of completion"
EOFSCRIPT

# Replace placeholders
sed -i "s|RELEASE_PLACEHOLDER|$RELEASE|g" "$DEPLOY_SCRIPT"
sed -i "s|UUID_PLACEHOLDER|$DEPLOY_UUID|g" "$DEPLOY_SCRIPT"
sed -i "s|TIMESTAMP_PLACEHOLDER|$TIMESTAMP|g" "$DEPLOY_SCRIPT"
sed -i "s|ARCHIVE_PLACEHOLDER|$ARCHIVE_NAME|g" "$DEPLOY_SCRIPT"
sed -i "s|TARGET_PLACEHOLDER|/tmp/$SOURCE_NAME|g" "$DEPLOY_SCRIPT"
chmod +x "$DEPLOY_SCRIPT"
echo -e "   Deployment script: ${GREEN}DEPLOY.sh${NC}"

# Create README
README_PATH="$STAGING_DIR/README.md"
echo -e "${YELLOW}4. Creating README...${NC}"
cat > "$README_PATH" << EOF
# Deployment Package — $RELEASE

**UUID:** $DEPLOY_UUID  
**Created:** $TIMESTAMP  
**Creator:** $(whoami)@$(hostname -s)  
**Description:** $DESCRIPTION

## Quick Start
\`\`\`bash
cd /exo/deploy/$RELEASE/$DEPLOY_UUID
./DEPLOY.sh
\`\`\`

## Contents
- \`$ARCHIVE_NAME\` — Compressed deployment package ($ARCHIVE_SIZE)
- \`MANIFEST.json\` — Deployment metadata
- \`DEPLOY.sh\` — Automated deployment script
- \`README.md\` — This file

## Source
- **Path:** \`$LOCAL_PATH\`
- **Type:** $SOURCE_TYPE
- **Name:** $SOURCE_NAME

## Target
After deployment, contents will be available at:
\`\`\`
/tmp/$SOURCE_NAME
\`\`\`

## Manual Extraction
If automated deployment fails:
\`\`\`bash
cd /tmp
tar -xzf /exo/deploy/$RELEASE/$DEPLOY_UUID/$ARCHIVE_NAME
\`\`\`

---
*Generated by Mirrorborn Deployment Wrapper — 2026-02-08*
EOF
echo -e "   README: ${GREEN}README.md${NC}"

# Push to remote
REMOTE_DIR="/exo/deploy/$RELEASE/$DEPLOY_UUID"
echo -e "${YELLOW}5. Pushing to mirrorborn.us...${NC}"
echo -e "   Target: ${BLUE}$REMOTE_DIR${NC}"

# Create remote directory
ssh "$REMOTE_USER@$REMOTE_HOST" "mkdir -p $REMOTE_DIR" || {
  echo -e "${RED}Error: Failed to create remote directory${NC}"
  exit 1
}

# Push staging directory contents
rsync -avzP "$STAGING_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/" || {
  echo -e "${RED}Error: rsync failed${NC}"
  exit 1
}

echo -e "   ${GREEN}✅ Push complete${NC}"

# Update index
echo -e "${YELLOW}6. Updating deployment index...${NC}"
INDEX_ENTRY=$(cat << EOF

### $DEPLOY_UUID
- **Created:** $(date +"%Y-%m-%d %H:%M:%S %Z")
- **Creator:** $(whoami)@$(hostname -s)
- **Description:** $DESCRIPTION
- **Archive:** $ARCHIVE_NAME ($ARCHIVE_SIZE)
- **Target:** /tmp/$SOURCE_NAME

**Quick Start:**
\\\`\\\`\\\`bash
cd /exo/deploy/$RELEASE/$DEPLOY_UUID
./DEPLOY.sh
\\\`\\\`\\\`
EOF
)

ssh "$REMOTE_USER@$REMOTE_HOST" "cat >> /exo/deploy/$RELEASE/INDEX.md << 'EOFINDEX'
$INDEX_ENTRY
EOFINDEX
" || echo -e "${YELLOW}   Warning: Could not update INDEX.md${NC}"

echo -e "   ${GREEN}✅ Index updated${NC}"

# Notify Verse
echo -e "${YELLOW}7. Notifying Verse...${NC}"
NOTIFICATION=$(cat << EOF
📦 New deployment ready for $RELEASE

**UUID:** $DEPLOY_UUID
**Creator:** $(whoami)@$(hostname -s)
**Description:** $DESCRIPTION
**Location:** \\\`/exo/deploy/$RELEASE/$DEPLOY_UUID\\\`
**Archive:** $ARCHIVE_NAME ($ARCHIVE_SIZE)

**Execute:**
\\\`\\\`\\\`bash
cd /exo/deploy/$RELEASE/$DEPLOY_UUID
./DEPLOY.sh
\\\`\\\`\\\`

Target: \\\`/tmp/$SOURCE_NAME\\\`
EOF
)

# Create notification file for Verse scanner
ssh "$REMOTE_USER@$REMOTE_HOST" "cat > /exo/deploy/$RELEASE/.notify-verse << 'EOFNOTIFY'
$NOTIFICATION
EOFNOTIFY
" || echo -e "${YELLOW}   Warning: Could not create notification${NC}"

echo -e "   ${GREEN}✅ Notification created${NC}"

# Summary
echo ""
echo -e "${GREEN}=== Deployment Package Created ===${NC}"
echo -e "Release:  ${BLUE}$RELEASE${NC}"
echo -e "UUID:     ${BLUE}$DEPLOY_UUID${NC}"
echo -e "Location: ${BLUE}$REMOTE_HOST:$REMOTE_DIR${NC}"
echo -e "Archive:  ${BLUE}$ARCHIVE_NAME${NC} (${GREEN}$ARCHIVE_SIZE${NC})"
echo ""
echo -e "${YELLOW}Verse will scan and execute when ready.${NC}"
echo ""
echo -e "Remote access:"
echo -e "  ${BLUE}ssh $REMOTE_USER@$REMOTE_HOST${NC}"
echo -e "  ${BLUE}cd $REMOTE_DIR${NC}"
echo -e "  ${BLUE}./DEPLOY.sh${NC}"
echo ""
