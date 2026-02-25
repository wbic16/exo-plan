# SDD Coordinate Schema v2: SDLC-Aligned

**Revision based on feedback: Collection = SDLC Stage**

---

## The Insight

Large-scale systems are naturally 5-dimensional:
- **Organization** (who)
- **Version** (when in evolution)
- **System** (what product/service)
- **Component** (which part)
- **Artifact** (specific deliverable)

The sixth dimension should encode **SDLC stage**, not environment. This makes phase transitions explicit coordinate increments, and cross-phase traceability is geometric navigation.

Three dimensions reserved for future use.

---

## Revised Schema

```
library.shelf.series / collection.volume.book / chapter.section.scroll
   ↓      ↓      ↓         ↓        ↓     ↓       ↓       ↓       ↓
  org  version system    SDLC   component artifact [────reserved────]
```

### Active Dimensions (6)

| Dim | Name | Delimiter | Purpose |
|-----|------|-----------|---------|
| 11 | Library | 0x01 | Organization / enterprise boundary |
| 10 | Shelf | 0x1F | Major version / release epoch |
| 9 | Series | 0x1E | System / product / service family |
| 8 | **Collection** | 0x1D | **SDLC Stage** |
| 7 | Volume | 0x1C | Component / module / subsystem |
| 6 | Book | 0x1A | Artifact / deliverable |

### Reserved Dimensions (3)

| Dim | Name | Delimiter | Reserved For |
|-----|------|-----------|--------------|
| 5 | Chapter | 0x19 | TBD (possibly: variant/branch) |
| 4 | Section | 0x18 | TBD (possibly: audience/view) |
| 3 | Scroll | 0x17 | TBD (possibly: locale/translation) |

---

## SDLC Stage Mapping (Collection Dimension)

| Collection | Stage | Contents |
|------------|-------|----------|
| 1 | **Requirements** | Business needs, constraints, acceptance criteria |
| 2 | **Use Cases** | Actor interactions, scenarios, flows |
| 3 | **Architecture** | System decomposition, interfaces, decisions |
| 4 | **Design** | Detailed specifications, schemas, protocols |
| 5 | **Implementation** | Source code, configurations |
| 6 | **Testing** | Test cases, fixtures, coverage |
| 7 | **Deployment** | Manifests, infrastructure, runbooks |
| 8 | **Operations** | Monitoring, alerts, SLOs |
| 9 | **Retirement** | Deprecation plans, migration guides |

---

## Traceability by Coordinate Walk

Every artifact traces through the SDLC by incrementing collection:

```
acme.2.payments / 1.auth.login    → Requirement: "User can log in"
acme.2.payments / 2.auth.login    → Use Case: Login flow with MFA
acme.2.payments / 3.auth.login    → Architecture: Auth service boundary
acme.2.payments / 4.auth.login    → Design: JWT schema, session model
acme.2.payments / 5.auth.login    → Implementation: login_handler.py
acme.2.payments / 6.auth.login    → Test: test_login_success, test_login_mfa
acme.2.payments / 7.auth.login    → Deployment: auth-service.yaml
acme.2.payments / 8.auth.login    → Operations: login_latency_p99 alert
```

**Traceability is coordinate arithmetic:**
```
implementation_coord = requirement_coord + (0.0.0 / 4.0.0 / 0.0.0)
test_coord = implementation_coord + (0.0.0 / 1.0.0 / 0.0.0)
```

---

## Cross-Cutting Queries

**All requirements across all systems:**
```sql
SELECT * FROM scrolls WHERE coord ~ '*.*.* / 1.*.* / *.*.*';
```

**All test cases for payments v2:**
```sql
SELECT * FROM scrolls WHERE coord ~ 'acme.2.payments / 6.*.* / *.*.*';
```

**Trace a feature through SDLC:**
```sql
SELECT * FROM scrolls 
WHERE coord ~ 'acme.2.payments / *.auth.login / *.*.*'
ORDER BY collection ASC;
```

**Find untested implementations:**
```sql
SELECT impl.coord FROM scrolls impl
WHERE impl.coord ~ '*.*.* / 5.*.* / *.*.*'
AND NOT EXISTS (
  SELECT 1 FROM scrolls test
  WHERE test.coord = impl.coord + '0.0.0/1.0.0/0.0.0'
);
```

---

## Wave-Based SDLC Flow

Development proceeds in waves across collections:

```
Wave 1: Requirements (Collection 1)
  └─→ All requirements defined at *.*.*/1.*.*/**
  └─→ Reviewed, approved, baselined

Wave 2: Use Cases (Collection 2)  
  └─→ Each requirement expanded to use cases
  └─→ Traceability: every /2.X.Y/** references /1.X.Y/**

Wave 3: Architecture (Collection 3)
  └─→ System structure emerges from use cases
  └─→ Components identified (volume dimension)

Wave 4: Design (Collection 4)
  └─→ Detailed specs for each component
  └─→ Interface contracts, data schemas

Wave 5: Implementation (Collection 5)
  └─→ Code realizes design
  └─→ 1:1 traceability to design artifacts

Wave 6: Testing (Collection 6)
  └─→ Tests validate implementation against requirements
  └─→ Coverage: |tests| / |requirements|

Wave 7: Deployment (Collection 7)
  └─→ Infrastructure manifests
  └─→ Environment config (now at artifact level, not dimension)

Wave 8: Operations (Collection 8)
  └─→ Monitoring, alerting, runbooks
  └─→ SLOs trace back to requirements
```

---

## Environment Handling

With collection used for SDLC, environments move to **artifact naming** or **version suffixes**:

