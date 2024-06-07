#!/bin/bash

# Variables
DOMAIN_FQDN_LCASE=${DOMAIN_FQDN,,}
DOMAIN_FQDN_UCASE=${DOMAIN_FQDN^^}
DOMAIN_NETBIOS=${DOMAIN_FQDN_UCASE%%.*}

CONFIG_DIR=/etc/samba/config
CONFIG_FILE=$CONFIG_DIR/smb.conf
DEFAULT_CONFIG_FILE=/etc/samba/smb.conf


PROVISION_SCRIPT=samba-provision.sh
