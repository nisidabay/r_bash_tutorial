# Propuesta: Nuevo Formato de Desafíos "Now Build Your Own"

## Resumen del Cambio

Se reemplaza el formato único de desafío por un sistema de DOS PATRONES:

- **Patrón A — "Basado en este ejemplo, modifica para conseguir X"**: Intra-concepto. El estudiante toma UN script que ya ejecutó y lo modifica.
- **Patrón B — "Basado en lo aprendido hasta ahora, creá un script que..."**: Fin de grupo. Combina conceptos de MÚLTIPLES scripts del grupo.

**Reglas aplicadas a todos los desafíos:**
1. Referencian scripts REALES que existen en `concept/`.
2. Incluyen siempre una 💡 Pista con un punto de partida concreto.
3. Son alcanzables usando SOLO conceptos de ese grupo y grupos anteriores.
4. Están pensados para un autor que YA sabe Bash — son desafíos de repaso/práctica, no tutoriales paso a paso.

---

## Grupo 01 — Basics (Variables, Quoting, Exit Codes, Output)

**Patrón elegido: Patrón A (intra-concepto)**

Razón: El grupo cubre fundamentos independientes (variables, quoting, exit codes, printf, IFS). Cada script es autocontenido. Un solo desafío combinándolos todos sería Patrón B, pero el estudiante recién empieza — mejor anclar cada desafío a un script concreto.

### Desafío actual (viejo formato):
```
Write a script that asks for the user's name and age, stores them in variables,
and prints a formatted introduction. Use ${var:-default} to handle empty input,
printf for formatting, and ensure it runs with strict mode enabled.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `01_hello_variables.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `01_hello_variables.sh` y modificálo para que:

1. En lugar de `name="Carlos"` fijo, pida el nombre al usuario con `read -p` y lo guarde en `name`.
2. Use `${name:-Invitado}` para que si el usuario no ingresa nada, se muestre "Invitado".
3. Al final, declare una variable `fecha` con la fecha actual usando `$(date +%Y-%m-%d)` y la incluya en el mensaje final.

💡 Pista: reemplazá la línea 14 (`name=...`) por `read -p "Tu nombre: " name` y agregá `${name:-Invitado}` en el echo de la línea 20. Para la fecha, agregá una línea como `fecha=$(date +%Y-%m-%d)` y referenciala en el mensaje.
```

---

#### Desafío 2A — Basado en `05_echo_printf.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `05_echo_printf.sh` y modificálo para que:

1. En lugar de la tabla de ejemplo "Name/Score", mostrá una tabla de 3 productos con nombre, precio (formateado con 2 decimales) y cantidad.
2. Usá `printf` con `%.2f` para el precio y `%3d` para la cantidad.
3. Agregá una fila de total al final que sume los precios × cantidades.

💡 Pista: copiá el bloque de la tabla (líneas 38-44) y cambiá las columnas a algo como `"│ %-15s │ %8.2f │ %3d │"`. Creá un total con `total=$(echo "scale=2; ..." | bc)` o usando aritmética de enteros si los precios son sin decimales.
```

---

#### Desafío 3A — Basado en `06_ifs.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `06_ifs.sh` y modificálo para que:

1. En lugar de parsear una cadena fija `path_entry`, pedile al usuario que ingrese una línea con campos separados por coma.
2. Parseá los campos usando `IFS=","` y mostralos numerados.
3. Volvé a unir los campos en una sola cadena con `IFS=" | "` y mostrala.

💡 Pista: reemplazá la línea 38 (`path_entry=...`) por `read -p "Ingresá campos separados por coma: " entrada`. Después del parseo con `IFS=","`, usá `IFS=" | "` y `echo "${colors[*]}"` (pero con tu variable en lugar de `colors`).
```

---

## Grupo 02 — Control Flow (Conditionals and Loops)

**Patrón elegido: Patrón A (intra-concepto)**

Razón: Los 6 scripts cubren aspectos distintos del control de flujo (if, elif, for, while, case, break/continue). Conviene anclar cada desafío a uno de ellos para reforzar cada patrón por separado. El desafío original ya es bastante amplio — mejor dividirlo.

### Desafío actual (viejo formato):
```
Write a script that iterates over all .sh files in a directory, checks if each
is readable and executable, and prints a report. Use a for loop with file tests,
an if/elif chain for the status message, and break/continue to skip non-files.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `01_if_test.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `01_if_test.sh` y modificálo para que:

1. En lugar de tests fijos, pedí al usuario que ingrese un path (archivo o directorio) con `read -p`.
2. Mostrá un reporte que indique: si existe (`-e`), si es archivo (`-f`) o directorio (`-d`), si es legible (`-r`), y si es ejecutable (`-x`).
3. Usá `elif` para que el mensaje cambie según el tipo: "Es un directorio legible" vs "Es un script ejecutable" vs "No existe".

💡 Pista: agregá `read -p "Path a verificar: " path` al inicio del `main()`. Después usá `if [[ -e "$path" ]]; then` con `[[ -f "$path" ]]` y `[[ -d "$path" ]]` dentro. Los tests de `-r` y `-x` van como condiciones adicionales.
```

