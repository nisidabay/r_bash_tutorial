#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A_solution.sh — Solución: Nameref array operations
# ──────────────────────────────────────────────────────────────

append_to_array() {
    local -n arr="$1"
    local elem="$2"
    arr+=( "$elem" )
}

array_length() {
    local -n arr="$1"
    ((${#arr[@]} > 3))
}

main() {
    local -a mi_array=()
    local elementos=("a" "b" "c" "d" "e")

    echo "Agregando elementos uno por uno..."
    for elem in "${elementos[@]}"; do
        append_to_array mi_array "$elem"
        echo "Array ahora tiene ${#mi_array[@]} elementos: ${mi_array[*]}"
    done

    echo ""
    echo "Total: ${#mi_array[@]} elementos"
    if array_length mi_array; then
        echo "El array tiene más de 3 elementos."
    else
        echo "El array tiene 3 o menos elementos."
    fi
}

main "$@"
