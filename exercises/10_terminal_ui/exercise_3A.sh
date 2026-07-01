#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A.sh — Basado en 03_formatted_table.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Tabla de conversión pulgadas a centímetros (1 a max),
# con max opcional (default 12).
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Obtener máximo de la tabla de ${1:-12}
    local max="${1:-12}"

    # TODO: Validar que max es un entero positivo

    echo "=== Conversión: Pulgadas → Centímetros ==="

    # TODO: Mostrar encabezado con printf
    # "│ %-2s pulg │ %3s cm │"

    # TODO: Loop for ((i=1; i<=max; i++))
    # Calcular cm=$((i * 254 / 100))
    # Mostrar con printf "│ %-2d pulg │ %3d cm │"

    echo "Tabla generada hasta $max pulgadas."
}

main "$@"
