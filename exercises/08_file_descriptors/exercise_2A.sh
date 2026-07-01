#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 05_fd_logging.sh y 06_fd_dual_output.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Sistema de logging con niveles (info/warn/error)
# que escribe a consola Y archivo de log, con error a stderr.
# ──────────────────────────────────────────────────────────────

readonly LOG_FILE="ejercicio_log.txt"

# TODO: Crear función log_message() que use tee -a /dev/fd/3
# como en 06_fd_dual_output.sh

# TODO: Crear log_info() que llame a log_message con "[INFO]"
# TODO: Crear log_warn() que llame a log_message con "[WARN]"
# TODO: Crear log_error() que llame a log_message con "[ERROR]" Y
# redirija también a stderr (>&2)

main() {
    # Abrir FD 3 para append al log
    exec 3>>"$LOG_FILE"

    # TODO: Llamar a log_info, log_warn, log_error con mensajes de ejemplo

    exec 3>&-
}

main "$@"
