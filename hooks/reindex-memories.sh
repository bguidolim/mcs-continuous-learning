#!/bin/bash

set -euo pipefail
trap 'exit 0' ERR

MEMORIES_DIR=".claude/memories"
TIMESTAMP_FILE=".claude/.mcs-last-indexed"

# Exit early if no memories directory
[ -d "$MEMORIES_DIR" ] || exit 0

# Exit early if Ollama is not running
curl -s --max-time 2 http://localhost:11434/api/tags >/dev/null 2>&1 || exit 0

# Read and validate JSON input (hook protocol)
input_data=$(cat) || exit 0
echo "$input_data" | jq '.' >/dev/null 2>&1 || exit 0

# --- Staleness check ---
# Only reindex if memory files have changed since last index.
# If no timestamp file exists, SessionStart hasn't run yet — skip.
[ -f "$TIMESTAMP_FILE" ] || exit 0

newest_memory=$(find "$MEMORIES_DIR" -name "*.md" -newer "$TIMESTAMP_FILE" -print -quit 2>/dev/null)
[ -n "$newest_memory" ] || exit 0

# --- Perform reindex ---
repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "")
[ -n "$repo_name" ] || exit 0

export OPENAI_API_KEY=ollama
export OPENAI_API_BASE=http://localhost:11434/v1
embedding_model="openai:nomic-embed-text"

# Only refresh if library already exists (SessionStart creates it)
if npx -y @arabold/docs-mcp-server list --silent 2>/dev/null | grep -q "$repo_name"; then
    npx -y @arabold/docs-mcp-server refresh "$repo_name" \
        --embedding-model "$embedding_model" \
        --silent >/dev/null 2>&1

    # Update timestamp on success
    touch "$TIMESTAMP_FILE"
fi
