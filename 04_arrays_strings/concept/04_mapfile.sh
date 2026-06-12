#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 04_mapfile.sh — Reading files/strings into arrays with mapfile
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── mapfile from a file ───────────────────────────────────
    # -t strips trailing newlines from each line
    local tmpfile
    tmpfile=$(mktemp)
    printf "line one\nline two\nline three\n" > "$tmpfile"

    local lines=()
    mapfile -t lines < "$tmpfile"
    echo "Read ${#lines[@]} lines from file:"
    printf "  %s\n" "${lines[@]}"

    # ── mapfile from a here-string ───────────────────────────
    local data=()
    mapfile -t data <<< "alpha
beta
gamma"
    echo "From here-string: ${data[1]}"

    # ── readarray is an alias for mapfile ─────────────────────
    local nums=()
    readarray -t nums <<< "10
20
30"
    echo "readarray alias: ${nums[@]}"

    rm -f "$tmpfile"
}
main "$@"
