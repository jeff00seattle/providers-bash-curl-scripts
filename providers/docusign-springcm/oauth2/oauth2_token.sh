#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose -n 'oauth2_token.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_springcm_parse.sh
source ../../../shared/credentials/credentials_code_parse.sh

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_CMD="curl \"${AUTH_TOKEN_URL}\"
    --request POST
    $CURL_VERBOSE
    --write-out 'HTTPSTATUS:%{http_code}'
    --silent
    --data 'grant_type=authorization_code'
    --data-urlencode 'code=${AUTHENTICATION_CODE}'
    --data-urlencode 'client_id=${CLIENT_ID}'
    --data-urlencode 'client_secret=${CLIENT_SECRET}'
    --data-urlencode 'redirect_uri=${REDIRECT_URI}'
"

source ../../../shared/curl/curl_http_response.sh
source ../../../shared/curl/curl_response.sh

echo -e '\n-------------------------\n'

echo "${HTTP_BODY}" |
  jq '.'

echo -e '\n-------------------------\n'

rm -f ../credentials/config/credentials.token.json

echo "${HTTP_BODY}" |
  jq '.' > ../credentials/config/credentials.token.json

