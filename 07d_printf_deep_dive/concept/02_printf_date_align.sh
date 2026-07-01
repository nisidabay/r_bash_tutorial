#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_printf_date_align.sh — printf date formatting and alignment
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# printf tiene un secreto poco conocido: %(datefmt)T
# Formatea fechas como date(1) pero sin forkear un subshell.

echo "=== %(datefmt)T — Fechas sin date(1) ==="
# El tercer argumento es el timestamp (segundos desde epoch).
# -1 = ahora, -2 = tiempo de ejecución del script.
printf "Ahora:        %(%Y-%m-%d %H:%M:%S)T\n" -1
printf "Ejecución:    %(%Y-%m-%d)T\n" -2

echo ""
echo "=== Tabla formateada ==="
# Combinar ancho dinámico con columnas
printf "%-20s %8s %12s\n" "Nombre" "Edad" "Fecha"
printf "%-20s %8d %12s\n" "Carlos" 42 "2024-01-15"
printf "%-20s %8d %12s\n" "Ana" 35 "2024-03-22"
printf "%-20s %8d %12s\n" "Pedro" 28 "2024-06-01"

echo ""
echo "=== Ancho dinámico desde variable ==="
cols=(15 25 35)
for c in "${cols[@]}"; do
    printf "Ancho %2d: |%${c}s|\n" "$c" "texto"
done

echo ""
echo "=== Repetir caracteres con printf ==="
# printf sin argumento + %s con ancho = repetir
separador=$(printf "%0.s=" {1..40})
echo "Separador: $separador"

# Otra forma: printf con * y string vacío
printf "%0.s=" {1..30}
echo ""
