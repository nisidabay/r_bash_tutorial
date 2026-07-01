#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# validador.sh — Script principal que sourcea lib_validacion.sh
# ──────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib_validacion.sh"

usage() {
    echo "Uso: ${0##*/} <valor1> [valor2 ...]"
    echo "Valida argumentos usando las funciones de lib_validacion.sh"
}

main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    local arg
    for arg in "$@"; do
        echo "--- Validando: '$arg' ---"
        if no_vacio "$arg"; then
            echo "  ✓ No vacío"
        else
            echo "  ✗ Vacío"
        fi
        if es_numero "$arg"; then
            echo "  ✓ Es número"
        fi
        if es_email "$arg"; then
            echo "  ✓ Es email"
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
