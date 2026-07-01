#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A_solution.sh — Solución: Barras de progreso múltiples
# ──────────────────────────────────────────────────────────────

draw_progress_bar() {
    local percentage=$1
    local width=${2:-40}
    local filled_chars=$((percentage * width / 100))
    local empty_chars=$((width - filled_chars))

    printf "\r[%3d%%] [" "$percentage"
    if ((filled_chars > 0)); then
        printf "%${filled_chars}s" "" | tr ' ' '#'
    fi
    if ((empty_chars > 0)); then
        printf "%${empty_chars}s" "" | tr ' ' '-'
    fi
    printf "]"
}

main() {
    local archivos=("doc1.zip" "doc2.zip" "doc3.zip" "doc4.zip" "doc5.zip")
    local tamanos=(40 75 20 90 55)
    local total_general=0
    local gran_total=0

    # Calcular el gran total
    for t in "${tamanos[@]}"; do
        ((gran_total += t))
    done

    for i in "${!archivos[@]}"; do
        echo -e "\nDescargando ${archivos[$i]}..."
        for ((p=0; p<=tamanos[i]; p++)); do
            draw_progress_bar "$p" "${tamanos[i]}"
            sleep 0.03
        done
        ((total_general += tamanos[i]))
        printf "\n"
    done

    echo -e "\nProgreso general:"
    local pct=$((total_general * 100 / gran_total))
    draw_progress_bar "$pct" 50
    printf "\n\nDescarga completada.\n"
}

main "$@"
