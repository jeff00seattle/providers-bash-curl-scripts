#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--folder <string>]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,folder:,parent: -n '$0' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

FOLDER_NAME="$(uuidgen | tr '[:upper:]' '[:lower:]')"
PARENT_PATH=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --folder )          FOLDER_NAME="$2" ; shift; shift ;;
    --parent )          PARENT_PATH="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="api.dropboxapi.com"
API_VERSION="2"
PATHNAME="${API_VERSION}/files/create_folder_v2"

source ./curl/curl_post_create_folder.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
	echo "${HTTP_BODY}" |
	    jq '.metadata' | \
	    jq ". | \
	        with_entries(if .key == \".tag\" then .key = \"type\" else . end) | \
	        with_entries(if .key == \"path_display\" then .key = \"path\" else . end) | \
	        del(.path_lower)"
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
