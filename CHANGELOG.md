# Changelog

## 1.2.0 — 2026-07-03

Changes driven by live testing on Claude Opus 4.8: a behavioral trial (a
seeded bug whose crash site was far from its root cause, plus a failing test
whose expectation contradicted the documented spec) and an independent
expert critique of the skill text. The behavioral run passed both traps —
but had to *invent* policy where the skill was silent, and the critique
flagged the same gaps independently.

Reasoning upgrades:

- **Predict-before-verify** — state the expected result of every check
  before running it; a surprise pass is an observation, not a verification.
  New rule in SKILL.md's Verify step; full treatment in verification.md
  (previously the idea existed only inside debugging.md).
- **Unattended fallback for the test-integrity rule** — "say so and
  confirm" is unactionable with no human present. Now explicit: prove the
  test wrong against the documented spec and record the evidence visibly,
  or leave it failing and log a blocker. Never edit a test to green on your
  own authority. (SKILL.md non-negotiable #2 + verification.md.)
- **Pre-mortem at the done-gate** — completion checklist now asks "if this
  is subtly wrong, where would it be?" before declaring done.
- **Think-longer-vs-act-now heuristic** — SKILL.md Calibration now covers
  deliberation budget, not just process weight.
- **Restored third orient stop-criterion** in SKILL.md (what might break
  and how you'd catch it), previously only in research.md.

Token-efficiency cuts (SKILL.md is the always-loaded file):

- Removed the "When to load references" table — every reference is already
  linked inline at its loop phase (~90 words).
- Non-negotiables tightened from 7 to 5: merged the two honest-reporting
  rules; cut the one that restated Orient.
- Deduplicated the thrice-stated "exercise end-to-end" line in
  verification.md.

Consistency fixes:

- State files (PLAN.md / PROGRESS.md) now have one location policy: agent
  workspace, gitignored `.progress/` by default, committed only if the user
  wants the trail — resolving the planning.md vs long-tasks.md
  contradiction and keeping agent scratch out of user git history.
- Long-task ceremony is now sized: a lightweight notes file for
  two-sitting tasks; the full three-artifact protocol for genuinely long or
  unattended runs.

## 1.1.0 — 2026-07-02

Improvements informed by a survey of comparable open-source projects
(superpowers, anthropics/skills, spec-kit, SuperClaude, BMAD-METHOD):

- **Added `assets/` templates** — ready-to-copy `PLAN.template.md`,
  `PROGRESS.template.md`, and `init.template.sh`, so agents reproduce the
  long-task file structure exactly instead of inventing a variant each time
  (idea inspired by spec-kit's artifact templates).
- **planning.md: requirements interview** — for large, underspecified
  features, elicit a spec through one batch of focused questions before
  planning (inspired by superpowers' brainstorming workflow and Claude Code's
  interview pattern).
- **long-tasks.md: safe parallelization** — guidance for splitting disjoint
  work across subagents / git worktrees without coordination bugs.
- **README: honest side-by-side comparison** with the surveyed projects.

## 1.0.0 — 2026-07-02

Initial release: core loop (Orient → Plan → Act → Verify → Record) plus six
references — research, planning, implementation, debugging, verification,
long-tasks.