---

#### Desafío 2A — Basado en `03_for_loop.sh` + `06_break_continue.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `03_for_loop.sh` y modificálo para que:

1. Itere sobre todos los archivos `*.txt` del directorio actual.
2. Saltee los que no sean archivos regulares con `continue`.
3. Si encuentra un archivo de más de 1 KB, muestre su nombre y tamaño, y detenga el proceso con `break` (simulando que "encontró uno grande, no hace falta seguir").

💡 Pista: arrancá con `for file in *.txt; do` y dentro usá `[[ -f "$file" ]] || continue`. Para el tamaño: `size=$(wc -c < "$file")` y `if (( size > 1024 )); then ...; break; fi`. El patrón `continue`/`break` lo viste en `06_break_continue.sh`.
```

---

#### Desafío 3A — Basado en `05_case_basic.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `05_case_basic.sh` y modificálo para que:

1. En lugar del `weather` fijo, tomá el primer argumento del script como entrada (`$1`).
2. Agregá más casos: `cloudy`, `windy`, `foggy`, cada uno con su recomendación.
3. Usá el patrón `*)` como fallback para mostrar el uso del script si no se pasa argumento o si el clima es desconocido.

💡 Pista: cambiá `weather="sunny"` por `local weather="${1:-}"`. Al inicio del `case`, agregá `""|*)` que muestre "Uso: $0 <clima>". Los casos nuevos van antes del `*)`.
```

---

## Grupo 03 — Functions (Definition, Arguments, Scope, Libraries)

**Patrón elegido: Patrón B + Patrón A**

Razón: El grupo tiene scripts que son secuenciales (define_call → arguments → return_codes → local_vars → main_pattern → source_include). Un Patrón B que combine `05_main_pattern.sh` y `06_source_include.sh` captura la esencia del grupo. Un Patrón A sobre `04_local_vars.sh` refuerza el scope.

### Desafío actual (viejo formato):
```
Write a small utility library (lib_math.sh) with functions like add, multiply,
is_even, and factorial. Then write a main script that sources it and uses its
functions. Use local variables, return codes, and the main "$@" pattern.
```

### Nuevos desafíos:

---

#### Desafío 1B — Basado en lo aprendido de `05_main_pattern.sh` y `06_source_include.sh`

```
## Basado en lo aprendido hasta ahora, creá un script que...

Basado en lo que viste en `05_main_pattern.sh` y `06_source_include.sh`, creá un script que:

1. Creá una library `lib_validacion.sh` con funciones: `es_numero()` (return 0 si es dígito), `es_email()` (return 0 si contiene @), `no_vacio()` (return 0 si no está vacío).
2. Cada función debe usar `local` para sus variables y devolver códigos de retorno (0/1).
3. Creá un script principal `validador.sh` que sourcee la library, tenga un `main()` con el patrón BASH_SOURCE guard, y valide argumentos recibidos por línea de comandos reportando cuáles pasaron cada validación.

💡 Pista: copiá `lib_helpers.sh` como base para `lib_validacion.sh` — usá el mismo `SCRIPT_DIR` y `BASH_SOURCE` guard. Para `es_numero`, usá `[[ "$1" -eq "$1" ]] 2>/dev/null` (si no es número, la aritmética falla y devuelve != 0). En `validador.sh`, copiá `05_main_pattern.sh` como esqueleto y llamá a las funciones de la library.
```

---

#### Desafío 2A — Basado en `04_local_vars.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `04_local_vars.sh` y modificálo para que:

