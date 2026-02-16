#!/usr/bin/env BASH
#
# Example of case flow
user_input="12345"

case $user_input in
[0-9]*)
    echo -n "Checking numbers... "
    ;;& # FILTER: Keep checking...
*[a-zA-Z]*)
    echo "Success: Contains letters."
    ;;
*)
    echo "ERROR: Must contain at least one letter!"
    ;;
esac
