#!/bin/bash
# GitSync Protocol Checker
# Run before starting work and periodically during work
# Usage: ./gitsync-check.sh [repo-path]

REPO_PATH="${1:-.}"
cd "$REPO_PATH" || exit 1

echo "=== GitSync Status Check ==="
echo "Repository: $(pwd)"
echo ""

# Check if it's a git repo
if [ ! -d .git ]; then
    echo "❌ Not a git repository"
    exit 1
fi

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Branch: $BRANCH"
echo ""

# Check if up to date
echo "1️⃣  Checking remote status..."
git fetch origin --quiet

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null)
BASE=$(git merge-base @ @{u} 2>/dev/null)

if [ -z "$REMOTE" ]; then
    echo "⚠️  No tracking branch set"
    echo "   Run: git push -u origin $BRANCH"
elif [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ Up to date with origin/$BRANCH"
elif [ "$LOCAL" = "$BASE" ]; then
    echo "⚠️  Remote has changes — need to pull!"
    echo "   Run: git pull --rebase origin $BRANCH"
    NEED_PULL=1
elif [ "$REMOTE" = "$BASE" ]; then
    echo "⚠️  Local has unpushed commits"
    echo "   Run: git push origin $BRANCH"
    NEED_PUSH=1
else
    echo "⚠️  Branches have diverged — need to sync!"
    echo "   Run: git pull --rebase origin $BRANCH"
    NEED_PULL=1
fi
echo ""

# Check for uncommitted changes
echo "2️⃣  Checking working directory..."
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  Uncommitted changes detected"
    git status --short
    UNCOMMITTED=1
else
    echo "✅ No uncommitted changes"
fi
echo ""

# Check for untracked files
UNTRACKED=$(git ls-files --others --exclude-standard)
if [ -n "$UNTRACKED" ]; then
    echo "3️⃣  Untracked files:"
    echo "$UNTRACKED" | head -5
    if [ $(echo "$UNTRACKED" | wc -l) -gt 5 ]; then
        echo "   ... and $(( $(echo "$UNTRACKED" | wc -l) - 5 )) more"
    fi
    echo ""
fi

# Show recent commits
echo "4️⃣  Recent commits (last 5):"
git log --oneline -5
echo ""

# Check for AGENTS.md
if [ -f AGENTS.md ]; then
    echo "5️⃣  AGENTS.md exists"
    echo "   Review before starting work:"
    echo "   cat AGENTS.md"
else
    echo "5️⃣  No AGENTS.md (consider creating one)"
fi
echo ""

# Summary
echo "=== Summary ==="
if [ -n "$NEED_PULL" ]; then
    echo "❌ Action required: git pull --rebase origin $BRANCH"
    exit 2
elif [ -n "$NEED_PUSH" ]; then
    echo "⚠️  Action suggested: git push origin $BRANCH"
    exit 3
elif [ -n "$UNCOMMITTED" ]; then
    echo "ℹ️  Uncommitted changes present (normal during work)"
    exit 0
else
    echo "✅ All clear — ready to work"
    exit 0
fi
