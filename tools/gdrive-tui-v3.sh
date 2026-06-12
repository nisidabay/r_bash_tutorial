#!/usr/bin/env bash
# gdrive-tui — Google Drive TUI via rclone
#   Browse+Open: fast single-file access (downloads then opens locally)
#   Mount: bulk operations via your normal shell tools
set -uo pipefail

REMOTE="gdrive:"
MOUNT_DIR="$HOME/GoogleDrive"

# ── color helpers ──────────────────────────────────────────────
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DIM='\033[2m'
CYAN='\033[0;36m'
RESET='\033[0m'

H1()   { printf "${BOLD}${CYAN}%s${RESET}\n" "$1"; }
OK()   { printf "${GREEN}%s${RESET}\n" "$1"; }
WARN() { printf "${YELLOW}%s${RESET}\n" "$1"; }
ERR()  { printf "${RED}%s${RESET}\n" "$1"; }
DIMM() { printf "${DIM}%s${RESET}\n" "$1"; }

# ── helpers ─────────────────────────────────────────────────────
die() { ERR "$1"; exit 1; }

check_remote() {
    rclone listremotes 2>/dev/null | grep -q "^gdrive:" \
        || die "No 'gdrive:' remote found. Run: rclone config"
}

check_fuse() {
    command -v fusermount &>/dev/null \
        || die "fusermount not found. Install: sudo pacman -S fuse3"
}

# ── browse + open (fast for single files) ──────────────────────
do_open() {
    local count=$#
    H1 "Opening $count file(s)..."
    for f in "$@"; do
        local ext="${f##*.}"
        local base
        base=$(basename "$f")
        local tmp="/tmp/gdTUI_${base}"

        if ! rclone copyto "${REMOTE}${f}" "$tmp" 2>/dev/null; then
            ERR "  ✗ Failed to download: $base"
            continue
        fi

        case "$ext" in
            pdf|djvu|epub)     zathura "$tmp" & ;;
            png|jpg|jpeg|gif|webp) feh "$tmp" & ;;
            mp4|mkv|webm|avi)  mpv "$tmp" & ;;
            mp3|flac|ogg|wav)  mpv "$tmp" & ;;
            txt|md|sh|py|rs|go|nim|rb|lua|conf|toml|yaml|yml|json|csv)
                setsid kitty sh -c "n '$tmp'" & ;;
            *) xdg-open "$tmp" & ;;
        esac
        OK "  ➤ $base"
    done
    OK "✓ Done."
}

do_download() {
    local dest="$1"; shift
    mkdir -p "$dest"
    for f in "$@"; do
        local base
        base=$(basename "$f")
        if rclone copyto "${REMOTE}${f}" "$dest/$base" 2>/dev/null; then
            OK "  ↓ $base"
        else
            ERR "  ✗ Failed: $base"
        fi
    done
    OK "✓ Downloaded to $dest."
}

do_delete() {
    local count=$#
    for f in "$@"; do printf "  %s\n" "$(basename "$f")"; done

    printf "\n${RED}Delete %d file(s) permanently?${RESET} [y/N] " "$count"
    read -r ans
    [[ "$ans" != "y" && "$ans" != "Y" ]] && { WARN "Cancelled."; return; }

    for f in "$@"; do
        local base
        base=$(basename "$f")
        if rclone deletefile "${REMOTE}${f}" 2>/dev/null; then
            OK "  ✕ $base"
        else
            ERR "  ✗ Failed: $base"
        fi
    done
    OK "✓ Deleted $count file(s)."
}

file_action() {
    local f="$1"
    local base
    base=$(basename "$f")

    local PS3="Action for $base [1-4]: "
    local act
    local actions=("Open" "Download" "Delete" "Cancel")
    select act in "${actions[@]}"; do
        break
    done

    [[ -z "$act" || "$act" == "Cancel" ]] && return

    case "$act" in
        Open)
            do_open "$f"
            ;;
        Download)
            printf "Download to [%s]: " "$HOME/Downloads/"
            read -r dest
            dest="${dest:-$HOME/Downloads/}"
            do_download "${dest%/}" "$f"
            ;;
        Delete)
            do_delete "$f"
            ;;
    esac
}

