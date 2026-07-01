#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 04_local_vars.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Agregar función acumular() y validar_y_procesar(),
# y evitar modificación accidental de variable global.
# ──────────────────────────────────────────────────────────────

# Variable global (no modificar accidentalmente)
contador=0

# TODO: Crear función acumular() que reciba un nombre de variable
# (como nameref) y un número, y sume el número a la variable.
# Usar local -n ref="$1"

# TODO: Crear función validar_y_procesar() que llame a acumular()
# y luego muestre el total actual.

main() {
    local total=0

    # TODO: Llamar a acumular total 10
    # TODO: Llamar a validar_y_procesar
    # TODO: Mostrar que contador global NO fue modificado

    echo "Contador global (debería ser 0): $contador"
    echo "Total local: $total"
}

main "$@"
