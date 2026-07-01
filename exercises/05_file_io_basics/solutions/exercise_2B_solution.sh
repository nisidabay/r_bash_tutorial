#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2B_solution.sh — Solución: Prefijador de líneas
# ──────────────────────────────────────────────────────────────

main() {
    local input="${1:-/dev/stdin}"
    local prefijo
    local outfile
    local count=0

    read -p "Prefijo: " prefijo

    outfile="salida_$(date +%s).txt"

    while IFS= read -r line || [[ -n "$line" ]]; do
        echo "$prefijo$line" >> "$outfile"
        ((count++))
    done < "$input"

    echo "Procesadas $count líneas -> $outfile"
}

main "$@"