1. Agregá una función `acumular()` que reciba un número, lo sume a una variable `total` del caller (usando `local -n ref` si el script lo usa, o simplemente devolviendo el valor).
2. Agregá otra función `validar_y_procesar()` que llame a `acumular()` y después muestre el total actual.
3. Asegurate de que una variable global `contador` definida fuera de las funciones NO sea modificada accidentalmente por error de scope.

💡 Pista: si el script usa `local -n ref`, agregá `acumular() { local -n ref="$1"; ((ref += $2)); }`. Llamala con `acumular total 5`. Probá definir `total=0` en `main()` y después `acumular total 10` para verificar que funciona.
```

---

## Grupo 04 — Arrays & Strings (Indexed, Associative, Iteration, Expansion)

**Patrón elegido: Patrón B (combinación)**

Razón: El grupo se presta naturalmente a combinar arrays (indexados y asociativos) con parameter expansion y mapfile. El desafío original ya es una combinación — el Patrón B es perfecto aquí.

### Desafío actual (viejo formato):
```
Write a script that reads a CSV file into an array with mapfile, then uses
parameter expansion to strip quotes from each field, and prints the result as
a formatted table.
```

### Nuevos desafíos:

---

#### Desafío 1B — Basado en `01_indexed_arrays.sh`, `04_mapfile.sh`, `05_parameter_expansion.sh`, y `06_here_docs.sh`

```
## Basado en lo aprendido hasta ahora, creá un script que...

Basado en lo que viste en `01_indexed_arrays.sh`, `04_mapfile.sh`, y `05_parameter_expansion.sh`, creá un script que:

1. Use un here-doc (como en `06_here_docs.sh`) para definir datos de ejemplo con formato clave=valor, una por línea.
2. Lea esos datos en un array con `mapfile`.
3. Procese cada línea con parameter expansion para separar clave y valor (`${line%%=*}` y `${line#*=}`).
4. Almacene los pares en un array asociativo (`declare -A`) y luego los imprima como una tabla formateada.

💡 Pista: arrancá copiando `04_mapfile.sh` y reemplazá el contenido del tmpfile por un here-doc inline. Usá `mapfile -t lines << 'EOF'...EOF`. Después, para cada línea: `key="${line%%=*}"` y `val="${line#*=}"`. Creá `declare -A config` y asigná `config["$key"]="$val"`.
```

---

#### Desafío 2A — Basado en `02_associative_arrays.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `02_associative_arrays.sh` y modificálo para que:

1. En lugar de las frutas/precios fijos, lea entrada del usuario con `read -p` para agregar productos al carrito (nombre del producto y precio).
2. El usuario puede seguir agregando hasta que escriba "listo".
3. Al final, use `${!map[@]}` para iterar las claves y mostrar el ticket con el total calculado con `(( total += map[$item] ))`.

💡 Pista: reemplazá la declaración fija del array por un loop `while true; do read -p "Producto: " prod; [[ "$prod" == "listo" ]] && break; read -p "Precio: " precio; carrito["$prod"]=$precio; done`. Al final, iterá con `for item in "${!carrito[@]}"; do`.
```

---

## Grupo 05 — File I/O Basics (Read, Write, Redirect, Pipe)

**Patrón elegido: Patrón A + Patrón B**

Razón: El grupo tiene scripts muy variados (read, write, redirect, pipes, here-strings, /dev/stdin). Un Patrón A sobre pipes/PIPESTATUS es concreto. Un Patrón B combinando read + redirect/dev-stdin cubre el caso de uso más realista.

### Desafío actual (viejo formato):
```
Write a script that reads a list of URLs from a file (or stdin), uses curl to
fetch each one, logs both stdout and stderr to separate files with tee, and
reports the exit status of each download.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `04_pipes.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `04_pipes.sh` y modificálo para que:

1. En lugar de los comandos fijos, leé una lista de palabras desde un archivo (usando `mapfile` como viste en el grupo 04).
2. Pasá cada palabra por un pipeline: `echo "$palabra" | rev | tr 'a-z' 'A-Z'` para invertirla y ponerla en mayúsculas.
3. Usá `PIPESTATUS` para verificar que cada etapa del pipeline funcionó, y mostrá un error si alguna falló.

💡 Pista: arrancá con `mapfile -t words < palabras.txt` (creá el archivo primero). Después, para cada word: `result=$(echo "$word" | rev | tr 'a-z' 'A-Z')` y chequeá `echo "${PIPESTATUS[@]}"` después del pipeline. Si algún valor no es 0, reportá el error.
```

