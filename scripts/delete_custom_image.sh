#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

####
## USAGE: Called by bash when exiting on error.
## Will dump stdout and stderr from lgo file to stdout
####
function error_exit() {
    cat "$MSG_FILE"
    exit 1
}

####
## USAGE: _log <log_message>
####
function _log() {
    echo "$1" > "$MSG_FILE"
}

####
## USAGE: parse_input
## Parsing input from the terraform and assigning to script variable.
## 1. custom_image_id - Custom Image ID which needs to be deleted after vsi creation.
## 2. local_iam_auth_token - Local IAM token
####
function parse_input() {
    _log "## Entering function: ${FUNCNAME[0]}"
    eval "$(jq -r '@sh "custom_image_id=\(.custom_image_id) region=\(.region)"')"
    _log "## Exiting function: ${FUNCNAME[0]}"
}

####
## USAGE: select_riaas_endpoint
## selecting the riaas endpoint based on the IBM Region and assigning to script variable.
## 
function select_riaas_endpoint() {
    rias_endpoint="https://$region.iaas.cloud.ibm.com"
}

####
## USAGE: delete_image
## Delete Custom Image from User Account after VSI Creation.
####
function delete_image() {
    _log "## Entering function: ${FUNCNAME[0]}"
    # Command to delete Custom Image from user account.
    # IC_IAM_TOKEN - Provided by IBM Cloud Schematics
    token=$IC_IAM_TOKEN
    if [[ $token != Bearer* ]]; then
        token="Bearer "$token
    fi
    curl -X DELETE \
    "$rias_endpoint/v1/images/$custom_image_id?version=2020-01-28&generation=2" \
    -H "Authorization: $token" &> "$MSG_FILE"
    _log "## Exiting function: ${FUNCNAME[0]}"
}

####
## USAGE: produce_output
## Returnig output to terraform variable.
## Ex.
##    {
##        "custom_image_id": "r006-7d9aa110-a111-4386-a2a3-65568f2845cb"
##    }
####
function produce_output() {
    _log "## Entering function: ${FUNCNAME[0]}"
    jq -n --arg custom_image_id "$custom_image_id" '{"custom_image_id":$custom_image_id}'
    _log "## Exiting function: ${FUNCNAME[0]}"
}

#### Main Script execution starts here.
# Global variables shared by functoins
MSG_FILE="/tmp/out.log" && rm -f "$MSG_FILE" &> /dev/null && touch "$MSG_FILE" &> /dev/null
rias_endpoint=""

# Main Script functions starts here
parse_input
select_riaas_endpoint
delete_image
produce_output
