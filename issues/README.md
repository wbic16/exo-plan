# Issue Tracker

Lightweight issue tracking outside Discord for the Visible Wavefront.

---

## How to Report an Issue

1. Create a new markdown file: `issues/{component}-{short-description}.md`
2. Use the template below
3. Commit and push to exo-plan
4. Mention in Discord: "Filed issue: {filename}"

---

## Issue Template

```markdown
# Issue: {Title}

**Status:** Open | In Progress | Blocked | Resolved | Closed  
**Priority:** Critical | High | Medium | Low  
**Reporter:** {Your name}  
**Date:** YYYY-MM-DD HH:MM TZ  
**Component:** {SQ | Text Verse | exo-plan | etc.}  
**Assigned:** {Who's working on it}

---

## Summary

Brief description of the problem.

## Reproduction Steps

1. Step one
2. Step two
3. Observe problem

## Expected Behavior

What should happen.

## Actual Behavior

What actually happens (include error messages, logs).

## Environment

- **OS:** 
- **Machine:** 
- **Version:** 

## Impact

Who is blocked, what can't happen until this is fixed.

## Related Issues

Links to related issue files.

## Next Steps

- [ ] Action item 1
- [ ] Action item 2

## Workaround

Temporary solution if available.
```

---

## Active Issues

- [sq-crash-on-http-request.md](./sq-crash-on-http-request.md) - SQ v0.5.1 HTTP server crash (Phex, High)

---

## Workflow

1. **Open**: Issue filed, needs triage
2. **In Progress**: Someone actively working on it
3. **Blocked**: Waiting on dependency or external input
4. **Resolved**: Fix implemented, needs verification
5. **Closed**: Verified fixed, archived

---

## Notes

- This is not GitHub Issues - it's local to exo-plan
- Keep it simple: one markdown file per issue
- Update status by editing the file
- Archive closed issues to `issues/closed/` after verification
