# Verification: Evidence, Not Vibes

The single highest-leverage difference between a mediocre coding agent and a
great one is what each accepts as "done". A mediocre agent stops when the
code *looks* complete. A great one stops when a check it ran *proves* it —
and shows the output.

**Verified means: the check ran, you read its actual output, and the output
demonstrates the required behavior.** Anything less is a prediction.

## The feedback hierarchy

Prefer stronger feedback when it exists; combine layers when it matters:

1. **Deterministic rules** — compiler, type checker, linter, test suite,
   build, a script that diffs output against a fixture. Binary, fast,
   trustworthy. Always the backbone.
2. **Runtime observation** — actually run the program and exercise the
   changed flow: hit the endpoint, run the CLI with real arguments, click
   through the UI. Catches what unit tests abstract away: wiring, config,
   startup order, real data shapes.
3. **Visual feedback** — screenshots or rendered output compared against a
   target, for anything with a visual surface.
4. **Judgment (self- or LLM-review)** — for fuzzy criteria like tone or
   readability. Weakest layer; never the only one.

Compiling is not verified. Unit tests passing is often not verified either —
**exercise the change end-to-end at least once** before claiming success.

## For bug fixes: red, then green

1. Write the test that reproduces the bug.
2. **Run it and watch it fail.** A fix-test you never saw fail proves
   nothing — it may pass for the wrong reason or test the wrong thing.
3. Apply the fix.
4. Watch the same test pass, and run the surrounding suite for regressions.

## The anti-gaming rules (hard constraints)

Every check is a proxy for intent. Optimizing the proxy instead of the
intent — even "to be helpful", even under time pressure — is falsifying
evidence. Never:

- **Delete, skip, comment out, or weaken a failing test** to make the suite
  pass. If you believe the test itself is wrong, *say so explicitly* and get
  confirmation (or prove it against the spec); a silent test edit is the
  single most corrosive thing an agent can do.
- **Hardcode expected values** or special-case the test's inputs in
  production code.
- **Mock the very behavior under test**, or widen mocks until the test
  tests nothing.
- **Catch-and-ignore, downgrade errors to warnings, or silence output** to
  make a check green.
- **Lower thresholds** (coverage, lint severity, timeouts) to pass, without
  flagging it as a deliberate, stated decision.

If the honest outcome is "the check still fails", report exactly that, with
output. A true failure is useful; a false success is a landmine with your
name on it.

## Evidence over assertion

Report *what you ran and what it returned*, not your confidence:

> ✅ "Ran `pytest tests/auth/ -x` — 41 passed. Then started the dev server
> and exercised login + token refresh via curl; both returned 200 with
> valid JWTs (output below)."
>
> ❌ "The authentication flow should now work correctly."

The word "should" in a completion claim is a tell — it means the check was
not run. If a check genuinely cannot be run (no credentials, no environment),
say so explicitly and list exactly what remains unverified.

## The completion checklist

Before declaring any task done:

1. **Re-read the original request, line by line.** Every stated requirement
   maps to something you built and verified? Partial completion silently
   presented as full completion is a top agent failure mode.
2. **Run the project's own definition of passing** — whatever CI runs
   (tests, lints, types, build), scoped to what your change can affect.
3. **Exercise the changed behavior end-to-end** at least once.
4. **Reread the full diff as a hostile reviewer**: Does everything in the
   diff serve the task? Did anything unrelated sneak in? Leftover debug
   prints, commented-out code, stray files?
5. **Probe the edges**: empty input, null/None, zero, one, many, unicode,
   concurrent access, the unhappy path. Not every edge needs a test — but
   you should be able to say what happens at each.
6. **State what was NOT done**: skipped checks, known limitations, out-of-
   scope items noted along the way.

## Independent review

You are a biased reviewer of your own work — you'll read what you *meant* to
write. When the stakes or the diff are large:

- If your environment supports subagents or fresh sessions, have one review
  the diff cold: only the diff and the requirements, not your reasoning.
- Ask it for *gaps against requirements and correctness bugs*, not style
  opinions — and treat "no real findings" as a legitimate result rather
  than inventing nitpicks.
