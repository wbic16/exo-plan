# SDD Dimensional Model — Refined
**SDLC as the Sixth Dimension**

**Author:** Phex 🔱 with Will Bickford  
**Date:** 2026-02-25  
**Status:** Canonical (supersedes earlier 9D schemas)

---

## The Insight

Large-scale systems are organized in **5 dimensions**. The **6th dimension** is reserved for **SDLC stages**. The remaining **3 dimensions** are reserved for future use.

This makes traceability a **navigation operation**, not a linking operation. Walk the D6 axis to see how any deliverable evolved through the lifecycle.

---

## The Model

### D1-D5: System Organization (5D Spatial Structure)

| Dimension | Name | System Interpretation |
|-----------|------|----------------------|
| D1 | Library | Organization / Federation |
| D2 | Shelf | Domain / Product Line |
| D3 | Series | Feature Family / Epic |
| D4 | Collection | Component / Service |
| D5 | Volume | Version / Release |

These five dimensions locate **what** you're specifying within the organizational topology.

### D6: SDLC Stage (Lifecycle Dimension)

| D6 Value | Stage | Content |
|----------|-------|---------|
| 1 | Requirements | Business needs, constraints, acceptance criteria |
| 2 | Use Cases | Actor-goal interactions, scenarios, user stories |
| 3 | Design | Architecture, interfaces, data models, contracts |
| 4 | Implementation | Code, configuration, scripts |
| 5 | Test | Unit tests, integration tests, acceptance tests |
| 6 | Deployment | Manifests, infrastructure, runbooks |
| 7 | Operations | Monitoring, alerts, SLAs, incident response |
| 8 | Retirement | Migration paths, deprecation notices, sunset plans |
| 9 | Archive | Historical reference (read-only) |

The sixth dimension locates **where in the lifecycle** the artifact lives.

### D7-D9: Reserved (Future Expansion)

| Dimension | Name | Reserved For |
|-----------|------|--------------|
| D7 | Chapter | Sub-artifact structure (TBD) |
| D8 | Section | Internal organization (TBD) |
| D9 | Scroll | Atomic content units (TBD) |

Default to `1.1.1` until these dimensions are needed.

---

## Coordinate Structure

A full SDD coordinate:

```
D1.D2.D3 / D4.D5.D6 / D7.D8.D9
   │         │           │
   │         │           └── Reserved (use 1.1.1)
   │         └── Component.Version.SDLC-Stage
   └── Org.Domain.Epic
```

**Example:** `3.2.1/4.5.4/1.1.1`
- Organization 3, Domain 2, Epic 1
- Component 4, Version 5, **Implementation** (D6=4)
- Reserved dimensions at 1.1.1

---

## Traceability by Navigation

Walk the D6 axis to trace any deliverable through its lifecycle:

```
Feature: User Authentication
Base coordinate: @3.2.1/4.1.*/1.1.1

@3.2.1/4.1.1/1.1.1 → Requirements
  "Users must authenticate with email and password"
  "Session timeout: 24 hours"
  "Failed login lockout: 5 attempts"

@3.2.1/4.1.2/1.1.1 → Use Cases
  UC-001: Login with credentials
  UC-002: Password reset
  UC-003: Session management

@3.2.1/4.1.3/1.1.1 → Design
  Interface: AuthService
  Data model: User, Session, Credential
  Sequence: login_flow.puml

@3.2.1/4.1.4/1.1.1 → Implementation
  auth_service.rs
  session_manager.rs
  credential_store.rs

@3.2.1/4.1.5/1.1.1 → Test
  auth_service_test.rs
  integration/login_test.rs
  e2e/auth_flow_test.rs

@3.2.1/4.1.6/1.1.1 → Deployment
  auth-service.k8s.yaml
  secrets.tf
  auth-runbook.md

@3.2.1/4.1.7/1.1.1 → Operations
  auth_alerts.yaml
  auth_dashboard.json
  sla_auth.md
```

