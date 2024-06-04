#!/bin/bash

set -e

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

if [ -f "$CONFIG_FILE" ]; then

   echo "Samba config file found at: $CONFIG_FILE"
   echo "Samba seems to be provisioned already. Exiting." 

   exit 1

fi

# Provision a new AD domain
samba-tool domain provision --use-rfc2307 --server-role=dc --dns-backend=SAMBA_INTERNAL --realm="${DOMAIN_FQDN_UCASE}" --domain="${DOMAIN_NETBIOS}" --host-ip=${DC_IP}

# Disable password expiry, etc.
samba-tool domain passwordsettings set --history-length=0
samba-tool domain passwordsettings set --min-pwd-age=0
samba-tool domain passwordsettings set --max-pwd-age=0

# Replace the default DNS forwarder (127.0.0.11) with our main DNS server IP address
sed -i "/dns forwarder/c\\\tdns forwarder = ${DNSFORWARDER}" "$DEFAULT_CONFIG_FILE"

# Move the Samba config created by the provisioning tool to our target directory
mv "$DEFAULT_CONFIG_FILE" "$CONFIG_FILE"
