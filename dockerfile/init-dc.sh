#!/bin/bash

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

# Set local variables
PROVISION_SCRIPT=samba-provision.sh

if [ -f "$CONFIG_FILE" ]; then

   # We assume Samba is provisioned.

   # Use the Kerberos configuration the provisioning tool created for us
   cp -f /var/lib/samba/private/krb5.conf "$KERBEROS_CONFIG_FILE"
   
   # Create a link from the expected config file location to our custom location on the Docker host
   rm -f "$DEFAULT_CONFIG_FILE"
   ln -s "$CONFIG_FILE" "$DEFAULT_CONFIG_FILE"
   
   # Run Samba (blocking)
   exec samba --interactive --no-process-group

else

   echo "No Samba config file found at: $CONFIG_FILE"
   echo "Please exec into the container and provision Samba by running the following commands:" 
   echo "   docker exec -it samba bash"
   echo "   $SCRIPT_PATH/$PROVISION_SCRIPT"
   sleep infinity

fi
