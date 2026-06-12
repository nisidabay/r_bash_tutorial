#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 04_wait.sh — wait for children, parallel execution pattern
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Parallel execution pattern ───────────────────────────
    # Launch N jobs, then wait for all to complete
    echo "Starting parallel jobs..."

    sleep 2 &
    local pid1=$!

    sleep 1 &
    local pid2=$!

    # ── wait for a specific PID ─────────────────────────────
    echo "Waiting for job $pid2 (1s)..."
    wait "$pid2"
    echo "Job $pid2 finished"

    # ── wait for all remaining children ─────────────────────
    echo "Waiting for remaining jobs..."
    wait
    echo "All jobs complete"

    # ── wait -n (wait for ANY job to finish) ───────────────
    sleep 2 &
    sleep 3 &
    echo "wait -n: waiting for any job..."
    wait -n
    echo "At least one job finished"
    wait   # wait for the rest
}
main "$@"
