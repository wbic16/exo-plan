# Ticket System

Lightweight ticket tracking outside Discord for the Visible Wavefront.

---

## How to File a Ticket

1. Generate UUID: `uuidgen`
2. Create file: `tickets/new/{uuid}.md`
3. Use the template below
4. Commit and push to exo-plan
5. Mention in Discord: "Filed ticket: {uuid}"

## How to Close a Ticket

1. Move from `tickets/new/{uuid}.md` to `tickets/closed/{uuid}.md`
2. Update status to "Closed" in the file
3. Commit with message: "Close ticket {uuid}: {summary}"

---

## Ticket Template

```markdown
# Ticket: {Title}

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

## Active Tickets

- [66cb3cb5-d904-412a-bda8-e1c836576845](./new/66cb3cb5-d904-412a-bda8-e1c836576845.md) - SQ v0.5.1 HTTP server crash (Phex, High)

---

## Workflow

1. **Open**: Ticket filed in `tickets/new/`, needs triage
2. **In Progress**: Someone actively working on it
3. **Blocked**: Waiting on dependency or external input
4. **Resolved**: Fix implemented, needs verification
5. **Closed**: Moved to `tickets/closed/`, verified fixed

---

## Notes

- This is not GitHub Issues - it's local to exo-plan
- Keep it simple: one markdown file per ticket, UUID-named
- Update status by editing the file
- Move to `tickets/closed/` when verified fixed
