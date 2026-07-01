#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A.sh — Basado en 07_fd_timeout.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Leer de un proceso en background con timeout en read,
# mostrando "Timeout — línea lenta" si excede 3 segundos.
# ──────────────────────────────────────────────────────────────

main() {
    echo "=== Lectura con Timeout ==="

    # TODO: Usar exec 3< <(...) con un proceso que genere líneas
    # Cada línea con sleep aleatorio entre 1 y 4 segundos
    # for i in {1..5}; do echo "línea $i"; sleep $((RANDOM % 4 + 1)); done

    # TODO: En un while, usar read -r -t 3 line <&3
    # Si read tiene éxito, mostrar "Leído: $line"
    # Si expira, mostrar "Timeout — línea lenta"

    exec 3<&-
}

main "$@"
