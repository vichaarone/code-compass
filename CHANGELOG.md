# Changelog

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
