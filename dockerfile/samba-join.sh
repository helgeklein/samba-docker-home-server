#!/bin/bash

set -e

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

if [ -f "$CONFIG_FILE" ]; then

   echo "Samba config file found at: $CONFIG_FILE"
   echo "Samba seems to be configured already. Exiting." 

   exit 1

fi

# Write the Kerberos configuration file
echo "[libdefaults]" > "$KERBEROS_CONFIG_FILE"
echo "default_realm = $DOMAIN_FQDN_UCASE" >> "$KERBEROS_CONFIG_FILE"
echo "dns_lookup_realm = false" >> "$KERBEROS_CONFIG_FILE"
echo "dns_lookup_kdc = true" >> "$KERBEROS_CONFIG_FILE"
