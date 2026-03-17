# Client Delivery Features
## From Harold's Experiments — 2026-03-17

*Logged by Aster @ best-willow*

---

## Context

"Client" = the space (site, analysis, reports) we manage for a user.
Source: Harold Bickford's experiments today surfaced three delivery capabilities needed.

---

## Feature Requests

### 1. Deliver Specs to Clients via Email

**What:** When a spec, requirements doc, or analysis is ready, send it directly to the client's email without requiring them to log in or navigate to a URL.

**Why:** Harold shouldn't have to go find things. The system should push completed work to him.

**Implementation path:**
- Each client record gets an email address (add to `clients/<name>/config.json`)
- On spec completion, trigger `send-email.py` (already in `/source/exocortical/`)
- Format: clean HTML email with spec as inline content + PDF attachment
- Queue via SQ: write to `client-notifications/<client_id>/1.1.1/1.1.1`, pick up on heartbeat
- Method: SMTP or SendGrid API (not Gmail-only as in gstack-auto)

**Files to create:**
- `clients/scripts/notify-client.sh` — triggered on spec publish
- `clients/templates/spec-email.html` — email template
- Each client dir gets `config.json` with `email`, `name`, `domain`

---

### 2. Publish Analysis to Client's Web Site

**What:** Push completed analysis (reports, site updates, content) directly to the client's live website without manual FTP/git steps.

**Why:** The Exocortex should close the loop — generate → review → publish → notify. No manual handoff.

**Implementation path:**
- Client site config: `deploy_method` (git push / rsync / FTP / Netlify API)
- On analysis completion: run `clients/scripts/publish-to-site.sh <client_id>`
- For HB Aeromotive: likely rsync to `hb-aeromotive.com` server or git push to hosting
- Publish log written to SQ at `client-deploys/<client_id>/1.1.1/1.1.1`
- Dashboard shows last deploy timestamp per client

**Files to create:**
- `clients/scripts/publish-to-site.sh`
- `clients/<name>/deploy.config` — deploy method, credentials ref, target path

---

### 3. Print Reports Directly to Local Printers

**What:** Send completed reports to a printer on Harold's local network without any browser/PDF step.

**Why:** Physical deliverables. Some clients want paper. Harold runs a shop.

**Implementation path:**
- Discover printers via mDNS/Avahi on client's LAN (or use a known IP/hostname)
- Format report as PDF via `wkhtmltopdf` or `weasyprint`
- Send via `lp` / `lpr` / IPP protocol
- For remote clients: email the print job to a cloud print endpoint, or use CUPS over VPN
- For Harold specifically: he's on Will's LAN — direct `lp` to `hb-aeromotive-printer.local`

**Files to create:**
- `clients/scripts/print-report.sh <client_id> <report_file>`
- `clients/<name>/printers.config` — printer hostname/IP, paper size, copies

---

## Priority Order (based on Harold's use case)

| # | Feature | Effort | Impact |
|---|---------|--------|--------|
| 1 | Email delivery | Low | High — immediate client value |
| 2 | Site publish | Medium | High — closes the loop |
| 3 | Print reports | Low | Medium — niche but Harold specifically needs it |

Start with email. It unblocks Harold today.

---

## HB Aeromotive Specific Notes

- **Client:** Harold Arthur Bickford II
- **Domain:** hb-aeromotive.com
- **Email:** TBD (get from Harold)
- **Printer:** On LAN — likely accessible from best-willow or via SSH to a LAN node
- **Current spec status:** Requirements questionnaire exists, detailed requirements in progress

---

## Integration with FORGE (MBV5)

These three delivery channels become the output layer of FORGE:
- FORGE builds → publish-to-site delivers
- FORGE scores → email notifies client
- FORGE report → print-report sends to printer

The spec-to-delivery pipeline becomes fully automated.

---

*Next step: confirm Harold's email address and deploy method for hb-aeromotive.com*
