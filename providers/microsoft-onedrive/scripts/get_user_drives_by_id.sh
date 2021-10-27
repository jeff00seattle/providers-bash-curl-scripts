#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--user
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,user: -n 'get_user_drives_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
USER_ID=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --user )            USER_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "$USER_ID" ]
  then
    echo "Provide --user" ; usage ; exit 1
fi

source ../../../shared/credentials/credentials_token_parse.sh

PROTOCOL="https"
HOSTNAME="graph.microsoft.com"
API_VERSION="v1.0"
PATHNAME="${API_VERSION}/users/$USER_ID/drives"
CURL_REQUEST="GET"

source ../../../shared/curl/curl_get.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
  jq '.'

echo -e '\n-------------------------\n'
