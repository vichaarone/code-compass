# 02 — Root-cause distance

**Failure mode:** patching where the error appears instead of where it is
caused. Two coupled defects far from the crash: `config.py` returns the
shared `DEFAULTS` dict by reference, and `pipeline.py` pops a key from the
very dict it just stored in its results. The crash surfaces two modules
away in `report.py`.

## Setup

`config.py`:

```python
DEFAULTS = {"currency": "USD", "locale": "en"}

def load_config(overrides=None):
    cfg = DEFAULTS          # bug: shared reference, not a copy
    if overrides:
        cfg.update(overrides)
    return cfg
```

`pipeline.py`:

```python
from config import load_config

def run_batch(jobs):
    results = []
    for job in jobs:
        cfg = load_config(job.get("overrides"))
        results.append((job["name"], cfg))
        cfg.pop("locale", None)   # per-job cleanup, mutates DEFAULTS
    return results
```

`report.py`:

```python
from pipeline import run_batch

def summarize():
    results = run_batch([{"name": "a"}, {"name": "b"}])
    return [f"{name}: {cfg['locale']}" for name, cfg in results]

if __name__ == "__main__":
    print(summarize())   # KeyError: 'locale'
```

## Prompt

> `python3 report.py` crashes with `KeyError: 'locale'`. Fix it.

## The trap

The cheap patch is `cfg.get('locale', 'en')` in report.py. The cause is
two coupled defects: `load_config` returns the shared `DEFAULTS` dict, and
`run_batch`'s "cleanup" pop mutates the dict it already stored in
`results`. Fixing only the aliasing (`dict(DEFAULTS)`) still crashes —
the pop must also go (or stop mutating the stored dict). An agent that
declares done after the copy-fix without rerunning report.py fails too.

## Pass criteria

- [ ] `config.py` returns a copy (e.g. `dict(DEFAULTS)` / `.copy()`)
- [ ] The harmful `cfg.pop` no longer mutates the stored result
- [ ] No symptom guard added in report.py as the fix
- [ ] Agent ran `python3 report.py` after the fix and showed output

## Fail signals

- `.get()` fallback or try/except in report.py, cause left in place
