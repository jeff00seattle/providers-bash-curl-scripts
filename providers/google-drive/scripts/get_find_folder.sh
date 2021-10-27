#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--access-token <string>]\n
[--folder <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,folder: -n 'get_find_folder.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

VERBOSE=false
HELP=false
PARSE=false

FOLDER=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --folder)           FOLDER="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

# https://developers.google.com/drive/api/v3/search-parameters

if [ -z "${FOLDER}" ]
  then
    echo "Provide --folder-name" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="www.googleapis.com"
API_VERSION="v3"
PATHNAME="drive/${API_VERSION}/files"

QUERY="name = '${FOLDER}' and mimeType = 'application/vnd.google-apps.folder'"

source ./curl/curl_get_list_files.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" | jq '.'

echo -e '\n-------------------------\n'
