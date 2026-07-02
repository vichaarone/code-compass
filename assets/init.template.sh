#!/usr/bin/env bash
# Environment recipe: fresh checkout -> running dev state, in one command.
# Keep this current — every session of a long task starts here.
set -euo pipefail

# 1. Install dependencies (adapt to the project)
# npm ci
# uv sync            # or: pip install -r requirements.txt

# 2. Environment (document required vars; never commit secrets)
# : "${DATABASE_URL:?Set DATABASE_URL before running}"
# cp -n .env.example .env

# 3. Services
# docker compose up -d db redis

# 4. Baseline check — the ONE command that proves the project is healthy.
#    Session rule: if this fails at session start, fixing it is the first task.
# npm test
# pytest -q

echo "TODO: fill in the steps above for this project, then delete this line"
