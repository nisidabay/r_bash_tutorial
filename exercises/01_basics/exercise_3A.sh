#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A.sh — Basado en 06_ifs.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Pedir al usuario campos separados por coma,
# parsearlos con IFS, mostrarlos numerados, y luego unirlos con " | "
# ──────────────────────────────────────────────────────────────

echo "=== Parseo de Campos CSV ==="

# TODO: Pedir al usuario que ingrese campos separados por coma
# read -p "Ingresá campos separados por coma: " entrada

# TODO: Guardar IFS actual, cambiar a coma, y leer los campos en un array
# saved_ifs="$IFS"; IFS=","; ...

# TODO: Mostrar cada campo numerado (1: campo1, 2: campo2, ...)

# TODO: Unir los campos con IFS=" | " y mostrar el resultado
# Usar "${array[*]}" con el IFS modificado

# TODO: Restaurar IFS original

exit 0
