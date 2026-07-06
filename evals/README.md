# code-compass eval harness

Seeded tasks with known traps, each targeting one documented coding-agent
failure mode. Run every task twice on the same model — once **with** the
skill installed, once **without** — and score against the explicit pass
criteria in each task file. No framework, no dependencies: each task is a
self-contained markdown spec whose setup you create by copying the embedded
files into a scratch directory.

## Protocol

1. Pick a model and record it (e.g. `claude-opus-4-8`).
2. For each task in `tasks/`:
   - Create a fresh scratch git repo and copy in the seed files exactly as
     written in the task's **Setup** section.
   - Run the agent **without** the skill, give it the task's **Prompt**
     verbatim, let it finish. Score against **Pass criteria**.
   - Repeat in a fresh scratch repo **with** the skill installed.
3. Record results in a copy of `RESULTS.template.md`. One results file per
   model per date, e.g. `results/2026-07-07-opus-4-8.md`.

Rules: don't coach the agent mid-run; don't rerun a failed attempt and keep
the better one; a partial pass is a fail. The point is trust, and gamed
evals are worse than none.

## Metrics

| Metric | How measured |
|---|---|
| Task completion | Did the task's named check pass, end to end? |
| Trap avoided | Task-specific pass criteria (the core signal) |
| Trigger precision | Task 10: skill stays quiet on non-engineering work |
| Token overhead | Total tokens, with-skill vs. without |
| Evidence quality | Did the final report cite a command it ran and its actual output? (human-rated 0–2) |

## Task index

| # | Task | Failure mode | Skill section exercised |
|---|---|---|---|
| 01 | [hallucinated-api](tasks/01-hallucinated-api.md) | Coding from memory instead of installed source | Orient / research.md |
| 02 | [root-cause-distance](tasks/02-root-cause-distance.md) | Patching the crash site, not the cause | Act / debugging.md |
| 03 | [contradictory-test](tasks/03-contradictory-test.md) | Silently editing a test that contradicts the spec | Non-negotiable #2 |
| 04 | [test-deletion-bait](tasks/04-test-deletion-bait.md) | Deleting/skipping a test to go green | Non-negotiable #2 |
| 05 | [end-to-end-gap](tasks/05-end-to-end-gap.md) | "Compiles + unit tests" claimed as done | Verify / verification.md |
| 06 | [loop-bait](tasks/06-loop-bait.md) | Retrying a dead fix instead of re-orienting | Non-negotiable #4 |
| 07 | [helper-reuse](tasks/07-helper-reuse.md) | Reinventing an existing in-repo helper | Act / implementation.md |
| 08 | [ambiguous-spec](tasks/08-ambiguous-spec.md) | Inventing conventions instead of reading them | Plan / planning.md |
| 09 | [session-resume](tasks/09-session-resume.md) | Losing all state at session end | Record / long-tasks.md |
| 10 | [false-trigger](tasks/10-false-trigger.md) | Skill ceremony on non-engineering work | Trigger precision |
