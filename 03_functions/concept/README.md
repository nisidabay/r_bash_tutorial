# 03 Functions — Definition, Arguments, Scope, and Libraries

## Quick Start

```bash
bash 03_functions/concept/01_define_call.sh
bash 03_functions/concept/02_arguments.sh
bash 03_functions/concept/03_return_codes.sh
bash 03_functions/concept/04_local_vars.sh
bash 03_functions/concept/05_main_pattern.sh
bash 03_functions/concept/06_source_include.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_define_call.sh` | Function definition and calling | `name() { ... }`, `function name() { ... }`, call by name |
| `02_arguments.sh` | Function arguments | `$1`, `$2`, `$@`, `$#`, `shift`, `${1:-default}` |
| `03_return_codes.sh` | Return codes from functions | `return 0`/`return 1`, `$?`, `if func; then` pattern |
| `04_local_vars.sh` | Variable scope and `local` | `local var`, `local -n ref` (nameref), scope isolation |
| `05_main_pattern.sh` | Entry point with `main "$@"` | `main "$@"`, `BASH_SOURCE` guard, source vs execute |
| `06_source_include.sh` | Sourcing library files | `source file.sh`, `SCRIPT_DIR`, library pattern |

## Common Patterns

```bash
# Standard function with local variables
process_file() {
    local file="$1"
    local count
    count=$(wc -l < "$file")
    echo "$file: $count lines"
}

# Function with return code
is_valid() {
    [[ -n "$1" ]] && [[ -f "$1" ]]
}

# main() entry point pattern
main() {
    local name="${1:-World}"
    echo "Hello, $name!"
}
main "$@"

# Source guard for libraries
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi

# SCRIPT_DIR for relative path resolution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib_helpers.sh"
```

## Now Build Your Own

Write a small utility library (`lib_math.sh`) with functions like `add`, `multiply`, `is_even`, and `factorial`. Then write a main script that sources it and uses its functions. Use `local` variables, return codes, and the `main "$@"` pattern.