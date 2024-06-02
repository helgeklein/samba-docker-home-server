#!/bin/bash

set -e

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

SAMBA_CONFIG_FILE=/etc/samba/smb.conf

if [ -f "$CONFIG_FILE" ]; then

   echo "Samba config file found at: $CONFIG_FILE"
   echo "Samba seems to be provisioned already. Exiting." 

   exit 1

fi

# Provision a new AD domain
samba-tool domain provision --use-rfc2307 --server-role=dc --dns-backend=SAMBA_INTERNAL --realm="${DOMAIN_FQDN_UCASE}" --domain="${DOMAIN_NETBIOS}" --adminpass="${DOM_ADMIN_PW}"

# Use the Kerberos configuration the provisioning tool created for us
cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf

# Replace the default DNS forwarder (127.0.0.11) with our main DNS server IP address
sed -i "/dns forwarder/c\\tdns forwarder = ${DNSFORWARDER}" "$SAMBA_CONFIG_FILE"

# Move the Samba config created by the provisioning tool to our target directory
mv "$SAMBA_CONFIG_FILE" "$CONFIG_FILE"
