#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 06_here_docs.sh — Here-documents and here-strings
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    local name="World"

    # ── Basic Here-Document ───────────────────────────────────
    # <<EOF ... EOF — variables ARE expanded inside
    cat <<EOF
Hello $name
This is a here-document.
EOF

    # ── Quoted Delimiter (no expansion) ────────────────────────
    # <<'EOF' — single quotes prevent variable expansion
    cat <<'EOF'
Literal text: $name is not expanded
EOF

    # ── Stripping Leading Tabs ────────────────────────────────
    # <<-EOF allows indentation with tabs (not spaces)
    if true; then
        cat <<-EOF
	Indented here-doc with tabs
	Second line
EOF
    fi

    # ── Here-String ──────────────────────────────────────────
    # <<<"string" — feeds a single string as stdin
    read -r first second <<< "alpha beta"
    echo "Here-string: first=$first, second=$second"
}
main "$@"
