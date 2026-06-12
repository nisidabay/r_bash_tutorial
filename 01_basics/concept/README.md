# 01 Basics — Variables, Quoting, Exit Codes, and Output

## Quick Start

```bash
bash 01_basics/concept/01_hello_variables.sh
bash 01_basics/concept/02_quoting.sh
bash 01_basics/concept/03_exit_codes.sh
bash 01_basics/concept/04_shebang_strict.sh
bash 01_basics/concept/05_echo_printf.sh
bash 01_basics/concept/06_ifs.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_hello_variables.sh` | Variables, assignment, expansion | `name="value"`, `$var`, `${var:-default}` |
| `02_quoting.sh` | Single vs double quotes, escaping | `"$var"` expands, `'$var'` is literal, `$'\n'` escapes |
| `03_exit_codes.sh` | Exit codes, `$?`, `true`/`false` | `$?`, `exit 0`, `&&`/`\|\|` chaining |
| `04_shebang_strict.sh` | Shebang, `set -euo pipefail` | `#!/usr/bin/env bash`, strict mode combo |
| `05_echo_printf.sh` | `echo` vs `printf` formatting | `printf "%s %d %.2f"`, alignment |
| `06_ifs.sh` | IFS and word splitting | `IFS=:`, `IFS=$'\n\t'`, save/restore pattern |

## Common Patterns

```bash
# Safe variable with default
name="${1:-World}"

# Strict mode boilerplate
set -euo pipefail
IFS=$'\n\t'

# Save and restore IFS for parsing
OLD_IFS="$IFS"
IFS=":"
# ... parse fields ...
IFS="$OLD_IFS"

# Format a table
printf "%-20s %5s\n" "Name" "Score"
printf "%-20s %5d\n" "Alice" 95

# Check exit code safely with set -e
set +e
potentially_failing_command
exit_code=$?
set -e
```

## Now Build Your Own

Write a script that asks for the user's name and age, stores them in variables, and prints a formatted introduction. Use `${var:-default}` to handle empty input, `printf` for formatting, and ensure it runs with strict mode enabled.