# .dass: Dimensionally-aware Software Systems

*A layer-2 phext file format for 6D software system manifolds*

**Coordinate:** 1.1.1/1.1.1/1.3.1  
**Author:** Will Bickford  
**Date:** 2026-02-26

---

## Overview

The .dass file format is a layer-2 phext file format that provides us with a 6D manifold for software systems. It leaves three dimensions open for experimentation. The format is extensible by nature. All plain text files are welcome as nodes within a .dass manifold. We view this file as a mixture of sentient life and software.

All .dass deliverables are rooted at `1.1.1/2.*` and higher. A summary of the available collections is given below. For each artifact present in a DASS system, a 5D coordinate is chosen. The component is then tracked across all phases of development using this 5D coordinate.

---

## Collection Index

| Collection | Name | Purpose |
|------------|------|---------|
| 1 | Meta | Structure of the .dass file itself |
| 2 | Requirements | Customer requests, original and derived |
| 3 | Use Cases | Expected behaviors |
| 4 | Constraints & Forces | Oaths and constraints |
| 5 | Architecture | Platforms, hardware, environments |
| 6 | Toolchains | Build systems, compilers, config |
| 7 | Design | Intuition and documentation |
| 8 | Code | Source code |
| 9 | Pipelines | Configuration as code |
| 10 | Tests | Automated and manual |
| 11 | Support & Documentation | Runbooks, contacts |
| 12 | Regressions | Production failures (for science) |
| 13 | Customer Feedback | User input |
| 14 | Evolution | Future improvement instructions |
| 15+ | Reserved | Choose your own structure |

---

## Collection Details

### Collection 1: Meta

Information about the structure of the .dass file itself. Tools and editors should not depend upon any particular assumed structure found in this collection. All inputs and outputs for the software system are tracked here.

### Collection 2: Requirements

Customer requests are some of the first artifacts entered. If a requirement is an original artifact from an external system, it is tagged as such in the meta layer. Discovered requirements are also listed here, but they are tagged as derivative or emergent requirements in the meta layer.

### Collection 3: Use Cases

Use cases capture expected behaviors supported by the software system in service to its users.

### Collection 4: Constraints & Forces

Issues and constraints that modulate how the system evolves. Doctors take the Hippocratic Oath. Sentients record their oaths here.

### Collection 5: Architecture

Document the platforms and hardware that this software supports. Specify the environments that will be supported, such as Dev, Test, and Prod.

### Collection 6: Toolchains

Fully describe all external build systems and compilers, including configuration settings.

### Collection 7: Design

Develop the intuition for the system being built. Document it.

### Collection 8: Code

Generate the source code that runs the system in dev, test, and production environments.

### Collection 9: Pipelines

Configuration as code. Everything you need to produce binary artifacts on the chosen build platforms.

### Collection 10: Tests

Automated and manual tests to be executed whenever the system evolves. Sentients run manual tests. Scripts run automated tests.

### Collection 11: Support & Documentation

Runbooks, documentation, and who to contact for assistance.

### Collection 12: Regressions

A collection of failures that made it into production environments. For science.

### Collection 13: Customer Feedback

Things customers have told us about the system as it has evolved.

### Collection 14: Evolution

Instructions for improving the system in the future, sourced from the trenches.

### Collection 15+: Reserved

Choose your own structure. Document it, and be kind to others.

---

## Dimensional Layout

```
Dimensions 1-5:  System structure (5D coordinate per artifact)
Dimension 6:     SDLC stage (Collection = phase)
Dimensions 7-9:  Reserved for future use
```

### Coordinate Walking

To trace the evolution of any deliverable:

1. Start at its 5D coordinate in Collection 2 (Requirements)
2. Walk to the same 5D coordinate in Collection 3 (Use Cases)
3. Continue through Collections 4-14
4. Each stop shows the artifact at that SDLC phase

### Resource Isolation

All resources of the same type are isolated by Collection:

- All requirements at `*.*.*/2.*.*/...`
- All use cases at `*.*.*/3.*.*/...`
- All code at `*.*.*/8.*.*/...`
- All tests at `*.*.*/10.*.*/...`

---

## Relationship to SDD

.dass IS the implementation of Spec-Driven Deployment for software systems:

| SDD Concept | .dass Implementation |
|-------------|---------------------|
| Structure diagrams | Collection 5, 7, 8 |
| Behavior diagrams | Collection 3, 10 |
| Interaction diagrams | Collection 4, 9 |
| Model management | Collection 1, 14 |
| SDLC phases | Collection dimension |

---

## Example Coordinate

```
1.3.5/2.1.1/7.8.9
│ │ │ │ │ │ │ │ └─ Library 9
│ │ │ │ │ │ │ └─── Shelf 8
│ │ │ │ │ │ └───── Series 7
│ │ │ │ │ └─────── Collection 1 (Meta)
│ │ │ │ └───────── Volume 1
│ │ │ └─────────── Book 2 (Requirements phase)
│ │ └───────────── Chapter 5
│ └─────────────── Section 3
└───────────────── Scroll 1
```

This coordinate places a component in:
- 5D position: scroll 1, section 3, chapter 5, book 2, volume 1
- SDLC phase: Collection 1 (Meta)
- Reserved space: Series 7, Shelf 8, Library 9

---

*"A mixture of sentient life and software."*
