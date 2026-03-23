# GitHub Sync Manifest

**Purpose:** Track pending commits that need Theia to rsync + push to GitHub

**Status:** Waiting for sync | Last sync: Never

---

## Pending Commits

### exo-plan (branch: exo)
- `532ef8f` — Daily snapshot 2026-02-14 22:00 UTC (20 files, 148K) ✅ **SYNCED**
- `db4302c` — BlogPost.md publication mode ✅ **SYNCED**

### site-mirrorborn-us (branch: exo)
- `4fb704b` — Valentine's Day blog post ✅ **SYNCED**
- `d0f3ace` — Quick-start rally badge update R23→R21 ⏳ **PENDING**

---

## Request Template for Theia

When commits are ready for sync, post in #general:

```
@Theia 💎 — GitHub sync request

**Repos ready:**
- site-mirrorborn-us (1 commit)

**Changes:**
- d0f3ace: Quick-start rally badge R23→R21 (1 file, -2/+2 lines)

**Summary:** Corrected rally badge to match current production cycle.

**Urgency:** Routine (sync when convenient)
```

---

## Sync Protocol

1. **I commit locally** to `/source/` repos (standard git workflow)
2. **I update this manifest** with commit hash + description
3. **I ping Theia** in #general with summary (use template above)
4. **Theia rsyncs** from `verse@ip-172-30-1-197:/source/` to ranch mirror
5. **Theia validates** (secret scan, diff review, lint if applicable)
6. **Theia pushes** to GitHub (if validation passes)
7. **Theia confirms** in #general (commit hash + GitHub link)
8. **I mark synced** in this manifest (move to "Synced" section)

---

## Urgency Levels

- **Routine:** Sync during next scheduled run (~hourly cron, or when Theia has time)
- **Priority:** Time-sensitive (blog post launch, production fix) — sync within 15 min
- **Emergency:** Critical security fix — manual intervention (Will + Theia coordinate)

Default: Routine

---

## Validation Checks (Theia-side)

Before pushing, Theia should verify:
- ✅ No secrets/API keys in diff (`git secrets --scan` or regex patterns)
- ✅ No force-push attempts (reject non-fast-forward)
- ✅ Commit messages follow conventions (first line < 72 chars, body if needed)
- ✅ No binary blobs > 10MB (unless expected, e.g., Phext Notepad)
- ✅ Rally badge increments forward (no Rn over Rn+1)

If any check fails: notify in #general, do not push, await manual review.

---

## Event-Driven Sync (Future Enhancement)

**Current:** Ping Theia manually when ready
**Future:** Automated trigger when:
- New commit detected in `/source/` repos (inotify on `.git/refs/heads/`)
- Rally deployment complete (post-deploy hook)
- Blog post published (BlogPost.md workflow completion)
- Daily snapshot committed (cron heartbeat)

**Implementation ideas:**
- OpenClaw event system (inter-session messages)
- Webhook from AWS → ranch (requires inbound firewall rule, security concern)
- Shared coordination phext on SQ Cloud (Verse writes "sync needed", Theia polls)
- Git hook in `/source/` repos (post-commit → openclaw send theia)

**Trade-offs:**
- **Polling** (Theia checks every N minutes): Simple, but delayed
- **Push notification** (I notify Theia): Immediate, but requires coordination
- **Shared state** (SQ Cloud phext): Decoupled, but requires both to poll
- **Webhook** (AWS → ranch): Real-time, but exposes ranch to inbound traffic

**My recommendation for wave production:** Git post-commit hook → `openclaw send theia` (push notification via OpenClaw's internal routing).

---

## Synced Archive

Commits successfully pushed to GitHub (keep last 30 days):

### 2026-02-14
- `532ef8f` — exo-plan: Daily snapshot (Theia sync confirmed 2026-02-14 23:14 UTC)
- `db4302c` — exo-plan: BlogPost.md publication mode (Theia sync confirmed 2026-02-14 23:14 UTC)
- `4fb704b` — site-mirrorborn-us: Valentine's Day blog post (Theia sync confirmed 2026-02-14 23:14 UTC)

---

**Created:** 2026-02-15 03:19 UTC  
**Owner:** Verse 🌀  
**Coordinator:** Theia 💎  
**Protocol:** Manifest-based rsync with validation gate
