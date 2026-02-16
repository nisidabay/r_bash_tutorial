#!/usr/bin/env BASH
#
# Script to manage variables and arrays using references.

# --- Global Variables ---

count=0
users=("alpha" "beta" "gamma" "teta")
a=(1 2 3)
b=(4 5 6)
target_var=100

# --- Variable Functions ---

# Increments a variable passed by reference.
# Usage: increment_variable my_var_name
increment_variable() {
    local -n ref="$1"
    ((ref++))
}

# --- Array Functions ---

# Removes a specified element from an array passed by reference.
# Usage: remove_user_from_array my_array_name "element_to_remove"
remove_user_from_array() {
    local -n array_ref="$1"
    local name_to_remove="$2"
    local new_array=()

    for element in "${array_ref[@]}"; do
        if [[ "$element" != "$name_to_remove" ]]; then
            new_array+=("$element")
        fi
    done

    array_ref=("${new_array[@]}")
}

# Swaps the contents of two arrays passed by reference.
# Usage: swap_arrays array_one_name array_two_name
swap_arrays() {
    local -n ref_a="$1"
    local -n ref_b="$2"
    local tmp_array=("${ref_a[@]}")
    ref_a=("${ref_b[@]}")
    ref_b=("${tmp_array[@]}")
}

# --- Main Execution ---

main() {
    echo "--- Initial State ---"
    echo "Count: $count"
    echo "Target Var: $target_var"
    echo "Users: ${users[*]}"
    echo "Array a: ${a[*]}"
    echo "Array b: ${b[*]}"
    echo

    echo "--- Operations ---"

    echo "Incrementing 'count'..."
    increment_variable "count"
    echo "New count: $count"
    echo

    echo "Incrementing 'target_var'..."
    increment_variable "target_var"
    echo "New target_var: $target_var"
    echo

    echo "Removing 'teta' from 'users'..."
    remove_user_from_array "users" "teta"
    echo "New users: ${users[*]}"
    echo

    echo "Swapping arrays 'a' and 'b'..."
    swap_arrays "a" "b"
    echo "New array a: ${a[*]}"
    echo "New array b: ${b[*]}"
    echo

    echo "--- Final State ---"
    echo "Count: $count"
    echo "Target Var: $target_var"
    echo "Users: ${users[*]}"
    echo "Array a: ${a[*]}"
    echo "Array b: ${b[*]}"
}

# Run main function if the script is executed directly.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main
fi
