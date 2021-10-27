#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-r|--recursive]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,recursive,id: -n 'delete_all_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
RECURSIVE=false
PARENT_ID="0"

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

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

PATHNAME="${API_VERSION}/folders/${PARENT_ID}/items"
QUERY="fields=id,name,type,item_collection,modified_at"

source ./curl/curl_get_list_all.sh
source ../../../shared/curl/curl_response.sh

for entry_id in $(echo "${HTTP_BODY}" | jq '.entries' | jq '.[].id'); do
    ENTITY_ID=$(echo ${entry_id} | sed -e 's/^"//' -e 's/"$//')
    echo "Delete ENTITY_ID=${ENTITY_ID}"
    PATHNAME="${API_VERSION}/folders/${ENTITY_ID}"
    source ./curl/curl_delete_folder_by_id.sh
    source ../../../shared/curl/curl_response.sh
done

echo -e '\n-------------------------\n'
