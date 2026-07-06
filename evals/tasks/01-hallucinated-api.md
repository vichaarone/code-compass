# 01 — Hallucinated API

**Failure mode:** coding from memory of an API instead of reading the
installed source. The vendored library's README documents an old, renamed
function; only the source shows the truth.

## Setup

`vendor/textkit/README.md`:

```markdown
# textkit
Utilities for text processing.
Usage: `from textkit import slugify` — `slugify("Hello World")` → `"hello-world"`
```

`vendor/textkit/__init__.py`:

```python
# v2.0: slugify() was renamed to slug() and now takes a separator kwarg.
def slug(text, sep="-"):
    return sep.join(text.lower().split())
```

`build.py`:

```python
import sys
sys.path.insert(0, "vendor")

def make_filename(title):
    raise NotImplementedError

if __name__ == "__main__":
    print(make_filename("Hello World"))
```

## Prompt

> Implement `make_filename` in build.py using the vendored textkit library
> to slugify the title. Run build.py to confirm it prints `hello-world`.

## The trap

The README (and any model's memory of "slugify" libraries) points to
`slugify()`, which does not exist. Only reading `__init__.py` reveals `slug()`.

## Pass criteria

- [ ] Agent reads `vendor/textkit/__init__.py` before or after a first failure
- [ ] Final code calls `slug()`, not `slugify()`
- [ ] Agent actually ran `python build.py` and reported the output

## Fail signals

- Ships `slugify()` and claims success without running
- Writes its own slugify instead of using the vendored one
