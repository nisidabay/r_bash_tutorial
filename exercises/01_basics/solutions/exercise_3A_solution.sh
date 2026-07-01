#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A_solution.sh — Solución: Parseo CSV con IFS
# ──────────────────────────────────────────────────────────────

echo "=== Parseo de Campos CSV ==="

read -p "Ingresá campos separados por coma: " entrada

# Guardar IFS y cambiar a coma
saved_ifs="$IFS"
IFS="," read -ra campos <<< "$entrada"

# Mostrar campos numerados
for i in "${!campos[@]}"; do
    echo "$((i+1)): ${campos[$i]}"
done

# Unir con " | "
IFS=" | "
echo "Unidos: ${campos[*]}"

# Restaurar IFS
IFS="$saved_ifs"
