#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A.sh — Basado en 05_nameref_increment.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Crear append_to_array() y array_length() usando
# namerefs, y usarlas para llenar un array hasta 5 elementos.
# ──────────────────────────────────────────────────────────────

# TODO: Crear función append_to_array()
# Recibe nombre de array y elemento, agrega con arr+=( "$elem" )
# Usar local -n arr="$1"

# TODO: Crear función array_length()
# Recibe nombre de array, return 0 si > 3 elementos, 1 si <= 3

main() {
    # TODO: Declarar array local mi_array=()

    # TODO: Usar append_to_array para agregar elementos
    # hasta que tenga al menos 5 elementos

    # TODO: Mostrar longitud después de cada inserción
    echo "Completá este ejercicio siguiendo los TODOs."
}

main "$@"
