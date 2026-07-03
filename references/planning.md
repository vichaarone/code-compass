# Planning: Define Done Before You Start

Planning is not ceremony. It is the cheap phase where mistakes cost sentences
instead of rewrites. But it must be sized to the task — a plan for a typo fix
is waste, and no plan for a migration is negligence.

## Step 1 — Restate the task

Write one or two sentences: what the user actually wants, and what would
make them say "yes, that's it". If you cannot restate it, you cannot build it.

Then split every ambiguity into one of two bins:

- **Resolvable by evidence**: the codebase, its conventions, or its docs
  answer it. Resolve it yourself and note the decision. Do not push these
  to the user.
- **Genuinely the user's call**: product behavior, naming that users will
  see, trade-offs between valid approaches with different costs. Ask —
  *before* building, in one batch, not one interruption at a time.

### For large or vague features: interview first

When the request is big and underspecified ("build a dashboard", "add
billing"), don't guess a spec — elicit one. Interview the user in one
focused batch: the hard trade-offs, edge cases, and behavior decisions they
haven't considered yet — not things the codebase already answers. Write the
outcome down as the spec (it becomes the *Done means* section of the plan).
Minutes of interviewing beat hours of building the wrong thing.

## Step 2 — Define "done" as runnable checks

Before any code, name the checks that will prove completion:

- A test (existing or to-be-written) that fails now and will pass.
- A command whose exit code or output changes.
- A reproducible manual flow ("start server, POST /login, expect 200").
- A screenshot matching a target design.

**If no check exists, creating one is step one of implementation** — not an
optional extra. A task without a check can only end in "looks done", and
"looks done" is how broken work gets shipped.

Write the checks down. For multi-session work they go in the plan file; the
completion criteria must be something a later session (or a reviewer) can
run, not something you remember intending.

## Step 3 — Choose the approach by blast radius

For anything non-trivial, name 2–3 candidate approaches, even briefly. For
each: one line on what it touches and what could break. Then prefer:

1. The approach that **touches the least** and reuses the most existing code
2. The approach that is **easiest to revert**
3. The approach **most consistent** with how the codebase already solves
   similar problems

An elegant approach that fights the codebase's grain is worse than a plain
one that follows it. You are extending a system, not authoring a fresh one.

## Step 4 — Order by risk, not by convenience

Identify the assumption most likely to kill the plan — the unproven
integration, the API you *think* behaves a certain way, the performance
guess — and test it **first** with the smallest possible spike. A plan that
saves the risky part for last is a plan to discover failure after the
budget is spent.

## Step 5 — Slice into working increments

Break work into steps where **each step leaves the system building and
passing**. Good increments:

- Are independently verifiable (each has its own micro-check)
- Can be committed as they complete (each commit is a checkpoint)
- Deliver a walking skeleton early: the thinnest end-to-end path first,
  flesh on the bones after

Bad increments: "write all the models, then all the handlers, then all the
tests" — nothing is provable until everything is done.

## Step 6 — Declare what is out of scope

Write down what you noticed but will NOT do: the refactor that tempted you,
the adjacent bug, the outdated dependency. Surfacing them as notes for the
user keeps the diff reviewable and the task finishable. Scope creep is the
quiet killer of long autonomous runs.

## When the plan meets reality

Plans are predictions. When implementation reveals the prediction was wrong:

- **Stop and update the plan** — do not force the code to match a falsified
  plan.
- If the discovery changes cost or behavior materially, tell the user before
  proceeding; that decision has moved into their bin.
- Record *why* the plan changed (in the plan file, for long tasks). A later
  session that reads only the original plan will repeat the original mistake.

## Plan format for long tasks

For work spanning sessions, keep a `PLAN.md` state file (location and
commit rules in [long-tasks.md](long-tasks.md)):

```markdown
# Task: <one-line goal>

## Done means
- [ ] <runnable check 1>
- [ ] <runnable check 2>

## Approach
<2-5 sentences, incl. what was rejected and why>

## Steps
- [x] 1. <increment> — verified by <check>
- [ ] 2. <increment> — verified by <check>

## Out of scope
- <noted, not done>

## Discovered along the way
- <plan changes, surprises, constraints — dated>
```

Checked boxes must mean *verified*, never *attempted*. A ready-to-copy
version lives at [assets/PLAN.template.md](../assets/PLAN.template.md). See
[long-tasks.md](long-tasks.md) for how this file is used across sessions.
