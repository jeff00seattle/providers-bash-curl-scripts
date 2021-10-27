#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--cursor <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,cursor: -n '$0' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

CURSOR=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --cursor )          CURSOR="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="api.dropboxapi.com"
API_VERSION="2"
PATHNAME="${API_VERSION}/files/list_folder/continue"

source ./curl/curl_post_list_folder_continue.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
	echo "${HTTP_BODY}" |
	    jq '.entries' | \
	    jq "map(
	        with_entries(if .key == \".tag\" then .key = \"type\" else . end) | \
	        with_entries(if .key == \"path_display\" then .key = \"path\" else . end) | \
	        del(.path_lower))"
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'