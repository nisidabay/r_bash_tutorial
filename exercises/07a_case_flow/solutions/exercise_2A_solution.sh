#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Analizador de bebidas
# ──────────────────────────────────────────────────────────────

main() {
    local bebida="${1:-}"
    local cold=false
    local milk=false
    local caffeine=true

    [[ -z "$bebida" ]] && { echo "Uso: $0 <bebida>"; exit 1; }

    case "$bebida" in
        *iced_*|*frappe*)
            cold=true
            ;;&
        *milk*|*latte*)
            milk=true
            ;;&
        *decaf*)
            caffeine=false
            ;;&
        *espresso*)
            caffeine=true
            ;;&
        *)
            # Todos los casos evaluados
            ;;
    esac

    echo "--- Resumen ---"
    echo "Bebida: $bebida"
    echo "Es: $([[ $cold == true ]] && echo 'fría' || echo 'caliente')"
    echo "Con leche: $([[ $milk == true ]] && echo 'sí' || echo 'no')"
    echo "Cafeína: $([[ $caffeine == true ]] && echo 'sí' || echo 'no')"
}

main "$@"
