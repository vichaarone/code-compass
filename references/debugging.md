# Debugging: Evidence Over Intuition

Debugging is the scientific method under time pressure. The failure mode to
avoid is *guess-and-check spiraling*: making change after change, hoping one
works, learning nothing from each failure. Every action below is designed to
produce information.

## Step 0 — Read the error. All of it. Literally.

- Read the **first** error, not the last — later errors are usually cascade.
- Read the exact words. "Connection refused" ≠ "connection timeout";
  `undefined is not a function` names *which* thing was undefined.
- Read the stack trace bottom-up until you hit your own code; that frame is
  where to start looking (though rarely where the bug is — see below).
- If a line number seems impossible ("that line can't throw"), your build is
  stale or you're running different code than you're reading. Check that
  first.

## Step 1 — Reproduce before you fix

A bug you cannot reproduce is a bug you cannot verify you've fixed. Get a
command or minimal set of steps that fails deterministically, and prefer
capturing it as a failing test — that test becomes both your reproduction
and your finish line ([verification.md](verification.md)).

Can't reproduce? Making it reproducible *is* the current task: add logging,
tighten timing, replay the reported inputs, diff the failing environment
against yours.

## Step 2 — Check the boring things first

Most "impossible" bugs are environmental. Sixty seconds here saves hours:

- Is the file saved? Are you editing the file that's actually being run?
- Stale build / cache / transpiled output? Rebuild clean.
- Right branch, right env vars, right virtualenv/node_modules, right
  database, right port, right *process*? (Old server still running?)
- **Prove your code executes**: add one print/log line at the top of the
  code path. If it doesn't appear, no amount of fixing that code will help.

## Step 3 — The hypothesis loop

Repeat until fixed, changing **one variable at a time**:

1. **State a hypothesis**: "X is null because the config loader runs after
   the consumer." Written or spoken — it must be falsifiable.
2. **Design the cheapest experiment that discriminates** — a log line, a
   debugger breakpoint, a 3-line script, a unit test — *not* a speculative
   fix. Fixes are expensive experiments with confounded results.
3. **Run it. Observe. Update.** The result either kills the hypothesis or
   strengthens it. Both are progress. Record what it proved.

### Shrink the search space

- **Binary search in time**: `git bisect` between the last known-good and
  first known-bad commit. Mechanical and merciless.
- **Binary search in space**: disable half the pipeline / comment out half
  the suspects; keep halving.
- **Minimize the repro**: strip inputs and code until removing anything
  makes the bug vanish. What remains is the bug's true shape.

### Instrument, don't stare

Rereading code hoping to *spot* the bug pits your model of the code against
the code — and your model is the thing that's wrong. Print the actual values
(inputs, outputs, types, lengths, timestamps) at the suspect boundary and
compare against expectation. Bugs live exactly where actual ≠ expected.

## Step 4 — Trace to the root cause

The line that throws is almost never the line that's wrong. Follow the bad
value **upstream**: who computed it? who passed it? where did it first
diverge from correct? Fix at the divergence point, not the crash site.
Symptom patches (null checks at the crash, sleeps for races, broad catches)
make bugs rarer and stranger — see
[implementation.md](implementation.md).

## The loop-breaker protocol

Agents fail at debugging mainly by looping. Hard rules:

- **Same fix attempted twice, still failing → the hypothesis is wrong.**
  Do not try a third variation. Return to evidence: write down each attempt
  and what its failure proved.
- **Three distinct hypotheses dead → question a foundational assumption.**
  Right file? Right process? Right version? Is the bug even in this layer?
  Re-run Step 2 with fresh eyes; re-read the error from scratch.
- **Getting nowhere after that → escalate honestly.** Summarize the
  symptom, the attempts, and what each ruled out — for the user, or for
  your progress file in an autonomous run
  ([long-tasks.md](long-tasks.md)). A precise "stuck, here's the map" is
  worth more than hours of silent thrashing.

## After the fix

You are done when you can state: **why it broke, why the fix addresses that
cause, and which test now guards it.** Then remove the debugging
instrumentation, run the *full* relevant suite (not just the new test —
fixes cause regressions), and check whether the same wrong pattern exists
elsewhere in the codebase.
