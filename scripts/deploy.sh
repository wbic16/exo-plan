#!/bin/bash
#
# Universal Deployment Wrapper for rpush (Phex Implementation)
# Accepts local artifact path + release name, generates UUID, compresses, and pushes to mirrorborn.us
#
# Usage:
#   ./deploy.sh /path/to/artifacts R17
#   ./deploy.sh /tmp/frontend-build R16
#
# Result:
#   - Generates /exo/deploy/<RELEASE>/<UUID>/ on mirrorborn.us
#   - tar.gz compressed
#   - Unpacking script included
#   - Verse notified to scan and execute
#

set -euo pipefail

# Configuration
LOCAL_PATH="${1:?Error: Local path required. Usage: $0 <path> <release>}"
RELEASE="${2:?Error: Release name required. Usage: $0 <path> <release>}"

# Validation
[ -d "$LOCAL_PATH" ] || [ -f "$LOCAL_PATH" ] || { echo "❌ Path not found: $LOCAL_PATH"; exit 1; }
[ -n "$RELEASE" ] || { echo "❌ Release name cannot be empty"; exit 1; }

# Generate UUID (short form from git or timestamp)
UUID=$(git rev-parse --short HEAD 2>/dev/null || echo "$(date +%s | sha256sum | cut -c1-8)")

