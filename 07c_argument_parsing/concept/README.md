# 07c Argument Parsing — getopts, Long Options, and Config Parsers

## Quick Start

```bash
bash 07c_argument_parsing/concept/01_getopts_long.sh
bash 07c_argument_parsing/concept/02_regex_ini_parser.sh
bash 07c_argument_parsing/concept/03_getopts_standard.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_getopts_long.sh` | Long option parsing with `getopts` | `getopts \":-:...\"`, nested `case` for `--option`, `--option=value` |
| `02_regex_ini_parser.sh` | INI/config file parser | `=~` regex validation, whitespace trimming, associative array storage |
| `03_getopts_standard.sh` | Standard `getopts` argument parsing | `getopts \":vf:n:h\"`, `OPTARG`, `OPTIND`, silent error handling |

## Common Patterns

```bash
# Long option parsing with getopts
while getopts ":-:adho:vV" VAL; do
    case $VAL in
        -) case "$OPTARG" in
               verbose) VERBOSE=true ;;
               outfile=*) OFILE="${OPTARG#*=}" ;;
           esac ;;
    esac
done

# Standard getopts
while getopts ":vf:n:h" opt; do
    case $opt in
        v) VERBOSE=true ;;
        f) FILE="$OPTARG" ;;
        n) COUNT="$OPTARG" ;;
        h) usage; exit 0 ;;
        \?) echo "Unknown: -$OPTARG" >&2 ;;
    esac
done
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `03_getopts_standard.sh`

Tomá el script `03_getopts_standard.sh` y modificálo para que:

1. Agregá una opción `-o` que reciba un directorio de salida (`-o DIR`) y cree el directorio si no existe (`mkdir -p`).
2. Agregá una opción `-q` que active modo silencioso (suprima los mensajes de "Processing...").
3. Validá que si se pasa `-o`, el directorio sea escribible (`[[ -w "$dir" ]]`).

💡 Pista: modificá el optstring de la línea 52 de `:vf:n:h` a `:vf:n:o:qh`. Agregá `o)` y `q)` en el case. Para `o)`: `output_dir="$OPTARG"; mkdir -p "$output_dir"`. Para `q)`: `quiet=true`. Al final, usá `if [[ "$quiet" != true ]]; then echo "..."; fi`.