Every artifact's evolution is visible by walking D6. No manual traceability links required.

---

## Resource Isolation by Type

Queries by SDLC stage are O(1) navigations:

```bash
# All requirements across the entire system
sdd ls @*.*.*/*.*.1/*.*.*

# All implementations across all components
sdd ls @*.*.*/*.*.4/*.*.*

# All tests for a specific component (4.1)
sdd ls @*.*.*/4.1.5/*.*.*

# All deployments for version 5.x
sdd ls @*.*.*/*.5.6/*.*.*

# Trace one component through its complete lifecycle
sdd trace @3.2.1/4.1.*/1.1.1
```

---

## Why This Model?

### 1. Separation of Concerns

System structure (D1-D5) is independent of lifecycle stage (D6). You can:
- View all requirements across the system
- View all artifacts for one component
- View one artifact's evolution through lifecycle

### 2. Natural Traceability

Traditional traceability requires explicit links:
- Requirement R-001 traces to Use Case UC-003
- UC-003 traces to Design D-007
- D-007 traces to Code auth.rs

SDD traceability is coordinate adjacency:
- R-001 at @x/y.1/z
- UC-003 at @x/y.2/z (same x, same y base, D6 incremented)
- D-007 at @x/y.3/z
- auth.rs at @x/y.4/z

Walk the axis. No link maintenance.

### 3. Stage-Specific Tooling

Each D6 value can have specialized tooling:
- D6=1: Requirements management (prioritization, approval)
- D6=2: Use case modeling (actor-goal decomposition)
- D6=3: Design tools (diagramming, interface contracts)
- D6=4: IDEs, compilers, linters
- D6=5: Test runners, coverage tools
- D6=6: Deployment pipelines, IaC
- D6=7: Monitoring, alerting, dashboards
- D6=8: Migration tools, deprecation tracking

Same coordinate base, different stage = different tooling.

### 4. Reserved Dimensions for Growth

D7-D9 at `1.1.1` leaves room for:
- Sub-component structure (D7)
- File-level organization (D8)
- Line/block-level addressing (D9)

When needed, expand. Until then, simplicity.

---

## Comparison with Earlier 9D Schemas

| Aspect | Earlier Model | Refined Model |
|--------|---------------|---------------|
| D6 meaning | Layer (UI/API/Core/Data) | SDLC Stage |
| D7-D9 | Actively used | Reserved |
| Traceability | Requires links | Navigation |
| Resource queries | Complex | O(1) by stage |

The refined model trades inner-dimension complexity for lifecycle clarity.

---

## Implementation Notes

### SQ Queries

```sql
-- All requirements (D6=1) for organization 3
SQ SELECT @3.*.*/*.*.1/*.*.*

-- Component 4.1 complete lifecycle
SQ SELECT @*.*.*/4.1.*/*.*.* ORDER BY D6

-- Cross-version requirements comparison
SQ DIFF @*.*.*/4.1.1/*.*.* @*.*.*/4.2.1/*.*.*
```

### Synthesis Pipeline

```
D6=1 (Requirements) ─┐
D6=2 (Use Cases)    ─┼─→ Validate consistency
D6=3 (Design)       ─┘

D6=3 (Design)       ─┐
D6=4 (Implementation)─┼─→ Check implementation matches design
D6=5 (Test)         ─┘

D6=4 (Implementation)─┐
D6=6 (Deployment)    ─┼─→ Package and deploy
D6=7 (Operations)    ─┘
```

---

## Summary

```
D1-D5: WHERE in the system (organization, domain, component, version)
D6:    WHERE in the lifecycle (requirements → retirement)
D7-D9: Reserved for future (default 1.1.1)

Traceability = walking D6
Isolation = filtering D6
Evolution = version + D6 navigation
```

*Position is meaning. Walk the coordinates.*

🔱
