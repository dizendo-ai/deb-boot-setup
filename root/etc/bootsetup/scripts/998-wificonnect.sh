#!/bin/bash

#
#	Configure WIFI if cann't reach google.com
#	@see https://askubuntu.com/questions/227297/how-do-i-remove-obsolete-network-entries-from-network-connection-applet
#

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket

WIFICOUNTRY_FILE=$BOOTSETUP_CONFIG/wifi_country

# Check if config file exists
if [ ! -f "$WIFICOUNTRY_FILE" ]; then
	wifi_country="$(cat $WIFICOUNTRY_FILE)"
else
    wifi_country="BR"
fi

# Wait devices come online
sleep 10

# Check if can access google.com
echo "bootsetup: Begin test connection to https://google.com..."
if ping -c 3 8.8.8.8 > /dev/null; then
	echo "bootsetup: Have internet connection"
else
	echo "bootsetup: Start WIFI connection setup"
	# Scan avaiable WIFI LAN's
	#/sbin/iwlist wlan0 scan
	#sleep 5
	# Remove saved connections
	/usr/bin/nmcli --fields UUID,TYPE con show | grep wifi | awk '{print $1}' | while read line; do /usr/bin/nmcli con delete uuid $line; done
	sleep 2
	sudo iw reg set "$wifi_country"
	sleep 2
	sudo rfkill unblock all
	sleep 2
	sudo /usr/local/sbin/wifi-connect --portal-ssid="$HOSTNAME"
	sleep 5
	echo "bootsetup: End WIFI connection setup"
fi

