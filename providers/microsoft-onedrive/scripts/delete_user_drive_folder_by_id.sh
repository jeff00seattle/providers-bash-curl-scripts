#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--id <string>]\n"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,id: -n 'delete_user_drive_folder_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false
FOLDER_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true ; shift ;;
    --id )              FOLDER_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "$FOLDER_ID" ]
  then
    echo "Provide --id" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/me/drive/items/$FOLDER_ID"
CURL_REQUEST="DELETE"

source curl/curl_delete_user_drive_folder_by_id.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'
