#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A_solution.sh — Solución: Tabla pulgadas→centímetros
# ──────────────────────────────────────────────────────────────

main() {
    local max="${1:-12}"

    if ! [[ "$max" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: '$max' no es un entero positivo." >&2
        exit 1
    fi

    echo "=== Conversión: Pulgadas → Centímetros ==="
    printf "┌──────────────────────┐\n"
    printf "│ %-10s │ %-7s │\n" "Pulgadas" "cm"
    printf "├──────────────────────┤\n"

    local cm
    for ((i=1; i<=max; i++)); do
        cm=$((i * 254 / 100))
        printf "│ %-10d │ %3d      │\n" "$i" "$cm"
    done

    printf "└──────────────────────┘\n"
    echo "Tabla generada hasta $max pulgadas."
}

main "$@"
