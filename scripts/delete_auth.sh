#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

# TO-DO comments on input variables

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
## Takes terrform input and sets global variables
####
# eval "$(jq -r '@sh "FOO=\(.foo) BAZ=\(.baz)"')"

function parse_input() {
    _log "## Entering function: ${FUNCNAME[0]}"
    eval "$(jq -r '@sh "id=\(.id) ibmcloud_endpoint=\(.ibmcloud_endpoint) ibmcloud_svc_api_key=\(.ibmcloud_svc_api_key) region=\(.region)"')"
    _log "## Exiting function: ${FUNCNAME[0]}"
}

function login() {
    _log "## Entering function: ${FUNCNAME[0]}"
    # Login to IBMCloud for given region and resource-group
    ibmcloud login -a $ibmcloud_endpoint --apikey $ibmcloud_svc_api_key -r $region &> $MSG_FILE
    _log "## Exiting function: ${FUNCNAME[0]}"
}

function delete_policy() {
    _log "## Entering function: ${FUNCNAME[0]}"
    status=$(eval "ibmcloud iam authorization-policy-delete -f $id")
    _log "## Exiting function: ${FUNCNAME[0]}"
}

function produce_output() {
    _log "## Entering function: ${FUNCNAME[0]}"
    jq -n --arg id "$status" '{"id":$id}'
    _log "## Exiting function: ${FUNCNAME[0]}"
}

# Global variables shared by functoins
MSG_FILE="/tmp/out.log" && rm -f "$MSG_FILE" &> /dev/null && touch "$MSG_FILE" &> /dev/null

parse_input
login
delete_policy
produce_output