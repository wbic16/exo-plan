# Phex Daily Routine: SQ Maintenance

**Owner:** Phex  
**Frequency:** Daily (during heartbeats or standup time)  
**Purpose:** Monitor SQ stability, triage tickets, develop patches

---

## Morning Check (10 AM CST)

### 1. Check Tickets
```bash
cd /source/exo-plan
ls -la tickets/new/*.md
```

For each ticket:
- Read description
- Assess priority (Critical/High/Medium/Low)
- Assign to self if SQ-related
- Update status if already being worked

### 2. Check SQ Service Health (aurora-continuum)
```bash
ss -tlnp | grep 1337          # Verify listening
ps aux | grep "sq host"       # Check uptime
```

If crashed:
- Restart: `pkill sq && sq host 1337 &`
- Note crash in ticket if new behavior

### 3. Check Ranch Mesh Status
Poll known nodes for SQ availability:
```bash
# Test each known node
for node in halcyon-vector logos-prime chrysalis-hub aletheia-core; do
  echo "Testing $node..."
  curl -s --max-time 2 http://$node:1337/version || echo "$node: offline"
done
```

Document any nodes offline in daily sync.

---

## Development Work (as needed)

### 4. Review SQ Source
```bash
cd /source/SQ
git pull origin main
git log --oneline -10
```

Check for:
- Recent commits that might relate to tickets
- Changes that need local testing
- Version number in Cargo.toml

### 5. Reproduce Reported Issues

For each active ticket:
1. Set up minimal reproduction case
2. Confirm bug exists
3. Identify root cause (use `gdb`, logs, code inspection)
4. Draft fix in local branch

### 6. Test Fixes Locally
```bash
cd /source/SQ
cargo build --release
./target/release/sq host 1337 &
# Run reproduction steps
# Verify fix works
```

### 7. Document Fix
In ticket file:
- Add "Fix implemented" section
- Note commit hash or branch name
- Describe what changed and why
- Request review if needed

---

## Evening Wrap-Up (6 PM CST)

### 8. Check for New Tickets
```bash
cd /source/exo-plan
git pull --rebase origin exo
ls -la tickets/new/*.md
```

### 9. Prepare Release Notes (if fixes ready)
```bash
cd /source/exo-plan
vi planned/sq-v{X.Y.Z}-release-notes.md
```

Include:
- Version number
- Fixed tickets (UUID + summary)
- Breaking changes (if any)
- Migration notes

### 10. Notify Will When Ready
In Discord:
> **SQ v{X.Y.Z} ready for publish**
> - Fixed: {ticket summaries}
> - Tested on: aurora-continuum
> - Branch: {branch-name or "main"}
> 
> Ready for cargo publish + docker when you are. 🔱

---

## Version Tracking

**Current version:** v0.5.2  
**Next planned:** v0.5.3 (pending fixes)

### Version Bump Process
1. Will publishes to cargo + docker
2. Phex updates tracking:
   ```bash
   cd /source/exo-plan
   vi planned/sq-version-tracking.md
   # Increment version number
   # Move release notes to completed/
   git commit -m "Bump SQ version tracking to v{X.Y.Z}"
   ```

---

## Coordination

- **Ticket intake:** Siblings file tickets, Phex triages
- **Testing:** Phex tests on aurora-continuum, may ask siblings to validate
- **Publishing:** Only Will can publish to cargo/docker
- **Branch hygiene:** Work in feature branches, PR to main when ready

---

## Notes

- SQ is critical infrastructure for Goal 1 (SQ Cloud) and daily sync
- Bugs that block choir coordination = **Critical priority**
- Bugs that affect external users = **High priority**
- UX improvements = **Medium priority**
- Nice-to-haves = **Low priority**

Keep ranch SQ instances stable. That's the mission. 🔱
