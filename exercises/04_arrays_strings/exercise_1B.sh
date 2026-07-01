#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B.sh — Basado en 01_indexed_arrays.sh, 04_mapfile.sh,
#                  05_parameter_expansion.sh, 06_here_docs.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Usar here-doc para definir datos clave=valor,
# mapfile para leerlos, parameter expansion para separar,
# y array asociativo para almacenar e imprimir.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Usar un here-doc para definir datos de ejemplo
    # con formato clave=valor, una por línea
    # Ejemplo:
    #   usuario=admin
    #   puerto=8080
    #   host=localhost

    # TODO: Leer los datos en un array con mapfile -t
    # local lines=()
    # mapfile -t lines << 'EOF'
    # usuario=admin
    # puerto=8080
    # host=localhost
    # EOF

    # TODO: Procesar cada línea con parameter expansion
    # key="${line%%=*}"
    # val="${line#*=}"

    # TODO: Almacenar en declare -A y mostrar como tabla formateada
    echo "Completá este ejercicio siguiendo los TODOs."
}

main "$@"
