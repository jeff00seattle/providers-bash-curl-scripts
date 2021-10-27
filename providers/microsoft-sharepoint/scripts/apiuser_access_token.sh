#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-v|--verbose]\n
[-h|--help]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o vh --long verbose,help -n 'get_auth_uat.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

VERBOSE=false
HELP=false

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

CURL_REQUEST="POST"

source ../credentials/credentials_parse.sh

source ./curl/curl_apiuser_access_token.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'