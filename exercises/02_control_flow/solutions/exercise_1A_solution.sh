#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: Verificador de Path
# ──────────────────────────────────────────────────────────────

echo "=== Verificador de Path ==="

read -p "Path a verificar: " path

if [[ ! -e "$path" ]]; then
    echo "No existe: $path"
    exit 1
fi

if [[ -d "$path" ]]; then
    if [[ -r "$path" ]]; then
        echo "Es un directorio legible"
    else
        echo "Es un directorio (no legible)"
    fi
elif [[ -f "$path" ]]; then
    if [[ -x "$path" ]]; then
        echo "Es un script ejecutable"
    elif [[ -r "$path" ]]; then
        echo "Es un archivo legible"
    else
        echo "Es un archivo"
    fi
else
    echo "Es un tipo especial de archivo"
fi
