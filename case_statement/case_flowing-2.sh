#!/usr/bin/env BASH
#
# Example of case flow
file="photo.jpg"

case $file in
*.jpg)
    echo -n "Image "
    ;& # SLIDE: Forces the next block to run
ignored)
    echo -n "Format "
    ;;& # FILTER: Continues searching for other matches
photo*)
    echo -n "named Photo "
    ;; # STOP: Finished
esac
