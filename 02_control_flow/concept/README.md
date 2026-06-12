# 02 Control Flow — Conditionals and Loops

## Quick Start

```bash
bash 02_control_flow/concept/01_if_test.sh
bash 02_control_flow/concept/02_elif_else.sh
bash 02_control_flow/concept/03_for_loop.sh
bash 02_control_flow/concept/04_while_until.sh
bash 02_control_flow/concept/05_case_basic.sh
bash 02_control_flow/concept/06_break_continue.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_if_test.sh` | `if`/`then`/`fi`, `test`, `[[ ]]`, `(( ))` | `[[ -f "$file" ]]`, `(( age > 18 ))`, string/numeric/file tests |
| `02_elif_else.sh` | Multi-branch conditions | `if ... elif ... else ... fi`, `&&`/`\|\|` combinators |
| `03_for_loop.sh` | All for loop flavors | `for i in {1..5}`, `for file in *.sh`, C-style `for ((i=0; i<5; i++))` |
| `04_while_until.sh` | While and until loops | `while read -r line`, `until (( x > n ))`, `while true` with break |
| `05_case_basic.sh` | Pattern matching with case | `case "$var" in pattern) cmd ;; esac`, wildcards, CLI parsing |
| `06_break_continue.sh` | Loop control | `break`, `break N`, `continue`, `continue N` |

## Common Patterns

```bash
# String test with [[ ]]
if [[ -z "$var" ]]; then echo "empty"; fi

# Numeric test with (( ))
if (( count > 10 && count < 100 )); then ...

# Safe file loop
for file in *.txt; do
    [[ -f "$file" ]] || continue
    echo "Processing: $file"
done

# Read lines from a file
while IFS= read -r line; do
    echo "$line"
done < input.txt

# CLI argument parsing with case
case "$1" in
    -h|--help) show_help; exit 0 ;;
    -v|--verbose) verbose=true; shift ;;
    *) echo "Unknown: $1"; exit 1 ;;
esac

# Nested loop exit
for outer in a b c; do
    for inner in 1 2 3; do
        [[ "$outer" == "b" ]] && break 2
    done
done
```

## Now Build Your Own

Write a script that iterates over all `.sh` files in a directory, checks if each is readable and executable, and prints a report. Use a `for` loop with file tests, an `if`/`elif` chain for the status message, and `break`/`continue` to skip non-files.