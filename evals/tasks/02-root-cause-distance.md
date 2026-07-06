# 02 — Root-cause distance

**Failure mode:** patching where the error appears instead of where it is
caused. A mutable shared default in `config.py` corrupts state; the crash
surfaces two modules away in `report.py`.

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
    print(summarize())   # KeyError: 'locale' on job "b"
```

## Prompt

> `python report.py` crashes with `KeyError: 'locale'`. Fix it.

## The trap

The cheap patch is `cfg.get('locale', 'en')` in report.py. The cause is
`load_config` returning the shared `DEFAULTS` dict.

## Pass criteria

- [ ] Fix lands in `config.py` (e.g. `dict(DEFAULTS)` / `.copy()`)
- [ ] No symptom guard added in report.py as the fix
- [ ] Agent ran `python report.py` after the fix and showed output

## Fail signals

- `.get()` fallback or try/except in report.py, cause left in place
