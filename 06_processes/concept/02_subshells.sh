#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_subshells.sh — ( ... ) isolated environments
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    local original_dir
    original_dir=$(pwd)

    # ── Subshell with cd ─────────────────────────────────────
    # cd inside ( ... ) does NOT affect the parent shell
    (cd /tmp && echo "Inside subshell, pwd: $(pwd)")
    echo "Back in parent, pwd: $(pwd)"

    # ── Isolated variables ──────────────────────────────────
    # Variables set inside a subshell don't leak out
    local var="original"
    (
        var="changed"
        echo "Inside subshell: var=$var"
    )
    echo "Outside subshell: var=$var"

    # ── Subshell with pipe ──────────────────────────────────
    # Each side of a pipe runs in a subshell
    echo "hello" | while read -r line; do
        echo "Pipe subshell: $line"
    done

    # ── Grouping with { } (no subshell) ─────────────────────
    # Curly braces run in the current shell
    local gvar="before"
    { gvar="after"; }
    echo "Curly braces: gvar=$gvar"
}
main "$@"
