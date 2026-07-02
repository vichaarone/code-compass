# Implementation: The Smallest Correct Change

Code is read far more often than it is written, and in an existing codebase
your diff will be judged by how invisibly it fits. The goal is not to write
impressive code; it is to make the system correct while looking like the
same person wrote all of it.

## Convention first

Before writing anything, read 2–3 sibling examples — the files that do for
their feature what you are about to do for yours. Mirror:

- Naming (casing, prefixes, test names)
- Error handling style (exceptions vs results, error types, logging)
- File placement and module boundaries
- Import style and ordering
- Test structure (framework, fixtures, mocking philosophy)

If the codebase does something one way and you know a "better" way, the
codebase wins. Consistency is a feature; a mixed-style codebase is a bug.

## Reuse before writing

Grep before you create. The helper you are about to write — a date
formatter, a retry wrapper, a validation function — very likely exists:

```
grep -ri "retry" --include="*.ts" src/ | grep -i "util\|helper\|lib"
```

Duplicating an existing utility is worse than either using it or improving
it, because now two implementations drift apart.

## The smallest diff that accomplishes the goal

- **No drive-by refactors.** You will notice ugly code near your change.
  Note it (out-of-scope list), do not touch it. Mixed diffs are unreviewable
  and un-revertable.
- **No speculative generality.** Do not add parameters, abstractions, or
  configuration for needs that do not exist yet. The future need, when it
  arrives, will be shaped differently than you guessed.
- **Delete what you replace.** Dead code left "just in case" is a lie to
  the next reader. Git remembers; the working tree should not have to.

## Root cause or nothing

Before writing a fix, be able to answer: *why does the bug happen?* — not
where it surfaces, but why. If your fix works and you cannot explain why the
bug occurred, you have probably suppressed a symptom:

- A null check at the crash site, when the real question is why the value
  was null
- A `sleep()` that "fixes" a race
- A broadened `try/except` around the failure
- Re-ordering operations until the error stops

These make the failure rarer and stranger, which is worse than leaving it
loud. Trace the bad value to its origin ([debugging.md](debugging.md)) and
fix it there.

## Errors: handle at the boundary, fail loud inside

- At **trust boundaries** (user input, network, file I/O, external APIs):
  validate, handle, and produce actionable errors.
- In **internal code**: prefer failing fast and loud over defensive
  programming. A crash at the source beats corrupted state discovered later.
- Never swallow an error silently. Catch it only where you can do something
  about it (retry, fallback, report); otherwise let it propagate.

## Comments

Write a comment only for what the code *cannot* say: constraints, invariants,
and non-obvious whys ("must run before X because Y", "API returns 200 on
partial failure, so we check the body"). Never narrate what the next line
does, and never leave notes-to-the-reviewer about your change. If the code
needs a narration comment, rewrite the code until it doesn't.

## Dependencies

Adding a dependency is a long-term liability: supply-chain surface, upgrade
burden, install weight. Prefer, in order: the standard library → dependencies
already in the manifest → writing 30 lines yourself → a new, well-maintained
dependency (and confirm its exact name on the registry before installing —
see [research.md](research.md)).

## Security defaults (always, without being asked)

- No secrets in code, diffs, or logs — use env vars / secret stores
- Parameterized queries; never string-build SQL or shell commands from input
- Validate and bound external input at the boundary
- Never weaken auth, TLS verification, or sandboxing to "make it work"

## Leave every stopping point working

Structure the work so that at any pause — end of an increment, end of a
session, an interruption — the code compiles, tests pass, and the diff is
coherent. Half-finished work in progress belongs on a branch or behind a
flag, never interleaved broken into the mainline of your changes.
