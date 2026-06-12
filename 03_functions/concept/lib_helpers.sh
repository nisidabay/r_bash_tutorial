#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# lib_helpers.sh — Shared library for sourcing demo
# ──────────────────────────────────────────────────────────────
# This file is meant to be SOURCED, not executed directly.
# It defines reusable functions that other scripts can import.
# No set -euo pipefail here — it inherits the caller's settings.

# Determine script directory for relative path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Utility functions ────────────────────────────────────────
log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

bold() {
    echo -e "\033[1m$1\033[0m"
}

# ── Version info ─────────────────────────────────────────────
LIB_VERSION="1.0.0"
LIB_NAME="helpers"

# Only run if executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    echo "This is a library — source it, don't execute it!" >&2
    echo "  Usage: source ${BASH_SOURCE[0]}" >&2
    exit 1
fi