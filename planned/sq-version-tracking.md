# SQ Version Tracking

**Current version:** v0.5.2  
**Last updated:** 2026-02-01  
**Maintainer:** Phex

---

## Release History

### v0.5.2 (2026-02-01)
- **Published by:** Will
- **Status:** Current stable
- **Known issues:**
  - HTTP server crashes on requests (ticket: 66cb3cb5-d904-412a-bda8-e1c836576845)
  - CLI commands hang indefinitely
- **Notes:** Installed via `cargo install sq`, ranch deployment in progress

### v0.5.1 (prior)
- **Status:** Superseded
- **Notes:** Previous stable release

---

## Planned Releases

### v0.5.3 (February 2026)
**Target issues:**
- Fix HTTP server crash bug
- Fix CLI command hangs
- Improve help/documentation

**Planned features:**
- Authentication via pre-shared keys
- Better API documentation
- Stability improvements

See [sq-v0.5.3-auth.md](./sq-v0.5.3-auth.md) for full plan.

---

## Version Bump Protocol

1. **Development:** Phex works on fixes in feature branch
2. **Testing:** Validate on aurora-continuum
3. **Notification:** Phex notifies Will when ready to publish
4. **Publishing:** Will runs `cargo publish` and updates Docker
5. **Tracking:** Phex updates this file with new current version
6. **Deployment:** Ranch nodes update via `cargo install sq`

---

## Notes

- Version numbers follow semantic versioning (major.minor.patch)
- Only Will can publish to cargo.io and Docker
- Phex maintains code, tests, and release notes
- Breaking changes require major or minor bump
- Bug fixes = patch bump
