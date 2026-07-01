#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1A.sh — Basado en 02_printf_progress.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Simular descarga de 5 archivos con barra de progreso
# individual y barra de progreso general.
# ──────────────────────────────────────────────────────────────

# TODO: Copiar la función draw_progress_bar() de 02_printf_progress.sh
# (usa \r, printf y tr para dibujar la barra)

main() {
    # TODO: Definir arrays de archivos y tamaños
    # archivos=(doc1.zip doc2.zip doc3.zip doc4.zip doc5.zip)
    # tamanos=(40 75 20 90 55)

    # TODO: Loop anidado para cada archivo
    # for i in "${!archivos[@]}"; do
    #     for ((p=0; p<=tamanos[i]; p++)); do
    #         draw_progress_bar "$p" "${tamanos[i]}"
    #         sleep 0.05
    #     done
    # done

    # TODO: Mostrar barra general con total acumulado
    printf "\n"
    echo "Descarga completada."
}

main "$@"
