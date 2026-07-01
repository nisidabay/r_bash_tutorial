#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 03_fd_compare.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Comparar dos archivos recibidos como argumentos,
# con contador de diferencias.
# ──────────────────────────────────────────────────────────────

main() {
    # TODO: Validar que se pasaron exactamente 2 argumentos
    # [[ $# -eq 2 ]] || { echo "Uso: ..."; exit 1; }

    local file_1="$1"
    local file_2="$2"
    local diff_count=0
    local line_num=0
    local eof1=0
    local eof2=0

    # TODO: Verificar que ambos archivos existen
    # [[ -f "$file_1" ]] || { echo "No existe: $file_1"; exit 1; }

    # Abrir file descriptors
    exec 3<"$file_1"
    exec 4<"$file_2"

    echo "--- Comparando: $file_1 vs $file_2 ---"

    # Loop de comparación
    while true; do
        ((line_num++))
        IFS= read -r line1 <&3 || eof1=1
        IFS= read -r line2 <&4 || eof2=1
        ((eof1 && eof2)) && break

        if [[ "$line1" != "$line2" ]]; then
            echo "Línea $line_num: DIFERENTE"
            echo "  Archivo1: '$line1'"
            echo "  Archivo2: '$line2'"
            # TODO: Incrementar diff_count
        fi
    done

    # TODO: Reportar "X líneas diferentes encontradas"

    exec 3<&-
    exec 4<&-
}

main "$@"