browse() {
    local path="${1:-}"
    while true; do
        printf "\n${BOLD}${CYAN}☁  /%s${RESET}\n\n" "$path"

        local dirs_raw files_raw
        dirs_raw=$(rclone lsf "${REMOTE}${path}" --dirs-only 2>/dev/null | sed 's/\/$//')
        files_raw=$(rclone lsf "${REMOTE}${path}" --files-only 2>/dev/null)

        if [[ -z "$dirs_raw" && -z "$files_raw" ]]; then
            DIMM "  (empty folder)"
        fi

        local items=()
        if [[ -n "$path" ]]; then
            items+=("../")
        fi

        local d f
        while IFS= read -r d; do
            [[ -n "$d" ]] && items+=("$d/")
        done <<< "$dirs_raw"

        while IFS= read -r f; do
            [[ -n "$f" ]] && items+=("$f")
        done <<< "$files_raw"

        if [[ ${#items[@]} -eq 0 ]]; then
            DIMM "  (nothing to select)"
            printf "Press Enter to go back..."
            read -r
            if [[ -n "$path" ]]; then
                path=$(dirname "$path")
                [[ "$path" == "." ]] && path=""
            else
                return
            fi
            continue
        fi

        local PS3="Pick [0=back]: "
        local choice
        select choice in "${items[@]}"; do
            break
        done

        if [[ -z "$choice" ]]; then
            if [[ -n "$path" ]]; then
                path=$(dirname "$path")
                [[ "$path" == "." ]] && path=""
                continue
            else
                return
            fi
        fi

        if [[ "$choice" == "../" ]]; then
            path=$(dirname "$path")
            [[ "$path" == "." ]] && path=""
            continue
        fi

        if [[ "$choice" == */ ]]; then
            local dirname="${choice%/}"
            path="${path:+$path/}$dirname"
            continue
        fi

        local full_path="${path:+$path/}$choice"
        file_action "$full_path"
    done
}

# ── search (single-file quick access) ──────────────────────────
search() {
    printf "Search Drive: "
    read -r query
    [[ -z "$query" ]] && return

    printf "\n${BOLD}${CYAN}🔍  %s${RESET}\n\n" "$query"

    local tmpfile
    tmpfile=$(mktemp)
    rclone lsjson "$REMOTE" --recursive --files-only \
        --no-mimetype --no-modtime 2>/dev/null \
        | sed '1d;$d' > "$tmpfile" 2>/dev/null || true

    if [[ ! -s "$tmpfile" ]]; then
        ERR "No results or remote error."
        rm -f "$tmpfile"
        return
    fi

    local idxfile
    idxfile=$(mktemp)
    local line_n=0
    while IFS= read -r entry; do
        [[ -z "$entry" ]] && continue
        local fpath
        fpath=$(echo "$entry" | grep -oP '"Path"\s*:\s*"\K[^"]*')
        [[ -z "$fpath" ]] && continue
        if echo "$fpath" | grep -qi "$query"; then
            line_n=$((line_n + 1))
            printf "%d\t%s\n" "$line_n" "$fpath" >> "$idxfile"
        fi
    done < "$tmpfile"
    rm -f "$tmpfile"

    if [[ ! -s "$idxfile" ]]; then
        WARN "No results for: $query"
        rm -f "$idxfile"
        return
    fi

    local results=()
    while IFS=$'\t' read -r num fpath; do
        results+=("$fpath")
        printf "  %2d) %s\n" "$num" "$fpath"
        [[ "$num" -ge 30 ]] && break
    done < "$idxfile"

    printf "\nSelect file number (0 to cancel): "
    read -r pick
    rm -f "$idxfile"

    [[ -z "$pick" ]] && return
    [[ "$pick" -eq 0 ]] 2>/dev/null && return

    if ! [[ "$pick" =~ ^[0-9]+$ ]] || [[ "$pick" -lt 1 ]] || [[ "$pick" -gt ${#results[@]} ]]; then
        WARN "Invalid selection."
        return
    fi

    local sel_path="${results[$((pick - 1))]}"
    file_action "$sel_path"
}

# ── mount / unmount (fast for bulk operations) ──────────────────
do_mount() {
    if mountpoint -q "$MOUNT_DIR" 2>/dev/null; then
        WARN "Already mounted at $MOUNT_DIR"
        return
    fi
    mkdir -p "$MOUNT_DIR"
    if rclone mount "$REMOTE" "$MOUNT_DIR" --daemon 2>/dev/null; then
        OK "✓ Mounted at $MOUNT_DIR"
        DIMM "  cp *.pdf $MOUNT_DIR/Books/"
        DIMM "  rm $MOUNT_DIR/Books/old.pdf"
        DIMM "  lf $MOUNT_DIR"
    else
        ERR "Mount failed. Is fuse3 installed?"
    fi
}

do_unmount() {
    if ! mountpoint -q "$MOUNT_DIR" 2>/dev/null; then
        WARN "Not currently mounted."
        return
    fi
    if fusermount -u "$MOUNT_DIR" 2>/dev/null; then
        OK "✓ Unmounted."
    else
        ERR "Failed to unmount. Files in use? Close programs and retry."
    fi
}

do_status() {
    if mountpoint -q "$MOUNT_DIR" 2>/dev/null; then
        OK "Mounted at $MOUNT_DIR"
        rclone about "$REMOTE" 2>/dev/null || true
    else
        WARN "Not mounted."
    fi
}

# ── main ────────────────────────────────────────────────────────
show_hints() {
    printf "\n"
    DIMM "  ┌─────────────────────────────────────────────────────────┐"
    DIMM "  │  Browse+Open → fast for reading a single book/doc       │"
    DIMM "  │  Mount        → use cp/mv/rm for bulk file operations   │"
    DIMM "  │  Search       → find a file by name without browsing    │"
    DIMM "  └─────────────────────────────────────────────────────────┘"
    printf "\n"
}

main() {
    check_remote
    check_fuse

    # CLI flags
    case "${1:-}" in
        -b|--browse)   browse ""; exit $? ;;
        -s|--search)   search; exit $? ;;
        -m|--mount)    do_mount; exit $? ;;
        -u|--unmount)  do_unmount; exit $? ;;
        --status)      do_status; exit $? ;;
    esac

    # Interactive
    while true; do
        printf "\n${BOLD}${CYAN}☁  Google Drive${RESET}"
        show_hints

        local PS3="Choose [1-6]: "
        local opt
        select opt in "Browse + Open" "Search" "Mount" "Unmount" "Status" "Exit"; do
            break
        done

        case "$opt" in
            "Browse + Open") browse "" ;;
            "Search")        search ;;
            "Mount")          do_mount ;;
            "Unmount")        do_unmount ;;
            "Status")         do_status ;;
            "Exit")           exit 0 ;;
            *)                continue ;;
        esac
    done
}

main "$@"