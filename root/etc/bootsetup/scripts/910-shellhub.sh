#!/bin/bash

#
#	Configure shellhub
#

SHELLHUB_FILE=$BOOTSETUP_ROOT/shellhub
SHELLHUB_SERVER_ADDRESS=$BOOTSETUP_CONFIG/shellhub_server_address
SHELLHUB_TENANT_ID=$BOOTSETUP_CONFIG/shellhub_tenant_id
SHELLHUB_VERSION=$BOOTSETUP_CONFIG/shellhub_version

# Check if config file exists
if [ ! -f "$SHELLHUB_FILE" ]; then
	exit 0
fi

# Check if tenant ID config file exists
if [ ! -f "$SHELLHUB_TENANT_ID" ]; then
	echo "bootsetup: Missing file $SHELLHUB_TENANT_ID"
    exit 0
else
    shellhub_tenant_id="$(cat $SHELLHUB_TENANT_ID)"
fi

# Check if server address config file exists
if [ ! -f "$SHELLHUB_SERVER_ADDRESS" ]; then
    shellhub_server_address="https://cloud.shellhub.io"
else
    shellhub_server_address="$(cat $SHELLHUB_SERVER_ADDRESS)"
fi

# Check if version config file exists
if [ ! -f "$SHELLHUB_VERSION" ]; then
    shellhub_version="v0.4.2"
else
    shellhub_version="$(cat $SHELLHUB_VERSION)"
fi

# Create app directory
mkdir -p /home/pi/dizendo/apps/shellhub

# Create app start script
echo "bootsetup: Start creating shellhub start script"
echo "/usr/bin/docker run -d --name=shellhub --restart=on-failure --privileged --net=host --pid=host -v /:/host -v /dev:/dev -v /var/run/docker.sock:/var/run/docker.sock -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -e SHELLHUB_SERVER_ADDRESS=$shellhub_server_address -e SHELLHUB_PRIVATE_KEY=/host/etc/shellhub.key -e SHELLHUB_TENANT_ID=$shellhub_tenant_id -e SHELLHUB_PREFERRED_HOSTNAME=$HOSTNAME shellhubio/agent:$shellhub_version" > /home/pi/dizendo/apps/shellhub/start.sh
echo "/usr/bin/docker stop shellhub; sleep 2; /usr/bin/docker rm shellhub" > /home/pi/dizendo/apps/shellhub/stop.sh
chmod ugo+x /home/pi/dizendo/apps/shellhub/start.sh
chmod ugo+x /home/pi/dizendo/apps/shellhub/stop.sh
chown pi:pi -R /home/pi/dizendo
echo "bootsetup: End creating shellhub start script"

rm $SHELLHUB_FILE

