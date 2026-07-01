#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Logging con niveles
# ──────────────────────────────────────────────────────────────

readonly LOG_FILE="ejercicio_log.txt"

log_message() {
    local message
    message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$message" | tee -a /dev/fd/3
}

log_info() {
    log_message "[INFO] $*"
}

log_warn() {
    log_message "[WARN] $*"
}

log_error() {
    log_message "[ERROR] $*" >&2
}

main() {
    exec 3>>"$LOG_FILE"

    log_info "Script iniciado."
    log_warn "Esto es una advertencia."
    log_error "Esto es un error simulado."

    exec 3>&-
    echo "Log escrito en: $LOG_FILE"
}

main "$@"
