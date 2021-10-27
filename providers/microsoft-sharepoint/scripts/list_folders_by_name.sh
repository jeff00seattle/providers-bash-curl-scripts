#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--folder <string>]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,folder:,parent: -n 'list_folders_by_search' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
FOLDER=""
PARENT=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --folder )          FOLDER="$2" ; shift; shift ;;
    --parent )          PARENT="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

source ./curl/curl_get_search_folders_by_name.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
  jq '.'

echo -e '\n-------------------------\n'
