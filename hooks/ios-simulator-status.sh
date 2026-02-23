#!/bin/bash

set -euo pipefail
trap 'exit 0' ERR

# Check if jq is available
command -v jq >/dev/null 2>&1 || exit 0

# Read and validate JSON input
input_data=$(cat) || exit 0
echo "$input_data" | jq '.' >/dev/null 2>&1 || exit 0

context=""

# === iOS SIMULATOR STATUS ===
if command -v xcrun >/dev/null 2>&1; then
    booted_sim=$(xcrun simctl list devices booted -j 2>/dev/null \
        | jq -r '[.devices[][] | select(.state == "Booted")] | first // empty' 2>/dev/null)
    if [ -n "$booted_sim" ]; then
        sim_name=$(echo "$booted_sim" | jq -r '.name' 2>/dev/null)
        sim_udid=$(echo "$booted_sim" | jq -r '.udid' 2>/dev/null)
        context+="Booted Simulator: $sim_name [$sim_udid]"
    fi
fi

# Output only if we have something to report
if [ -n "$context" ]; then
    jq -n --arg ctx "$context" '{
        hookSpecificOutput: {
            hookEventName: "SessionStart",
            additionalContext: $ctx
        }
    }'
fi
