#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_indexed_arrays.sh — Declaring, accessing, appending, slicing
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Declaring Arrays ──────────────────────────────────────
    # Empty array, then array with initial values
    # shellcheck disable=SC2034  # intentional: showing empty array declaration
    local empty=()
    local fruits=("apple" "banana" "cherry" "date")

    # ── Accessing Elements ────────────────────────────────────
    echo "First fruit: ${fruits[0]}"
    echo "All fruits: ${fruits[*]}"
    echo "Number of fruits: ${#fruits[@]}"

    # ── Appending ──────────────────────────────────────────────
    fruits+=("elderberry")
    echo "After append: ${fruits[*]}"

    # ── Slicing ───────────────────────────────────────────────
    # ${arr[@]:start:count} — start at index 1, take 2 elements
    echo "Slice [1:2]: ${fruits[*]:1:2}"

    # ── Index-based access ────────────────────────────────────
    echo "Last element: ${fruits[-1]}"
}
main "$@"
