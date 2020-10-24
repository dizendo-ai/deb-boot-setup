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
mkdir -p /opt/shellhub

# Create app start script
echo "bootsetup: Start creating shellhub env file"
cat > /opt/shellhub/.env <<EOF
SHELLHUB_TENANT_ID=$shellhub_tenant_id
SHELLHUB_SERVER_ADDRESS=$shellhub_server_address
SHELLHUB_VERSION=$shellhub_version
SHELLHUB_PREFERRED_HOSTNAME=$HOSTNAME
SHELLHUB_PRIVATE_KEY=/host/etc/shellhub.key
EOF
echo "bootsetup: End creating shellhub env file"

rm $SHELLHUB_FILE

