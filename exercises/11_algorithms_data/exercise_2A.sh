#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A.sh — Basado en 04_random_data.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Agregar funciones generar_matricula() y
# generar_telefono(), y un menú select para elegir tipo de dato.
# ──────────────────────────────────────────────────────────────

# TODO: Crear función generar_matricula()
# Formato: "ABC-1234" (3 letras mayúsculas, guión, 4 dígitos)
# Usar LC_ALL=C tr -dc 'A-Z' </dev/urandom | head -c 3
# y printf "%04d" $((RANDOM % 10000))

# TODO: Crear función generar_telefono()
# Formato: "+54 9 11 XXXX-XXXX" (últimos 8 dígitos aleatorios)

main() {
    # TODO: Definir array de funciones como en 04_random_data.sh
    # Incluir: generar_matricula, generar_telefono

    # TODO: Agregar menú select para elegir qué generar
    # Generar 10 ejemplos del tipo seleccionado
    echo "Completá este ejercicio siguiendo los TODOs."
}

main "$@"
