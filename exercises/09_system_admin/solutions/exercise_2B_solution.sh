#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_2B_solution.sh — Solución: Limpiador de .tmp
# ──────────────────────────────────────────────────────────────

main() {
    local dir="${1:-.}"

    [[ -d "$dir" ]] || { echo "Error: '$dir' no es un directorio." >&2; exit 1; }

    shopt -s nullglob
    local files=("$dir"/*.tmp)
    shopt -u nullglob

    if ((${#files[@]} == 0)); then
        echo "No se encontraron archivos .tmp en '$dir'."
        exit 0
    fi

    local -a to_delete=()
    local file size total_size=0

    for file in "${files[@]}"; do
        size=$(stat -c%s "$file" 2>/dev/null || wc -c < "$file")
        if (( size > 1048576 )); then
            to_delete+=("$file")
            total_size=$((total_size + size))
            echo "  ${file}: $((size / 1024)) KB"
        fi
    done

    if ((${#to_delete[@]} == 0)); then
        echo "No hay archivos .tmp mayores a 1 MB."
        exit 0
    fi

    echo ""
    echo "Se encontraron ${#to_delete[@]} archivos para eliminar"
    echo "(total: $((total_size / 1024 / 1024)) MB)."
    read -p "¿Eliminar? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "${to_delete[@]}"
        echo "Eliminados ${#to_delete[@]} archivos."
    else
        echo "Operación cancelada."
    fi
}

main "$@"
