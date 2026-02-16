#!/usr/bin/env BASH
#
# File: find_with_null.sh

read_files_null_safe() {
    local dir="$1"
    local -a files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$dir" -type f -print0)

    echo "Found ${#files[@]} files:"
    printf ' - %s\n' "${files[@]}"
}

main() {
    local dir="${1:-.}"
    if [[ ! -d "$dir" ]]; then
        echo "Invalid directory: $dir" >&2
        exit 1
    fi
    read_files_null_safe "$dir"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
