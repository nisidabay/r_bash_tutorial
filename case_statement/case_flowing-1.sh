#!/usr/bin/env BASH
#
# Example of case flow

drink="iced_latte"

case $drink in
iced_*)
    echo -n "Cold "
    ;& # SLIDE: Go straight to the next block no matter what
*_latte)
    echo -n "Coffee "
    ;;& # FILTER: Keep looking for other matches below
*latte)
    echo -n "with Milk "
    ;; # STOP: We are done
*)
    echo "Water"
    ;;
esac
