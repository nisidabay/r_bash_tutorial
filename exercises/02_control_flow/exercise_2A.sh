#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 03_for_loop.sh + 06_break_continue.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Iterar sobre archivos *.txt, saltar no-regulares con
# continue, y detenerse con break al encontrar uno > 1 KB.
# ──────────────────────────────────────────────────────────────

echo "=== Buscador de archivos TXT grandes ==="

# TODO: Iterar sobre todos los archivos *.txt del directorio actual
# for file in *.txt; do

# TODO: Si no es un archivo regular, hacer continue

# TODO: Obtener tamaño con wc -c < "$file"

# TODO: Si el tamaño > 1024, mostrar nombre y tamaño, y hacer break

# TODO: Si no se encontró ningún archivo grande, mostrar mensaje

exit 0
