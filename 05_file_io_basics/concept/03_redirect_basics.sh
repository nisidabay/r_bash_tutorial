#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_redirect_basics.sh — stdout, stderr, fd merging, order
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    local tmpfile
    tmpfile=$(mktemp)

    # ── Redirect stdout (>) ──────────────────────────────────
    echo "stdout line" > "$tmpfile"

    # ── Redirect stderr (2>) ─────────────────────────────────
    # Send an error message to a separate file
    echo "error message" >&2 2>> "${tmpfile}.err"

    # ── Redirect both stdout and stderr (&>) ─────────────────
    # &>file is shorthand for >file 2>&1
    {
        echo "to stdout"
        echo "to stderr" >&2
    } &> "$tmpfile.both"
    echo "Both streams captured:"
    cat "$tmpfile.both"

    # ── Order matters! ──────────────────────────────────────
    # 2>&1 >file  — stderr goes to original stdout (terminal)
    # >file 2>&1  — both go to file (correct)
    echo "Order test" > "$tmpfile.order" 2>&1

    rm -f "$tmpfile" "${tmpfile}.err" "${tmpfile}.both" "${tmpfile}.order"
}
main "$@"
