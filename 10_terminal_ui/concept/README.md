# 10 Terminal UI — Progress Bars, Animations, fzf, and Formatted Output

## Quick Start

```bash
bash 10_terminal_ui/concept/01_progress_bar.sh
bash 10_terminal_ui/concept/02_printf_progress.sh
bash 10_terminal_ui/concept/03_formatted_table.sh
bash 10_terminal_ui/concept/04_matrix_rain.sh
bash 10_terminal_ui/concept/05_fzf_preview.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_progress_bar.sh` | Animated progress bar with walking man | `\r` carriage return, `printf "%0.s="`, animation frames via `case`, percentage calc |
| `02_printf_progress.sh` | Simple text-based progress bar | `printf "%${filled}s"`, `tr ' ' '#'`, `\r` overwrite, configurable width |
| `03_formatted_table.sh` | Multiplication table generator | `printf "%${width}d"`, nested loops for grid, header/separator/body layout |
| `04_matrix_rain.sh` | "Matrix" digital rain animation | `tput smcup`/`rmcup`, `tput civis`/`cnorm`, alternate screen, random char generation |
| `05_fzf_preview.sh` | fzf file previewer with ueberzug | `file --mime-type`, `bat` for syntax highlight, ueberzug JSON protocol, `pdftoppm` |
| `06_mpv_spinner.sh` | Video player with loading spinner | Background spinner process, `grep` polling on mpv log, timeout loop |
| `07_dmenu_manager.sh` | dmenu video launcher | `dmenu` integration, CRUD on file list, `notify-send`, `xsel` clipboard, `setsid` terminal launch |

## Common Patterns

```bash
# Carriage-return progress bar
draw_bar() {
    local pct=$1 width=${2:-40}
    local filled=$((pct * width / 100))
    printf "\r[%3d%%] [" "$pct"
    [[ $filled -gt 0 ]] && printf "%${filled}s" "" | tr ' ' '#'
    printf "%$((width - filled))s" "" | tr ' ' '-'
    printf "]"
}

# Alternate screen (clean entry/exit for full-screen UIs)
trap 'tput rmcup; tput cnorm; exit 0' SIGINT
tput smcup   # save screen
tput civis   # hide cursor
# ... animation loop ...
tput rmcup   # restore screen
tput cnorm   # show cursor

# Background spinner
spin() {
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while true; do
        printf "\rLoading... %s" "${spin:i++%${#spin}:1}"
        sleep 0.1
    done
}
spin &
pid=$!
# do work ...
kill "$pid" 2>/dev/null
printf "\rDone.   \n"

# Formatted table with printf
cell_width=4
printf "%${cell_width}s|" ""
for ((i=1; i<=size; i++)); do
    printf "%${cell_width}d" "$i"
done
printf "\n"

# dmenu wrapper
menu() {
    dmenu -c -i -l 20 -p "$1"
}

# fzf preview handler (called via --preview)
mime=$(file --mime-type -b "$file")
case "$mime" in
    text/*|text/x-shellscript) bat --color=always "$file" ;;
    image/*) show_image "$file" ;;
    application/pdf) pdftoppm -singlefile -png -r 144 "$file" preview.png ;;
esac
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `02_printf_progress.sh`

Tomá el script `02_printf_progress.sh` y modificálo para que:

1. En lugar de un loop fijo de 0 a 100, simulá la descarga de 5 archivos, donde cada archivo tiene un tamaño aleatorio entre 10 y 100 "unidades".
2. Mostrá una barra de progreso para cada archivo individual, y al final una barra de progreso general que sume todos los avances.
3. Usá `sleep 0.2` entre unidades para simular la descarga.

💡 Pista: creá un array `archivos=(doc1.zip doc2.zip doc3.zip doc4.zip doc5.zip)` y un array de tamaños `tamaños=(40 75 20 90 55)`. Usá un loop anidado: `for i in "${!archivos[@]}"; do ... for ((p=0; p<=tamaños[i]; p++)); do draw_progress_bar "$p" "${tamaños[i]}"; sleep 0.05; done; done`. Al final, una barra general con el total acumulado.

---

#### Desafío 2A — Basado en `06_mpv_spinner.sh`

Tomá el script `06_mpv_spinner.sh` y modificálo para que:

1. En lugar de esperar a mpv, simulá una tarea de larga duración (por ejemplo, `sleep 8` mientras contás del 1 al 8 en un archivo temporal).
2. El spinner debe cambiar de mensaje en el segundo 4: de "Cargando..." a "Casi listo...".
3. Timeout ajustado a 10 segundos.

💡 Pista: reemplazá `setsid -f mpv ...` por `(for i in {1..8}; do echo "Paso $i"; sleep 1; done) > "$temp_log" 2>&1 &`. En el loop de monitoreo, agregá un contador y si `((timeout_original - timeout > 40))` (pasaron ~4 segundos), mostrá "Casi listo..." en lugar de "Cargando...".

---

#### Desafío 3A — Basado en `03_formatted_table.sh`

Tomá el script `03_formatted_table.sh` y modificálo para que:

1. En lugar de una tabla de multiplicar, mostrá una tabla de conversión de pulgadas a centímetros (del 1 al 20).
2. Mostrá el resultado en centímetros enteros (redondeo simple: `cm=$((i * 254 / 100))`).
3. Aceptá un argumento opcional que indique el máximo de la tabla (default 12).

💡 Pista: cambiá el loop anidado por uno simple `for ((i=1; i<=max; i++))`. Calculá `cm=$((i * 254 / 100))`. Usá `printf "│ %-2d pulg │ %3d cm │\n" "$i" "$cm"` para las columnas. La variable `max` la tomás de `${1:-12}`.