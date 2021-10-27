#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,id: -n 'get_file_metadata_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false

FILE_ID="0"

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --id )              FILE_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [[ -z "${FILE_ID}" ]]
  then
    echo "Provide --id" ; usage ; exit 1
fi

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

PATHNAME="${API_VERSION}/files/${FILE_ID}"
QUERY="fields=type,id,name,etag,parent"

source ./curl/curl_get_file_metadata_by_id.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" | jq '.'

echo -e '\n-------------------------\n'
