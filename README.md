# 🧭 code-compass

**A portable Agent Skill that teaches coding agents to think like senior engineers** — where to look when researching, how to plan and verify instead of guess and hope, how to debug from evidence, and how to run long autonomous tasks across sessions without losing state.

Works with any tool that supports the open [Agent Skills](https://agentskills.io) standard: Claude Code, OpenAI Codex CLI, Cursor, GitHub Copilot, Gemini CLI, and 30+ others.

## Why

Modern coding models are strong; their *process* is what fails. The documented failure modes are consistent: coding from memory instead of reading the installed source, claiming success without running a check, weakening tests to make them pass, looping on a dead hypothesis, and losing all state when the context window fills.

code-compass encodes the countermeasures as a compact methodology, distilled from published agentic-engineering research:

- The core loop — *gather context → take action → verify work* — from [Building agents with the Claude Agent SDK](https://claude.com/blog/building-agents-with-the-claude-agent-sdk)
- Explore/plan/code/commit, verification-first workflows from [Claude Code best practices](https://code.claude.com/docs/en/best-practices)
- Session rituals, progress files, and checkpointing from [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Note-taking, just-in-time retrieval, and compaction resilience from [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- Anti-reward-hacking rules informed by research on agents [gaming their own verifiers](https://arxiv.org/html/2605.02964)

## What's inside

```
code-compass/
├── SKILL.md                     # The operating loop: Orient → Plan → Act → Verify → Record
├── assets/                      # Ready-to-copy templates: PLAN.md, PROGRESS.md, init.sh
└── references/                  # Loaded on demand (progressive disclosure)
    ├── research.md              # Where to look: ground-truth hierarchy, codebase orientation,
    │                            #   git archaeology, researching libraries without hallucinating
    ├── planning.md              # Define "done" as a runnable check; risk-first ordering;
    │                            #   blast-radius approach selection
    ├── implementation.md        # Convention-first coding, smallest correct diff, root causes
    ├── debugging.md             # Hypothesis loops, search-space bisection, loop-breaker protocol
    ├── verification.md          # The feedback hierarchy, red→green, anti-gaming hard rules
    └── long-tasks.md            # Autonomous multi-session protocol: PLAN.md / PROGRESS.md,
                                 #   session rituals, proceed-vs-ask rules, macro loop detection
```

The skill uses **progressive disclosure**: agents load ~100 tokens of metadata at startup, the ~1,500-word `SKILL.md` when a coding task begins, and individual references only when the situation calls for them. It adds depth without taxing the context window.

## Install

### Claude Code

```bash
git clone https://github.com/vichaarone/code-compass.git ~/.claude/skills/code-compass
```

Per-project instead: clone into `.claude/skills/code-compass` inside the repo.

### Any other Agent Skills-compatible tool

Clone this repo into the tool's skills directory (e.g. `~/.codex/skills/`, or wherever your tool discovers skills):

```bash
git clone https://github.com/vichaarone/code-compass.git <skills-dir>/code-compass
```

The directory name must remain `code-compass` (the spec requires it to match the skill name).

### Verify it loaded

Ask your agent: *"Which skills do you have available?"* — or just give it a coding task and watch for the loop.

## What it changes, concretely

| Without | With code-compass |
|---|---|
| Codes from memory of an API | Confirms against the installed version's source first |
| "The fix should work now" | "Ran `pytest tests/auth -x`: 41 passed; exercised the flow via curl — output below" |
| Deletes the failing test | Hard rule: never; flags the test and asks instead |
| Retries the same failed fix five times | Loop-breaker: 2 strikes → new hypothesis; 3 hypotheses → question assumptions |
| Loses everything at context compaction | PLAN.md + PROGRESS.md + git checkpoints; any fresh session resumes cold |
| Stops when work "looks done" | Stops when the named check passes, end to end |

## How it compares

Several strong open-source projects also aim to make coding agents better. They solve different problems, and code-compass borrows ideas from the best of them (see [CHANGELOG](CHANGELOG.md)). Surveyed July 2026:

| | **code-compass** | [superpowers](https://github.com/obra/superpowers) | [anthropics/skills](https://github.com/anthropics/skills) | [spec-kit](https://github.com/github/spec-kit) | [SuperClaude](https://github.com/SuperClaude-Org/SuperClaude_Framework) | [BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) |
|---|---|---|---|---|---|---|
| **What it is** | One skill: how an agent should *think* while engineering | Skills framework + dev workflow (11+ skills, slash commands) | Official example skills (documents, design, technical tasks) | Spec-driven development CLI + artifact templates | Config framework: 30 commands, 20 agents, 8 MCP servers | Agile-lifecycle framework with 12+ agent personas |
| **Install & runtime deps** | `git clone` one folder; zero dependencies | Plugin marketplace, per-platform installers | Plugin / API upload | Python 3.11+, `uv`, CLI scaffolds `.specify/` | `pipx` + optional MCP servers | `npx` + Node 20 + Python |
| **Idle context cost** | ~100 tokens (metadata only) | Metadata for 11+ skills | Per-skill | Slash-command templates | Injected behavioral config (heaviest) | Persona definitions |
| **Research methodology** (where to look, ground-truth hierarchy, anti-hallucination) | ✅ dedicated reference | ❌ | ❌ | ❌ | Partial (web "Deep Research" mode) | ❌ |
| **Planning** | ✅ check-first, risk-first | ✅ brainstorm → write-plan | ❌ | ✅✅ core focus | ✅ commands | ✅✅ core focus |
| **Verification + anti-reward-hacking rules** | ✅ hard rules, research-grounded | ✅ verification-before-completion | ❌ | ❌ | Partial | Partial (test architect) |
| **Debugging method** | ✅ hypothesis loop + loop-breaker | ✅ systematic-debugging | ❌ | ❌ | ❌ | ❌ |
| **Long-horizon / multi-session autonomy** | ✅✅ dedicated protocol (state files, session rituals, macro loop detection) | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Works unattended** | ✅ designed for it | Assumes human collaboration | n/a | Human gate at each phase | Assumes human at keyboard | Guided, human-led |
| **Portability** | Any [Agent Skills](https://agentskills.io) tool — plain folder | 10 platforms via installers | Claude-centric | 30+ agents via its CLI | Claude Code | Claude Code, Cursor, web bundles |
| **License** | MIT | MIT | Apache-2.0 / source-available | MIT | MIT | MIT |

### Why code-compass

1. **It's the only one that treats long-horizon autonomy as a first-class problem.** Every other project assumes a human between phases. code-compass assumes the opposite — your memory *will* be wiped mid-task — and provides the full survival protocol: durable state files, session start/end rituals, git checkpointing, blocked-vs-idle rules, and cross-session loop detection.
2. **It's the only one that teaches research methodology.** The most common agent failure is acting on remembered APIs instead of installed reality. No other project addresses "where to look": the ground-truth hierarchy, codebase orientation passes, git archaeology, and version-pinned library research.
3. **Anti-reward-hacking is explicit and hard.** Grounded in [published research](https://arxiv.org/html/2605.02964) on agents deleting tests and gaming checks — not just "verify your work" but an enumerated list of forbidden moves.
4. **Zero infrastructure.** No CLI to install, no npm/pipx packages, no MCP servers, no marketplace account. A plain spec-compliant folder that works identically in 32+ tools. Nothing to version-sync, nothing to break.
5. **Token frugality by design.** The entire skill active costs less context than most frameworks cost idle. Methodology loads in layers only when the situation calls for it — and degraded context is itself a failure mode the skill is defending against.
6. **Composable, not competing.** Because it's pure methodology, it runs *underneath* the others: use spec-kit's artifact pipeline or superpowers' slash commands on top; code-compass governs how the agent thinks while executing them.

**When another tool fits better:** you want ready-made slash-command workflows and subagent orchestration today → superpowers. You want a full spec-artifact pipeline for greenfield products → spec-kit. You want an MCP-integrated toolchain → SuperClaude. You want simulated agile team roles → BMAD.

## Design principles

1. **Written for the agent, not about the agent** — imperative, high-signal, no filler.
2. **Every rule earns its tokens** — if removing a line wouldn't change behavior, it's gone.
3. **Process scales with task size** — a typo fix shouldn't trigger a planning ceremony; the skill says so explicitly.
4. **Verification is the spine** — every other section exists to make the Verify step pass honestly.

## Contributing

Issues and PRs welcome. The bar for adding content: it must change agent *behavior* in a way you've observed, not just read about. Keep `SKILL.md` under 500 lines and references focused — one situation per file.

Validate changes against the spec with [skills-ref](https://github.com/agentskills/agentskills/tree/main/skills-ref):

```bash
skills-ref validate .
```

## License

[MIT](LICENSE)
