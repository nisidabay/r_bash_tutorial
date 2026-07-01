#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_bubble_sort.sh — Bubble sort with nameref
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Bubble Sort ──────────────────────────────────────────────
# Sorts an array in-place using bubble sort.
# Uses nameref to modify the caller's array directly.
# Arguments: the name of the array variable to sort
bubble_sort() {
    local -n arr="$1"
    local n=${#arr[@]}
    local i j tmp

    for ((i = 0; i < n - 1; i++)); do
        for ((j = 0; j < n - i - 1; j++)); do
            # Use arithmetic comparison for numbers, string comparison for others
            if [[ "${arr[j]}" =~ ^[0-9]+$ ]] && [[ "${arr[j+1]}" =~ ^[0-9]+$ ]]; then
                if (( arr[j] > arr[j+1] )); then
                    tmp="${arr[j]}"
                    arr[j]="${arr[j+1]}"
                    arr[j+1]="$tmp"
                fi
            elif [[ "${arr[j]}" > "${arr[j+1]}" ]]; then
                # Swap
                tmp="${arr[j]}"
                arr[j]="${arr[j+1]}"
                arr[j+1]="$tmp"
            fi
        done
    done
}

# ── Main ─────────────────────────────────────────────────────
main() {
    local -a numbers=(42 7 15 8 3 101 64 23 11 5)

    echo "Original: ${numbers[*]}"
    bubble_sort numbers
    echo "Sorted:   ${numbers[*]}"

    # Test with strings
    local -a fruits=("banana" "apple" "cherry" "date" "elderberry")
    echo ""
    echo "Original: ${fruits[*]}"
    bubble_sort fruits
    echo "Sorted:   ${fruits[*]}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
