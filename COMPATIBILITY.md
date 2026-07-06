# Compatibility matrix

code-compass is a plain [Agent Skills](https://agentskills.io) folder —
`SKILL.md` with YAML frontmatter, plus `references/` and `assets/`. Any
spec-compliant tool can load it. This matrix converts that claim into
per-tool install paths and an honest test status.

**Status legend:** ✅ behavior-tested (a documented run exists) ·
🟡 spec-compatible, install verified only · ⚪ spec-compatible, untested.
Only claims with evidence get a ✅ — help us upgrade ⚪ rows by filing an
issue with a transcript.

| Tool | Install path | Discovery | Status | Notes |
|---|---|---|---|---|
| Claude Code | `~/.claude/skills/code-compass` (global) or `.claude/skills/code-compass` (project) | Automatic; description-based triggering | ✅ | v1.2.0 validated on Opus 4.8 against seeded traps (see CHANGELOG) |
| OpenAI Codex CLI | `~/.codex/skills/code-compass` | Automatic | ⚪ | |
| Cursor | Project skills directory per Cursor's Agent Skills support | Automatic | ⚪ | |
| GitHub Copilot (agent mode) | Per Copilot's Agent Skills discovery path | Automatic | ⚪ | |
| Gemini CLI | Tool's skills directory | Automatic | ⚪ | |
| GitLab Duo | GitLab's skill support (`SKILL.md` recognized) | Automatic | ⚪ | GitLab also honors `AGENTS.md`; not required here |

Universal rules regardless of tool:

- The directory **must** be named `code-compass` (spec requires the folder
  name to match `name:` in the frontmatter).
- Relative links (`references/…`, `assets/…`) must survive the install —
  clone or copy the whole folder; don't flatten it.
- No build step, no post-install hook. If the folder is present, the skill
  works.

## Known quirks

- **Trigger phrasing:** tools differ in how aggressively they match the
  `description:` field. If the skill under- or over-triggers in your tool,
  file an issue naming the tool and the prompt.
- **Slash commands:** code-compass defines none; it is description-triggered
  methodology only. Tools that only surface skills as slash commands will
  still load it when the agent selects it.

## Machine-readable manifest

The skill's manifest **is** the `SKILL.md` frontmatter (name, description,
license, version, homepage) per the Agent Skills spec — no separate
manifest file is needed. Validate with:

```bash
skills-ref validate .
```
