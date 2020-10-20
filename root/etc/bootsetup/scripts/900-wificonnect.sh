#!/bin/bash

#
#	Configure WIFI if cann't reach google.com
#

# Check if can access google.com
/usr/bin/wget --spider https://google.com 2>&1

if [ $? -eq 0 ]; then
    printf 'Skipping WiFi Connect\n'
else
    printf 'Starting WiFi Connect\n'
    /usr/local/sbin/wifi-connect --portal-ssid="$HOSTNAME"
fi
