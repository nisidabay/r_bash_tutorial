#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_here_strings.sh — <<< feeding data to commands
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Basic Here-String ────────────────────────────────────
    # <<<"string" feeds the string as stdin to the command
    wc -w <<< "count these words"

    # ── Feeding Variables ────────────────────────────────────
    local data="apple
banana
cherry"
    sort <<< "$data"

    # ── read from here-string ─────────────────────────────────
    # Use IFS=' ' locally to split on spaces (global IFS is \n\t)
    IFS=' ' read -r first rest <<< "alpha beta gamma"
    echo "First: $first, Rest: $rest"

    # ── while read with here-string ──────────────────────────
    local count=0
    while IFS= read -r line; do
        ((count++))
    done <<< "$data"
    echo "Read $count lines from here-string"

    # ── Avoiding Subshells ──────────────────────────────────
    # Here-strings run in the current shell (no subshell)
    # Compare with: echo "$data" | while read -r line; ...
    local result=""
    while IFS= read -r line; do
        result+="$line "
    done <<< "$data"
    echo "Result (no subshell): $result"
}
main "$@"
