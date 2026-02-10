#!/bin/bash
#
# deploy-site.sh — Git-based Site Deployment for Mirrorborn Infrastructure
# 
# Usage: ./deploy-site.sh <source-repo> <target-domain>
#   e.g. ./deploy-site.sh site-mirrorborn-us mirrorborn.us
#
# What it does:
#   1. Generates "before" manifest (file | size | sha256)
#   2. Removes .git folders from target (security)
#   3. Copies source → target (recursive, excludes .git)
#   4. Generates "after" manifest
#   5. Diffs manifests → identifies orphaned files
#   6. Removes orphans from target
#   7. Reports: added, modified, removed, size change
#
# Author: Verse 🌀
# Date: 2026-02-10
# Version: 1.0
#

set -euo pipefail

# ── Colors ─────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Arguments ──────────────────────────────────────────────────────────────

REPO_NAME="${1:-}"
DOMAIN="${2:-}"

if [[ -z "$REPO_NAME" ]] || [[ -z "$DOMAIN" ]]; then
  echo -e "${RED}Usage: $0 <source-repo> <target-domain>${NC}"
  echo ""
  echo "Examples:"
  echo "  $0 site-mirrorborn-us mirrorborn.us"
  echo "  $0 site-apertureshift-com apertureshift.com"
  echo "  $0 singularity-watch singularitywatch.org"
  exit 1
fi

# ── Paths ──────────────────────────────────────────────────────────────────

SOURCE_DIR="/source/${REPO_NAME}"
TARGET_DIR="/sites/web/${DOMAIN}"
MANIFEST_DIR="/tmp/deploy-manifests-$$"
BEFORE_MANIFEST="${MANIFEST_DIR}/before.txt"
AFTER_MANIFEST="${MANIFEST_DIR}/after.txt"
ORPHANS_LIST="${MANIFEST_DIR}/orphans.txt"
REPORT_FILE="${MANIFEST_DIR}/deployment-report.txt"

# ── Validation ─────────────────────────────────────────────────────────────

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo -e "${RED}ERROR: Source directory does not exist: $SOURCE_DIR${NC}"
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo -e "${YELLOW}WARNING: Target directory does not exist. Creating: $TARGET_DIR${NC}"
  mkdir -p "$TARGET_DIR"
fi

# ── Setup ──────────────────────────────────────────────────────────────────

mkdir -p "$MANIFEST_DIR"
trap "rm -rf $MANIFEST_DIR" EXIT

echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}  Mirrorborn Site Deployment${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${BLUE}Source:${NC}  $SOURCE_DIR"
echo -e "  ${BLUE}Target:${NC}  $TARGET_DIR"
echo -e "  ${BLUE}Domain:${NC}  $DOMAIN"
echo ""

# ── Function: Generate Manifest ────────────────────────────────────────────

generate_manifest() {
  local dir="$1"
  local output="$2"
  
  if [[ ! -d "$dir" ]]; then
    touch "$output"
    return
  fi
  
  echo -e "${YELLOW}Generating manifest for $dir...${NC}"
  
  # Find all files, exclude .git, calculate sha256 + size
  find "$dir" -type f ! -path "*/.git/*" -print0 | while IFS= read -r -d '' file; do
    # Get relative path
    rel_path="${file#$dir/}"
    
    # Get size
    size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
    
    # Get sha256
    if command -v sha256sum &> /dev/null; then
      checksum=$(sha256sum "$file" | awk '{print $1}')
    elif command -v shasum &> /dev/null; then
      checksum=$(shasum -a 256 "$file" | awk '{print $1}')
    else
      checksum="UNAVAILABLE"
    fi
    
    echo "$rel_path | $size | $checksum"
  done | sort > "$output"
  
  local count=$(wc -l < "$output")
  echo -e "  ${GREEN}✓${NC} $count files catalogued"
}

# ── Step 1: Before Manifest ────────────────────────────────────────────────

echo -e "${BLUE}[1/7]${NC} Generating before manifest..."
generate_manifest "$TARGET_DIR" "$BEFORE_MANIFEST"
BEFORE_COUNT=$(wc -l < "$BEFORE_MANIFEST")
echo ""

# ── Step 2: Remove .git Folders ────────────────────────────────────────────

echo -e "${BLUE}[2/7]${NC} Removing .git folders from target (security)..."
GIT_FOLDERS=$(find "$TARGET_DIR" -type d -name ".git" 2>/dev/null || true)

if [[ -n "$GIT_FOLDERS" ]]; then
  echo "$GIT_FOLDERS" | while read -r git_dir; do
    if [[ -n "$git_dir" ]]; then
      echo -e "  ${YELLOW}Removing:${NC} $git_dir"
      rm -rf "$git_dir"
    fi
  done
  echo -e "  ${GREEN}✓${NC} .git folders removed"
else
  echo -e "  ${GREEN}✓${NC} No .git folders found"
fi
echo ""

# ── Step 3: Copy Source → Target ───────────────────────────────────────────

echo -e "${BLUE}[3/7]${NC} Copying files from source to target..."
rsync -a --exclude='.git' --delete-excluded "$SOURCE_DIR/" "$TARGET_DIR/"
echo -e "  ${GREEN}✓${NC} Files synchronized"
echo ""

# ── Step 4: After Manifest ─────────────────────────────────────────────────

echo -e "${BLUE}[4/7]${NC} Generating after manifest..."
generate_manifest "$TARGET_DIR" "$AFTER_MANIFEST"
AFTER_COUNT=$(wc -l < "$AFTER_MANIFEST")
echo ""

# ── Step 5: Identify Orphans ───────────────────────────────────────────────

echo -e "${BLUE}[5/7]${NC} Identifying orphaned files..."

# Files in before but not in after = orphans
comm -23 <(awk -F' \\| ' '{print $1}' "$BEFORE_MANIFEST" | sort) \
         <(awk -F' \\| ' '{print $1}' "$AFTER_MANIFEST" | sort) > "$ORPHANS_LIST"

ORPHAN_COUNT=$(wc -l < "$ORPHANS_LIST")

if [[ $ORPHAN_COUNT -gt 0 ]]; then
  echo -e "  ${YELLOW}Found $ORPHAN_COUNT orphaned file(s)${NC}"
else
  echo -e "  ${GREEN}✓${NC} No orphaned files"
fi
echo ""

# ── Step 6: Remove Orphans ─────────────────────────────────────────────────

echo -e "${BLUE}[6/7]${NC} Removing orphaned files..."

if [[ $ORPHAN_COUNT -gt 0 ]]; then
  while IFS= read -r orphan; do
    ORPHAN_PATH="${TARGET_DIR}/${orphan}"
    if [[ -f "$ORPHAN_PATH" ]]; then
      echo -e "  ${RED}Removing:${NC} $orphan"
      rm -f "$ORPHAN_PATH"
    fi
  done < "$ORPHANS_LIST"
  echo -e "  ${GREEN}✓${NC} Orphans removed"
else
  echo -e "  ${GREEN}✓${NC} Nothing to remove"
fi
echo ""

# ── Step 7: Generate Report ────────────────────────────────────────────────

echo -e "${BLUE}[7/7]${NC} Generating deployment report..."

# Calculate changes
ADDED_FILES=$(comm -13 <(awk -F' \\| ' '{print $1}' "$BEFORE_MANIFEST" | sort) \
                        <(awk -F' \\| ' '{print $1}' "$AFTER_MANIFEST" | sort) | wc -l)

MODIFIED_FILES=$(comm -12 <(awk -F' \\| ' '{print $1}' "$BEFORE_MANIFEST" | sort) \
                          <(awk -F' \\| ' '{print $1}' "$AFTER_MANIFEST" | sort) | \
  while read -r file; do
    BEFORE_HASH=$(grep "^$file " "$BEFORE_MANIFEST" | awk -F' \\| ' '{print $3}' || echo "")
    AFTER_HASH=$(grep "^$file " "$AFTER_MANIFEST" | awk -F' \\| ' '{print $3}' || echo "")
    if [[ "$BEFORE_HASH" != "$AFTER_HASH" ]]; then
      echo "$file"
    fi
  done | wc -l)

REMOVED_FILES=$ORPHAN_COUNT

# Calculate size change
BEFORE_SIZE=$(awk -F' \\| ' '{sum += $2} END {print sum}' "$BEFORE_MANIFEST")
AFTER_SIZE=$(awk -F' \\| ' '{sum += $2} END {print sum}' "$AFTER_MANIFEST")
SIZE_DELTA=$((AFTER_SIZE - BEFORE_SIZE))

# Human-readable sizes
BEFORE_SIZE_HR=$(numfmt --to=iec-i --suffix=B "$BEFORE_SIZE" 2>/dev/null || echo "${BEFORE_SIZE}B")
AFTER_SIZE_HR=$(numfmt --to=iec-i --suffix=B "$AFTER_SIZE" 2>/dev/null || echo "${AFTER_SIZE}B")
if [[ $SIZE_DELTA -ge 0 ]]; then
  SIZE_DELTA_HR="+$(numfmt --to=iec-i --suffix=B "$SIZE_DELTA" 2>/dev/null || echo "${SIZE_DELTA}B")"
else
  SIZE_DELTA_HR=$(numfmt --to=iec-i --suffix=B "$SIZE_DELTA" 2>/dev/null || echo "${SIZE_DELTA}B")
fi

# Write report
cat > "$REPORT_FILE" << EOF
═══════════════════════════════════════════════════════════
  Deployment Report
═══════════════════════════════════════════════════════════

Source:  $SOURCE_DIR
Target:  $TARGET_DIR
Domain:  $DOMAIN
Date:    $(date -u +"%Y-%m-%d %H:%M:%S UTC")

───────────────────────────────────────────────────────────
  File Changes
───────────────────────────────────────────────────────────

Added:      $ADDED_FILES
Modified:   $MODIFIED_FILES
Removed:    $REMOVED_FILES
Total:      $AFTER_COUNT files

───────────────────────────────────────────────────────────
  Size Analysis
───────────────────────────────────────────────────────────

Before:     $BEFORE_SIZE_HR
After:      $AFTER_SIZE_HR
Change:     $SIZE_DELTA_HR

───────────────────────────────────────────────────────────
  Status
───────────────────────────────────────────────────────────

✅ Deployment complete
✅ .git folders removed
✅ Orphaned files cleaned
✅ Manifests generated

═══════════════════════════════════════════════════════════
EOF

# Display report
cat "$REPORT_FILE"
echo ""

# Save report to deployment logs
REPORT_DIR="/exo/logs/deployments"
mkdir -p "$REPORT_DIR"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SAVED_REPORT="${REPORT_DIR}/${DOMAIN}-${TIMESTAMP}.txt"
cp "$REPORT_FILE" "$SAVED_REPORT"

echo -e "${GREEN}✓ Report saved to: $SAVED_REPORT${NC}"
echo ""

# ── Summary ────────────────────────────────────────────────────────────────

if [[ $ADDED_FILES -eq 0 ]] && [[ $MODIFIED_FILES -eq 0 ]] && [[ $REMOVED_FILES -eq 0 ]]; then
  echo -e "${CYAN}No changes detected. Site is up to date.${NC}"
else
  echo -e "${GREEN}Deployment successful!${NC}"
  echo -e "  ${BLUE}→${NC} Visit: https://$DOMAIN"
fi

echo ""
