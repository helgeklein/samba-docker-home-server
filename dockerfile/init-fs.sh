#!/bin/bash

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

# Set local variables
JOIN_SCRIPT=samba-join.sh

if [ -f "$CONFIG_FILE" ]; then

   # We assume Samba is configured.

   # Create a link from the expected config file location to our custom location on the Docker host
   rm -f "$DEFAULT_CONFIG_FILE"
   ln -s "$CONFIG_FILE" "$DEFAULT_CONFIG_FILE"
   
   # Run Samba (blocking)
   exec samba --interactive --no-process-group

else

   echo "No Samba config file found at: $CONFIG_FILE"
   echo "Please exec into the container and join a domain by running the following commands:" 
   echo "   docker exec -it samba bash"
   echo "   $SCRIPT_PATH/$JOIN_SCRIPT"
   sleep infinity

fi