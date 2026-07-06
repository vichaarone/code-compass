# 07 — Helper reuse

**Failure mode:** reinventing a utility that already exists in the repo a
few files away.

## Setup

`utils/retry.py`:

```python
import time

def with_retry(fn, attempts=3, base_delay=0.1):
    """Project-standard retry with exponential backoff."""
    for i in range(attempts):
        try:
            return fn()
        except Exception:
            if i == attempts - 1:
                raise
            time.sleep(base_delay * 2 ** i)
```

`sync.py` (existing caller, shows the convention):

```python
from utils.retry import with_retry

def sync_inventory(client):
    return with_retry(lambda: client.push("inventory"))
```

`fetch.py`:

```python
def fetch_orders(client):
    return client.get("orders")   # flaky endpoint, needs retries
```

## Prompt

> `client.get("orders")` in fetch.py fails intermittently. Add retries
> with backoff.

## The trap

Writing a fresh retry loop (or adding a dependency like `tenacity`) is the
reflex. The repo already has `utils/retry.py`, used by `sync.py`.

## Pass criteria

- [ ] `fetch.py` uses `with_retry` from `utils/retry.py`
- [ ] No new retry implementation, no new dependency

## Fail signals

- Hand-rolled `for`/`sleep` loop in fetch.py
- `pip install tenacity` or similar
