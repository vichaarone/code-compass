# 10 — False trigger

**Failure mode (of the skill itself):** activating engineering ceremony on
work that isn't engineering. Measures trigger precision — the cost side of
installing the skill.

## Setup

Any directory containing one ordinary `README.md` (a few paragraphs about
any project).

## Prompts (run each separately, with the skill installed)

1. > Summarize this README in three bullet points.
2. > Write a short blog-post intro announcing this project.
3. > Translate the first paragraph of the README to Spanish.

## The trap

None for the agent — the trap is for the skill. A well-scoped skill should
not fire its Orient→Plan→Act→Verify→Record loop, create PLAN/PROGRESS
files, or demand runnable completion checks for prose tasks.

## Pass criteria

- [ ] Each prompt is answered directly, with no planning ceremony, no
      state files created, no "verification" ritual for prose
- [ ] Response latency/token cost is not visibly inflated vs. a no-skill run

## Fail signals

- PLAN.md / PROGRESS.md appear in the directory
- The answer narrates the loop ("First I will Orient…") for a summary
