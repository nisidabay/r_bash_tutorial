#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 04_shebang_strict.sh — Shebang options and strict mode
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Shebang comparison ───────────────────────────────────────
# #!/usr/bin/env bash finds bash via PATH (portable across systems)
# #!/bin/bash is hard-coded (faster but may not exist everywhere)
# #!/usr/bin/env bash is preferred in scripts meant for distribution

echo "This script runs under: $(which bash)"

# ── set -e (exit on error) ───────────────────────────────────
# Without set -e, Bash continues even after a command fails
# With set -e, the script exits immediately on any non-zero exit code
echo ""
echo "Demonstrating set -e behavior (already active):"
echo "  If any command fails below this line, the script would exit."
echo "  (But we use || true to safely demonstrate.)"

# set -e is NOT triggered inside if/while/until conditions, &&/|| chains,
# or commands followed by || true

# ── set -u (error on unset variables) ────────────────────────
# Without -u: unset variables expand to empty string (silent bug)
# With -u: accessing ${undefined_var} exits the script
echo ""
echo "set -u is active — unset variables cause errors:"
echo "  Use \${var:-default} for safe defaults: ${UNDEFINED:-fallback}"

# ── set -o pipefail ──────────────────────────────────────────
# Without pipefail: pipeline exit code = last command only
# With pipefail: pipeline exit code = rightmost non-zero, or 0 if all pass
echo ""
echo "pipefail means: if 'false | echo hi' runs, exit code = 1 (false)"
set +e   # temporarily disable set -e to demonstrate pipefail
false | echo "  This echo succeeds, but false makes the pipeline fail"
pipeline_exit=$?
set -e   # re-enable
echo "  Exit code of pipeline: $pipeline_exit"

# ── set -E (trap inheritance) ────────────────────────────────
# -E makes ERR traps inherited by shell functions and subshells
# Useful when using trap ... ERR for debugging
echo ""
echo "Common strict mode combo: set -euo pipefail"
echo "Also consider: set -E for ERR trap inheritance"
echo "And: IFS=\$'\n\t'  to prevent word splitting on spaces"