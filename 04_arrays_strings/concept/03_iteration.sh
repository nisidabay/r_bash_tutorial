#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_iteration.sh — All array iteration patterns in Bash
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    local fruits=("apple" "banana" "cherry" "date")

    # ── For-each over elements ────────────────────────────────
    # "${arr[@]}" expands to each element (preserving spaces)
    echo "--- For-each over elements ---"
    for fruit in "${fruits[@]}"; do
        echo "  Fruit: $fruit"
    done

    # ── For-each over indices ─────────────────────────────────
    # "${!arr[@]}" expands to the index numbers
    echo "--- For-each over indices ---"
    for i in "${!fruits[@]}"; do
        echo "  Index $i: ${fruits[$i]}"
    done

    # ── C-style index loop ────────────────────────────────────
    echo "--- C-style loop ---"
    for ((i = 0; i < ${#fruits[@]}; i++)); do
        echo "  fruits[$i] = ${fruits[$i]}"
    done

    # ── While with counter ────────────────────────────────────
    echo "--- While with counter ---"
    local i=0
    while ((i < ${#fruits[@]})); do
        echo "  ${fruits[$i]}"
        ((i++))
    done
}
main "$@"
