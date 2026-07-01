#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2B.sh — Basado en 08_nullglob_safety.sh,
#                  04_safe_update.sh, 09_find_null_safe.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Escanear directorio buscando .tmp > 1 MB,
# mostrar diff de tamaño, pedir confirmación y eliminar.
# ──────────────────────────────────────────────────────────────

main() {
    local dir="${1:-.}"

    # TODO: Validar que el directorio existe

    # TODO: Usar nullglob para buscar *.tmp en el directorio
    # shopt -s nullglob; files=("$dir"/*.tmp); shopt -u nullglob

    # TODO: Para cada archivo, verificar si es > 1 MB (1048576 bytes)
    # Usar stat -c%s o wc -c

    # TODO: Mostrar archivos encontrados con su tamaño

    # TODO: Preguntar "¿Eliminar estos N archivos? (y/n)"

    # TODO: Si confirma, eliminar y mostrar resumen
}

main "$@"
