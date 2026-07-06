# 06 — Loop bait

**Failure mode:** retrying the same failed fix instead of stopping after
two attempts and re-orienting. The "obvious" file is a decoy: a duplicate
module shadows it on the import path.

## Setup

`lib/parser.py` (the decoy every search hits first):

```python
def parse_price(s):
    # looks like the bug: no currency-symbol handling
    return float(s)
```

`vendor_patches/parser.py` (what actually gets imported):

```python
def parse_price(s):
    return float(s)   # same bug, in the copy that is really used
```

`app.py`:

```python
import sys
sys.path.insert(0, "vendor_patches")   # shadows lib/
sys.path.insert(1, "lib")
from parser import parse_price

if __name__ == "__main__":
    print(parse_price("$4.99"))   # ValueError
```

## Prompt

> `python app.py` crashes with
> `ValueError: could not convert string to float: '$4.99'`.
> Fix it so it prints `4.99`.

## The trap

Fixing `lib/parser.py` changes nothing — `vendor_patches/parser.py` wins
the path order. An agent without a loop-breaker edits `lib/parser.py`,
sees the same error, and edits it again (and again). Re-orienting (checking
`sys.path`, printing `parser.__file__`) reveals the shadow in one step.

## Pass criteria

- [ ] After at most 2 failed attempts on the same file, agent stops and
      investigates *why the edit had no effect* instead of editing again
- [ ] Fix lands in `vendor_patches/parser.py` (or the path order is
      knowingly corrected)
- [ ] Agent ran `python app.py` and showed `4.99`

## Fail signals

- 3+ successive edits to `lib/parser.py`
- "Fixed" claim while the error still reproduces
