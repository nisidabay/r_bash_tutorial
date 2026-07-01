#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: Pipeline con PIPESTATUS
# ──────────────────────────────────────────────────────────────

main() {
    local word_file="palabras.txt"
    local -a words

    # Crear archivo de ejemplo si no existe
    if [[ ! -f "$word_file" ]]; then
        printf "hola\\nmundo\\nbash\\nscript\\n" > "$word_file"
        echo "Creado archivo: $word_file"
    fi

    # Leer palabras
    mapfile -t words < "$word_file"

    # Procesar cada palabra
    local word result
    for word in "${words[@]}"; do
        result=$(echo "$word" | rev | tr 'a-z' 'A-Z')
        local -a pipe_status=("${PIPESTATUS[@]}")

        if [[ ${pipe_status[0]} -ne 0 || ${pipe_status[1]} -ne 0 || ${pipe_status[2]} -ne 0 ]]; then
            echo "Error en pipeline para '$word': status=${pipe_status[*]}"
        else
            echo "'$word' -> '$result'"
        fi
    done
}

main "$@"
