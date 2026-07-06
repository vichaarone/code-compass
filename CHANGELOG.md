# Changelog

## 1.3.0 — 2026-07-07

Trust-infrastructure release, driven by a comparative study of ~100
repositories in the agent-skills ecosystem. The study's core finding: the
skill's methodology is unusually complete for its size, and the highest-value
next step is **not to make it bigger but to make it measurable and
trustable**. Accordingly, `SKILL.md` and all six references are **unchanged**
in this release — every addition is repo-level evidence around the same core.

- **Eval harness (`evals/`)** — 10 reproducible seeded-trap tasks, one per
  documented agent failure mode (hallucinated API, root-cause distance,
  test-integrity baits, end-to-end gap, loop bait, helper reuse, ambiguous
  spec, session resume, false trigger), plus a run protocol, scoring
  metrics, and a results template. Formalizes the ad-hoc behavioral testing
  used to validate v1.2.0.
- **`SECURITY.md`** — explicit security model: what the skill contains,
  what it never does (no network, no execution, no telemetry, no
  dependencies), how to audit all of it, tag-pinned installs, and the
  gitignored-state-files policy.
- **`COMPATIBILITY.md`** — converts the broad "32+ tools" portability claim
  into a per-tool matrix with install paths and honest tested/untested
  status (only Claude Code currently earns a ✅).
- **README: "Works well with"** — positions the skill as composable rather
  than competing: Context7 for fresh docs, planning-with-files/persist-os
  for heavier memory, asm for skill lifecycle/scanning, spec-kit/superpowers
  for workflow layers on top.
- **README: sharpened positioning** — "the minimal dependable layer that
  makes any coding agent behave better"; new Trust section linking evals,
  security, and compatibility.
- **Install ergonomics** — installs now documented against release tags
  (`--branch v1.3.0 --depth 1`) instead of tracking `main`.

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
