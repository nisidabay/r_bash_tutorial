#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A_solution.sh — Solución: ROT13/47 multiuso
# ──────────────────────────────────────────────────────────────

usage() {
    echo "Uso: ${0##*/} -e|-d|-r <archivo>"
    echo "  -e : ROT13 (encode)"
    echo "  -d : ROT13 (decode = mismo)"
    echo "  -r : ROT47"
    exit 1
}

main() {
    [[ $# -eq 2 ]] || usage

    local mode="$1"
    local input_file="$2"
    local output_file="${input_file}.out"
    local tr_cmd=""

    [[ "$mode" == "-e" || "$mode" == "-d" || "$mode" == "-r" ]] || { echo "Modo inválido: $mode" >&2; usage; }

    [[ -f "$input_file" ]] || { echo "Error: archivo no encontrado." >&2; exit 1; }
    [[ -s "$input_file" ]] || { echo "Error: archivo vacío." >&2; exit 1; }

    if [[ "$mode" == "-r" ]]; then
        tr_cmd="tr '!-~' 'P-~!-O'"
    else
        tr_cmd="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
    fi

    echo "Procesando '$input_file' -> '$output_file' (modo $mode)..."
    eval "$tr_cmd" < "$input_file" > "$output_file"
    echo "Hecho."
}

main "$@"
