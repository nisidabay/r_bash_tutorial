#!/usr/bin/env BASH
#
# Script to clean up files
# Change spaces with _ and remove "'"

# Fail on unset variables (safety)
set -u

DRY_RUN=false
VERSION="0.0.3"

working_dir=$(mktemp -d)

show_version() {
    # Pure BASH way to get script name (removes path)
    echo "${0##*/} v$VERSION" >&2
    exit 0
}

show_help() {
    echo "Usage: ${0##*/} [-h] [-v] [-d] [-p PATH]" >&2
    echo "  -h        show help" >&2
    echo "  -v        show version" >&2
    echo "  -d        dry run (Safe Mode: copies to temp folder)" >&2
    echo "  -p PATH   start path (default: .)" >&2
    exit 0
}

normalize_path() {
    local dir="$1"
    # We use a subshell simply by calling this function, but we need
    # to handle the failure case if cd doesn't work.
    if cd "$dir" 2>/dev/null; then
        pwd
    else
        echo "❌ Error: Directory '$dir' not found." >&2
        exit 1
    fi
}

select_items_with_fzf() {
    local scan_path="$1"
    echo "🔍 Scanning directories in: $scan_path" >&2

    find "$scan_path" -type d -print0 2>/dev/null |
        fzf --read0 --print0 --multi --prompt="🔓 Select directories > " \
            --header="TAB = multi-select | ESC = cancel"
}

clean_up_files() {
    # Note: We are using the global $start_path here
    for file in "$@"; do

        # --- CALCULATION PHASE (Pure BASH) ---
        # 1. Remove single quotes
        cleaned_name=${file//\'/}
        # 2. Replace spaces with underscores
        cleaned_name=${cleaned_name// /_}
        # 3. Get just the folder name (Remove longest match of */ from front)
        base_name=${cleaned_name##*/}

        # --- EXECUTION PHASE ---
        if [[ "$DRY_RUN" == "true" ]]; then
            echo "[SANDBOX] Copying to temp: $base_name"
            cp -r "$file" "$working_dir/$base_name"
        else
            echo "[REAL] Creating clean copy in: $start_path/$base_name"
            cp -r "$file" "$start_path/$base_name"
        fi
    done
}

main() {
    # Default start path
    start_path="."

    while getopts "hvdp:" opt; do
        case "$opt" in
        h) show_help ;;
        v) show_version ;;
        d) DRY_RUN=true ;;
        p) start_path="$OPTARG" ;;
        *)
            echo "Invalid option: -$opt" >&2
            exit 1
            ;;
        esac
    done
    shift $((OPTIND - 1))

    # Normalize and validate path
    start_path=$(normalize_path "$start_path") || exit 1

    # 1. Select files
    mapfile -t -d '' selected_dirs < <(select_items_with_fzf "$start_path")

    # 2. Safety check: Did user press ESC?
    if [ ${#selected_dirs[@]} -eq 0 ]; then
        echo "No directories selected. Exiting."
        exit 0
    fi

    # 3. Run the logic
    clean_up_files "${selected_dirs[@]}"

    # 4. Final Report
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "------------------------------------------------"
        echo "🧪 SANDBOX COMPLETE. Results below:"
        echo "------------------------------------------------"
        ls -F "$working_dir"
        echo "------------------------------------------------"
        echo "Temp location: $working_dir"
    else
        echo "✅ DONE. Clean copies created in $start_path"
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
