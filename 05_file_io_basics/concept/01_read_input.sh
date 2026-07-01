#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 01_read_input.sh — read command: prompt, raw, array, silent
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Basic read with prompt ────────────────────────────────
    # shellcheck disable=SC2162  # intentional: first example doesn't use -r for simplicity
    read -p "Enter your name: " name
    echo "Hello, $name!"

    # ── read -r (raw mode) ───────────────────────────────────
    # -r prevents backslash from escaping characters
    read -r -p "Enter a path (backslashes kept): " path
    echo "Path: $path"

    # ── read -a (into array) ─────────────────────────────────
    # Use IFS=' ' locally so words split on spaces (global IFS is \n\t)
    IFS=' ' read -r -p "Enter three words: " -a words
    echo "Word count: ${#words[@]}, first: ${words[0]}"

    # ── read -t (timeout) ────────────────────────────────────
    if read -r -t 3 -p "Quick! Type something (3s): "; then
        echo "Got it!"
    else
        echo "Timed out."
    fi

    # ── read -s (silent / password) ──────────────────────────
    read -r -s -p "Enter secret: " secret
    echo
    echo "Secret received (${#secret} chars)."
}
main "$@"
