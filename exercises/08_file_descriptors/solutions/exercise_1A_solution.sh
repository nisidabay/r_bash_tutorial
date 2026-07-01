#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: Comparador de archivos
# ──────────────────────────────────────────────────────────────

main() {
    [[ $# -eq 2 ]] || { echo "Uso: ${0##*/} <archivo1> <archivo2>"; exit 1; }

    local file_1="$1"
    local file_2="$2"
    local diff_count=0
    local line_num=0
    local eof1=0
    local eof2=0

    [[ -f "$file_1" ]] || { echo "Error: '$file_1' no existe." >&2; exit 1; }
    [[ -f "$file_2" ]] || { echo "Error: '$file_2' no existe." >&2; exit 1; }

    exec 3<"$file_1"
    exec 4<"$file_2"

    echo "--- Comparando: $file_1 vs $file_2 ---"

    while true; do
        ((line_num++))
        IFS= read -r line1 <&3 || eof1=1
        IFS= read -r line2 <&4 || eof2=1
        ((eof1 && eof2)) && break

        if [[ "$line1" != "$line2" ]]; then
            echo "Línea $line_num: DIFERENTE"
            echo "  Archivo1: '$line1'"
            echo "  Archivo2: '$line2'"
            ((diff_count++))
        fi
    done

    echo "---"
    echo "$diff_count líneas diferentes encontradas."

    exec 3<&-
    exec 4<&-
}

main "$@"
