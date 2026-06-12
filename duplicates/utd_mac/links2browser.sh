#!/usr/local/bin/bash

# Script name: links2browser.sh
# Description: Show downloaded media
# Date: sábado, 12 de marzo de 2022, 22:07:34 CET
# Dependencies: choose-gui, from brew
# Get the links from a log file parsed by a python script

set -euo pipefail
declare -A media

CHOOSE=$(which choose)
FILE="$(pwd)/links.txt"

if [[ ! -f "$CHOOSE" ]];then
    echo -e "[!] choose-gui not installed"
    echo -e "[!] use brew to install it"
    exit 1
fi


if [[ ! -f "$FILE" ]];then
    echo -e "[!] File: -$FILE- not found"
    echo -e "[!] Generate it with utd.py downloads'"
    exit 1
fi

# Strip out the keys and values from the links.txt
# The text would be like this:
# 1 Minute Video - Doggie=https://www.youtube.com/watch?v=YLslsZuEaNE
while read -r line; do
    key=${line%%=*}
    val=${line#*=}
    media[$key]=$val
done < $FILE

title=$(printf '%s\n' "${!media[@]}" | sort | $CHOOSE -m)

function cleanup(){
# remove the file links.txt as is generated from utd.log
if [[ -f ${FILE} ]];then
 rm -rf $FILE 
fi
}

trap cleanup EXIT

if [[ -n $title ]]; then
    url=${media[${title}]}
    echo "Opening URL: $url" # Debugging line
    open -a firefox "${url}" > /dev/null 2>&1 &
else
    echo "No selection made or invalid selection."
fi

