#!/usr/bin/env BASH
#
# Progress bar with printf

draw_progress() {
    local input=$1
    local width=40
    local filled=$((input * width / 100))
    local empty=$((width - filled))

    printf "\r[%03d%%] " "$input"
    printf "%${filled}s" "" | tr ' ' '#'
    printf "%${empty}s" "" | tr ' ' '-'
}

for i in {0..100..10}; do
    draw_progress "$i"
    sleep 0.2
done
