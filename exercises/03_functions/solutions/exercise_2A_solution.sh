#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Acumulador con nameref
# ──────────────────────────────────────────────────────────────

contador=0

acumular() {
    local -n ref="$1"
    local valor="$2"
    ((ref += valor))
}

validar_y_procesar() {
    local -n ref="$1"
    local valor="$2"
    acumular "$1" "$valor"
    echo "Total actual: $ref"
}

main() {
    local total=0

    acumular total 10
    echo "Después de acumular 10: total=$total"

    validar_y_procesar total 5
    echo "Después de validar_y_procesar 5: total=$total"

    echo ""
    echo "Contador global (debería ser 0): $contador"
    echo "Total local: $total"
}

main "$@"
