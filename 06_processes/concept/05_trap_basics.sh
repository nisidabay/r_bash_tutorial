#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_trap_basics.sh — trap for cleanup, signals, EXIT
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Cleanup function ──────────────────────────────────────────
# Registered with trap — runs on EXIT (normal exit, error, signal)
cleanup() {
    local exit_code=$?
    echo "Cleanup: removing temp files (exit code: $exit_code)"
    rm -f /tmp/trap_demo_*
}

main() {
    # ── Register trap on EXIT ───────────────────────────────
    trap cleanup EXIT

    # ── Create temp files to clean up ───────────────────────
    touch /tmp/trap_demo_1 /tmp/trap_demo_2
    echo "Created temp files"

    # ── Trap specific signals ──────────────────────────────
    trap 'echo "Caught SIGINT (Ctrl+C)"' SIGINT
    trap 'echo "Caught SIGTERM"' SIGTERM

    # ── List all traps ──────────────────────────────────────
    echo "Active traps:"
    trap -p

    # ── Simulate work ──────────────────────────────────────
    echo "Running... (press Ctrl+C to test SIGINT trap)"
    sleep 1
    echo "Done — cleanup will run automatically on EXIT"
}
main "$@"
