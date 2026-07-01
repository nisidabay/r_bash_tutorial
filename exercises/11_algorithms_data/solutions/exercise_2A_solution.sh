#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2A_solution.sh — Solución: Generador de datos aleatorios
# ──────────────────────────────────────────────────────────────

generar_matricula() {
    local letras numeros
    letras=$(LC_ALL=C tr -dc 'A-Z' </dev/urandom | head -c 3)
    numeros=$(printf "%04d" $((RANDOM % 10000)))
    echo "${letras}-${numeros}"
}

generar_telefono() {
    local num
    num=$(printf "%04d-%04d" $((RANDOM % 10000)) $((RANDOM % 10000)))
    echo "+54 9 11 ${num}"
}

main() {
    local functions=(
        "generar_matricula"
        "generar_telefono"
    )

    echo "=== Generador de Datos Aleatorios ==="
    PS3="Seleccioná un tipo (o 'q' para salir): "
    select choice in "${functions[@]}"; do
        if [[ -n "$choice" ]]; then
            echo "Generando 10 ejemplos de $choice:"
            for ((i=1; i<=10; i++)); do
                echo "  $i: $("$choice")"
            done
            break
        else
            echo "Opción inválida."
        fi
    done
}

main "$@"
