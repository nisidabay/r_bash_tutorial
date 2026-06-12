#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_write_output.sh — echo, printf, >, >>, tee, /dev/null
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    local tmpfile
    tmpfile=$(mktemp)

    # ── echo vs printf ────────────────────────────────────────
    # echo is simple; printf gives format control
    echo "echo: simple output"
    printf "printf: %s = %d\n" "answer" 42

    # ── Write (>) and Append (>>) ────────────────────────────
    echo "first line" > "$tmpfile"       # overwrite
    echo "second line" >> "$tmpfile"     # append
    echo "--- File contents ---"
    cat "$tmpfile"

    # ── tee: output to file AND stdout ──────────────────────
    echo "tee demo" | tee -a "$tmpfile"

    # ── /dev/null: discard output ──────────────────────────
    echo "This is discarded" > /dev/null
    echo "(Nothing was printed above — discarded to /dev/null)"

    rm -f "$tmpfile"
}
main "$@"
