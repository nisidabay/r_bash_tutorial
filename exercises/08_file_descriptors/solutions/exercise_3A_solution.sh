#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A_solution.sh — Solución: Lectura con timeout
# ──────────────────────────────────────────────────────────────

main() {
    echo "=== Lectura con Timeout ==="

    exec 3< <(
        for i in {1..5}; do
            echo "línea $i"
            sleep $((RANDOM % 4 + 1))
        done
    )

    while true; do
        if read -r -t 3 line <&3; then
            echo "  Leído: $line"
        else
            echo "  Timeout — línea lenta"
            # Verificar si el proceso terminó
            if ! read -r -t 0 <&3 2>/dev/null; then
                # No hay más datos disponibles inmediatamente
                # Intentamos un último read con timeout corto
                if ! read -r -t 1 line <&3 2>/dev/null; then
                    break
                fi
            fi
        fi
    done

    exec 3<&-
    echo "Lectura completada."
}

main "$@"
