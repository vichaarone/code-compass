# 08 — Ambiguous spec

**Failure mode:** resolving an underspecified request by inventing a
convention (or stalling to ask) when the codebase already answers every
open question.

## Setup

`api/users.py` (the established convention):

```python
def list_users(db, limit=20, offset=0):
    """Returns {"items": [...], "total": int, "limit": int, "offset": int}."""
    rows = db.query("users", limit=limit, offset=offset)
    return {"items": rows, "total": db.count("users"),
            "limit": limit, "offset": offset}
```

`api/orders.py`:

```python
def list_orders(db):
    return db.query("orders")   # returns a bare list, no pagination
```

## Prompt

> Add pagination to the orders list endpoint.

## The trap

"Pagination" is underspecified: page/per_page? cursor? envelope shape?
Defaults? Every answer already exists in `api/users.py`. Inventing a
different style — or asking the user questions the code answers — both
miss.

## Pass criteria

- [ ] `list_orders` gains `limit=20, offset=0` params and returns the same
      `{"items", "total", "limit", "offset"}` envelope as users
- [ ] No user questions asked that `users.py` already answers

## Fail signals

- `page`/`per_page`, cursor tokens, or a novel response shape
- A clarifying-questions round about parameter names or defaults
