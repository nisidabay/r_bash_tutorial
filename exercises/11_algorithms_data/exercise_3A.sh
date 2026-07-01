#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_3A.sh — Basado en 01_rot13.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Ofrecer tres modos: -e (ROT13), -d (ROT13 decode),
# -r (ROT47). Validar archivo no vacío.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Validar argumentos (modo y archivo)

    # TODO: Validar que el archivo no esté vacío con [[ -s ]]

    # TODO: Definir comando tr según modo:
    # -e o -d: tr 'A-Za-z' 'N-ZA-Mn-za-m'
    # -r:      tr '!-~' 'P-~!-O'

    # TODO: Ejecutar tr < "$input_file" > "$output_file"
    echo "Completá este ejercicio siguiendo los TODOs."
}

main "$@"
