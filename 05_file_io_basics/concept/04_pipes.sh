#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 04_pipes.sh — | pipe, chaining, tee, FIFOs, PIPESTATUS
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Basic Pipe ────────────────────────────────────────────
    # stdout of left feeds stdin of right
    echo "hello world" | wc -w

    # ── Chaining ─────────────────────────────────────────────
    # Multiple pipes in sequence
    printf "foo\nbar\nbaz\n" | sort | tr 'a-z' 'A-Z'

    # ── tee in pipelines ──────────────────────────────────────
    # tee writes to file AND passes through stdout
    local tmpfile
    tmpfile=$(mktemp)
    echo "tee test" | tee "$tmpfile" | wc -c
    echo "tee also wrote to: $tmpfile"

    # ── PIPESTATUS ───────────────────────────────────────────
    # Array of exit codes from each command in the pipe
    true | false | true
    echo "PIPESTATUS: ${PIPESTATUS[@]}"

    rm -f "$tmpfile"
}
main "$@"