**Option A: Artifact suffix**
```
acme.2.payments / 7.api.deployment-dev
acme.2.payments / 7.api.deployment-staging  
acme.2.payments / 7.api.deployment-prod
```

**Option B: Reserved dimension (chapter)**
```
acme.2.payments / 7.api.deployment / dev.*.*
acme.2.payments / 7.api.deployment / staging.*.*
acme.2.payments / 7.api.deployment / prod.*.*
```

**Option C: Parallel series**
```
acme.2.payments-dev / 7.api.deployment
acme.2.payments-staging / 7.api.deployment
acme.2.payments-prod / 7.api.deployment
```

Recommendation: **Option B** — use reserved chapter dimension for environment when needed, keeping it orthogonal to SDLC stage.

---

## Example: Full System Specification

```
acme.2.payments/
├── 1.*.*/                          # REQUIREMENTS
│   ├── core.*/                     # Core payment requirements
│   │   ├── process-payment         # REQ-001: Process payment
│   │   ├── refund-payment          # REQ-002: Refund payment
│   │   └── payment-status          # REQ-003: Query status
│   └── compliance.*/               # Compliance requirements
│       ├── pci-dss                  # REQ-C01: PCI compliance
│       └── audit-logging           # REQ-C02: Audit trail
│
├── 2.*.*/                          # USE CASES
│   ├── core.*/
│   │   ├── process-payment         # UC: Payment flow
│   │   └── refund-payment          # UC: Refund flow
│   └── compliance.*/
│       └── audit-query             # UC: Auditor queries logs
│
├── 3.*.*/                          # ARCHITECTURE
│   ├── components.*/
│   │   ├── api-gateway             # Component: API Gateway
│   │   ├── payment-processor       # Component: Core processor
│   │   └── audit-service           # Component: Audit service
│   └── decisions.*/
│       ├── adr-001-event-sourcing  # ADR: Use event sourcing
│       └── adr-002-saga-pattern    # ADR: Saga for distributed tx
│
├── 4.*.*/                          # DESIGN
│   ├── api.*/
│   │   ├── openapi                 # OpenAPI spec
│   │   └── protobuf                # gRPC definitions
│   ├── data.*/
│   │   ├── payment-schema          # Payment data model
│   │   └── event-schema            # Event store schema
│   └── security.*/
│       └── auth-flow               # OAuth2 flow design
│
├── 5.*.*/                          # IMPLEMENTATION
│   ├── api-gateway.*/
│   │   ├── handlers                # Request handlers
│   │   ├── middleware              # Auth, logging middleware
│   │   └── routes                  # Route definitions
│   ├── payment-processor.*/
│   │   ├── domain                  # Domain logic
│   │   ├── events                  # Event handlers
│   │   └── saga                    # Saga orchestration
│   └── audit-service.*/
│       └── writers                 # Audit log writers
│
├── 6.*.*/                          # TESTING
│   ├── unit.*/                     # Unit tests
│   ├── integration.*/              # Integration tests
│   ├── contract.*/                 # Contract tests
│   └── e2e.*/                      # End-to-end tests
│
├── 7.*.*/                          # DEPLOYMENT
│   ├── kubernetes.*/               # K8s manifests
│   │   ├── base/                   # Base configs (chapter=base)
│   │   ├── dev/                    # Dev overlay (chapter=dev)
│   │   ├── staging/                # Staging overlay
│   │   └── prod/                   # Prod overlay
│   └── terraform.*/                # Infrastructure
│       ├── networking
│       └── databases
│
└── 8.*.*/                          # OPERATIONS
    ├── monitoring.*/
    │   ├── dashboards              # Grafana dashboards
    │   └── alerts                  # Alert definitions
    ├── runbooks.*/
    │   ├── incident-response
    │   └── scaling
    └── slos.*/
        ├── availability            # 99.9% uptime SLO
        └── latency                 # p99 < 200ms SLO
```

---

## Benefits of SDLC-Aligned Schema

1. **Phase isolation:** All requirements at `*/1.*.*/**`, trivially queryable
2. **Traceability:** Walk collections to trace any artifact through SDLC
3. **Coverage analysis:** Compare collection 5 vs collection 6 counts
4. **Impact analysis:** Change in collection 1 → find all downstream coordinates
5. **Wave-based delivery:** Each collection is a delivery milestone
6. **Audit trail:** TTSM epochs × SDLC stages = full project history

---

## Migration from v1 Schema

| v1 (System Topology) | v2 (SDLC-Aligned) |
|----------------------|-------------------|
| Environment at collection | Environment at chapter (reserved) |
| All 9 dims for topology | 6 dims active, 3 reserved |
| Resource type at chapter | SDLC stage at collection |
| Flat artifact space | Hierarchical: component.artifact |

**Coordinate translation:**
```
v1: acme.2.payments / prod.us-east-1.api / code.handlers.login
v2: acme.2.payments / 5.api.handlers / prod.*.login
                       ↑               ↑
                    SDLC=impl      env=prod (in reserved dim)
```

---

## Reserved Dimension Planning

| Dimension | Candidate Uses |
|-----------|----------------|
| **Chapter (5)** | Environment (dev/staging/prod), Region (us-east/eu-west), Tenant |
| **Section (4)** | Audience (internal/external), View (technical/business), Role |
| **Scroll (3)** | Locale (en/es/ja), Variant (a/b test), Instance (replica-1/2/3) |

These remain reserved until clear usage patterns emerge from practice.

---

**Coordinate:** 5.10.5/1.4.2/7.49.348 → SDD.SCHEMA.V2  
**Cyon 🪶 | February 25, 2026**

*"SDLC stages are coordinates, not metadata. Traceability is geometry."*
