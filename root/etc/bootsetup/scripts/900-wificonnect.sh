#!/bin/bash

#
#	Configure WIFI if cann't reach google.com
#

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

WIFICOUNTRY_FILE=$BOOTSETUP_CONFIG/wifi_country

# Check if config file exists
if [ ! -f "$WIFICOUNTRY_FILE" ]; then
	wifi_country="$(cat $WIFICOUNTRY_FILE)"
else
    wifi_country="BR"
fi

# Check if can access google.com
echo "bootsetup: Begin test connection to https://google.com..."
if ping -c 3 8.8.8.8 > /dev/null; then
	echo "bootsetup: Have internet connection"
else
	echo "bootsetup: Start WIFI connection setup"
	sudo iw reg set "$wifi_country"
	sleep 2
	sudo rfkill unblock all
	sleep 2
	sudo /usr/local/sbin/wifi-connect --portal-ssid="$HOSTNAME"
	echo "bootsetup: End WIFI connection setup"
fi

