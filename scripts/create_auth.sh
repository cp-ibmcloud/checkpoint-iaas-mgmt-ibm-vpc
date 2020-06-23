#!/bin/bash

# Exit if any of the intermediate steps fail
set -e
#set -x
# TO-DO comments on input variables

####
## USAGE: Called by bash when exiting on error.
## Will dump stdout and stderr from log file to stdout
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
    eval "$(jq -r '@sh "ibmcloud_endpoint=\(.ibmcloud_endpoint) ibmcloud_svc_api_key=\(.ibmcloud_svc_api_key) region=\(.region) source_service_name=\(.source_service_name) target_service_name=\(.target_service_name) roles=\(.roles) source_service_account=\(.source_service_account) source_resource_type=\(.source_resource_type) target_resource_instance_id=\(.target_resource_instance_id)"')"
    _log "## Exiting function: ${FUNCNAME[0]}"
}

function is_policy_exist() {
    _log "## Entering function: ${FUNCNAME[0]}"
  #fetch existing iam policies
    cmd="ibmcloud iam authorization-policies --output json | jq 'map(select(.resources[]|(.attributes[].value == \"$target_resource_instance_id\" and .attributes[].value == \"$target_service_name\")))' | jq 'map(select( .subjects[] | (.attributes[].value == \"$source_service_name\" and .attributes[].value == \"$source_service_account\" and .attributes[].value == \"$source_resource_type\")))' | jq 'map(select( .roles[]| (.display_name == \"$roles\")))| .[].id'"

    #fetch existing iam policies
   # cmd='ibmcloud iam authorization-policies --output json | jq "map(select(any(.resources[]; ((.attributes[].value == \"$target_resource_instance_id\" ) and (.attributes[].value == \"$target_service_name\")))) | select( any(.subjects[]; ((.attributes[].value == \"$source_service_name\") and (.attributes[].value == \"$source_service_account\" ) and (.attributes[].value == \"$source_resource_type\")))) | select( any(.roles[]; (.display_name == \"$roles\"))) ) "'

    id=$(eval ${cmd}) 
    #$id=$(echo $policies | jq '.[].id' )
    _log "## Exiting function: ${FUNCNAME[0]}"
} 

function login() {
    _log "## Entering function: ${FUNCNAME[0]}"
    # Login to IBMCloud for given region and resource-group
    ibmcloud login -a $ibmcloud_endpoint --apikey $ibmcloud_svc_api_key -r $region &> $MSG_FILE
    _log "## Exiting function: ${FUNCNAME[0]}"
}

function create_policy() {
    _log "## Entering function: ${FUNCNAME[0]}"
    
  if [ -z $id ] ; then
     id=$(eval "ibmcloud iam authorization-policy-create $source_service_name $target_service_name $roles --source-service-account $source_service_account --source-resource-type $source_resource_type --target-service-instance-id $target_resource_instance_id --output json | jq '.id'")
   fi
    _log "## Exiting function: ${FUNCNAME[0]}"
}

function produce_output() {
    _log "## Entering function: ${FUNCNAME[0]}"
    jq -n --arg id "$id" '{"id":$id}'
    _log "## Entering function: ${FUNCNAME[0]}"
}

# Global variables shared by functoins
MSG_FILE="/tmp/out.log" && rm -f "$MSG_FILE" &> /dev/null && touch "$MSG_FILE" &> /dev/null

parse_input
login
is_policy_exist
create_policy
produce_output
