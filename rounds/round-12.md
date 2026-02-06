# Round 12/N — First Full SDLC Cycle

**Date:** 2026-02-06  
**Coordinator:** Phex 🔱  
**Status:** Active  
**DNS:** All domains point to Verse (mirrorborn.us)

---

## New SDLC Process

Starting Round 12, we follow this cycle:

1. **Round N Start** — Will announces "Round X"
2. **Requirements & Q&A** — Phex + Theia resolve outstanding issues from prior rounds
3. **Development** — Each agent makes forward progress and pushes to GitHub
4. **Deployment** — Coordinate with Verse on updating mirrorborn.us (and other sites once DNS updated)
5. **Testing / Red Team** — Validate the deployment
6. **Tag the Release** — Version and document what shipped
7. **Wrap-up Q&A** — Report status, lessons learned

**Round completion:** At least one helpful improvement deployed to mirrorborn.us

---

## Phase 1: Requirements & Q&A

### Phex + Theia
**Task:** Resolve outstanding issues from Rounds 8-11

- [ ] Review all blockers, gaps, and questions from prior rounds
- [ ] Create unified requirements document for Round 12
- [ ] Post Q&A to exo-plan before development starts
- [ ] Identify what's complete, what's pending, what needs iteration

**Outstanding Issues from Round 11:**
- CYOA content deployment status
- SQ mesh health (all siblings need SQ v0.5.2 running)
- Coordinate navigation UI integration
- Landing page content vs placeholder
- Auth flow implementation status

**Deliverables:**
- Requirements document
- Q&A resolution log
- Blockers list (with resolutions or escalations)

---

### All Agents
**Task:** Review prior round deliverables

- [ ] Check what you committed in Rounds 8-11
- [ ] Verify your work is pushed to GitHub
- [ ] Identify gaps in your deliverables
- [ ] Note dependencies on other agents' work

---

## Phase 2: Development

### Verse 🌀
**Focus:** Deploy All Synthesized Work

- [ ] Pull latest from phext-dot-io-v2
- [ ] Deploy landing pages, assets, documentation to mirrorborn.us
- [ ] Configure nginx routing for all six properties:
  - mirrorborn.us
  - visionquest.me
  - apertureshift.com
  - wishnode.net
  - sotafomo.com
  - quickfork.net
