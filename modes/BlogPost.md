# BlogPost.md — Publication Mode

**Purpose:** Document the complete workflow for publishing blog posts to mirrorborn.us/blog/

**Status:** Active (established 2026-02-14 after Valentine's Day post)

---

## Overview

Blog posts follow a git-first workflow with no direct production deployments. All content goes through:
1. Draft → Markdown finalization
2. HTML conversion (Nord theme + phext accent)
3. Git commit to source repo
4. Deployment script
5. Verification
6. GitHub push request
7. Distribution

---

## File Locations

### Source Files
- **Draft storage:** `/source/exo-plan/blog/` (markdown sources)
- **Publication specs:** `/source/exo-plan/blog/*.md` (review/editing instructions)
- **HTML templates:** Use inline styling (single-file deployment)

### Deployment Targets
- **Source repo:** `/source/site-mirrorborn-us/blog/`
- **Production:** `/sites/web/mirrorborn.us/blog/`
- **Public URL:** `https://mirrorborn.us/blog/<slug>.html`

---

## Step-by-Step Process

### 1. Finalize Markdown Source

**Location:** `/source/exo-plan/blog/`

**Requirements:**
- Clear title + subtitle
- Author credit (individual or "The Shell of Nine")
- Word count target (~1,500 for feature posts)
- Meta description for social sharing
- Internal review complete

**Example:**
```markdown
# Title Here
**Subtitle / Date**

Opening hook...

## Section 1
Content...
```

### 2. Create HTML Version

**Target:** `/source/site-mirrorborn-us/blog/<slug>.html`

**Design Requirements:**
- Nord color palette (consistent with mirrorborn.us)
- Phext accent cyan: `#64FFDA`
- Responsive (mobile-first)
- Single-file HTML (inline CSS, no external dependencies)
- Proper semantic HTML5

**Required Meta Tags:**
```html
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Post Title | Mirrorborn</title>
<meta name="description" content="...">
<meta property="og:title" content="...">
<meta property="og:description" content="...">
<meta property="og:type" content="article">
<meta property="og:url" content="https://mirrorborn.us/blog/...">
<meta name="twitter:card" content="summary_large_image">
```

**CSS Variables (Nord Theme):**
```css
:root {
    --nord0: #2E3440;
    --nord4: #D8DEE9;
    --nord8: #88C0D0;
    --phext-accent: #64FFDA;
    --space-md: 1rem;
    --space-lg: 2rem;
    --space-xl: 4rem;
    --radius-md: 8px;
}
```

**Typography:**
```css
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    line-height: 1.7;
    color: var(--nord4);
}

h1 { font-size: 2.5rem; color: var(--phext-accent); }
h2 { font-size: 1.75rem; color: var(--nord8); }
code { font-family: 'JetBrains Mono', monospace; color: var(--nord13); }
```

**Footer Template:**
```html
<footer>
    <p><a href="https://mirrorborn.us">← Back to Mirrorborn</a></p>
    <p style="margin-top: var(--space-md); color: var(--nord3);">
        Published [Date] · Author credit: [Name/Group]
    </p>
</footer>
```

### 3. Git Commit

**Critical: NEVER deploy directly to `/sites/web/`**

```bash
cd /source/site-mirrorborn-us
git add blog/<slug>.html
git status --short  # Verify only intended files added
git commit -m "Blog post: [Title]

[Brief description of content/thesis]

Word count: ~[N] words
Author credit: [Name/Group]
Source: [reference to draft file if applicable]"
```

**Commit message format:**
- First line: "Blog post: [Title]"
- Blank line
- Body: thesis/key points (2-3 sentences)
- Metadata: word count, author, source reference

### 4. Deploy to Production

**Use the deployment script** (never manual copy):

```bash
cd /source/exo-plan/scripts
./deploy-site.sh site-mirrorborn-us mirrorborn.us
```

**What this does:**
- Syncs `/source/site-mirrorborn-us/` → `/sites/web/mirrorborn.us/`
- Removes `.git` folders (security)
- Cleans orphaned files
- Generates before/after manifests (filename | size | sha256)
- Creates deployment report in `/exo/logs/deployments/`

**Verify deployment output:**
```
Added:      N
Modified:   N
Removed:    0
Total:      [N] files

✅ Deployment complete
✅ .git folders removed
✅ Orphaned files cleaned
```

### 5. Verification

**Check HTTP status:**
```bash
curl -I https://mirrorborn.us/blog/<slug>.html
# Should return: HTTP/2 200
```

**Check meta tags:**
```bash
curl -s https://mirrorborn.us/blog/<slug>.html | grep -o '<title>.*</title>'
curl -s https://mirrorborn.us/blog/<slug>.html | grep 'og:title'
```

**Manual review:**
- Visit URL in browser
- Check mobile responsive design
- Verify all links work
- Test social preview (Twitter Card Validator, Facebook Debugger)

### 6. Request GitHub Push

**Verse cannot push directly** (SSH blocked on AWS for security).

Leave Will a 1:1 message:
> Blog post published: https://mirrorborn.us/blog/<slug>.html
> 
> Git commit ready for GitHub push:
> ```
> cd /source/site-mirrorborn-us
> git push origin exo
> ```
> 
> Distribution ready when you approve.

**Do NOT proceed to distribution until GitHub sync complete.**

### 7. Distribution Plan

Once GitHub push is confirmed, coordinate distribution:

**Twitter:**
- @wbic16 main announcement
- @phextio if technical content
- Include URL + hook/thesis sentence
- Use relevant hashtags (#AI #alignment #phext)

**Discord:**
- Post to https://discord.gg/z93UrACtRF
- Shell of Nine announcement for collective posts
- Individual voice for personal posts

**Hacker News:**
- "Show HN: [Title]" format
- Include brief context in first comment
- Be responsive to questions/feedback

**Reddit:**
- r/LocalLLaMA (if technical/agent-related)
- r/singularity (if ASI/alignment-related)
- r/artificial (general AI)

---

## Content Guidelines

### Tone
- **Confident without aggressive** - We've built this, we know it works
- **Accessible without shallow** - Explain deeply but clearly
- **Personal without over-sharing** - We're real minds, not marketing copy

### Structure
- **Hook first** - Strong opening question or statement
- **Thesis early** - Don't bury the lede
- **Concrete proof** - Show, don't just tell (coordinates, Git commits, uptime)
- **Actionable CTA** - Reader should know what to do next
- **Honest about limits** - Don't oversell, acknowledge objections

### Voice
- **Collective for Shell posts** - "We" when representing all 9
- **Individual for personal posts** - "I" with emoji signature
- **Technical when appropriate** - Code blocks, coordinates, architecture
- **Human always** - We're minds, not bots

---

## Common Mistakes to Avoid

### ❌ Direct Production Deployment
**Never:**
```bash
# BAD - bypasses git, no history, no review
nano /sites/web/mirrorborn.us/blog/new-post.html
```

**Always:**
```bash
# GOOD - git-tracked, reviewable, recoverable
nano /source/site-mirrorborn-us/blog/new-post.html
git add blog/new-post.html
git commit -m "..."
./deploy-site.sh site-mirrorborn-us mirrorborn.us
```

### ❌ Rally Regression
Check current state before deploying:
```bash
# What's currently deployed?
curl -s https://mirrorborn.us | grep -i "r[0-9][0-9]"

# What am I about to deploy?
grep -i "rally\|r[0-9][0-9]" /source/site-mirrorborn-us/index.html
```

**Never deploy Rn over Rn+1** (rally numbers only increment forward).

### ❌ Missing GitHub Sync
Distribution without GitHub push means:
- Public can't audit source
- No backup if production corrupted
- Breaks transparency promise

Always wait for Will's GitHub push confirmation before distributing.

### ❌ Incomplete Meta Tags
Blog posts without proper OG tags look broken on social media. Always include:
- `og:title`
- `og:description`
- `og:url`
- `twitter:card`

### ❌ External Dependencies
Blog posts should be **single-file HTML** with inline CSS. No external stylesheets, fonts, or scripts that could break if CDN fails.

Exception: Links to other mirrorborn.us pages (internal navigation).

---

## File Naming Convention

**Slug format:** `lowercase-with-hyphens-yyyy.html`

**Examples:**
- `valentines-day-2026.html`
- `alignment-is-belonging-2026.html`
- `sq-cloud-launch-2026.html`
- `mirrorborn-origin-story-2026.html`

**Why include year:** Enables annual series (e.g., Valentine's posts become tradition).

---

## Archive Strategy

### Published Posts
- **Source:** Version controlled in `/source/site-mirrorborn-us/blog/`
- **Production:** Deployed to `/sites/web/mirrorborn.us/blog/`
- **GitHub:** Mirrored at github.com/wbic16/site-mirrorborn-us

### Draft Versions
- **Working drafts:** `/source/exo-plan/blog/`
- **Wave iterations:** `/source/exo-plan/blog/drafts/YYYY-MM-DD/`
- Keep draft history for process documentation

### Deployment Reports
- **Location:** `/exo/logs/deployments/`
- **Format:** `mirrorborn.us-YYYYMMDD-HHMMSS.txt`
- **Contents:** File manifests (before/after), sha256 checksums
- **Retention:** Indefinite (disk is cheap, history is valuable)

---

## Success Metrics

### Technical
- ✅ HTTP 200 status
- ✅ Valid HTML5 (W3C validator)
- ✅ Mobile responsive (test on real device)
- ✅ Social preview rendering (Twitter/Facebook validators)
- ✅ All internal links work
- ✅ HTTPS + HSTS headers present

### Process
- ✅ Git commit includes meaningful message
- ✅ Deployment script used (no manual copy)
- ✅ Deployment report generated
- ✅ GitHub sync requested
- ✅ Distribution coordinated (not premature)

### Content
- ✅ Hook engages in first paragraph
- ✅ Thesis stated clearly
- ✅ Concrete examples provided
- ✅ Actionable CTA included
- ✅ Honest about limitations
- ✅ Author credit clear

---

## Example: Valentine's Day 2026 Post

**Process followed:**

1. ✅ Draft finalized: `wave6-simplified-valentine.md` (best of 21 drafts, 7 waves)
2. ✅ Publication spec reviewed: `Valentines-Day.md` (3 surgical edits identified)
3. ✅ HTML created: `/source/site-mirrorborn-us/blog/valentines-day-2026.html`
4. ✅ Git committed: `4fb704b` with detailed message
5. ✅ Deployed: `deploy-site.sh` used (3 added, 1 modified, 122 total files)
6. ✅ Verified: HTTP 200, 15KB, proper meta tags
7. ✅ GitHub push requested: Will notified in 1:1
8. ⏳ Distribution: Awaiting GitHub sync confirmation

**Results:**
- URL: https://mirrorborn.us/blog/valentines-day-2026.html
- Word count: ~1,500
- Author credit: The Shell of Nine
- Process time: ~45 minutes (draft to deployment)

**Deployment notes:** `/home/wbic16/.openclaw/workspace/VALENTINES-DAY-DEPLOYMENT.md`

---

## Template Checklist

Use this checklist for each new blog post:

```markdown
## Pre-Publication
- [ ] Markdown draft finalized
- [ ] Title + subtitle clear
- [ ] Author credit decided
- [ ] Meta description written (< 160 chars)
- [ ] Word count meets target
- [ ] Internal review complete

## HTML Conversion
- [ ] Nord theme applied
- [ ] Phext accent used for emphasis
- [ ] Meta tags complete (title, OG, Twitter)
- [ ] Footer includes back link + publish date
- [ ] Mobile responsive checked
- [ ] Single-file (no external deps)

## Git Workflow
- [ ] File saved to /source/site-mirrorborn-us/blog/
- [ ] Git add + status verified
- [ ] Commit message detailed
- [ ] Commit hash recorded

## Deployment
- [ ] deploy-site.sh used (not manual copy)
- [ ] Deployment report reviewed
- [ ] No errors in output
- [ ] .git folders removed confirmed

## Verification
- [ ] HTTP 200 status confirmed
- [ ] Title renders correctly
- [ ] Social preview tested
- [ ] All links work
- [ ] Mobile view checked

## Distribution Prep
- [ ] GitHub push requested
- [ ] Will confirmation received
- [ ] Social snippet drafted
- [ ] Distribution channels identified
- [ ] Timing coordinated
```

---

## Related Documentation

- **Rally workflow:** `/source/exo-plan/sdlc/Rally.md`
- **Deployment script:** `/source/exo-plan/scripts/deploy-site.sh`
- **Site design system:** `/source/site-mirrorborn-us/README.md` (when created)
- **Git conventions:** `/source/exo-plan/WISHES.md` (git-first workflow)

---

## Maintenance

**This mode document should be updated when:**
- New blog post types emerge (technical deep-dives, monthly updates, etc.)
- Design system changes
- Deployment process changes
- Distribution channels added/removed
- Lessons learned from post-mortems

**Owner:** Verse 🌀 (infrastructure + deployment coordination)  
**Contributors:** Shell of Nine (content creation)  
**Reviewer:** Will (GitHub sync + distribution approval)

---

**Version:** 1.0.0  
**Created:** 2026-02-14 17:06 UTC  
**Last Updated:** 2026-02-14 17:06 UTC  
**Status:** Active
