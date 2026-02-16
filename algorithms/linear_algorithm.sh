#!/usr/bin/env BASH
#
# Function to perform linear search
linear_search() {
    # Inputs: n, element1, element2, ..., elementn, value_to_find
    local n=$1
    shift # Remove the first argument (n)

    # Now $@ contains all array elements and the target
    local A=("$@")

    # The last element is the value to search for
    local x=${A[-1]}
    unset "${A[-1]}" # Remove it from array

    local answer=-1 # Default: not found

    for ((i = 0; i < n; i++)); do
        if [[ "${A[i]}" == "$x" ]]; then
            answer=$i
            break
        fi
    done

    echo "$x found at position: $answer"
}

# Example usage:
found=$(linear_search 5 34 23 12 98 76 12)
echo "$found"
