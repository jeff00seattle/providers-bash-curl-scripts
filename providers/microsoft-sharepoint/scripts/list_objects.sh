#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--folders]\n
[--files]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,folders,files,parent: -n 'list_objects.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
OBJECTS_TYPE=""
OBJECTS_ID=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true ; shift ;;
    --parent)           OBJECTS_ID=$2 ; shift; shift ;;
    --folders)          OBJECTS_TYPE="folders" ; shift ;;
    --files)            OBJECTS_TYPE="documents" ; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

source ./curl/curl_list_objects.sh
source ../../../shared/curl/curl_response.sh

 echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'
