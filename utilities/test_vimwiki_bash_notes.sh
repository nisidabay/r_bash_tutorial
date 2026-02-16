#!/usr/bin/env BASH
#
# Check multiple installations of a program
#
# Use 'type -p -a' to get only the full file paths
# mapfile -t yt_locations < <(type -p -a yt)
#
# echo "Testing ${#yt_locations[@]} 'yt' commands..."
# echo "=========================================="
#
# for path in "${yt_locations[@]}"; do
#     echo "LOCATION: $path"
#
#     # 1. Identify the file type (binary, script, etc.)
#     echo -n "FILE TYPE: "
#     file -b "$path"
#
#     # 2. Try to run it safely to see its identity
#     # We redirect errors (2>&1) so we catch "command not found" or usage tips
#     echo "IDENTITY TEST:"
#     timeout 2s "$path" --version 2>&1 | sed 's/^/  /' ||
#         timeout 2s "$path" --help 2>&1 | head -n 5 | sed 's/^/  /'
#
#     echo "------------------------------------------"
# done
#
# val_a=15
# val_b=4
#
# # Basic Math
# sum=$((val_a + val_b))  # 19
# diff=$((val_a - val_b)) # 11
# prod=$((val_a * val_b)) # 60
# quot=$((val_a / val_b)) # 3 (Integer division!)
# rem=$((val_a % val_b))  # 3 (Modulus/Remainder)
# pow=$((val_a ** 2))     # 225 (Exponentiation)
#
# echo "15 / 4 = $quot (remainder $rem)"
#
mapfile -t hosts </etc/hosts

for line in "${hosts[@]}"; do
    [[ -z "$line" || "$line" =~ ^\# ]] && continue
    printf "Host line: %s\n" "$line"
done

mapfile -d $'\0' -t files < <(find . -maxdepth 1 -type f -print0)

if [[ "${#files[@]}" -gt 0 ]]; then
    for ((i = 0; i < ${#files[@]}; i++)); do
        printf "Found %d files, file: %q\n" "${#files[@]}" "${files[i]}"
    done
fi

s="root:x:0:0"
mapfile -d":" -t parts <<<"$s"

# Define the function as before
generate_fake_data() {
    local name=$(LC_ALL=C tr -dc 'a-zA-Z' </dev/urandom | head -c 5)
    local age=$((RANDOM % 60 + 20))
    local email="${name,,}@example.com"
    echo "\"$name\",\"$age\",\"$email\""
}

# Use Process Substitution < <(...) to fill the array directly
mapfile -t data_rows < <(for ((i = 1; i <= 5; i++)); do generate_fake_data; done)
# Optional: Verify the array size
echo "Rows in array: ${#data_rows[@]}"
echo "array: ${data_rows[*]}"

# Simple progress bar using printf padding
draw_progress() {
    local percent=$1
    local width=40
    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    # %*s uses the argument to set dynamic width
    printf "\r[%03d%%] " "$percent"
    printf "%${filled}s" "" | tr ' ' '#'
    printf "%${empty}s" "" | tr ' ' '-'
}

for i in {0..100..10}; do
    draw_progress "$i"
    sleep 0.2
done
printf "\nDone.\n"

mkdir -p safe_demo
touch "safe_demo/report final.txt" "safe_demo/notes 2025.txt"

echo "--- Processing Files ---"

# 2. Safety Switch: Enable nullglob
# If no .txt files exist, this ensures the loop doesn't run at all.
# Without this, the loop runs once with the literal string "safe_demo/*.txt".
shopt -s nullglob

# 3. Use Globbing + Quoting (Safe)
# Globs expand safely into filenames.
for file in safe_demo/*.txt; do
    # "file" now holds the full path. Quote it when using it.
    echo "Processing: '$file'"

    # Simulate a command
    if [[ -f "$file" ]]; then
        wc -c "$file"
    fi
done

printf "%-20s %-10s %-10s\n" "FILESYSTEM" "SIZE" "USAGE%"
printf "%41s\n" "------------------------------------------"
df -h | awk 'NR>1 {print $1, $2, $5}' | while read -r fs size use; do
    # Truncate long FS names to 20 chars for alignment
    printf "%-20s %-10s %-10s\n" "$fs" "$size" "$use"
done