---

#### Desafío 2B — Basado en `01_read_input.sh`, `02_write_output.sh`, y `06_dev_stdin.sh`

```
## Basado en lo aprendido hasta ahora, creá un script que...

Basado en lo que viste en `01_read_input.sh` y `06_dev_stdin.sh`, creá un script que:

1. Acepte un archivo como argumento O lea de stdin (patrón `${1:-/dev/stdin}` de `06_dev_stdin.sh`).
2. Use `read -p` para preguntar al usuario un prefijo de línea.
3. Lea cada línea de la entrada y la escriba en un archivo de salida (`salida_$(date +%s).txt`) con el prefijo agregado al inicio, usando `>>` para append.
4. Informe cuántas líneas procesó.

💡 Pista: copiá la estructura de `06_dev_stdin.sh` — usá `local input="${1:-/dev/stdin}"`. Después de leer el prefijo con `read -p "Prefijo: " prefijo`, usá `while IFS= read -r line; do echo "$prefijo$line" >> "$outfile"; done < "$input"`. Contá con un contador `((count++))`.
```

---

## Grupo 06 — Processes (Subshells, Jobs, Signals, Temp Files)

**Patrón elegido: Patrón B (combinación natural)**

Razón: Los scripts de este grupo forman un flujo natural: command sub → subshells → background → wait → trap → mktemp. Un buen desafío los combina casi todos, exactamente como el original. Patrón B es ideal.

### Desafío actual (viejo formato):
```
Write a script that launches 5 background jobs (e.g., sleep with different
durations), captures their PIDs, uses wait -n to report each completion as it
happens, and cleans up any temp files with a trap on EXIT.
```

### Nuevos desafíos:

---

#### Desafío 1B — Basado en `03_background_jobs.sh`, `04_wait.sh`, `05_trap_basics.sh`, y `06_mktemp.sh`

```
## Basado en lo aprendido hasta ahora, creá un script que...

Basado en lo que viste en `03_background_jobs.sh`, `04_wait.sh`, y `06_mktemp.sh`, creá un script que:

1. Cree un directorio temporal con `mktemp -d` (como en `06_mktemp.sh`).
2. Lance 3 procesos en background que escriban un archivo cada uno dentro de ese directorio temporal, cada uno con una demora diferente (simulada con `sleep`).
3. Capture los PIDs con `$!` y espere a que terminen con `wait $pid` (como en `03_background_jobs.sh` y `04_wait.sh`).
4. Use `trap` en EXIT para limpiar el directorio temporal automáticamente.

💡 Pista: copiá el patrón de `06_mktemp.sh` para el `TMPDIR`, `trap cleanup EXIT` y `cleanup()`. Después, para cada job: `(sleep $((RANDOM % 5)); echo "dato" > "$TMPDIR/archivo_$i.txt") &` con `pids+=($!)`. Al final, `for pid in "${pids[@]}"; do wait "$pid"; done`.
```

---

#### Desafío 2A — Basado en `01_command_substitution.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `01_command_substitution.sh` y modificálo para que:

1. En lugar de mostrar solo la fecha y usuarios, mostrá también: cantidad de procesos del sistema (`ps -e | wc -l`), uso de memoria libre (`free -m | awk 'NR==2{print $7}'`), y el hostname en mayúsculas.
2. Cada valor debe capturarse con `$(...)` y almacenarse en variables separadas.
3. Mostrá todo como un reporte formateado con `printf`.

