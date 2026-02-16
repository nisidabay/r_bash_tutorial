#!/usr/bin/env BASH
#
# Read two files and see the differences
read_two_files() {
    local file1="$1"
    local file2="$2"

    while IFS= read -r line1 && IFS= read -r line2 <&3; do
        printf "File1: %-40s | File2: %s\n" "$line1" "$line2"
    done <"$file1" 3<"$file2"
    exec 3<&-
}

diff_two_files() {
    local file1="$1"
    local file2="$2"

    if diff -u --color=always "$file1" "$file2"; then
        echo "✅ No changes detected. File is already up to date."
        return 0
    else
        diff -u --color=always "$file1" "$file2"
        return 1
    fi
}

main() {
    if (($# != 2)); then
        echo "Usage: $0 <file1> <file2>" >&2
        exit 1
    fi

    read_two_files "$1" "$2"
    echo
    read -p "Press to diff command" -n 1 -r
    echo
    diff_two_files "$1" "$2"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
