#!/bin/bash

cat << 'EOF'
MANDATORY MEMORY — CHECK & EVALUATE

BEFORE → If this request starts a new sub-task (writing tests,
refactoring, integrating, deploying, etc.), search the KB
for relevant patterns and conventions before executing.

AFTER  → Evaluate whether this request produced extractable
knowledge or decisions worth saving to memory.

LEARNINGS → Non-obvious debugging, workarounds, error resolutions
  Save as: learning_<topic>_<specific>

DECISIONS → Architecture choices, conventions, preferences, tool selections
  Save as: decision_<domain>_<topic>

If saving → Use Skill(continuous-learning) to extract
and save to <project>/.claude/memories/
EOF
