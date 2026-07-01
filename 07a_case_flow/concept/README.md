# 07a Case Flow Control — Templates, `;&`, `;&&`, and Validation

## Quick Start

```bash
bash 07a_case_flow/concept/01_templates.sh
bash 07a_case_flow/concept/02_case_flowing.sh
bash 07a_case_flow/concept/03_case_flowing_ext.sh
bash 07a_case_flow/concept/04_case_flowing_validate.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_templates.sh` | Robust script boilerplate | `set -euo pipefail`, logging levels, `cleanup` trap, `mktemp`, `main()` guard |
| `02_case_flowing.sh` | Case flow control: `;&` and `;&&` | `;&` (fallthrough), `;&&` (test next), `;;` (stop) |
| `03_case_flowing_ext.sh` | Case flow control extended | Chaining fallthrough then test-next on a single input |
| `04_case_flowing_validate.sh` | Multi-condition validation with `case` | `;&&` to set multiple boolean flags from one input |

## Common Patterns

```bash
# Case flow control — cascade through matching patterns
case "$input" in
    *[0-9]*) has_numbers=true ;;&
    *[a-zA-Z]*) has_letters=true ;;
esac

# Logging levels
readonly LOG_ERROR=0 LOG_WARN=1 LOG_INFO=2 LOG_DEBUG=3
log() {
    local level="$1"; shift
    [[ $level -eq $LOG_DEBUG && "${DEBUG:-}" != "1" ]] && return
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >&2
}

# Strict mode boilerplate
set -euo pipefail
IFS=$'\n\t'
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `02_case_flowing.sh`

Tomá el script `02_case_flowing.sh` y modificálo para que:

1. En lugar de analizar "iced_latte", analizá el primer argumento del script (`$1`).
2. Agregá más categorías: si contiene "sugar", "milk", "espresso", "decaf" — cada una debe aplicar `;&` o `;&&` apropiadamente para que una bebida como "decaf_soy_latte" active todos los flags correspondientes.
3. Al final, mostrá un resumen: "Es: caliente/frío, Con leche: sí/no, Cafeína: sí/no".

💡 Pista: usá `;&` para propiedades que siempre aplican (como "es una bebida") y `;&&` para seguir evaluando más patrones. Por ejemplo: `*decaf*) decaf=true ;;&` y `*milk*) milk=true ;;&`. Al final, un `echo` condicional muestra el resumen según los flags.

---

#### Desafío 2A — Basado en `01_templates.sh`

Tomá el script `01_templates.sh` y modificálo para que:

1. Agregá un nivel de log `LOG_TRACE=4` que solo se muestre si `TRACE=1` está seteado.
2. Agregá una función `die()` que muestre un mensaje de error con `log` y salga con código 1.
3. Usá `die` en el cleanup trap si el script falla (exit code != 0).

💡 Pista: copiá la estructura de `log()` y agregá `LOG_TRACE=4`. En la función `die()`: `die() { local msg="$1"; log $LOG_ERROR "$msg"; exit 1; }`. En el trap, chequeá `$?` y llamá a `die` si es != 0.