💡 Pista: agregá líneas como `procesos=$(ps -e --no-headers | wc -l)` y `mem_libre=$(free -m | awk 'NR==2{print $7}')`. Después usá `printf` como en `05_echo_printf.sh` para mostrar: "Procesos: %d | Memoria libre: %d MB".
```

---

## Grupo 07 — Advanced Bash (Namerefs, Case Flow, Getopts, Templates)

**Patrón elegido: Patrón A (intra-concepto)**

Razón: Este grupo cubre temas avanzados y muy específicos (namerefs, case flow control, getopts, templates). Cada concepto es lo suficientemente denso como para merecer su propio desafío. El desafío original ya es Patrón A-like.

### Desafío actual (viejo formato):
```
Write a script that accepts --count N and --name NAME as long options, sets
default values with a config file parser, logs progress with timestamps, and
uses a nameref to track how many items were processed. Use 01_templates.sh as
your starting boilerplate.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `11_getopts_standard.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `11_getopts_standard.sh` y modificálo para que:

1. Agregá una opción `-o` que reciba un directorio de salida (`-o DIR`) y cree el directorio si no existe (`mkdir -p`).
2. Agregá una opción `-q` que active modo silencioso (suprima los mensajes de "Processing...").
3. Validá que si se pasa `-o`, el directorio sea escribible (`[[ -w "$dir" ]]`).

💡 Pista: modificá el optstring de la línea 52 de `:vf:n:h` a `:vf:n:o:qh`. Agregá `o)` y `q)` en el case. Para `o)`: `output_dir="$OPTARG"; mkdir -p "$output_dir"`. Para `q)`: `quiet=true`. Al final, usá `if [[ "$quiet" != true ]]; then echo "..."; fi`.
```

---

#### Desafío 2A — Basado en `02_case_flowing.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `02_case_flowing.sh` y modificálo para que:

1. En lugar de analizar "iced_latte", analizá el primer argumento del script (`$1`).
2. Agregá más categorías: si contiene "sugar", "milk", "espresso", "decaf" — cada una debe aplicar `;&` o `;&&` apropiadamente para que una bebida como "decaf_soy_latte" active todos los flags correspondientes.
3. Al final, mostrá un resumen: "Es: caliente/frío, Con leche: sí/no, Cafeína: sí/no".

💡 Pista: usá `;&` para propiedades que siempre aplican (como "es una bebida") y `;&&` para seguir evaluando más patrones. Por ejemplo: `*decaf*) decaf=true ;;&` y `*milk*) milk=true ;;&`. Al final, un `echo` condicional muestra el resumen según los flags.
```

---

#### Desafío 3A — Basado en `05_nameref_increment.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `05_nameref_increment.sh` y modificálo para que:

1. Agregá una función `append_to_array()` que reciba el nombre de un array (como nameref) y un elemento, y agregue ese elemento al array con `arr+=( "$elem" )`.
2. Agregá otra función `array_length()` que reciba un array por nameref y devuelva (en `$?`) 0 si tiene más de 3 elementos, 1 si tiene 3 o menos.
3. En `main()`, usá ambas funciones para agregar elementos a un array hasta que tenga 5 elementos, mostrando la longitud después de cada inserción.

