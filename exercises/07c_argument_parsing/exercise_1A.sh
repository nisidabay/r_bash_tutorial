#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 11_getopts_standard.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Agregar opciones -o (directorio de salida) y -q
# (modo silencioso) al script de getopts.
# ──────────────────────────────────────────────────────────────

main() {
    local verbose=false
    local input_file=""
    local name=""
    local output_dir=""
    local quiet=false

    # TODO: Modificar optstring de ":vf:n:h" a ":vf:n:o:qh"
    # y agregar casos 'o)' y 'q)' en el case

    while getopts ":vf:n:h" opt; do
        case $opt in
            v) verbose=true ;;
            f) input_file="$OPTARG" ;;
            n) name="$OPTARG" ;;
            h)
                echo "Uso: ${0##*/} -f FILE -n NAME [-v] [-o DIR] [-q] [-h]"
                exit 0
                ;;
            # TODO: Agregar caso 'o)' — crear directorio con mkdir -p
            # TODO: Agregar caso 'q)' — activar modo silencioso
            \?)
                echo "Error: Opción inválida: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Error: -$OPTARG requiere un argumento." >&2
                exit 1
                ;;
        esac
    done

    # TODO: Validar que si se pasó -o, el directorio sea escribible
    # [[ -w "$output_dir" ]] || { echo "Error: no escribible"; exit 1; }

    [[ "$quiet" != true ]] && echo "Script iniciado."
    echo "Procesando..."
}

main "$@"
