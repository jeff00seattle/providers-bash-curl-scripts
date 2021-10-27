#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--access-token <string>]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,access-token:,id: -n 'get_folder_metadata_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ENTITY_ID="0"

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --id )              ENTITY_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

PATHNAME="${API_VERSION}/folders/${ENTITY_ID}"
QUERY="fields=type,id,name,etag,item_collection,parent"

source ./curl/curl_get_folder_metadata_by_id.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" | jq '. | {type, name, id}'

echo -e '\n-------------------------\n'
