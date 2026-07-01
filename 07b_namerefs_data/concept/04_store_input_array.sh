#!/usr/bin/env bash
set -euo pipefail
IFS=$'
	'

declare -A hash

while IFS= read -r line; do
    [[ -z "$line" ]] && continue

    # Get first word as key
    key=$(echo "$line" | cut -d' ' -f1)

    # Everything after the first space becomes value
    rest="${line#* }"
    value=$(echo "$rest" | xargs) # trim leading/trailing spaces

    # Only assign if we have a valid key and non-empty value
    [[ -n "$key" && -n "$value" ]] && hash["$key"]="$value"
done

for key in "${!hash[@]}"; do
    printf 'Key: %s ==> Value: %s\n' "$key" "${hash[$key]}"
done
