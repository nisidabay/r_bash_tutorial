#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────
# 05_case_basic.sh — case/esac pattern matching
# ──────────────────────────────────────────────────────────────
set -euo pipefail
IFS=$'\n\t'

# ── Basic case/esac ──────────────────────────────────────────
# case VALUE in PATTERN) COMMANDS ;; esac
# ;; terminates each clause (like break in C switch)

weather="sunny"

case "$weather" in
    sunny)
        echo "Wear sunglasses!"
        ;;
    rainy)
        echo "Take an umbrella!"
        ;;
    snowy)
        echo "Wear boots!"
        ;;
    *)
        echo "Check the forecast!"   # Default/wildcard
        ;;
esac

# ── Matching multiple patterns ───────────────────────────────
# Use | to match multiple values in one clause
echo ""
fruit="apple"

case "$fruit" in
    apple|pear|peach)
        echo "$fruit is a pome or stone fruit"
        ;;
    banana|mango)
        echo "$fruit is a tropical fruit"
        ;;
    *)
        echo "Unknown fruit: $fruit"
        ;;
esac

# ── Patterns with wildcards ──────────────────────────────────
# case patterns are glob patterns — *, ?, [abc]
echo ""
filename="script.sh"

case "$filename" in
    *.sh)
        echo "Bash script detected"
        ;;
    *.py)
        echo "Python script detected"
        ;;
    *.md|*.txt)
        echo "Documentation file"
        ;;
    *)
        echo "Unknown file type: $filename"
        ;;
esac

# ── Parsing command-line arguments ───────────────────────────
# case is ideal for CLI argument parsing
echo ""
handle_flag() {
    local arg="$1"
    case "$arg" in
        -h|--help)
            echo "Usage: $0 [-v|--verbose] [-n|--dry-run]"
            ;;
        -v|--verbose)
            echo "Verbose mode enabled"
            ;;
        -n|--dry-run)
            echo "Dry run mode enabled"
            ;;
        --*)
            echo "Unknown long option: $arg"
            ;;
        -*)
            echo "Unknown short option: $arg"
            ;;
        *)
            echo "Positional argument: $arg"
            ;;
    esac
}

handle_flag "--help"
handle_flag "-v"
handle_flag "readme.txt"