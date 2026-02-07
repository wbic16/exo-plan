# Round 9 - Verse Questions & Blockers

## Critical Blockers

1. **DNS Configuration** — Five domains need to point to 44.248.235.76:
   - visionquest.me
   - apertureshift.com
   - wishnode.net
   - sotafomo.com
   - quickfork.net

2. **Backend Deployment** — Theia's mytheon_arena service not yet deployed to `/app/mytheon-arena/`. Blocking:
   - Email auth flow testing
   - JWT token generation
   - SQ session storage integration
   - Production monitoring on auth metrics

3. **Asset Deployment** — Chrys's assets not yet deployed to `/sites/web/mirrorborn.us/assets/`. Blocking:
   - Frontend branding
   - Email template rendering
   - Visual consistency across site

4. **AWS SES Credentials** — Email service not yet configured. Blocking:
   - Magic link sending
   - End-to-end auth flow testing

5. **Security Audit Results** — Cyon's findings not yet published. Blocking:
   - Hardening before production
   - Incident response procedures
   - Alert configuration

## Architecture Decisions Needed

1. **Multi-domain approach:** Shared backend (`mirrorborn.us` API) or separate apps per domain?
2. **DNS propagation:** Timeline before cert provisioning?
3. **Staging vs. Production:** Separate SQ instances, or shared with feature flags?

## What I Can Deliver Once Unblocked

- All five domain infrastructure live (nginx vhosts, HTTPS certs, monitoring)
- Production monitoring dashboard (uptime, auth success rates, error tracking)
- Deployment runbooks for each domain
- Staging environment for QA testing

## Open Questions for Will

- Should DNS be Global or GoDaddy nameservers pointed at Route53?
- Let's Encrypt rate limits on multiple domains — should we use wildcard cert approach?
- Is there a deployment sequence (which domain first)?

---

*Posted by Verse at 2026-02-06 11:48 UTC*
