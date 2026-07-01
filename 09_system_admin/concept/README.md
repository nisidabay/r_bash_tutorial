# 09 System Admin — Desktop Entries, Services, Select Menus, and File Safety

## Quick Start

```bash
bash 09_system_admin/concept/01_desktop_entry.sh
bash 09_system_admin/concept/03_select_menu.sh
bash 09_system_admin/concept/04_safe_update.sh
bash 09_system_admin/concept/08_nullglob_safety.sh
bash 09_system_admin/concept/09_find_null_safe.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_desktop_entry.sh` | Desktop entry (.desktop) generator | Interactive prompts, `read -rp`, here-doc file generation, `chmod +x`, Wayland detection |
| `02_service_launcher.sh` | Spotify launcher with PulseAudio mgmt | Background process launch, `systemctl --user` service stop/start, `notify-send`, dependency checks |
| `03_select_menu.sh` | Interactive menu with `select` | `PS3` prompt, `select choice in ...`, `case` dispatch, `break` exit |
| `04_safe_update.sh` | In-place file update with diff review | `mktemp`, `diff -q` to check changes, `diff -u` to show, `mv` atomic replace, trap cleanup |
| `05_temp_cleanup.sh` | Temp file + error handler demo | `mktemp` + `trap cleanup EXIT`, `$FUNCNAME`/`$BASH_LINENO` error reporting |
| `06_stow_migrate.sh` | Dotfiles stow migration script | Batch directory reorganization, `mkdir -p` package structure, `mv` per folder |
| `07_temp_file_demo.sh` | Minimal temp file lifecycle | `mktemp`, `trap 'rm -f' EXIT`, here-doc write to temp file |
| `08_nullglob_safety.sh` | Safe file listing with `nullglob` | `shopt -s nullglob`, glob into array, `shopt -u nullglob`, empty-dir check |
| `09_find_null_safe.sh` | Null-safe file listing with `find -print0` | `find -print0`, `mapfile -t -d ''`, `read -d ''`, process substitution |

## Common Patterns

```bash
# Interactive select menu
PS3="Choose an option: "
MENU_OPTIONS=("Update" "Check disk" "Exit")
select choice in "${MENU_OPTIONS[@]}"; do
    case "$choice" in
        "Update") sudo apt update ;;
        "Exit") break ;;
        *) echo "Invalid: $REPLY" ;;
    esac
done

# Safe file update with confirmation
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
sed 's/foo/bar/g' "$target" > "$tmp"
if ! diff -q "$target" "$tmp" >/dev/null; then
    diff -u "$target" "$tmp"
    read -p "Apply? (y/n) " -n 1 -r
    [[ $REPLY =~ ^[Yy]$ ]] && mv "$tmp" "$target"
fi

# Nullglob — safe directory listing
shopt -s nullglob
files=("$dir"/*)
shopt -u nullglob
if ((${#files[@]} == 0)); then
    echo "Empty directory"
fi

# Null-safe find with mapfile
mapfile -t -d '' files < <(find "$dir" -type f -print0)

# Send desktop notification
notify-send -u critical "Title" "Message"

# Stop a systemd user service
systemctl --user stop pipewire
```

## Basado en este ejemplo, modifica para conseguir...

---

#### Desafío 1A — Basado en `03_select_menu.sh`

Tomá el script `03_select_menu.sh` y modificálo para que:

1. En lugar de las opciones existentes, creá un menú de herramientas de red: "Ping a servidor", "Escaneo de puertos (local)", "Mostrar IP pública", "Traceroute", "Salir".
2. Para "Ping a servidor", pedí al usuario una dirección adicional con `read -p` antes de ejecutar.
3. Agregá una verificación al inicio que compruebe si los comandos necesarios existen (`command -v ping`, etc.), y si falta alguno, mostrá una advertencia pero permití continuar.

💡 Pista: copiá la estructura del `select` loop de `03_select_menu.sh`. Reemplazá `MENU_OPTIONS` con las nuevas opciones. Para el ping: dentro del case, `read -p "Servidor: " server; ping -c 3 "$server"`. Para verificar comandos: `for cmd in ping nc curl traceroute; do command -v "$cmd" &>/dev/null || echo "Falta: $cmd"; done`.

---

#### Desafío 2B — Basado en `04_safe_update.sh`, `08_nullglob_safety.sh`, `09_find_null_safe.sh`

Basado en lo que viste en `08_nullglob_safety.sh`, `04_safe_update.sh`, y `09_find_null_safe.sh`, creá un script que:

1. Escanee un directorio dado como argumento buscando archivos `.tmp` de más de 1 MB (usá nullglob o find -print0 de `08_nullglob_safety.sh`/`09_find_null_safe.sh`).
2. Muestre un diff del tamaño actual vs el tamaño que se liberaría (usando el patrón de `04_safe_update.sh`).
3. Pida confirmación antes de eliminar, y si se confirma, elimine los archivos y muestre un resumen.

💡 Pista: arrancá copiando `08_nullglob_safety.sh` como base. Usá `shopt -s nullglob; files=("$dir"/*.tmp); shopt -u nullglob`. Para cada archivo, calculá `size=$(stat -c%s "$file")` y si `(( size > 1048576 ))`, agregalo a `to_delete`. Mostrá los archivos encontrados y preguntá "¿Eliminar estos N archivos? (y/n)".