💡 Pista: `append_to_array() { local -n arr="$1"; local elem="$2"; arr+=( "$elem" ); }`. Para `array_length()`, usá `local -n arr="$1"; ((${#arr[@]} > 3))`. Llamalo con `if array_length mi_array; then ...`.
```

---

## Grupo 08 — File Descriptors (Read, Write, Compare, Timeout, Parallel I/O)

**Patrón elegido: Patrón A (intra-concepto)**

Razón: Este grupo tiene 13 scripts cubriendo aspectos muy específicos de file descriptors. Cada uno es denso. Mejor un desafío anclado a un script concreto que un mega-desafío combinado inabarcable.

### Desafío actual (viejo formato):
```
Write a script that reads from two files simultaneously (one per FD), merges
their lines alternatingly, logs progress to a third FD (a log file), and
displays a status message both on screen and in the log. Add a 5-second timeout
for slow input.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `03_fd_compare.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `03_fd_compare.sh` y modificálo para que:

1. En lugar de comparar archivos temporales, tomá dos archivos como argumentos del script (`$1` y `$2`).
2. Si no se pasan dos argumentos, mostrá un mensaje de uso y salí con código 1.
3. Agregá un contador de diferencias: al final, reportá "X líneas diferentes encontradas".

💡 Pista: reemplazá la creación de archivos temporales (líneas 46-58) por `file_1="$1"` y `file_2="$2"`. Agregá `[[ $# -eq 2 ]] || { echo "Uso: ..."; exit 1; }`. En el loop de comparación, agregá `((diff_count++))` cuando las líneas difieran.
```

---

#### Desafío 2A — Basado en `05_fd_logging.sh` y `06_fd_dual_output.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `05_fd_logging.sh` y modificálo para que:

1. En lugar de solo loggear a un archivo por FD, usá el patrón de `06_fd_dual_output.sh` para que los mensajes vayan también a la consola.
2. Agregá un nivel de log: `log_info()`, `log_warn()`, `log_error()` — cada uno con un prefijo diferente (`[INFO]`, `[WARN]`, `[ERROR]`).
3. El `log_error()` debe escribir a stderr además del log y la consola.

💡 Pista: copiá la función `log_message` de `06_fd_dual_output.sh` (línea 45-51) que usa `tee -a /dev/fd/3`. Creá tres wrappers: `log_info() { log_message "[INFO] $*"; }`, `log_warn() { log_message "[WARN] $*"; }`, y `log_error() { log_message "[ERROR] $*" >&2; }`.
```

---

#### Desafío 3A — Basado en `07_fd_timeout.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `07_fd_timeout.sh` y modificálo para que:

1. En lugar de leer de un archivo fijo, leé de un proceso en background que genere una línea cada N segundos (por ejemplo, `(for i in {1..5}; do echo "línea $i"; sleep $((RANDOM % 4 + 1)); done)`).
2. Usá `exec 3< <(...)` con ese proceso como fuente.
3. Si el `read -t` expira (el proceso tarda más de 3 segundos), mostrá un mensaje "Timeout — línea lenta" y continuá con la siguiente.

💡 Pista: reemplazá el `cat` de la línea 43-48 por un proceso en background: `exec 3< <(for i in {1..5}; do echo "línea $i"; sleep $((RANDOM % 4 + 1)); done)`. En el while, usá `if read -r -t 3 line <&3; then echo "Leído: $line"; else echo "Timeout"; fi`.
```

---

## Grupo 09 — System Admin (Desktop Entries, Services, Select Menus, File Safety)

**Patrón elegido: Patrón A + Patrón B**

Razón: El grupo tiene dos grandes categorías: interactividad (select menu, desktop entry) y seguridad de archivos (nullglob, safe update, find null-safe). Un Patrón A para el menú select y un Patrón B que combine nullglob + safe update + find.

### Desafío actual (viejo formato):
```
Write a system maintenance script with an interactive select menu that offers:
checking disk usage, listing large files, and updating packages. Use nullglob to
safely scan ~/Downloads for temp files, and offer to clean them with a diff-style
review before deletion.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `03_select_menu.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `03_select_menu.sh` y modificálo para que:

1. En lugar de las opciones existentes, creá un menú de herramientas de red: "Ping a servidor", "Escaneo de puertos (local)", "Mostrar IP pública", "Traceroute", "Salir".
2. Para "Ping a servidor", pedí al usuario una dirección adicional con `read -p` antes de ejecutar.
3. Agregá una verificación al inicio que compruebe si los comandos necesarios existen (`command -v ping`, etc.), y si falta alguno, mostrá una advertencia pero permití continuar.

💡 Pista: copiá la estructura del `select` loop de `03_select_menu.sh`. Reemplazá `MENU_OPTIONS` con las nuevas opciones. Para el ping: dentro del case, `read -p "Servidor: " server; ping -c 3 "$server"`. Para verificar comandos: `for cmd in ping nc curl traceroute; do command -v "$cmd" &>/dev/null || echo "Falta: $cmd"; done`.
```

---

#### Desafío 2B — Basado en `04_safe_update.sh`, `08_nullglob_safety.sh`, `09_find_null_safe.sh`

```
## Basado en lo aprendido hasta ahora, creá un script que...

Basado en lo que viste en `08_nullglob_safety.sh`, `04_safe_update.sh`, y `09_find_null_safe.sh`, creá un script que:

1. Escanee un directorio dado como argumento buscando archivos `.tmp` de más de 1 MB (usá nullglob o find -print0 de `08_nullglob_safety.sh`/`09_find_null_safe.sh`).
2. Muestre un diff del tamaño actual vs el tamaño que se liberaría (usando el patrón de `04_safe_update.sh`).
3. Pida confirmación antes de eliminar, y si se confirma, elimine los archivos y muestre un resumen.

💡 Pista: arrancá copiando `08_nullglob_safety.sh` como base. Usá `shopt -s nullglob; files=("$dir"/*.tmp); shopt -u nullglob`. Para cada archivo, calculá `size=$(stat -c%s "$file")` y si `(( size > 1048576 ))`, agregalo a `to_delete`. Mostrá los archivos encontrados y preguntá "¿Eliminar estos N archivos? (y/n)".
```

---

## Grupo 10 — Terminal UI (Progress Bars, Animations, fzf, Formatted Output)

**Patrón elegido: Patrón A (intra-concepto)**

Razón: Cada script en este grupo cubre una técnica de UI completamente distinta (progress bar, printf progress, formatted table, matrix rain, spinner, fzf). No se combinan naturalmente. Mejor desafíos independientes.

### Desafío actual (viejo formato):
```
Write a script that monitors a directory for new .log files and displays a
live-updating table of file sizes (formatted with printf), a spinner while
scanning, and a progress bar during batch processing. Use tput for cursor
positioning and \r for in-place updates.
```

### Nuevos desafíos:

---

#### Desafío 1A — Basado en `02_printf_progress.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `02_printf_progress.sh` y modificálo para que:

1. En lugar de un loop fijo de 0 a 100, simulá la descarga de 5 archivos, donde cada archivo tiene un tamaño aleatorio entre 10 y 100 "unidades".
2. Mostrá una barra de progreso para cada archivo individual, y al final una barra de progreso general que sume todos los avances.
3. Usá `sleep 0.2` entre unidades para simular la descarga.

💡 Pista: creá un array `archivos=(doc1.zip doc2.zip doc3.zip doc4.zip doc5.zip)` y un array de tamaños `tamaños=(40 75 20 90 55)`. Usá un loop anidado: `for i in "${!archivos[@]}"; do ... for ((p=0; p<=tamaños[i]; p++)); do draw_progress_bar "$p" "${tamaños[i]}"; sleep 0.05; done; done`. Al final, una barra general con el total acumulado.
```

---

#### Desafío 2A — Basado en `06_mpv_spinner.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `06_mpv_spinner.sh` y modificálo para que:

1. En lugar de esperar a mpv, simulá una tarea de larga duración (por ejemplo, `sleep 8` mientras contás del 1 al 8 en un archivo temporal).
2. El spinner debe cambiar de mensaje en el segundo 4: de "Cargando..." a "Casi listo...".
3. Timeout ajustado a 10 segundos.

💡 Pista: reemplazá `setsid -f mpv ...` por `(for i in {1..8}; do echo "Paso $i"; sleep 1; done) > "$temp_log" 2>&1 &`. En el loop de monitoreo, agregá un contador y si `((timeout_original - timeout > 40))` (pasaron ~4 segundos), mostrá "Casi listo..." en lugar de "Cargando...".
```

---

#### Desafío 3A — Basado en `03_formatted_table.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `03_formatted_table.sh` y modificálo para que:

1. En lugar de una tabla de multiplicar, mostrá una tabla de conversión de pulgadas a centímetros (del 1 al 20).
2. Mostrá el resultado en centímetros enteros (redondeo simple: `cm=$((i * 254 / 100))`).
3. Aceptá un argumento opcional que indique el máximo de la tabla (default 12).

💡 Pista: cambiá el loop anidado por uno simple `for ((i=1; i<=max; i++))`. Calculá `cm=$((i * 254 / 100))`. Usá `printf "│ %-2d pulg │ %3d cm │\n" "$i" "$cm"` para las columnas. La variable `max` la tomás de `${1:-12}`.
```

---

## Grupo 11 — Algorithms & Data (ROT13, Fake Data, Search, Random)

**Patrón elegido: Patrón B (combinación natural)**

Razón: Este grupo cierra el tutorial y sus scripts se combinan maravillosamente — generar datos falsos (02) + almacenarlos en arrays (implícito en 03) + buscar (03) + transformar (01 ROT13). El desafío original ya es una combinación. Patrón B es perfecto.

### Desafío actual (viejo formato):
```
Write a script that generates 20 fake user records (name, age, email), stores
them in an array, then lets the user search by name using linear search. Display
results in a formatted table. Add an option to output the data as fake CSV with
ROT13-encoded email addresses.
```

### Nuevos desafíos:

---

#### Desafío 1B — Basado en `01_rot13.sh`, `02_fake_data.sh`, y `03_linear_search.sh`

```
## Basado en lo aprendido hasta ahora, creá un script que...

Basado en lo que viste en `02_fake_data.sh`, `03_linear_search.sh`, y `01_rot13.sh`, creá un script que:

1. Genere 15 registros de usuarios falsos (nombre, edad, email) usando el patrón de `02_fake_data.sh`.
2. Almacene los registros en un array indexado y también en un array asociativo clave=email.
3. Implementá una función `buscar_por_email()` que use linear search (como en `03_linear_search.sh`) sobre el array indexado para encontrar un usuario por email.
4. Agregá una opción para codificar los emails con ROT13 (usando `tr 'A-Za-z' 'N-ZA-Mn-za-m'` como en `01_rot13.sh`) antes de mostrar.

💡 Pista: arrancá copiando `02_fake_data.sh` y modificá `generate_fake_user()` para que también devuelva email. Usá `mapfile -t usuarios < <(for ...)`. Para la búsqueda, copiá la función `linear_search()` de `03_linear_search.sh` pero comparando el campo email. Para ROT13: `echo "$email" | tr 'A-Za-z' 'N-ZA-Mn-za-m'`.
```

---

#### Desafío 2A — Basado en `04_random_data.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `04_random_data.sh` y modificálo para que:

1. Agregá una función `generar_matricula()` que genere una matrícula estilo "ABC-1234" (3 letras mayúsculas, guión, 4 dígitos).
2. Agregá una función `generar_telefono()` que genere un número tipo "+54 9 11 XXXX-XXXX" con los últimos 8 dígitos aleatorios.
3. Agregá un menú (usando el `select` que ya tiene el script al final) que permita elegir qué tipo de dato generar, y genere 10 ejemplos de una vez.

💡 Pista: para la matrícula: `letras=$(LC_ALL=C tr -dc 'A-Z' </dev/urandom | head -c 3); numeros=$(printf "%04d" $((RANDOM % 10000))); echo "${letras}-${numeros}"`. Para el teléfono: `num=$(printf "%04d" $((RANDOM % 10000))); echo "+54 9 11 1234-${num}"`. Agregá estas funciones al array `functions` del menú (línea 126-137).
```

---

#### Desafío 3A — Basado en `01_rot13.sh`

```
## Basado en este ejemplo, modifica para conseguir...

Tomá el script `01_rot13.sh` y modificálo para que:

1. En lugar de solo ROT13, ofrecé tres modos con `-e` (ROT13 encode), `-d` (ROT13 decode = mismo comando), y `-r` (ROT47 — similar pero para ASCII imprimible: `tr '!-~' 'P-~!-O'`).
2. Agregá validación de que el archivo de entrada no esté vacío (`[[ -s "$input_file" ]]`).
3. Si se pasa `-r` modo ROT47, usá el comando `tr` correspondiente.

💡 Pista: agregá `-r` al case de validación del modo. Definí una variable `tr_cmd` que contenga `'A-Za-z' 'N-ZA-Mn-za-m'` para rot13 y `'!-~' 'P-~!-O'` para rot47. Usá `echo "$tr_cmd"` en la función `perform_rot13` en lugar de los valores fijos. Agregá `[[ -s "$input_file" ]] || { echo "Error: archivo vacío"; exit 1; }` antes de procesar.
```

---

## Resumen de Patrones por Grupo

| Grupo | Patrón Principal | Desafíos Propuestos | Razón |
|---|---|---|---|
| 01 — Basics | A | 3 (hellovars, printf, IFS) | Conceptos independientes, recién empieza |
| 02 — Control Flow | A | 3 (iftest, for+break, case) | Cada script cubre un aspecto distinto |
| 03 — Functions | B + A | 2 (library + local vars) | Flujo secuencial natural, más un refuerzo de scope |
| 04 — Arrays & Strings | B | 2 (mapfile+expansion + assoc) | Combinación natural de scripts |
| 05 — File I/O | A + B | 2 (pipes + dev-stdin) | Pipes específico, dev-stdin combinado con read |
| 06 — Processes | B | 2 (bg+wait+temp + command sub) | Combinación natural de scripts |
| 07 — Advanced Bash | A | 3 (getopts, case-flow, nameref) | Conceptos densos e independientes |
| 08 — File Descriptors | A | 3 (compare, dual-log, timeout) | 13 scripts ultra-específicos |
| 09 — System Admin | A + B | 2 (select menu + nullglob+safe) | Interactividad + seguridad de archivos |
| 10 — Terminal UI | A | 3 (progress bar, spinner, table) | Técnicas UI completamente distintas |
| 11 — Algorithms | B + A | 3 (fake+search+rot13, random, rot13) | Combinación natural de cierre + refuerzos |

**Total: 28 desafíos propuestos (14 Patrón A, 14 Patrón B)**
