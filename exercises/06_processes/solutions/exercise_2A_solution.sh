#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Reporte del sistema
# ──────────────────────────────────────────────────────────────

main() {
    local fecha
    local procesos
    local mem_libre
    local hostname_val

    fecha=$(date +%Y-%m-%d)
    procesos=$(ps -e --no-headers | wc -l)
    mem_libre=$(free -m | awk 'NR==2{print $7}')
    hostname_val=$(hostname)

    echo "=== Reporte del Sistema ==="
    printf "Fecha:     %s\n" "$fecha"
    printf "Procesos:  %d\n" "$procesos"
    printf "Mem libre: %d MB\n" "$mem_libre"
    printf "Hostname:  %s\n" "${hostname_val^^}"
}

main "$@"
