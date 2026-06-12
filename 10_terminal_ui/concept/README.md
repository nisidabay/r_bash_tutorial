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

## Now Build Your Own

Write a script that monitors a directory for new `.log` files and displays a live-updating table of file sizes (formatted with `printf`), a spinner while scanning, and a progress bar during batch processing. Use `tput` for cursor positioning and `\r` for in-place updates.