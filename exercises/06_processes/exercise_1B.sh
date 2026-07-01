#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B.sh — Basado en 03_background_jobs.sh, 04_wait.sh,
#                  05_trap_basics.sh, 06_mktemp.sh
# ──────────────────────────────────────────────────────────────
# Objetivo: Crear directorio temporal con mktemp, lanzar 3
# procesos en background que escriban archivos, esperar con wait,
# y limpiar con trap en EXIT.
# ──────────────────────────────────────────────────────────────

TMPDIR=""

# TODO: Crear función cleanup() que elimine TMPDIR si existe
# Usar rm -rf

# TODO: Registrar trap cleanup EXIT

main() {
    # TODO: Crear directorio temporal con mktemp -d
    # TMPDIR=$(mktemp -d)

    # TODO: Declarar array pids=() para capturar PIDs

    # TODO: Lanzar 3 procesos en background
    # Cada uno: (sleep $((RANDOM % 5)); echo "dato" > "$TMPDIR/archivo_$i.txt") &
    # Capturar PID con pids+=($!)

    # TODO: Esperar a que todos terminen
    # for pid in "${pids[@]}"; do wait "$pid"; done

    # TODO: Listar archivos creados en TMPDIR
    echo "Archivos creados:"
    ls -la "$TMPDIR"
}

main "$@"
