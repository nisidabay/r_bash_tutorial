#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_parameter_expansion.sh — Defaults, length, trim, replace
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    local name="hello world"
    local unset_var=""

    # ── Default Values ────────────────────────────────────────
    # ${var:-default} — use default if var is unset OR empty
    echo ":- default:  ${unset_var:-"fallback"}"
    # ${var:=default} — assign default if var is unset OR empty
    echo ":= assign:   ${unset_var:="assigned"}"
    # ${var:?error}   — error out if var is unset OR empty
    # ${var:+alt}     — use alt if var is set AND non-empty
    echo ":+ alternate: ${name:+"name is set"}"

    # ── Length ────────────────────────────────────────────────
    echo "Length: ${#name}"

    # ── Trimming ──────────────────────────────────────────────
    local path="/home/user/docs/file.txt"
    echo "Trim prefix (#):  ${path#/*/}"    # shortest prefix match
    echo "Trim prefix (##): ${path##/*/}"   # longest prefix match
    echo "Trim suffix (%):  ${path%.*}"     # shortest suffix match
    echo "Trim suffix (%%): ${path%%.*}"    # longest suffix match

    # ── Replace ───────────────────────────────────────────────
    local msg="the cat and the dog"
    echo "Replace first:  ${msg/the/THE}"
    echo "Replace all:    ${msg//the/THE}"

    # ── Case Modification ────────────────────────────────────
    local mixed="Hello World"
    echo "Uppercase: ${mixed^^}"
    echo "Lowercase: ${mixed,,}"
}
main "$@"
