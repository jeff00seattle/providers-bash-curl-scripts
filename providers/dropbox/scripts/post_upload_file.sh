#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--parent <string>]\n
[--file <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,parent:,file: -n '$0' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

FOLDER_ID=""
PARENT_PATH=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --parent )          PARENT_PATH="$2" ; shift; shift ;;
    --file )            FILE_PATH="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="content.dropboxapi.com"
API_VERSION="2"
PATHNAME="${API_VERSION}/files/upload"

source ./curl/curl_post_upload_file.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
	echo "${HTTP_BODY}" |
	    jq ". | \
	        with_entries(if .key == \".tag\" then .key = \"type\" else . end) | \
	        with_entries(if .key == \"path_display\" then .key = \"path\" else . end) | \
	        del(.path_lower) | \
	        del(.client_modified) | \
	        del(.server_modified) | \
	        del(.rev) | \
	        del(.is_downloadable) | \
	        del(.content_hash)
	        "
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
