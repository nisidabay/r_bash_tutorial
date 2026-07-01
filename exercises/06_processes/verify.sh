#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 06 (Processes)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local expected="$3"

    if [[ -f "$script" ]]; then
        output=$(bash "$script" 2>&1) || true
        if echo "$output" | grep -q "$expected"; then
            echo "PASS: $name"
        else
            echo "FAIL: $name — Expected pattern '$expected' not found"
            echo "       Output: $output"
            ((failures++))
        fi
    else
        echo "FAIL: $name — Script '$script' not found"
        ((failures++))
    fi
}

run_test "exercise_1B (background+trap)" \
    "exercises/06_processes/exercise_1B.sh" \
    "archivo"

run_test "exercise_2A (command_sub)" \
    "exercises/06_processes/exercise_2A.sh" \
    "Reporte"

exit "$failures"
