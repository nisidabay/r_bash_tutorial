#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2B.sh — Basado en 01_read_input.sh y 06_dev_stdin.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Aceptar archivo como argumento o leer de stdin.
# Preguntar prefijo al usuario, prefijar cada línea y escribir
# a un archivo de salida con timestamp.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Usar patrón file-or-stdin: local input="${1:-/dev/stdin}"

    # TODO: Preguntar prefijo al usuario con read -p

    # TODO: Crear nombre de archivo de salida con timestamp:
    # salida_$(date +%s).txt

    # TODO: Leer cada línea de la entrada y escribir con prefijo
    # al archivo de salida. Usar while IFS= read -r line

    # TODO: Contar líneas procesadas e informar al final
    echo "Completá este ejercicio siguiendo los TODOs."
}

main "$@"
