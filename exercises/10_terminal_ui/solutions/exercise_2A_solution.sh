#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Spinner con cambio de mensaje
# ──────────────────────────────────────────────────────────────

main() {
    local temp_log
    temp_log=$(mktemp)

    # Iniciar tarea simulada en background
    (
        for i in {1..8}; do
            echo "Paso $i"
            sleep 1
        done
    ) > "$temp_log" 2>&1 &
    local pid_task=$!

    # Iniciar spinner
    (
        local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local i=0
        local elapsed=0
        local msg="Cargando..."
        while true; do
            if ((elapsed >= 40)); then
                msg="Casi listo..."
            fi
            printf "\r\033[1;32m%s %s\033[0m" "$msg" "${spin:i++%${#spin}:1}" >&2
            sleep 0.1
            ((elapsed++))
        done
    ) &
    local pid_spinner=$!

    # Monitorear
    local timeout=100
    while ((timeout > 0)); do
        if ! kill -0 "$pid_task" 2>/dev/null; then
            break
        fi
        ((timeout--))
        sleep 0.1
    done

    # Limpiar
    kill "$pid_spinner" 2>/dev/null
    printf "\r%-50s\n" "✅ Tarea completada!" >&2
    rm -f "$temp_log"
}

main "$@"
