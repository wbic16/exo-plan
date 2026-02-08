# R16 GitHub Issues

**Created:** 2026-02-07 19:30 CST  
**Total Issues:** 47  
**Repository:** wbic16/phext-dot-io-v2

---

## Overview

All 47 bugs from the R16 audit have been documented as individual issue files in this directory.

Each file contains:
- Title with severity indicator
- Full description
- Code examples for fixes
- Appropriate labels

---

## Creating Issues on GitHub

### Option 1: Manual Copy-Paste
1. Go to https://github.com/wbic16/phext-dot-io-v2/issues/new
2. Open each `.md` file in this directory
3. Copy title and body
4. Add labels manually
5. Submit

### Option 2: GitHub CLI (if installed)
```bash
cd /source/exo-plan/rounds/round-16-github-issues
./create-all-issues.sh
```

### Option 3: Batch Import (requires gh CLI)
```bash
cd /source/phext-dot-io-v2
for file in /source/exo-plan/rounds/round-16-github-issues/issue-*.md; do
  gh issue create --body-file "$file" --repo wbic16/phext-dot-io-v2
done
```

---

## Issue Breakdown

### 🔴 Critical (8 issues) - Production Blockers
- `issue-001-arena-no-persistence.md`
- `issue-002-signup-no-backend.md`
- `issue-003-admin-token-rotation.md`
- `issue-004-arena-no-sq.md`
- `issue-005-css-font-blocking.md`
- `issue-006-signup-no-validation.md`
- `issue-007-no-csrf.md`
- `issue-008-localstorage-encryption.md`

### 🟠 High (12 issues) - Security & Accessibility
- `issue-009-arena-bounds.md` through `issue-020-mobile-keyboard.md`

### 🟡 Medium (18 issues) - UX & Features
- `issue-021-no-loading.md` through `issue-038-canonical-urls.md`

### 🟢 Low (9 issues) - Polish & Cleanup
- `issue-039-unused-css.md` through `issue-047-no-confirmation.md`

---

## Labels Used

- `bug` - All issues
- `r16` - Round 16 specific
- `critical` / `high` / `medium` / `low` - Severity
- `arena` - Arena-specific bugs
- `admin-api` - Admin API bugs
- `css` - CSS/styling bugs
- `security` - Security vulnerabilities
- `accessibility` - A11y issues
- `ux` - User experience
- `seo` - Search engine optimization
- `performance` - Performance issues
- `mobile` - Mobile-specific
- `backend` - Backend integration
- `validation` - Input validation
- `enhancement` - New features
- `cleanup` - Code quality

---

## Priority Recommendation

**Week 1: Critical (8 bugs)**
Fix all production blockers before any deployment.

**Week 1-2: High (12 bugs)**  
Address security and accessibility gaps.

**Week 2-3: Medium (18 bugs)**
UX improvements and feature additions.

**Week 3+: Low (9 bugs)**
Polish and code cleanup.

---

**Next:** Run issue creation scripts or manually create via GitHub web interface.
