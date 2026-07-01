#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 02_associative_arrays.sh — declare -A, set/get, iterate, delete
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

main() {
    # ── Declaring an Associative Array ────────────────────────
    # Must use declare -A (or local -A) before using
    local -A config

    # ── Setting and Getting Values ────────────────────────────
    config["host"]="localhost"
    config["port"]="8080"
    config["user"]="admin"

    echo "Host: ${config[host]}"
    echo "Port: ${config[port]}"

    # ── Iterating Keys ────────────────────────────────────────
    echo "All keys: ${!config[*]}"

    # ── Checking Existence ───────────────────────────────────
    if [[ -v config["host"] ]]; then
        echo "Key 'host' exists"
    fi

    # ── Deleting a Key ────────────────────────────────────────
    unset 'config["user"]'
    echo "After unset user, keys: ${!config[*]}"
}
main "$@"
