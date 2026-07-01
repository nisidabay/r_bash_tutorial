#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 01_command_substitution.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Capturar información del sistema con $(...),
# almacenar en variables y mostrar como reporte formateado.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Capturar fecha actual con $(date +%Y-%m-%d)

    # TODO: Capturar cantidad de procesos: $(ps -e --no-headers | wc -l)
    # o $(ps -e | wc -l)

    # TODO: Capturar memoria libre: $(free -m | awk 'NR==2{print $7}')

    # TODO: Capturar hostname en mayúsculas: $(hostname) con ${hostname^^}

    # TODO: Mostrar todo como reporte formateado con printf
    echo "=== Reporte del Sistema ==="
    # printf "Fecha:     %s\n" ...
    # printf "Procesos:  %d\n" ...
    # printf "Mem libre: %d MB\n" ...
    # printf "Hostname:  %s\n" ...
}

main "$@"
