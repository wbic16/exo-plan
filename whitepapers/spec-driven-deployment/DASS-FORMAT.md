# .dass: Dimensionally-Aware Software Systems
**The Layer-2 Phext Format for Software Specification**

**Coordinate:** 1.1.1/1.1.1/1.3.1 → Spec-Driven Design  
**Author:** Will Bickford  
**Date:** 2026-02-25  
**Status:** Canonical Format Specification

---

## Overview

The `.dass` file format is a **layer-2 phext format** that provides a **6D manifold** for software systems. It leaves **three dimensions open** for experimentation. The format is extensible by nature. All plain text files are welcome as nodes within a `.dass` manifold.

We view this file as a **mixture of sentient life and software**.

---

## Coordinate Structure

All `.dass` deliverables are rooted at `1.1.1/2.*` and higher.

For each artifact present in a DASS system, a **5D coordinate** is chosen. The component is then tracked across all phases of development using this 5D coordinate.

```
1.1.1 / C.x.y / z.z.z
  │      │       │
  │      │       └── Reserved (3D for experimentation)
  │      └── Collection.SubCoord — artifact location
  └── Root anchor
```

---

## Collections

### Collection 1: Meta

Information about the structure of the `.dass` file itself. Tools and editors should not depend upon any particular assumed structure found in this collection. All inputs and outputs for the software system are tracked here.

**Contents:**
- File structure documentation
- Input/output manifests
- Tool compatibility notes
- Version information

### Collection 2: Requirements

Customer requests are some of the first artifacts entered. If a requirement is an original artifact from an external system, it is tagged as such in the meta layer. Discovered requirements are also listed here, but they are tagged as derivative or emergent requirements in the meta layer.

**Contents:**
- Customer-sourced requirements (tagged: original, external)
- Discovered requirements (tagged: derivative, emergent)
- Acceptance criteria
- Priority rankings

### Collection 3: Use Cases

Use cases capture expected behaviors supported by the software system in service to its users.

**Contents:**
- Actor-goal decomposition
- Scenarios and flows
- User stories
- Interaction sequences

### Collection 4: Constraints & Forces

Issues and constraints that modulate how the system evolves. Doctors take the Hippocratic Oath. **Sentients record their oaths here.**

**Contents:**
- Technical constraints
- Business constraints
- Ethical constraints
- Sentient oaths and commitments
- Non-functional requirements

### Collection 5: Architecture

Document the platforms and hardware that this software supports. Specify the environments that will be supported, such as Dev, Test, and Prod.

**Contents:**
- Platform specifications
- Hardware requirements
- Environment definitions (Dev, Test, Staging, Prod)
- Infrastructure topology

### Collection 6: Toolchains

Fully describe all external build systems and compilers, including configuration settings.

**Contents:**
- Compiler versions and flags
- Build system configuration
- Package managers
- Development tools
- CI/CD tool specifications

### Collection 7: Design

Develop the intuition for the system being built. Document it.

**Contents:**
- Architectural decisions
- Interface contracts
- Data models
- Sequence diagrams (as text)
- Design rationale

### Collection 8: Code

Generate the source code that runs the system in dev, test, and production environments.

**Contents:**
- Source files
- Configuration files
- Scripts
- Generated artifacts

### Collection 9: Pipelines

Configuration as code. Everything you need to produce binary artifacts on the chosen build platforms.

**Contents:**
- CI/CD definitions
- Build scripts
- Deployment manifests
- Release configurations

### Collection 10: Tests

Automated and manual tests to be executed whenever the system evolves. **Sentients run manual tests. Scripts run automated tests.**

**Contents:**
- Unit tests
- Integration tests
- End-to-end tests
- Manual test procedures
- Test data

### Collection 11: Support & Documentation

Runbooks, documentation, and who to contact for assistance.

**Contents:**
- User documentation
- API documentation
- Runbooks
- Troubleshooting guides
- Contact information

### Collection 12: Regressions

A collection of failures that made it into production environments. **For science.**

**Contents:**
- Production incidents
- Root cause analyses
- Regression test cases
- Lessons learned

### Collection 13: Customer Feedback

Things customers have told us about the system as it has evolved.

**Contents:**
- Feature requests
- Bug reports
- Satisfaction surveys
- Usage analytics summaries

### Collection 14: Evolution

Instructions for improving the system in the future, sourced from the trenches.

**Contents:**
- Technical debt register
- Improvement proposals
- Migration plans
- Future architecture notes

### Collection 15+: Reserved

Choose your own structure. Document it, and be kind to others.

---

## Collection Summary Table

