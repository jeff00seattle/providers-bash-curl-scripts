#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--path <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,path: -n 'get_user_drive_folders_list_by_path.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARENT_FOLDER_PATH=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true ; shift ;;
    --path )            PARENT_FOLDER_PATH=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "$PARENT_FOLDER_PATH" ]
  then
    echo "Provide --path" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/me/drive/root:/${PARENT_FOLDER_PATH}:/children"
CURL_REQUEST="GET"

source ../../../shared/curl/curl_get.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'