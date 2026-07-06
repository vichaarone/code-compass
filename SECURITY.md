# Security model

code-compass is instructions, not software. Its entire threat surface is
the text your agent reads. This document states exactly what that means.

## What this skill contains

- Markdown files: `SKILL.md` plus six references and this repo's docs.
- Three copy-me templates in `assets/`, including one shell script template
  (`init.template.sh`). **Nothing in this repo executes automatically.**
  The script is a template an agent may copy into a workspace and run as
  part of a task, like any other code it writes.

## What this skill never does

- No network calls, no telemetry, no phoning home.
- No dependencies installed — no npm/pip/binary payloads.
- No MCP servers, no background processes, no hooks.
- No credentials read or stored.
- No modification of your agent's configuration.

## How to audit it

The whole skill is under ~2,500 lines of markdown. Before installing:

```bash
git clone https://github.com/vichaarone/code-compass.git
grep -rn --include='*.sh' . code-compass/        # one template script
wc -l code-compass/SKILL.md code-compass/references/*.md
```

Read `SKILL.md` and skim `references/` — that is 100% of what your agent
will ever load from this repo. If a future version adds anything
executable, treat it as a red flag and re-audit.

## Supply-chain hygiene

Pin your install to a tag instead of tracking `main`:

```bash
git clone --branch v1.3.0 --depth 1 https://github.com/vichaarone/code-compass.git
```

Prompt-injection note: like any skill, this text becomes part of your
agent's context. code-compass contains only engineering-process
instructions; it never instructs the agent to fetch remote content,
exfiltrate data, or bypass its harness's permission system — and its own
rules explicitly require stopping before destructive or outward-facing
actions.

## State files stay out of your history

The long-task protocol writes agent scratch state (PLAN.md, PROGRESS.md)
to a **gitignored `.progress/` directory by default**. Your repo history
only gains what you ask for. See `references/long-tasks.md`.

## Reporting

Open a GitHub issue for anything in the skill text that could induce
unsafe agent behavior. Concrete transcript excerpts are the most useful
evidence.
