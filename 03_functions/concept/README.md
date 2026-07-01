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

## Basado en lo aprendido hasta ahora, creá un script que...

---

#### Desafío 1B — Basado en lo aprendido de `05_main_pattern.sh` y `06_source_include.sh`

Basado en lo que viste en `05_main_pattern.sh` y `06_source_include.sh`, creá un script que:

1. Creá una library `lib_validacion.sh` con funciones: `es_numero()` (return 0 si es dígito), `es_email()` (return 0 si contiene @), `no_vacio()` (return 0 si no está vacío).
2. Cada función debe usar `local` para sus variables y devolver códigos de retorno (0/1).
3. Creá un script principal `validador.sh` que sourcee la library, tenga un `main()` con el patrón BASH_SOURCE guard, y valide argumentos recibidos por línea de comandos reportando cuáles pasaron cada validación.

💡 Pista: copiá `lib_helpers.sh` como base para `lib_validacion.sh` — usá el mismo `SCRIPT_DIR` y `BASH_SOURCE` guard. Para `es_numero`, usá `[[ "$1" -eq "$1" ]] 2>/dev/null` (si no es número, la aritmética falla y devuelve != 0). En `validador.sh`, copiá `05_main_pattern.sh` como esqueleto y llamá a las funciones de la library.

---

#### Desafío 2A — Basado en `04_local_vars.sh`

Tomá el script `04_local_vars.sh` y modificálo para que:

1. Agregá una función `acumular()` que reciba un número, lo sume a una variable `total` del caller (usando `local -n ref` si el script lo usa, o simplemente devolviendo el valor).
2. Agregá otra función `validar_y_procesar()` que llame a `acumular()` y después muestre el total actual.
3. Asegurate de que una variable global `contador` definida fuera de las funciones NO sea modificada accidentalmente por error de scope.

💡 Pista: si el script usa `local -n ref`, agregá `acumular() { local -n ref="$1"; ((ref += $2)); }`. Llamala con `acumular total 5`. Probá definir `total=0` en `main()` y después `acumular total 10` para verificar que funciona.