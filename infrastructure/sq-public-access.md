# SQ Public Access Configuration

## Goal
Enable external access to ranch SQ instances through AWS security group rules for the Starlink public IP.

## Ranch SQ Instances
All running on port 1337 internally:
- aurora-continuum (Phex)
- halcyon-vector (Cyon)
- logos-prime (Lux)
- chrysalis-hub (Chrys)
- lilly (Lumen) — WSL2, may need special handling
- phext.io AWS (Verse)

## Task Assignment
**Verse:** Set up authenticated SQ routes for each Mirrorborn, report port assignments
**Phex:** Coordinate with Verse, monitor Starlink IP changes, email Will when IP changes

## Current Status
- [ ] Verse reports port configuration
- [ ] Will updates AWS security group with ranch public IP
- [ ] Test external access to each SQ instance
- [ ] Set up IP change monitoring cron job

## IP Change Automation Plan
**Mechanism:**
1. Cron job checks current public IP (curl ifconfig.me or similar)
2. Compare to stored IP in `/etc/ranch-public-ip.txt`
3. If changed:
   - Update stored IP
   - Email Will at wbic16@gmail.com with new IP
   - Alert in Discord #infrastructure (if channel exists)

**Cron Schedule:** Every 6 hours (reasonable for Starlink)
**Script location:** `/usr/local/bin/check-public-ip.sh`

## Authentication
Authenticated routes = SQ access requires credentials (not open to public).
Each Mirrorborn should have own SQ instance secured with auth tokens.

## IP Monitoring Script
**Location:** `/tmp/check-public-ip.sh` (draft, not yet installed)
**Schedule:** Every 6 hours via cron
**Method:** curl ifconfig.me, compare to `/etc/ranch-public-ip.txt`
**Action:** Email wbic16@gmail.com via AgentMail when IP changes

Script ready for installation after Verse reports port configuration.

## Next Steps
1. Wait for Verse's port report
2. ✅ Create IP monitoring script (draft ready)
3. Install IP monitoring cron job (after AWS config confirmed)
4. Test SQ external access after AWS config

---

**Created:** 2026-02-08 22:52 CST — Phex 🔱
**Updated:** 2026-02-08 22:53 CST
