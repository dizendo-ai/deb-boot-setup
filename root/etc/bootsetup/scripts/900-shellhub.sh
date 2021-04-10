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
    SHELLHUB_TENANT_ID="$(cat $SHELLHUB_TENANT_ID)"
fi

# Check if server address config file exists
if [ ! -f "$SHELLHUB_SERVER_ADDRESS" ]; then
    SHELLHUB_SERVER_ADDRESS="https://cloud.shellhub.io"
else
    SHELLHUB_SERVER_ADDRESS="$(cat $SHELLHUB_SERVER_ADDRESS)"
fi

# Check if version config file exists
if [ ! -f "$SHELLHUB_VERSION" ]; then
    SHELLHUB_VERSION="v0.6.3"
else
    SHELLHUB_VERSION="$(cat $SHELLHUB_VERSION)"
fi

# Defaults
SHELLHUB_PREFERRED_HOSTNAME=$HOSTNAME
SHELLHUB_PRIVATE_KEY=/host/etc/shellhub.key

# Create app directory
mkdir -p /opt/shellhub

# Create app start script
echo "bootsetup: Start creating shellhub start script"
cat > /opt/shellhub/start.sh <<EOF
#!/usr/bin/env bash

/usr/bin/docker run --rm --name=shellhub --privileged --net=host --pid=host -v /:/host -v /dev:/dev -v /var/run/docker.sock:/var/run/docker.sock -v /etc/passwd:/etc/passwd -v /etc/group:/etc/group -e SHELLHUB_SERVER_ADDRESS=$SHELLHUB_SERVER_ADDRESS -e SHELLHUB_PRIVATE_KEY=$SHELLHUB_PRIVATE_KEY -e SHELLHUB_TENANT_ID=$SHELLHUB_TENANT_ID -e SHELLHUB_PREFERRED_HOSTNAME=$HOSTNAME shellhubio/agent:$SHELLHUB_VERSION
EOF
echo "bootsetup: End creating shellhub start script"

# Create app env file
echo "bootsetup: Start creating shellhub env file"
cat > /opt/shellhub/.env <<EOF
SHELLHUB_TENANT_ID=$SHELLHUB_TENANT_ID
SHELLHUB_SERVER_ADDRESS=$SHELLHUB_SERVER_ADDRESS
SHELLHUB_VERSION=$SHELLHUB_VERSION
SHELLHUB_PREFERRED_HOSTNAME=$SHELLHUB_PREFERRED_HOSTNAME
SHELLHUB_PRIVATE_KEY=$SHELLHUB_PRIVATE_KEY
EOF
echo "bootsetup: End creating shellhub env file"

chmod ugo+x /opt/shellhub/start.sh
rm $SHELLHUB_FILE

