#!/usr/bin/bash
# Author: nisidabay
# Rofi script to search TLDR pages

rofi -dmenu -p "TLDR pages: " | xargs tldr
