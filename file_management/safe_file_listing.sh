#!/usr/bin/env BASH
#
# File: safe_file_listing.sh

list_files_safely() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Directory '$dir' does not exist." >&2
        return 1
    fi

    # Handle empty directories gracefully
    shopt -s nullglob
    local files=("$dir"/*)
    shopt -u nullglob

    if ((${#files[@]} == 0)); then
        echo "No files in '$dir'."
        return 0
    fi

    echo "Files found:"
    printf ' - %q\n' "${files[@]}"
}

main() {
    local target_dir="${1:-.}"
    list_files_safely "$target_dir"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
