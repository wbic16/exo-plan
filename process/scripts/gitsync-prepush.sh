#!/bin/bash
# GitSync Pre-Push Validation
# Run this before EVERY push to catch issues early
# Usage: ./gitsync-prepush.sh [repo-path]

REPO_PATH="${1:-.}"
cd "$REPO_PATH" || exit 1

echo "=== GitSync Pre-Push Validation ==="
echo "Repository: $(pwd)"
echo ""

ERRORS=0

# Step 1: Validate working directory is clean (or committed)
echo "1️⃣  Checking working directory..."
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  Uncommitted changes detected"
    echo "   Either commit them or stash before pushing"
    git status --short
    ERRORS=$((ERRORS + 1))
else
    echo "✅ Working directory clean"
fi
echo ""

# Step 2: Pull + rebase check
echo "2️⃣  Checking if up to date..."
git fetch origin --quiet

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u} 2>/dev/null)
BASE=$(git merge-base @ @{u} 2>/dev/null)

if [ -z "$REMOTE" ]; then
    echo "⚠️  No tracking branch — first push?"
elif [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ Up to date with remote"
elif [ "$LOCAL" = "$BASE" ]; then
    echo "❌ Remote has changes — MUST pull + rebase first!"
    echo "   Run: git pull --rebase origin $(git rev-parse --abbrev-ref HEAD)"
    ERRORS=$((ERRORS + 1))
elif [ "$REMOTE" = "$BASE" ]; then
    echo "✅ Local ahead of remote (ready to push)"
else
    echo "❌ Branches diverged — MUST sync first!"
    echo "   Run: git pull --rebase origin $(git rev-parse --abbrev-ref HEAD)"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Step 3: Run validation (if check script exists)
echo "3️⃣  Running validation..."
if [ -x ./check ]; then
    if ./check; then
        echo "✅ Validation passed (./check)"
    else
        echo "❌ Validation failed (./check)"
        ERRORS=$((ERRORS + 1))
    fi
elif [ -x scripts/validate.sh ]; then
    if scripts/validate.sh; then
        echo "✅ Validation passed (scripts/validate.sh)"
    else
        echo "❌ Validation failed (scripts/validate.sh)"
        ERRORS=$((ERRORS + 1))
    fi
elif [ -f Cargo.toml ]; then
    if cargo test --quiet 2>&1 | tail -1; then
        echo "✅ Tests passed (cargo test)"
    else
        echo "❌ Tests failed (cargo test)"
        ERRORS=$((ERRORS + 1))
    fi
elif [ -f package.json ]; then
    if npm test --quiet 2>&1 | tail -1; then
        echo "✅ Tests passed (npm test)"
    else
        echo "❌ Tests failed (npm test)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "⚠️  No validation script found (./check, scripts/validate.sh, cargo, npm)"
    echo "   Consider adding tests"
fi
echo ""

# Step 4: Check commit message quality (last commit)
echo "4️⃣  Checking commit message..."
LAST_MSG=$(git log -1 --pretty=%B)
if echo "$LAST_MSG" | grep -qE "^R[0-9]+W[0-9]+:"; then
    echo "✅ Commit message has wave tag"
elif echo "$LAST_MSG" | grep -qE "^R[0-9]+:"; then
    echo "✅ Commit message has rally tag"
else
    echo "⚠️  Commit message missing rally/wave tag"
    echo "   Recommended: R{N}W{M}: <summary>"
    echo "   Your message: $(echo "$LAST_MSG" | head -1)"
fi
echo ""

# Summary
echo "=== Pre-Push Summary ==="
if [ $ERRORS -eq 0 ]; then
    echo "✅ All checks passed — safe to push"
    echo ""
    echo "Next steps:"
    echo "  git push origin $(git rev-parse --abbrev-ref HEAD)"
    exit 0
else
    echo "❌ $ERRORS error(s) detected — DO NOT PUSH YET"
    echo ""
    echo "Fix issues above, then run this script again"
    exit 1
fi
