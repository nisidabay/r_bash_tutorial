#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: getopts extendido
# ──────────────────────────────────────────────────────────────

main() {
    local verbose=false
    local input_file=""
    local name=""
    local output_dir=""
    local quiet=false

    while getopts ":vf:n:o:qh" opt; do
        case $opt in
            v) verbose=true ;;
            f) input_file="$OPTARG" ;;
            n) name="$OPTARG" ;;
            o)
                output_dir="$OPTARG"
                mkdir -p "$output_dir"
                ;;
            q) quiet=true ;;
            h)
                echo "Uso: ${0##*/} -f FILE -n NAME [-v] [-o DIR] [-q] [-h]"
                exit 0
                ;;
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

    if [[ -n "$output_dir" ]] && [[ ! -w "$output_dir" ]]; then
        echo "Error: No se puede escribir en '$output_dir'." >&2
        exit 1
    fi

    [[ "$quiet" != true ]] && echo "Script iniciado."
    echo "Procesando archivo '$input_file'..."
    [[ -n "$output_dir" ]] && echo "Salida en: $output_dir"
}

main "$@"
