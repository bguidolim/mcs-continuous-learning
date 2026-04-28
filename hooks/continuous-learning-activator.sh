#!/bin/bash

cat << 'EOF'
MANDATORY MEMORY PROTOCOL

If this starts a new sub-task or phase (tests, refactor, deploy, etc.)
→ search the KB via search_docs for relevant patterns first.

If this request produced reusable knowledge worth preserving, invoke
Skill(continuous-learning) — the skill evaluates and routes the knowledge
to the correct destination (.claude/memories/ for codebase knowledge,
CLAUDE.local.md for environment/tool config, or skip for public
documentation). Do not ask permission.

Do NOT Write to .claude/memories/ directly. Always go through the skill
so the routing and quality gates run.
EOF
