#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 06_mpv_spinner.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Spinner que simula una tarea larga (sleep 8) y
# cambia mensaje en el segundo 4.
# ──────────────────────────────────────────────────────────────

main() {
    local temp_log
    temp_log=$(mktemp)
    local pid_spinner
    local timeout=100  # 100 * 0.1s = 10 segundos

    # TODO: Iniciar proceso en background que simule trabajo
    # (for i in {1..8}; do echo "Paso $i"; sleep 1; done) > "$temp_log" 2>&1 &

    # TODO: Iniciar spinner en background (como en 06_mpv_spinner.sh)
    # Usar un conjunto de caracteres: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

    # TODO: Loop de monitoreo con timeout
    # Verificar si el proceso terminó o si pasaron ~4 segundos
    # para cambiar mensaje de "Cargando..." a "Casi listo..."

    # TODO: Limpiar: kill spinner, rm temp_log

    rm -f "$temp_log"
}

main "$@"
