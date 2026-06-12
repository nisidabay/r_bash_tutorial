#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_dev_stdin.sh — /dev/stdin, file-or-stdin pattern, -p test
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── /dev/stdin as a file ─────────────────────────────────
    # /dev/stdin is a virtual file that reads from stdin
    # This works with any command that accepts a filename
    echo "hello from pipe" | wc -l /dev/stdin

    # ── File-or-stdin pattern ────────────────────────────────
    # ${1:-/dev/stdin} — use arg1 if given, otherwise stdin
    local input="${1:-/dev/stdin}"
    echo "Reading from: $input"
    head -n 2 < "$input" 2>/dev/null || echo "(no input)"

    # ── Detecting pipe input ────────────────────────────────
    # [[ -p /dev/stdin ]] checks if stdin is a named pipe
    if [[ -p /dev/stdin ]]; then
        echo "Input is piped"
    else
        echo "Input is from terminal"
    fi

    # ── cat with stdin ───────────────────────────────────────
    # cat with no args reads from stdin
    echo "piped data" | cat
}
main "$@"
