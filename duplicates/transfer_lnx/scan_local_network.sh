#!/bin/bash
# Scan local network
TEMP_FILE="scan_temp"

sudo nmap   -sn 192.168.1.0/24 | sed -n -e '/.*down.*/d' -e '/scan report for/p' > $TEMP_FILE

if [ -f "$(pwd)/scan_temp" ];then
     cat $TEMP_FILE | less
fi

#rm $TEMP_FILE
