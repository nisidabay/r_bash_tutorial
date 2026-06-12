# 11 Algorithms & Data — ROT13, Fake Data, Search, and Random Generation

## Quick Start

```bash
bash 11_algorithms_data/concept/01_rot13.sh
bash 11_algorithms_data/concept/02_fake_data.sh
bash 11_algorithms_data/concept/03_linear_search.sh
bash 11_algorithms_data/concept/04_random_data.sh
```

## Learning Path

| File | Concept | Key Pattern |
|---|---|---|
| `01_rot13.sh` | ROT13 encryption/decryption | `tr 'A-Za-z' 'N-ZA-Mn-za-m'`, user prompts for overwrite, `.enc` extension convention |
| `02_fake_data.sh` | Fake user data generator | `/dev/urandom` + `tr -dc 'a-zA-Z'`, `$RANDOM` for age, `mapfile` from process substitution |
| `03_linear_search.sh` | Linear search algorithm | Pass array elements as `"$@"`, iterate with `!array[@]` index, `break` on first match |
| `04_random_data.sh` | Random data generation cookbook | `$RANDOM` range patterns, `/dev/urandom` passwords, random dates, hex colors, IPs, filenames |

## Common Patterns

```bash
# ROT13 — tr-based substitution cipher
tr 'A-Za-z' 'N-ZA-Mn-za-m' < input.txt > output.enc

# Random string from /dev/urandom
random_str=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12)

# Random number in range [min, max)
random_in_range=$((RANDOM % (max - min) + min))

# Random element from array
options=("apple" "banana" "cherry")
random_index=$((RANDOM % ${#options[@]}))
selected="${options[$random_index]}"

# Random date between two dates
start=$(date -ud "2023-01-01" +%s)
end=$(date -ud "2023-12-31" +%s)
random_ts=$((start + RANDOM % (end - start)))
random_date=$(date -ud "@$random_ts" +"%Y-%m-%d")

# Linear search
linear_search() {
    local target="$1"; shift
    local -a arr=("$@")
    for i in "${!arr[@]}"; do
        [[ "${arr[i]}" == "$target" ]] && echo "$i" && return 0
    done
    echo -1
}

# Generate fake data rows into an array
mapfile -t data < <(
    for ((i=0; i<count; i++)); do
        generate_row
    done
)
```

## Now Build Your Own

Write a script that generates 20 fake user records (name, age, email), stores them in an array, then lets the user search by name using linear search. Display results in a formatted table. Add an option to output the data as fake CSV with ROT13-encoded email addresses.