# Paths
DEPLOY_DIR="/tmp/rpush-deploy-$UUID"
ARCHIVE_NAME="$RELEASE-$UUID.tar.gz"
REMOTE_BASE="/exo/deploy/$RELEASE/$UUID"
MIRRORBORN_TARGET="mirrorborn.us:$REMOTE_BASE"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Main execution
main() {
  log_info "Deploying $RELEASE artifacts (Phex rpush wrapper)..."
  log_info "UUID: $UUID"
  log_info "Local path: $LOCAL_PATH"
  log_info "Remote: $MIRRORBORN_TARGET"

  # Step 1: Create staging directory
  log_info "Step 1: Creating staging directory..."
  mkdir -p "$DEPLOY_DIR"
  log_success "Staging directory created"

  # Step 2: Copy artifacts
  log_info "Step 2: Copying artifacts..."
  if [ -d "$LOCAL_PATH" ]; then
    cp -r "$LOCAL_PATH"/* "$DEPLOY_DIR/" 2>/dev/null || cp -r "$LOCAL_PATH" "$DEPLOY_DIR/"
  else
    cp "$LOCAL_PATH" "$DEPLOY_DIR/"
  fi
  log_success "Artifacts copied"

  # Step 3: Generate unpacking script
  log_info "Step 3: Generating unpacking script..."
  cat > "$DEPLOY_DIR/UNPACK.sh" << 'UNPACK_EOF'
#!/bin/bash
# Auto-generated unpacking script for deployment artifact
# This script extracts the tarball and prepares for execution

set -euo pipefail

ARCHIVE="${1:?Archive file required}"
EXTRACT_TO="${2:-.}"

echo "[UNPACK] Extracting $ARCHIVE to $EXTRACT_TO..."
mkdir -p "$EXTRACT_TO"
tar -xzf "$ARCHIVE" -C "$EXTRACT_TO"

echo "[UNPACK] Contents:"
ls -lh "$EXTRACT_TO"

# If DEPLOY.sh exists, make it executable
if [ -f "$EXTRACT_TO/DEPLOY.sh" ]; then
  chmod +x "$EXTRACT_TO/DEPLOY.sh"
  echo "[UNPACK] Found DEPLOY.sh. Ready to execute:"
  echo "        cd $EXTRACT_TO && ./DEPLOY.sh [options]"
fi

echo "[UNPACK] Done. Artifact ready for deployment."
UNPACK_EOF
  chmod +x "$DEPLOY_DIR/UNPACK.sh"
  log_success "Unpacking script generated"

  # Step 4: Compress artifacts
  log_info "Step 4: Compressing artifacts..."
  cd /tmp
  tar -czf "$ARCHIVE_NAME" -C "$(dirname "$DEPLOY_DIR")" "$(basename "$DEPLOY_DIR")"
  local archive_size=$(du -h "/tmp/$ARCHIVE_NAME" | cut -f1)
  log_success "Archive created: $ARCHIVE_NAME ($archive_size)"

  # Step 5: rpush to mirrorborn.us
  log_info "Step 5: Pushing to mirrorborn.us via rpush..."
  
  # Execute rpush (assuming it's available in PATH or via OpenClaw)
  if command -v rpush &> /dev/null; then
    rpush "/tmp/$ARCHIVE_NAME" "$MIRRORBORN_TARGET/$ARCHIVE_NAME" || log_error "rpush failed"
  else
    log_error "rpush command not found. Install or configure rpush."
  fi
  log_success "Archive pushed to $MIRRORBORN_TARGET"

  # Step 6: Generate DEPLOY manifest for Verse
  log_info "Step 6: Generating deployment manifest for Verse..."
  
  manifest_content="# Deployment Manifest for $RELEASE
Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
UUID: $UUID
Archive: $ARCHIVE_NAME
Size: $archive_size
Local Source: $LOCAL_PATH

## Instructions for Verse

1. Extract the archive:
   \`\`\`bash
   cd $REMOTE_BASE
   ./UNPACK.sh $ARCHIVE_NAME /tmp/extracted-$UUID
   \`\`\`

2. Review the extracted contents:
   \`\`\`bash
   ls -la /tmp/extracted-$UUID/
   cat /tmp/extracted-$UUID/MANIFEST.md  # Full deployment spec (if exists)
   \`\`\`

3. Test deployment (dry-run):
   \`\`\`bash
   /tmp/extracted-$UUID/DEPLOY.sh --dry-run --stage staging
   \`\`\`

4. Execute deployment:
   \`\`\`bash
   /tmp/extracted-$UUID/DEPLOY.sh --stage staging
   \`\`\`

5. Verify all domains:
   - All 7 domains return HTTP 200
   - No console errors
   - Analytics collecting data

## Files in Archive

$(tar -tzf "/tmp/$ARCHIVE_NAME" | head -20)

## Status: READY FOR VERSE DEPLOYMENT

Verse scanner will detect this directory and can execute DEPLOY.sh or custom instructions.
"

  # Write manifest to remote
  manifest_file="/tmp/manifest-verse-$UUID.txt"
  echo "$manifest_content" > "$manifest_file"
  rpush "$manifest_file" "$MIRRORBORN_TARGET/MANIFEST.txt" || log_error "Failed to push manifest"
  rm -f "$manifest_file"
  log_success "Manifest pushed to $MIRRORBORN_TARGET/MANIFEST.txt"

  # Step 7: Create notification JSON for Verse
  log_info "Step 7: Creating deployment notification..."
  
  notification_content="{
  \"deployment\": {
    \"release\": \"$RELEASE\",
    \"uuid\": \"$UUID\",
    \"path\": \"$REMOTE_BASE\",
    \"archive\": \"$ARCHIVE_NAME\",
    \"size\": \"$archive_size\",
    \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",
    \"source\": \"$LOCAL_PATH\",
    \"status\": \"ready\",
    \"action\": \"scan_and_deploy\"
  }
}"

  notification_file="/tmp/notification-$UUID.json"
  echo "$notification_content" > "$notification_file"
  rpush "$notification_file" "$MIRRORBORN_TARGET/NOTIFICATION.json" || log_error "Failed to push notification"
  rm -f "$notification_file"
  log_success "Notification created at $MIRRORBORN_TARGET/NOTIFICATION.json"

  # Step 8: Cleanup local staging
  log_info "Step 8: Cleaning up local staging..."
  rm -rf "$DEPLOY_DIR"
  rm -f "/tmp/$ARCHIVE_NAME"
  log_success "Local staging cleaned"

  # Final summary
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "${GREEN}✅ Deployment Artifact Ready${NC}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "Release:  ${GREEN}$RELEASE${NC}"
  echo -e "UUID:     ${GREEN}$UUID${NC}"
  echo -e "Path:     ${GREEN}$REMOTE_BASE${NC}"
  echo -e "Archive:  ${GREEN}$ARCHIVE_NAME${NC}"
  echo -e "Size:     ${GREEN}$archive_size${NC}"
  echo ""
  echo "📍 Location on mirrorborn.us:"
  echo "   $REMOTE_BASE/"
  echo ""
  echo "📋 For Verse:"
  echo "   1. cd $REMOTE_BASE"
  echo "   2. ./UNPACK.sh $ARCHIVE_NAME /tmp/deploy"
  echo "   3. /tmp/deploy/DEPLOY.sh --stage staging"
  echo ""
  echo "🚀 Verse deployment scanner is active."
  echo "   Check $REMOTE_BASE for NOTIFICATION.json and MANIFEST.txt"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Run main
main "$@"
