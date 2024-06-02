#!/bin/bash

# Call the vars script
SCRIPT_PATH=$(dirname "$0")
source "$SCRIPT_PATH"/vars.sh

if [ -f "$CONFIG_FILE" ]; then

   # We assume Samba is provisioned
   exec smbd --configfile="$CONFIG_FILE" --foreground --debug-stdout --debuglevel=1 --no-process-group

else

   echo "No Samba config file found at: $CONFIG_FILE"
   echo "Please exec into the container and provision Samba." 
   sleep infinity

fi