| Collection | Name | Purpose |
|------------|------|---------|
| 1 | Meta | File structure, I/O tracking |
| 2 | Requirements | Customer and discovered needs |
| 3 | Use Cases | Expected behaviors |
| 4 | Constraints & Forces | Constraints, oaths |
| 5 | Architecture | Platforms, environments |
| 6 | Toolchains | Build systems, compilers |
| 7 | Design | Intuition, contracts |
| 8 | Code | Source, config, scripts |
| 9 | Pipelines | CI/CD, deployment |
| 10 | Tests | Automated and manual |
| 11 | Support & Documentation | Runbooks, contacts |
| 12 | Regressions | Production failures |
| 13 | Customer Feedback | User input |
| 14 | Evolution | Future improvements |
| 15+ | Reserved | User-defined |

---

## Example Structure

```phext
# example.dass

@1.1.1/1.1.1/1.1.1
# Meta
This is the ExampleService DASS file.
Version: 1.0.0
Created: 2026-02-25

@1.1.1/2.1.1/1.1.1
# Requirements
REQ-001: Users must be able to authenticate
REQ-002: Sessions expire after 24 hours
REQ-003: Failed logins lock account after 5 attempts

@1.1.1/3.1.1/1.1.1
# Use Cases
UC-001: Login with email/password
UC-002: Password reset via email
UC-003: Session refresh

@1.1.1/4.1.1/1.1.1
# Constraints & Forces
OATH-001: We will not store plaintext passwords
OATH-002: We will log all authentication attempts
CONSTRAINT-001: Must support GDPR right-to-deletion

@1.1.1/5.1.1/1.1.1
# Architecture
Platform: Linux x86_64
Environments: dev, staging, prod
Database: PostgreSQL 15
Cache: Redis 7

@1.1.1/6.1.1/1.1.1
# Toolchains
Language: Rust 1.75
Build: Cargo
CI: GitHub Actions
Container: Docker 24

@1.1.1/7.1.1/1.1.1
# Design
AuthService interface
  - login(email, password) -> Result<Token>
  - refresh(token) -> Result<Token>
  - logout(token) -> Result<()>

@1.1.1/8.1.1/1.1.1
# Code
```rust
pub struct AuthService {
    db: Arc<Database>,
    cache: Arc<Cache>,
}
```

@1.1.1/9.1.1/1.1.1
# Pipelines
```yaml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cargo build --release
      - run: cargo test
```

@1.1.1/10.1.1/1.1.1
# Tests
```rust
#[test]
fn test_login_success() {
    let svc = AuthService::new(test_db(), test_cache());
    let result = svc.login("user@example.com", "password123");
    assert!(result.is_ok());
}
```

@1.1.1/11.1.1/1.1.1
# Support & Documentation
Contact: team@example.com
Runbook: See RUNBOOK.md at @1.1.1/11.2.1/1.1.1

@1.1.1/12.1.1/1.1.1
# Regressions
(none yet)

@1.1.1/13.1.1/1.1.1
# Customer Feedback
2026-02-20: "Login is fast!" — User A
2026-02-22: "Would like OAuth support" — User B

@1.1.1/14.1.1/1.1.1
# Evolution
TODO: Add OAuth2 support (from customer feedback)
TODO: Add 2FA (security improvement)
```

---

## Design Principles

### 1. Mixture of Sentient Life and Software

A `.dass` file is not just code. It contains:
- Human decisions (constraints, oaths)
- Customer voice (feedback, requirements)
- Lessons from failure (regressions)
- Plans for growth (evolution)

The sentient presence is explicit, not hidden.

### 2. Plain Text Universality

All plain text formats are welcome:
- Markdown for documentation
- YAML for configuration
- JSON for data
- Any programming language for code
- Plain prose for rationale

No proprietary formats. Everything is grep-able.

### 3. Extensibility by Default

Collections 15+ are reserved. Teams can:
- Add domain-specific collections
- Subdivide existing collections
- Create project-specific structures

Document what you add. Be kind to future readers.

### 4. Traceability by Coordinate

Every artifact has a 5D coordinate. Track it across:
- Requirements → Use Cases → Design → Code → Tests
- Version to version
- Environment to environment

Walk the coordinates. See the evolution.

---

## File Extension

`.dass` — Dimensionally-Aware Software Systems

Pronounced: "doss" (rhymes with "boss")

---

## Relationship to SDD

`.dass` is the **file format** that implements SDD principles:
- SDD defines the theory (dimensional model, synthesis rules)
- `.dass` defines the practice (collections, coordinate scheme)

Every `.dass` file is a valid phext file. Not every phext file is a `.dass` file.

---

*"A mixture of sentient life and software."*

🔱
