#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# verify.sh — Verificación de ejercicios del Grupo 09 (System Admin)
# ──────────────────────────────────────────────────────────────

failures=0

run_test() {
    local name="$1"
    local script="$2"
    local input="$3"
    local expected="$4"

    if [[ -f "$script" ]]; then
        if [[ -n "$input" ]]; then
            output=$(echo "$input" | timeout 2 bash "$script" 2>&1 || true)
        else
            output=$(timeout 2 bash "$script" 2>&1 || true)
        fi
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

run_test "exercise_1A (select_menu)" \
    "exercises/09_system_admin/exercise_1A.sh" \
    "4" \
    "Herramientas"

run_test "exercise_2B (nullglob+safe)" \
    "exercises/09_system_admin/exercise_2B.sh" \
    "" \
    "No se encontr"

exit "$failures"
