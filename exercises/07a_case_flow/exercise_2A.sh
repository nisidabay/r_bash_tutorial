#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 02_case_flowing.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Analizar primer argumento con case, usar ;& y ;;&
# para activar múltiples flags según el contenido.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Obtener el primer argumento: bebida="${1:-}"

    # TODO: Declarar flags: cold=false, milk=false, caffeine=true

    # TODO: Usar case con ;& y ;;& para analizar:
    # *iced_*) — activar cold ;;
    # *milk*|*latte*) — activar milk ;;
    # *decaf*) — desactivar caffeine ;;
    # *espresso*) — activar caffeine (redundante pero explícito) ;;

    # TODO: Mostrar resumen formateado
    # "Es: caliente/frío, Con leche: sí/no, Cafeína: sí/no"
    echo "Completá este ejercicio siguiendo los TODOs."
}

main "$@"
