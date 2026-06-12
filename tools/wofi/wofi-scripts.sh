#!/bin/bash
#
# Run wofi in the source folder allowing to execute the script selected
source=("$HOME/bin/dmenu"/wofi*)

# Extract script names from full paths
script_names=()
for script_path in "${source[@]}"; do
    script_name=$(basename "$script_path")
    script_names+=("$script_name")
done

# Show the script names using wofi
choice=$(printf '%s\n' "${script_names[@]}" | wofi --dmenu --insensitive --lines 20 --prompt "Wofi scripts")

# Find the corresponding full path based on the chosen script name
chosen_script_path=""
for script_path in "${source[@]}"; do
    script_name=$(basename "$script_path")
    if [ "$choice" = "$script_name" ]; then
        chosen_script_path="$script_path"
        break
    fi
done

# Execute the chosen script if a valid path was found
if [ -n "$chosen_script_path" ]; then
    eval "$chosen_script_path"
fi

