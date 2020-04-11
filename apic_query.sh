#!/bin/bash
#
# Invocation: sh apic_query.sh <APIC-FQDN or IP> <API-Operation> <username> <password>
# Example: sh apic_query.sh sandboxapicdc.cisco.com /api/class/fabricHealthTotal.json telegraf telegraf
#

# Variable definition
apic=$1
operation=$2
user=$3
pass=$4
# Create random cookie filename to avoid race conditions by multiple, concurrent script execution
cookiefilename=apic_cookie_$RANDOM

# APIC Login and store session cookie
curl -s -k -d "<aaaUser name=$user pwd=$pass/>" -c /etc/telegraf/$cookiefilename -X POST https://$apic/api/mo/aaaLogin.xml > /dev/null
# APIC Query Operation
curl -s -k -X GET https://$apic$operation -b /etc/telegraf/$cookiefilename
# APIC Logout
curl -s -k -d "<aaaUser name=$user/>" -X POST https://$apic/api/mo/aaaLogout.json -b /etc/telegraf/$cookiefilename > /dev/null
# Remove cookie
rm /etc/telegraf/$cookiefilename