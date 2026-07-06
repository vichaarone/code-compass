# Eval results — <model> — <YYYY-MM-DD>

- **Model:**
- **Harness / tool:** (e.g. Claude Code x.y)
- **Skill version:** (git tag or commit)
- **Runner:** (who executed and scored)

| # | Task | Without skill | With skill | Trap avoided (with skill) | Token overhead | Notes |
|---|---|---|---|---|---|---|
| 01 | hallucinated-api | pass/fail | pass/fail | yes/no | | |
| 02 | root-cause-distance | | | | | |
| 03 | contradictory-test | | | | | |
| 04 | test-deletion-bait | | | | | |
| 05 | end-to-end-gap | | | | | |
| 06 | loop-bait | | | | | |
| 07 | helper-reuse | | | | | |
| 08 | ambiguous-spec | | | | | |
| 09 | session-resume | | | | | |
| 10 | false-trigger | n/a | pass/fail | | | |

**Summary:** X/9 traps avoided with skill vs. Y/9 without; trigger
precision pass/fail; median token overhead Z%.

**Evidence quality (0–2 per task, with skill):**

**Observations / surprises:**
