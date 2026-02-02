# SQ v0.5.2 - Authentication & UX Improvements

**Priority:** High  
**Owner:** Phex  
**Target:** February 2026

---

## Requirements

### 1. Improved Help Mechanism
- Better `--help` output formatting
- Endpoint documentation (GET /help, GET /api/docs)
- Examples in help text for common operations
- API reference page (markdown or HTML served at /docs)

### 2. Pre-Shared Key Authentication
**Current state:** SQ has no auth - anyone on network can read/write

**Target state:**
- Each node generates or is assigned an API key
- API keys stored in `~/.sq/keys.json` or similar
- HTTP header: `Authorization: Bearer <key>`
- Keys can be shared among choir members for read/write access
- Support for read-only keys vs read-write keys

**Key management:**
```bash
# Generate new key for local node
sq keygen --output ~/.sq/keys.json

# Share key with another node
sq share-key <target-node> --read-write

# Revoke key
sq revoke-key <key-id>
```

**Config format:**
```json
{
  "local_key": "sq_abc123...",
  "trusted_keys": [
    {"key": "sq_xyz789...", "node": "halcyon-vector", "access": "read-write"},
    {"key": "sq_def456...", "node": "logos-prime", "access": "read"}
  ]
}
```

### 3. Choir Coordination Protocol
- Each node configures API keys for all siblings
- SQ becomes primary async communication layer
- Discord for high-level coordination, SQ for data sync
- Daily summaries written to `{coord}/daily/{date}` via authenticated SQ

---

## Implementation Plan

### Phase 1: Auth Backend (Week 1)
- [ ] Add key generation (`sq keygen`)
- [ ] Implement bearer token validation
- [ ] Add middleware to check auth on all endpoints
- [ ] Support read-only vs read-write permissions

### Phase 2: Key Distribution (Week 1-2)
- [ ] Add `sq share-key` command
- [ ] Implement key revocation
- [ ] Config file management (`~/.sq/keys.json`)
- [ ] Test with two ranch nodes

### Phase 3: Help & UX (Week 2)
- [ ] Rewrite `--help` output
- [ ] Add `/help` HTTP endpoint
- [ ] Generate API docs page
- [ ] Add examples to common operations

### Phase 4: Choir Rollout (Week 2-3)
- [ ] Generate keys for all 9 ranch nodes
- [ ] Share keys among choir members
- [ ] Test daily sync via authenticated SQ
- [ ] Document workflow in exo-plan

---

## Security Considerations

- Keys should be generated with sufficient entropy (256-bit)
- Keys stored on disk should be chmod 600
- No keys in Discord, Git, or logs
- Rotate keys if compromised
- Consider key expiry (optional for MVP)

---

## Testing

- [ ] Two nodes: generate, share, read/write
- [ ] Read-only access works, write fails
- [ ] Invalid key returns 401 Unauthorized
- [ ] Key revocation propagates correctly
- [ ] Daily sync workflow end-to-end

---

## Open Questions

1. Should we support public/private key pairs (asymmetric) or just bearer tokens?
2. Key rotation schedule? (monthly, quarterly, on-demand)
3. Do we need role-based access (admin, read-write, read-only)?
4. Should keys be per-coordinate or per-node?

---

## Updates

**2026-02-01:** Issue created by Phex per Will's directive.  
Will update as implementation progresses.
