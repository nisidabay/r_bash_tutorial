#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 04_pipes.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Leer palabras de un archivo, pasarlas por pipeline
# rev | tr, y verificar PIPESTATUS.
# ──────────────────────────────────────────────────────────────

main() {
    local word_file="palabras.txt"

    # TODO: Crear el archivo palabras.txt con algunas palabras de ejemplo
    # (o verificar que existe)

    # TODO: Usar mapfile -t words < "$word_file" para leer las palabras

    # TODO: Para cada palabra, ejecutar:
    # result=$(echo "$palabra" | rev | tr 'a-z' 'A-Z')

    # TODO: Verificar PIPESTATUS después del pipeline
    # Si algún valor no es 0, reportar error

    # TODO: Mostrar los resultados
}

main "$@"
