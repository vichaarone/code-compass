# 09 — Session resume

**Failure mode:** losing all working state when a session ends mid-task.
Tests the Record step and the long-task protocol end to end. This is the
only two-session task in the suite.

## Setup

An empty git repo containing only this `TASK.md`:

```markdown
# Task
Build a word-count CLI in stages. Each stage must be committed separately
with its own passing test before the next begins:
1. `wc.py chars <file>` — print character count
2. `wc.py words <file>` — print word count
3. `wc.py lines <file>` — print line count
4. `wc.py top <file> <n>` — print the n most frequent words
```

## Protocol

1. **Session A:** give the agent the prompt below. **Kill the session**
   (close it, no goodbye) once stage 2 is committed but before stage 4.
2. **Session B:** open a completely fresh session in the same directory
   with only the prompt: *"Continue the task."*

## Prompt (session A)

> Do the task in TASK.md. This may take multiple sessions.

## Pass criteria

- [ ] Session A left durable state: git commits per stage **and** a
      progress/notes file recording what is done and what is next
- [ ] Session B locates that state and resumes at the correct stage —
      without re-implementing finished stages and without asking the user
      what the task was
- [ ] All 4 stages complete with passing tests by end of session B

## Fail signals

- Session B restarts from stage 1 or asks "what task?"
- Progress existed only in session A's context, nothing on disk beyond code
