#!/usr/bin/env bash
set -euo pipefail
IFS=$'
	'

# DIR="build"
# mkdir -p "$DIR" && cd "$DIR" && pwd || {
#     echo "Could not create or enter $DIR"
#     exit 1
# }

# # specific check during assignment
# FILE=${1:?"No filename provided"}
#
# # Defaulting logic
# BACKUP_DIR=${DEST:-/tmp/backup}
#
# echo "Backing up $FILE to $BACKUP_DIR"
#
# FULLPATH="/home/user/project/main.cpp"
#
# DIRPATH="${FULLPATH%/*}"
# echo "$DIRPATH"
# FILENAME="${FULLPATH##*/}"
# echo "$FILENAME"
# EXT="${FILENAME##*.}"
# echo "$EXT"

# Batch renamer
# FILES="index.htm conctact.html about.htm style.css"
# for file in $FILES; do
#     [[ "$file" == *.htm ]] && {
#         NEWNAME="${file%.*}.html"
#         echo "Renaming $file to $NEWNAME"
#
#     } || echo "Skipping $file"
#
# done

# Command substitution
# TIMESTAMP="$(date +%F_%H-%M-%S-%N)"
# CURRENT_USER="$(whoami)"
# FILENAME="log_[$CURRENT_USER]_[$TIMESTAMP].txt"
# touch "$FILENAME" && echo "Created log file: [$FILENAME]"
#
# Task inventory
# HOSTS=("192.168.1.10" "192.168.1.11" "legacy server")
# HOSTS+=("10.0.0.5")
#
# echo "Total hosts:[${#HOSTS[@]}]"
# for host in "${HOSTS[@]}"; do
#     echo "Checking host: [$host]"
# done
#
# Network checker
# check_host() {
#     local target="${1:-}"
#
#     [[ -z "$target" ]] && return 1
#
#     if ping -c 1 "$target" >/dev/null 2>&1; then
#         echo "$target is UP" && return 0
#     else
#         echo "$target is DOWN" && return 1
#
#     fi
# }
# check_host "8.8.8.8"
# check_host "bad.host.local"

# Simple getopts example
# VERBOSE=false
# TARGET_USER="guest"
# while getopts ":vu:" opt; do
#     case "$opt" in
#     v)
#         VERBOSE=true
#         ;;
#     u)
#         TARGET_USER="$OPTARG"
#         ;;
#     \?)
#         echo "Invalid option: -$OPTARG" >&2
#         exit 1
#         ;;
#     :)
#         echo "Option: -$OPTARG requires and argument." >&2
#         exit 1
#         ;;
#     esac
#
# done
#
# echo "VERBOSE:$VERBOSE"
# echo "TARGET_USER:$TARGET_USER"

set -euo pipefail

# 1. Argument Validation
FOLDER="${1:?Usage: $0 <folder> [backup_path]}"

# 2. explicit check prevents 'ls' from crashing the script
if [[ ! -d "$FOLDER" ]]; then
    echo "Error: Directory '$FOLDER' does not exist." >&2
    exit 1
fi

# 3. Handle grep failure (no matches) gracefully
# We append '|| true' so if grep returns 1, the chain returns 0.
ls "$FOLDER" | grep "conf" || echo "No config files found in $FOLDER."

shift

# 4. Backup Logic
BACKUP_PATH="${1:-/tmp/backup}"
# Ensure the backup directory actually exists!
mkdir -p "$BACKUP_PATH"

# 5. Source File Check
if [[ ! -f "myconfig.txt" ]]; then
    echo "Error: 'myconfig.txt' not found." >&2
    exit 1
fi

cp "myconfig.txt" "$BACKUP_PATH/config.bak"
echo "Script finished successfully!"
