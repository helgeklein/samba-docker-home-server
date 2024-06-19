#!/bin/bash

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

# Set local variables
JOIN_SCRIPT=samba-join.sh

# hosts: replace multiple entries with only one
# Note:  the file is mounted by Docker, so we cannot change its inode. We can, however, change its contents.
cp -f /etc/hosts /etc/hosts.new
sed -i "/\\s\\+${FS_NAME}/d" /etc/hosts.new
echo -e "${FS_IP}\\t${FS_NAME}.${DOMAIN_FQDN_LCASE}\\t${FS_NAME}" >> /etc/hosts.new
cp -f /etc/hosts.new /etc/hosts
rm -f /etc/hosts.new

if [ -f "$CONFIG_FILE" ]; then

   # We assume Samba is configured.

   # Create a link from the expected config file location to our custom location on the Docker host
   rm -f "$DEFAULT_CONFIG_FILE"
   ln -s "$CONFIG_FILE" "$DEFAULT_CONFIG_FILE"
   
   # Run supervisord (which in turn starts the Samba processes)
   exec /usr/bin/supervisord --nodaemon --configuration=/etc/supervisor/config/supervisord.conf

else

   echo "No Samba config file found at: $CONFIG_FILE"
   echo "Please exec into the container and join a domain by running the following commands:" 
   echo "   docker exec -it samba bash"
   echo "   $SCRIPT_PATH/$JOIN_SCRIPT"
   sleep infinity

fi
