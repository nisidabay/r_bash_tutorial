# 07 Advanced Bash — Namerefs, Case Flow Control, Getopts, and Templates

## Quick Start

```bash
bash 07_advanced_bash/concept/01_templates.sh
bash 07_advanced_bash/concept/02_case_flowing.sh
bash 07_advanced_bash/concept/05_nameref_increment.sh
bash 07_advanced_bash/concept/06_getopts_long.sh
bash 07_advanced_bash/concept/09_regex_ini_parser.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_templates.sh` | Robust script boilerplate | `set -euo pipefail`, logging levels, `cleanup` trap, `mktemp`, `main()` guard |
| `02_case_flowing.sh` | Case flow control: `;&` and `;&&` | `;&` (fallthrough), `;&&` (test next), `;;` (stop) |
| `03_case_flowing_ext.sh` | Case flow control extended | Chaining fallthrough then test-next on a single input |
| `04_case_flowing_validate.sh` | Multi-condition validation with `case` | `;&&` to set multiple boolean flags from one input |
| `05_nameref_increment.sh` | Nameref variables (`local -n`) | Pass-by-reference: increment, recursion, counters, progress tracking |
| `06_getopts_long.sh` | Long option parsing with `getopts` | `getopts ":-:..."`, nested `case` for `--option`, `--option=value` |
| `07_nameref_arrays.sh` | Array manipulation with namerefs | Pass arrays by reference, remove element, swap arrays |
| `08_nameref_compare.sh` | Array comparison with namerefs | `compare_contents_sorted`, `compare_exact_order`, sort-and-compare |
| `09_regex_ini_parser.sh` | INI/config file parser | `=~` regex validation, whitespace trimming, associative array storage |
| `10_store_input_array.sh` | Stdin-to-associative-array | Read pipe input into `declare -A`, key/value split by first space |
| `11_getopts_standard.sh` | Standard `getopts` argument parsing | `getopts ":vf:n:h"`, `OPTARG`, `OPTIND`, silent error handling |

## Common Patterns

```bash
# Nameref — modify a variable in the caller's scope
increment() {
    local -n ref="$1"
    ((ref++))
}
count=0
increment count  # count is now 1

# Case flow control — cascade through matching patterns
case "$input" in
    *[0-9]*) has_numbers=true ;;&
    *[a-zA-Z]*) has_letters=true ;;
esac

# Long option parsing with getopts
while getopts ":-:adho:vV" VAL; do
    case $VAL in
        -) case "$OPTARG" in
               verbose) VERBOSE=true ;;
               outfile=*) OFILE="${OPTARG#*=}" ;;
           esac ;;
    esac
done

# Logging levels
readonly LOG_ERROR=0 LOG_WARN=1 LOG_INFO=2 LOG_DEBUG=3
log() {
    local level="$1"; shift
    [[ $level -eq $LOG_DEBUG && "${DEBUG:-}" != "1" ]] && return
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >&2
}

# Associative array from config file
declare -A config
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# || -z "$line" ]] && continue
    [[ "$line" =~ ^[^=]+=.*$ ]] || continue
    key="${line%%=*}"; value="${line#*=}"
    config["$key"]="$value"
done <"$config_file"
```

## Now Build Your Own

Write a script that accepts `--count N` and `--name NAME` as long options, sets default values with a config file parser, logs progress with timestamps, and uses a nameref to track how many items were processed. Use `01_templates.sh` as your starting boilerplate.