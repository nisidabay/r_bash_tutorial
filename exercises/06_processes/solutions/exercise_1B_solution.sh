#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# exercise_1B_solution.sh — Solución: Background jobs con trap
# ──────────────────────────────────────────────────────────────

TMPDIR=""

cleanup() {
    if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then
        rm -rf "$TMPDIR"
        echo "Limpiado: $TMPDIR"
    fi
}
trap cleanup EXIT

main() {
    TMPDIR=$(mktemp -d)
    echo "Directorio temporal: $TMPDIR"

    local -a pids=()
    local i

    for i in {1..3}; do
        (
            sleep $((RANDOM % 5))
            echo "dato_del_job_$i" > "$TMPDIR/archivo_$i.txt"
            echo "Job $i terminado"
        ) &
        pids+=($!)
    done

    echo "Esperando que terminen ${#pids[@]} jobs..."
    for pid in "${pids[@]}"; do
        wait "$pid"
    done

    echo "Todos los jobs completados."
    echo "Archivos creados:"
    ls -la "$TMPDIR"
}

main "$@"
