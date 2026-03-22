#!/bin/bash

set -euo pipefail
trap 'exit 0' ERR

# Check if jq is available
command -v jq >/dev/null 2>&1 || exit 0

# Read and validate JSON input
input_data=$(cat) || exit 0
echo "$input_data" | jq '.' >/dev/null 2>&1 || exit 0

# Exit early if Ollama is not running
curl -s --max-time 2 http://localhost:11434/api/tags >/dev/null 2>&1 || exit 0

# If project has a memories directory, ensure docs-mcp-server library is synced
if [ -d ".claude/memories" ]; then
    repo_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null || echo "")
    if [ -n "$repo_name" ]; then
        memories_path="$(git rev-parse --show-toplevel 2>/dev/null)/.claude/memories"

        export OPENAI_API_KEY=ollama
        export OPENAI_API_BASE=http://localhost:11434/v1
        embedding_model="openai:nomic-embed-text"

        if npx -y @arabold/docs-mcp-server list --silent 2>/dev/null | grep -q "$repo_name"; then
            npx -y @arabold/docs-mcp-server refresh "$repo_name" \
                --embedding-model "$embedding_model" \
                --silent >/dev/null 2>&1
        else
            npx -y @arabold/docs-mcp-server scrape "$repo_name" \
                "file://$memories_path" \
                --embedding-model "$embedding_model" \
                --silent >/dev/null 2>&1
        fi

        # Mark indexing time for staleness checks by the reindex hook
        touch ".claude/.mcs-last-indexed"
    fi
fi
