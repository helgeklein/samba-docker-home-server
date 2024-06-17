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

# krb5.conf: write the Kerberos configuration file
echo "[libdefaults]" > "$KERBEROS_CONFIG_FILE"
echo "default_realm = $DOMAIN_FQDN_UCASE" >> "$KERBEROS_CONFIG_FILE"
echo "dns_lookup_realm = false" >> "$KERBEROS_CONFIG_FILE"
echo "dns_lookup_kdc = true" >> "$KERBEROS_CONFIG_FILE"

# smb.conf: write the Samba configuration file
echo "[global]" > "$DEFAULT_CONFIG_FILE"
echo "  workgroup = ${DOMAIN_NETBIOS}" >> "$DEFAULT_CONFIG_FILE"
echo "  security = ADS" >> "$DEFAULT_CONFIG_FILE"
echo "  realm = ${DOMAIN_FQDN_UCASE}" >> "$DEFAULT_CONFIG_FILE"
echo "  winbind separator = +" >> "$DEFAULT_CONFIG_FILE"
echo "  idmap config * : backend = tdb" >> "$DEFAULT_CONFIG_FILE"
echo "  idmap config * : range = 3000-7999" >> "$DEFAULT_CONFIG_FILE"
echo "  idmap config ${DOMAIN_NETBIOS} : backend  = rid" >> "$DEFAULT_CONFIG_FILE"
echo "  idmap config ${DOMAIN_NETBIOS} : range  = 10000-999999" >> "$DEFAULT_CONFIG_FILE"
echo "  winbind use default domain = yes" >> "$DEFAULT_CONFIG_FILE"
echo "  winbind enum users = yes" >> "$DEFAULT_CONFIG_FILE"
echo "  winbind enum groups = yes" >> "$DEFAULT_CONFIG_FILE"
echo "  vfs objects = acl_xattr" >> "$DEFAULT_CONFIG_FILE"
echo "  map acl inherit = yes" >> "$DEFAULT_CONFIG_FILE"
echo "  username map = ${USERMAP_FILE}" >> "$DEFAULT_CONFIG_FILE"

# user.map: map the domain's Administrator account to the local root user
echo "!root = ${DOMAIN_NETBIOS}\Administrator" > "$USERMAP_FILE"

# hosts: replace multiple entries with only one
# Note:  the file is mounted by Docker, so we cannot change its inode. We can, however, change its contents.
cp -f /etc/hosts /etc/hosts.new
sed -i "/\\s\\+${FS_NAME}/d" /etc/hosts.new
echo -e "${FS_IP}\\t${FS_NAME}.${DOMAIN_FQDN_LCASE}\\t${FS_NAME}" >> /etc/hosts.new
cp -f /etc/hosts.new /etc/hosts
rm -f /etc/hosts.new

# If /var/lib/samba is a Docker bind mount the "private" directory needs to be created explicitly or the domain join fails
if [ ! -d /var/lib/samba/private ]; then
   mkdir /var/lib/samba/private
fi

# Join the domain
echo "Joining the domain ${DOMAIN_FQDN_LCASE}..."
samba-tool domain join ${DOMAIN_FQDN_LCASE} MEMBER -U Administrator

# smb.conf: move the config created/modified/used by the join tool to our target directory
mv "$DEFAULT_CONFIG_FILE" "$CONFIG_FILE"
