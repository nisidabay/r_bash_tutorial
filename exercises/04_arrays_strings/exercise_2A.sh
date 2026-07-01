#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 02_associative_arrays.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Leer productos del usuario hasta "listo",
# almacenar en array asociativo, mostrar ticket con total.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Declarar array asociativo local -A carrito

    # TODO: Loop while true para leer productos
    # read -p "Producto: " prod
    # [[ "$prod" == "listo" ]] && break
    # read -p "Precio: " precio
    # carrito["$prod"]=$precio

    # TODO: Mostrar ticket
    # Iterar con for item in "${!carrito[@]}"
    # Calcular total con (( total += carrito[$item] ))

    echo "=== Ticket ==="
    # TODO: Mostrar cada producto y precio
    echo "Total: ..."
}

main "$@"
