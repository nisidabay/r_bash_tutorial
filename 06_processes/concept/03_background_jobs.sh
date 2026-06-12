#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 03_background_jobs.sh — &, jobs, fg, bg, disown, nohup, $!
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Background with & ────────────────────────────────────
    # & runs the command in the background (non-blocking)
    sleep 2 &
    local pid=$!   # $! captures PID of last background job
    echo "Background job PID: $pid"

    # ── jobs: list background jobs ──────────────────────────
    sleep 1 &
    echo "Active jobs:"
    jobs

    # ── fg: bring to foreground ─────────────────────────────
    # fg %1 brings job 1 to the foreground
    # (interactive only — skipped in script)
    echo "Use 'fg %1' interactively to foreground a job"

    # ── disown: remove from job table ───────────────────────
    # disown removes a job so it won't get SIGHUP on shell exit
    sleep 1 &
    disown
    echo "Job disowned — won't be killed on shell exit"

    # ── Wait for background job ─────────────────────────────
    wait "$pid"
    echo "Background job $pid finished"
}
main "$@"
