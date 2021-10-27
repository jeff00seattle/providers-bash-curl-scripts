#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,id: -n '$0' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ENTITY_ID=""

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

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="api.dropboxapi.com"
API_VERSION="2"
PATHNAME="${API_VERSION}/files/get_metadata"

if [ -z "${ENTITY_ID}" ]
  then
    echo "Provide --id" ; usage ; exit 1
fi

source ./curl/curl_post_get_metadata_by_id.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq ". | \
        with_entries(if .key == \".tag\" then .key = \"type\" else . end) | \
        with_entries(if .key == \"path_display\" then .key = \"path\" else . end) | \
        del(.path_lower)"

echo -e '\n-------------------------\n'
