#!/usr/bin/bash
#
# Show the manual page in pdf format
man -k . | wofi --dmenu --insensitive --lines 20 --prompt "Choose a man page" | awk '{print $1}' | xargs -r man -Tutf8 -Tpdf | zathura - &






