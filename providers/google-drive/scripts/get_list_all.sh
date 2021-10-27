#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,parent: -n 'get_list_all.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

PARENT="root"

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --parent )          PARENT="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="www.googleapis.com"
API_VERSION="v3"
PATHNAME="drive/${API_VERSION}/files"

QUERY="'${PARENT}' in parents"

source ./curl/curl_get_list_all.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
    echo "${HTTP_BODY}"|
        jq '.files |
        map({mimeType, name, id}) |
        map(.type = if (.mimeType) == "application/vnd.google-apps.folder" then "folder" else "file" end)'
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
