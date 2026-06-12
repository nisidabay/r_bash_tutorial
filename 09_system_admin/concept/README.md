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

## Now Build Your Own

Write a system maintenance script with an interactive `select` menu that offers: checking disk usage, listing large files, and updating packages. Use `nullglob` to safely scan `~/Downloads` for temp files, and offer to clean them with a `diff`-style review before deletion.