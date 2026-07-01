#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Buscador de TXT grandes
# ──────────────────────────────────────────────────────────────

echo "=== Buscador de archivos TXT grandes ==="

found_big=false
shopt -s nullglob

for file in *.txt; do
    [[ -f "$file" ]] || continue

    size=$(wc -c < "$file")
    if (( size > 1024 )); then
        echo "Encontrado grande: $file ($size bytes)"
        found_big=true
        break
    fi
done

shopt -u nullglob

if [[ "$found_big" == false ]]; then
    echo "No se encontraron archivos .txt mayores a 1 KB."
fi
