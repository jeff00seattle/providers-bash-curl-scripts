#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,id: -n '$0' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
RECURSIVE=false
PARENT_ID=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -r | --recursive )  RECURSIVE=true; shift ;;
    --id )          	PARENT_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="api.dropboxapi.com"
API_VERSION="2"
PATHNAME="${API_VERSION}/files/list_folder"

source ./curl/curl_post_list_folder.sh
source ../../../shared/curl/curl_response.sh

PATHNAME="${API_VERSION}/files/delete_v2"

for entry_id in $(echo "${HTTP_BODY}" | jq '.entries' | jq '.[].id'); do
    ENTITY_ID=$(echo ${entry_id} | sed -e 's/^"//' -e 's/"$//')
    echo "Delete ENTITY_ID=${ENTITY_ID}"
    source ./curl/curl_post_delete_by_id.sh
    source ../../../shared/curl/curl_response.sh
done

echo -e '\n-------------------------\n'
