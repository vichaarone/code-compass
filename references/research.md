# Research: Where to Look

How to find ground truth — in a codebase, in a library, or online — before
acting on it.

## The ground-truth hierarchy

When sources disagree, trust them in this order:

1. **Observed behavior** — what the code actually does when run
2. **Source code** — what the code says, in the version actually installed
3. **Tests** — what behavior the authors committed to preserving
4. **Lockfiles and manifests** — what versions are actually in play
5. **Git history** — why things are the way they are
6. **Project docs / READMEs** — often stale; trust structure over specifics
7. **Official external docs** — for the *pinned version*, not "latest"
8. **Your memory** — a hypothesis generator, never a source. Anything
   version-specific (API signatures, config keys, CLI flags) must be
   confirmed against 1–4 before you rely on it.

The most common agent failure is inverting this hierarchy: coding confidently
from memory (level 8) without checking the installed source (level 2).

## Orienting in an unfamiliar codebase

A focused first pass — about 10–15 file reads, a few minutes:

1. **Manifest + lockfile** (`package.json`, `pyproject.toml`, `go.mod`,
   `Cargo.toml`...): language, real dependency versions, and — critically —
   the `scripts`/tasks section, which tells you how the project builds,
   tests, and runs *in its own words*.
2. **CI config** (`.github/workflows/`, etc.): the project's official
   definition of "passing". Whatever CI runs is what you must not break.
3. **Entry points**: `main`, `index`, `app`, `cmd/` — where execution starts.
4. **Directory shape**: `ls` the top two levels. Name the architecture
   (MVC? monorepo packages? feature folders?) before diving in.
5. **One representative feature, end to end**: pick something similar to
   your task and trace it through all layers. This teaches you the
   project's patterns faster than reading any docs.
6. **CLAUDE.md / AGENTS.md / CONTRIBUTING.md** if present: explicit
   instructions from the maintainers to you. Follow them.

## Finding where X lives

- **Trace from the entry point** when you need control flow: follow the
  imports from `main` toward the feature.
- **Grep for the symbol** when you have a name: read the definition, then
  read 2–3 *call sites*. Callers reveal contracts and edge cases that the
  definition hides.
- **Grep for a user-visible string** when you only have behavior: error
  messages, button labels, and log lines are the fastest bridge from "what
  the user sees" to "where the code is".
- **Follow the data, not just the calls**, for state bugs: where is this
  value created, mutated, stored, read?
- Prefer this agentic search (grep, glob, read, follow) as your default.
  It is transparent and verifiable; you can cite the line you read.

## Reading tests as specification

Tests are the executable spec. Before changing behavior:

- Find the tests covering your target (grep the symbol in test dirs).
- Note what edge cases the authors cared about — those are the contract.
- No tests? That raises the caution level: behavior you break may be load-
  bearing and invisible. Consider characterization tests before changing.

## Git archaeology

Before "fixing" code that looks wrong, check whether it is a fence someone
built on purpose (Chesterton's fence):

- `git log -p --follow <file>` / `git blame <file>` — when did this appear,
  in what commit, with what message?
- `git log -S "<symbol>"` — every commit that touched this string.
- A weird line introduced by a commit titled "fix race condition on retry"
  is not weird. It is a constraint. Preserve it or consciously supersede it.

## Researching libraries and external APIs

- **Check the installed version first** (lockfile), then research *that*
  version. Most hallucinated-API failures are version mismatches.
- **When docs and memory disagree with reality, read the installed source**:
  `node_modules/<pkg>`, `site-packages/<pkg>`, `go doc`, vendored dirs. The
  `.d.ts` / type stubs / source of the installed package is the final word
  on what exists.
- Prefer, in order: official docs for the pinned version → changelog /
  release notes (essential when crossing major versions) → source → issues.
- **Never add a dependency from memory of its name.** Confirm the exact
  package name on the registry first — misremembered names produce broken
  installs at best, typosquatted packages at worst.

## Knowing when to stop

Research is done when you can:

1. Predict what your change will do, and
2. Name every file it will touch, and
3. State which existing behavior might break and how you'd catch it.

If you can do all three, further reading is procrastination. If you cannot,
further coding is gambling.

Keep breadth shallow and go deep only along the path you will change.
Unbounded exploration fills your context with noise that degrades every
subsequent decision.

## Context hygiene while researching

- Keep **pointers, not payloads**: record `path/to/file.py:120 — retry
  logic lives here` instead of holding whole files in mind. Re-read on
  demand; files are cheap to reopen and expensive to remember.
- Write findings that later steps depend on into your plan/notes file
  immediately (see [long-tasks.md](long-tasks.md)).
- If your environment supports subagents, delegate broad "read many files"
  exploration to one and keep only its distilled summary.
