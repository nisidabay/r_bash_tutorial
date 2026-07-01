#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Tabla de productos con printf
# ──────────────────────────────────────────────────────────────

echo "=== Tabla de Productos ==="

# Productos: nombre, precio (en centavos para evitar floats), cantidad
nombres=("Manzana" "Pan" "Leche")
precios=(2500 1500 3200)  # en centavos
cantidades=(3 2 1)

printf "│ %-15s │ %8s │ %3s │\n" "Producto" "Precio" "Cant"
printf "│%s│\n" "──────────────────────────────────"

total=0
for i in "${!nombres[@]}"; do
    precio_decimal=$(printf "%.2f" "$(echo "scale=2; ${precios[$i]} / 100" | bc -l 2>/dev/null || echo "${precios[$i]}.00")")
    # Fallback a entero si bc no está disponible
    if [[ "$precio_decimal" == "0.00" && "${precios[$i]}" -gt 0 ]]; then
        precio_decimal="${precios[$i]}.00"
    fi
    printf "│ %-15s │ %8s │ %3d │\n" "${nombres[$i]}" "$precio_decimal" "${cantidades[$i]}"
    ((total += precios[$i] * cantidades[$i]))
done

# Mostrar total
total_decimal=$(printf "%.2f" "$(echo "scale=2; $total / 100" | bc -l 2>/dev/null || echo "$total.00")")
printf "│ %-15s │ %8s │ %3s │\n" "TOTAL" "$total_decimal" ""
