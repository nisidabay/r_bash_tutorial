#!/usr/bin/env BASH
# Compare arrays using nameref

compare_sorted() {
    local -n arr1_ref=$1 # nameref to first array
    local -n arr2_ref=$2 # nameref to second array

    # Sort both arrays
    readarray -t sorted1 < <(printf '%s\n' "${arr1_ref[@]}" | sort)
    readarray -t sorted2 < <(printf '%s\n' "${arr2_ref[@]}" | sort)

    # Compare as strings
    if [[ "${sorted1[*]}" == "${sorted2[*]}" ]]; then
        echo "Arrays are equal"
    else
        echo "Arrays are not equal"
    fi
}

compare_unsorted() {
    local -n arr1_ref=$1 # nameref to first array
    local -n arr2_ref=$2 # nameref to second array

    # Compare as strings
    if [[ "${arr1_ref[*]}" == "${arr2_ref[*]}" ]]; then
        echo "Arrays are equal"
    else
        echo "Arrays are not equal"
    fi
}
# Example usage
array1=("apple" "banana" "cherry")
array2=("banana" "apple" "cherry")

compare_sorted array1 array2
compare_unsorted array1 array2
