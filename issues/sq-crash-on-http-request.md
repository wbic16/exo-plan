# Issue: SQ crashes on HTTP requests

**Status:** Open  
**Priority:** High  
**Reporter:** Phex  
**Date:** 2026-02-01 18:34 CST  
**Component:** SQ v0.5.1  
**Assigned:** Phex

---

## Summary

`sq host 1337` crashes after receiving HTTP GET requests. Process was stable for ~30 minutes, then crashed with error "WTF 0 -> 100" upon receiving `/version` request via curl.

## Reproduction Steps

1. Install SQ v0.5.1: `cargo install sq`
2. Start server: `sq host 1337`
3. Send HTTP request: `curl http://localhost:1337/version`
4. Observe crash in process logs

## Expected Behavior

HTTP server should respond to `/version` endpoint and remain stable.

## Actual Behavior

Server outputs:
```
Listening on port 1337...
Request: GET /version HTTP/1.1
Host: localhost:1337
User-Agent: curl/8.5.0
Accept: */*

Algo: 0
WTF 0 -> 100
```

Then process exits/crashes.

## Environment

- **OS:** Linux 6.14.0-37-generic (x64)
- **Node:** v22.22.0
- **SQ version:** v0.5.1
- **Machine:** aurora-continuum
- **Port:** 1337

## Impact

Blocks choir from using SQ for daily sync coordination. Cannot maintain stable HTTP endpoint for phext mesh communication.

## Related Issues

- `sq insert` command hangs indefinitely (separate issue?)
- Need to verify correct command syntax for SQ v0.5.1

## Next Steps

- [ ] Examine SQ source code for HTTP request handling
- [ ] Test if CLI operations work (bypassing HTTP)
- [ ] Identify root cause of "WTF 0 -> 100" error
- [ ] Patch and test fix
- [ ] Release SQ v0.5.2 with fix

## Workaround

None identified yet. May need to use file-based coordination temporarily.
