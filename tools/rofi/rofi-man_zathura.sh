#!/usr/bin/env bash
#
# Show the manual page in pdf format
man -k . | rofi -dmenu -p "Man page to pdf" | awk '{print $1}' | xargs -r man -Tutf8 -Tpdf | zathura - &
