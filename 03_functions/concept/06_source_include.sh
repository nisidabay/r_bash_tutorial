#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_source_include.sh — sourcing and including library files
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── SCRIPT_DIR for relative paths ────────────────────────────
# Determine where THIS script lives (resolves symlinks too)
# This lets us find sibling files regardless of where we run from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Script directory: $SCRIPT_DIR"

# ── Sourcing with source ────────────────────────────────────
# source FILE or . FILE reads and executes the file in the current shell
# This makes all functions/variables from the sourced file available
echo ""
echo "Sourcing lib_helpers.sh..."
# shellcheck disable=SC1091  # intentional: sourced file not provided as shellcheck input
source "${SCRIPT_DIR}/lib_helpers.sh"

# Now we can use functions defined in the library
log_info "Script started"
log_info "Using library: $LIB_NAME v$LIB_VERSION"

# ── Alternative: . (dot) syntax ──────────────────────────────
# . is a synonym for source (POSIX-compatible)
echo ""
echo "Using dot-syntax (. file):"
# shellcheck disable=SC1091  # intentional: sourced file not provided as shellcheck input
. "${SCRIPT_DIR}/lib_helpers.sh"
log_info "This also works!"

# ── Functions from sourced file ──────────────────────────────
echo ""
bold "This text is bold thanks to the library!"

# ── When to source vs execute ────────────────────────────────
echo ""
echo "=== Source vs Execute ==="
echo "source FILE  → runs in CURRENT shell (shares variables/functions)"
echo "bash FILE    → runs in a SUB-SHELL (no sharing)"
echo ""
echo "Source when you want:"
echo "  - Reusable libraries (config, helpers)"
echo "  - Virtual environment activation"
echo "  - Modifying the current shell (cd, export)"
echo ""
echo "Execute when you want:"
echo "  - Standalone scripts (result via stdout/exit code)"
echo "  - Isolation from the current environment"