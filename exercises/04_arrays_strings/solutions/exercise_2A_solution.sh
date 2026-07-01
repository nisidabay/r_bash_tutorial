#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Carrito de compras
# ──────────────────────────────────────────────────────────────

main() {
    local -A carrito
    local prod precio total=0

    echo "=== Ingreso de Productos ==="
    echo "Escribí 'listo' para terminar."

    while true; do
        read -p "Producto: " prod
        [[ "$prod" == "listo" ]] && break
        read -p "Precio: " precio
        carrito["$prod"]=$precio
    done

    echo ""
    echo "=== Ticket ==="
    for item in "${!carrito[@]}"; do
        printf "  %-15s \$%s\n" "$item" "${carrito[$item]}"
        (( total += carrito[$item] ))
    done
    echo "  ---------------"
    echo "  Total: \$$total"
}

main "$@"
