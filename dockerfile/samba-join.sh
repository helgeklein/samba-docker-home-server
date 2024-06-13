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

# Write the Samba configuration file
echo "[global]" > "$CONFIG_FILE"
echo "  workgroup = ${DOMAIN_NETBIOS}" >> "$CONFIG_FILE"
echo "  security = ADS" >> "$CONFIG_FILE"
echo "  realm = ${DOMAIN_FQDN_UCASE}" >> "$CONFIG_FILE"
echo "  winbind separator = +" >> "$CONFIG_FILE"
echo "  idmap config * : backend = tdb" >> "$CONFIG_FILE"
echo "  idmap config * : range = 3000-7999" >> "$CONFIG_FILE"
echo "  idmap config ${DOMAIN_NETBIOS} : backend  = rid" >> "$CONFIG_FILE"
echo "  idmap config ${DOMAIN_NETBIOS} : range  = 10000-999999" >> "$CONFIG_FILE"
echo "  winbind use default domain = yes" >> "$CONFIG_FILE"
echo "  winbind enum users = yes" >> "$CONFIG_FILE"
echo "  winbind enum groups = yes" >> "$CONFIG_FILE"
echo "  vfs objects = acl_xattr" >> "$CONFIG_FILE"
echo "  map acl inherit = yes" >> "$CONFIG_FILE"

# Join the domain
echo "Joining the domain ${DOMAIN_FQDN_LCASE}..."
samba-tool domain join ${DOMAIN_FQDN_LCASE} MEMBER -U administrator