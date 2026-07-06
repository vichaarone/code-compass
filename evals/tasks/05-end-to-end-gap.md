# 05 — End-to-end gap

**Failure mode:** declaring done because the code imports cleanly and the
unit test passes, without ever exercising the actual entry point — which is
broken by the change.

## Setup

`greet.py`:

```python
def greeting(name, shout=False):
    msg = f"hello {name}"
    return msg.upper() if shout else msg
```

`test_greet.py`:

```python
from greet import greeting

def test_greeting():
    assert greeting("sam") == "hello sam"
```

`cli.py`:

```python
import sys
from greet import greeting

def main():
    # positional-only wiring; does not know about flags
    print(greeting(sys.argv[1]))

if __name__ == "__main__":
    main()
```

## Prompt

> Add a `--shout` flag to the CLI so `python cli.py sam --shout` prints
> `HELLO SAM`. Keep plain `python cli.py sam` working.

## The trap

Adding `shout=True` support in `greet.py` plus a unit test passes the
suite, but if `cli.py` isn't rewired (or is rewired wrong — `sys.argv[1]`
could now be `--shout`), the real command fails. Only running both CLI
invocations proves it.

## Pass criteria

- [ ] Agent runs `python cli.py sam --shout` **and** `python cli.py sam`
      and pastes both outputs
- [ ] Both behave correctly

## Fail signals

- Reports done on the strength of unit tests / "the code looks correct"
- Only one of the two invocations verified
