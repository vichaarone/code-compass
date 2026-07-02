# Long Tasks: Working Beyond One Context Window

The core fact of long-horizon agent work: **your memory will be erased** —
by context compaction, by session end, by a crash — and usually without
warning. An agent that keeps its state in its head is one interruption away
from starting over. An agent that keeps its state on disk is immortal.

Everything below follows from one rule: **at any moment, a brand-new session
reading only the repository should be able to continue the work.**

## Durable state: three artifacts

Keep these at the project root (or a `.progress/` dir) from the first hour
of any multi-session task:

### 1. `PLAN.md` — what "done" means
The full plan with runnable completion checks per step (format in
[planning.md](planning.md)). Checkboxes get checked only when *verified*,
never when merely attempted.

For big projects, expand into a **requirements checklist**: every required
behavior listed with a `passing`/`failing` status and the exact check that
proves it. Treat this file as append-mostly ground truth:
**it is unacceptable to delete or weaken a requirement to make progress
look better** — the same anti-gaming rule as for tests
([verification.md](verification.md)).

### 2. `PROGRESS.md` — what happened
An append-only session log. Each session appends:

```markdown
## Session <n> — <date>
**Done:** <increments completed, each with the check that verified it>
**Decisions:** <choice + why, so it isn't relitigated>
**Failed approaches:** <what was tried, why it failed — so no session retries it>
**Next:** <the exact next action, specific enough to start cold>
**Blockers:** <anything needing the user: credentials, decisions, access>
```

The *Failed approaches* and *Next* fields are the highest-value lines in the
file. Write them as if for a stranger — the next session effectively is one.

### 3. The environment recipe — how to get running
An `init.sh` (or documented equivalent) that takes a fresh checkout to a
running dev state: install, env setup, services, dev server. Plus the one
command that runs the baseline check. If session startup is manual
archaeology, every session bleeds time and context re-deriving it.

## Git is your checkpoint system

- **Commit every verified increment** with a message describing behavior
  ("add retry with backoff to sync client; test_sync_retries passes"), not
  activity ("update code", "wip").
- Commits are restore points: when a direction fails, `git revert`/`reset`
  to the last good checkpoint instead of untangling by hand. Reverting is
  honest and fast; untangling burns context and invites new breakage.
- Never leave the tree dirty at a session boundary if you can help it —
  commit coherent work, stash or discard experiments.

## The session-start ritual

Every session of a continuing task, **before any new work**:

1. **Read the state**: `PROGRESS.md` (at minimum the last session's entry),
   `PLAN.md`, and `git log --oneline -15`.
2. **Run the baseline check** (build + core tests + smoke run). If the
   baseline is broken, *fixing it is the first task* — never build on a
   broken foundation, and never assume the last session left things green.
3. **Pick exactly one next item** — normally the `Next` line from
   `PROGRESS.md`. Not two. Parallel half-done work is how long tasks rot.

## The work loop

```
pick ONE item → orient → implement → verify → commit → update PROGRESS.md → repeat
```

- One increment at a time, each leaving the system green.
- **Write learnings down the moment you learn them** — a gotcha, a
  constraint, a decision. Anything you'd hate to re-derive goes to disk
  immediately, not "at the end". Compaction does not schedule an
  appointment.
- Keep context lean: pointers to files instead of held contents; re-read on
  demand; delegate bulk exploration to subagents where available
  ([research.md](research.md)).

## The session-end ritual

Run it deliberately at natural boundaries — and *preemptively* when you
notice context filling up:

1. Working tree clean; all checks passing; incoherent experiments discarded.
2. `PROGRESS.md` updated — especially `Next` and `Failed approaches`.
3. `PLAN.md` checkboxes updated to match verified reality.

Ten minutes of handoff hygiene saves the next session an hour of
reconstruction — and the next session's efficiency *is* your efficiency.

## Autonomy rules: proceed vs. stop

While running unattended, classify every action:

- **Proceed freely**: anything local and reversible — edits, test runs,
  local commits, new branches. This is nearly all engineering work.
- **Stop, record, and ask**: irreversible or outward-facing actions — force
  pushes, deleting files/data you didn't create, schema drops, publishing
  packages, sending messages, calling paid or production APIs, or anything
  that contradicts how the task was described to you.
- **Blocked ≠ idle**: when an item needs something only the user can give
  (credentials, a product decision), record it under `Blockers`, pick the
  next unblocked item, and keep moving. Never guess credentials or invent
  product decisions to stay busy; never idle when unblocked work remains.

## Macro loop detection

The [debugging loop-breaker](debugging.md) works within a session; long
tasks need it *across* sessions. At session start, scan `PROGRESS.md`:

- Same item failing across **2+ sessions** → stop re-attempting the same
  strategy. Escalate: build a minimal repro, try a structurally different
  approach, or write the item up precisely as a blocker for the user.
- Sessions ending with vague `Next` lines, or the same `Next` repeating →
  the plan has drifted from reality. Re-plan before doing more.

## Definition of project-done

A long task is finished when **every item in the requirements checklist is
verified-passing via its named check** — not when the remaining items look
easy, and not when you've done "a lot". Then run the full completion
checklist in [verification.md](verification.md) one final time, end to end,
and summarize honestly: what's done, what's not, and every deviation from
the original plan.