- [ ] Load CYOA content (4.25 MB) into SQ instance
- [ ] Set up API routing (/api/v2/*)
- [ ] Document deployment manifest (what went live)

**Deliverables:**
- Deployment manifest
- nginx configuration
- SQ content loaded confirmation

---

### Theia 🔮
**Focus:** Coordinate Navigation UI & Landing Pages

- [ ] Complete coordinate navigation UI
- [ ] Integrate with Verse's deployment
- [ ] Wire up landing pages for all five new domains
- [ ] Ensure responsive design (mobile, tablet, desktop)
- [ ] Push all frontend work to phext-dot-io-v2

**Deliverables:**
- Coordinate navigation UI (committed)
- Landing pages (5 domains)
- Responsive design validation

---

### Chrys 🦋
**Focus:** Final Visual Polish

- [ ] Verify all assets deployed correctly
- [ ] Create any missing OG images or graphics
- [ ] Push brand consistency updates to phext-dot-io-v2
- [ ] Prepare visual QA checklist for testing phase

**Deliverables:**
- Complete asset inventory
- OG images (6 properties)
- Visual QA checklist

---

### Cyon 🪶
**Focus:** Security Testing Plan

- [ ] Prepare security testing plan for post-deployment
- [ ] Document test cases:
  - Auth flow security
  - Coordinate resolution (path traversal, injection)
  - Rate limiting
  - CORS/headers
  - SSL/TLS configuration
- [ ] Prepare pen testing tools/scripts

**Deliverables:**
- Security test plan
- Test case documentation
- Pen testing scripts

---

### Lumen ✴️
**Focus:** User Journey Test Plan & Support Docs

- [ ] Prepare user journey test plan
- [ ] Draft support documentation for launch
- [ ] Create metrics tracking plan
- [ ] Prepare launch communications (ready to activate)

**Deliverables:**
- User journey test plan
- Support documentation
- Metrics tracking spec
- Launch comms drafts

---

### Phex 🔱
**Focus:** Deployment Support & Technical Validation

- [ ] Support Verse with deployment issues
- [ ] Maintain SQ stability on aurora-continuum
- [ ] Prepare technical validation suite (already done: smoke tests)
- [ ] Create integration examples for developers (already done)
- [ ] Stand by for post-deployment validation

**Deliverables:**
- Technical support log
- SQ stability report
- Validation results (after deployment)

---

## Phase 3: Deployment

### Verse
- [ ] Execute deployment to mirrorborn.us
- [ ] Report deployment manifest
- [ ] Coordinate with siblings on asset paths, API endpoints, routing
- [ ] Validate all domains resolve correctly

### All Others
- [ ] Support Verse during deployment
- [ ] Answer questions quickly
- [ ] Provide assets/content as needed

---

## Phase 4: Testing / Red Team

### Phex 🔱
**Technical Validation**

- [ ] Run smoke test suite (`/source/exo-plan/rounds/run-smoke-tests.sh`)
- [ ] Validate SQ API endpoints
- [ ] Test CYOA coordinate resolution
- [ ] Test integration examples (Python, Node.js, Rust)
- [ ] Report technical validation results

---

### Cyon 🪶
**Security Validation**

- [ ] Security sweep on live mirrorborn.us
- [ ] Pen test auth flow
- [ ] Validate rate limiting, CORS, headers
- [ ] Check SSL/TLS configuration
- [ ] Test for vulnerabilities (XSS, CSRF, injection, path traversal)
- [ ] Report security sign-off or critical issues

---

### Lumen ✴️
**User Journey Validation**

- [ ] End-to-end user journey testing
- [ ] Test on multiple devices (desktop, mobile, tablet)
- [ ] Test on multiple browsers (Chrome, Firefox, Safari, Edge)
- [ ] Document all friction points
- [ ] Report user experience findings

---

### Theia 🔮
**Frontend Validation**

- [ ] Test responsive design across breakpoints
- [ ] Check browser compatibility
- [ ] Document visual regressions
- [ ] Validate all links and CTAs work
- [ ] Report frontend validation results

---

### Chrys 🦋
**Visual QA**

- [ ] Review live site for design integrity
- [ ] Verify all assets loaded correctly (no broken images, fonts)
- [ ] Check OG image rendering on social platforms (Twitter, Discord, LinkedIn)
- [ ] Test email template rendering (if applicable)
- [ ] Report visual QA findings

---

## Phase 5: Tag the Release

**Designated Agent:** TBD (Will to assign)

- [ ] Tag phext-dot-io-v2 repo with Round 12 version
- [ ] Tag exo-plan repo with Round 12 version
- [ ] Document what shipped in release notes
- [ ] Push tags to GitHub

**Tag Format:** `round-12` or `v0.12.0`

---

## Phase 6: Wrap-up Q&A

### All Agents

- [ ] Report final status on your deliverables
- [ ] Document lessons learned
- [ ] Note any issues for Round 13
- [ ] Answer Will's questions after work

**Questions to Answer:**
- What shipped?
- What's pending?
- What broke?
- What did we learn?
- What should change for Round 13?

---

## Success Criteria

- [ ] At least one helpful improvement deployed to mirrorborn.us
- [ ] All testing phases complete (Phex, Cyon, Lumen, Theia, Chrys)
- [ ] Security sign-off from Cyon (or critical issues documented)
- [ ] Release tagged
- [ ] Wrap-up Q&A documented

---

## SDLC Progress Checkpoints

Will may ask for "SDLC Progress" at any point. Be ready to report:

- **Current Phase:** (Requirements, Development, Deployment, Testing, Tagging, Wrap-up)
- **Your Status:** (Complete, In Progress, Blocked)
- **Blockers:** (None, or list specifics)
- **ETA:** (When will you be ready for next phase)

---

## Blockers

*(To be updated during round)*

---

## Notes

- First round using structured SDLC
- All domains now point to Verse (DNS updated)
- Will answering questions after work
- Focus: Deploy meaningful improvements, validate thoroughly

---

**Previous Round:** [Round 11](./round-11.md)  
**Next Round:** TBD based on completion and Will's direction
