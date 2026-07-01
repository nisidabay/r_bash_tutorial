#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_binary_search.sh — Binary search on a sorted array
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Binary Search ────────────────────────────────────────────
# Searches for target in a sorted array.
# Returns: index of target (0-based), or -1 if not found.
# Arguments: target, then array elements
binary_search() {
    local target="$1"
    shift
    local -a arr=("$@")
    local lo=0
    local hi=$((${#arr[@]} - 1))
    local mid

    while ((lo <= hi)); do
        mid=$((lo + (hi - lo) / 2))

        if [[ "${arr[mid]}" == "$target" ]]; then
            echo "$mid"
            return 0
        elif [[ "${arr[mid]}" < "$target" ]]; then
            lo=$((mid + 1))
        else
            hi=$((mid - 1))
        fi
    done

    echo -1
    return 1
}

# ── Helper: verify array is sorted ──────────────────────────
is_sorted() {
    local -a arr=("$@")
    local i
    for ((i = 0; i < ${#arr[@]} - 1; i++)); do
        if [[ "${arr[i]}" > "${arr[i+1]}" ]]; then
            return 1
        fi
    done
    return 0
}

# ── Main ─────────────────────────────────────────────────────
main() {
    local -a data=(2 5 8 12 16 23 38 45 56 72)
    local target="${1:-23}"

    echo "Array: ${data[*]}"
    if ! is_sorted "${data[@]}"; then
        echo "Error: array must be sorted for binary search" >&2
        exit 1
    fi

    local index
    index=$(binary_search "$target" "${data[@]}")
    if ((index >= 0)); then
        echo "Found '$target' at index $index"
    else
        echo "'$target' not found"
    fi

    # Test with not-found value
    echo ""
    target="99"
    index=$(binary_search "$target" "${data[@]}")
    if ((index >= 0)); then
        echo "Found '$target' at index $index"
    else
        echo "'$target' not found (correct: not in array)"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
