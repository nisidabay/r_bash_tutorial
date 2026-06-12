#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_mktemp.sh — mktemp for temp files/dirs, cleanup pattern
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Cleanup on EXIT ──────────────────────────────────────────
# Using a global var so the trap can reference it
TMPDIR=""
cleanup() {
    if [[ -n "$TMPDIR" && -d "$TMPDIR" ]]; then
        rm -rf "$TMPDIR"
        echo "Cleaned up: $TMPDIR"
    fi
}
trap cleanup EXIT

main() {
    # ── mktemp: secure temp file ────────────────────────────
    # Creates a unique file in /tmp — no name collisions
    local tmpfile
    tmpfile=$(mktemp)
    echo "Temp file: $tmpfile"
    echo "data" > "$tmpfile"

    # ── mktemp -d: secure temp directory ────────────────────
    TMPDIR=$(mktemp -d)
    echo "Temp dir: $TMPDIR"

    # ── mktemp with template ───────────────────────────────
    local named
    named=$(mktemp -t myapp_XXXXX)
    echo "Named temp: $named"
    rm -f "$named"

    # ── Cleanup pattern ────────────────────────────────────
    # The EXIT trap handles cleanup automatically
    echo "Temp dir contents:"
    touch "$TMPDIR/test.txt"
    ls -la "$TMPDIR"
}
main "$@"
