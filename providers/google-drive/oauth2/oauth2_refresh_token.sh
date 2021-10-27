#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose -n 'oauth2_refresh_token.sh' -- "$@"`
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

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

CURL_VERBOSE=""
if [ ${VERBOSE} = true ]
  then
    CURL_VERBOSE="--verbose"
fi

CURL_CMD="curl \"${AUTH_TOKEN_URL}\"
    --request POST
    $CURL_VERBOSE
    --connect-timeout 60
    --write-out 'HTTPSTATUS:%{http_code}'
    --silent
    --data 'grant_type=refresh_token'
    --data-urlencode 'client_id=${CLIENT_ID}'
    --data-urlencode 'client_secret=${CLIENT_SECRET}'
    --data-urlencode 'refresh_token=${REFRESH_TOKEN}'
"

source ../../../shared/curl/curl_http_response.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
  jq '.'

rm -f ../credentials/config/credentials.token.refreshed.json

echo "${HTTP_BODY}" |
  jq '.' > ../credentials/config/credentials.token.refreshed.json

rm -f ../credentials/config/credentials.token.json

jq --arg refresh_token ${REFRESH_TOKEN} '. + {refresh_token: $refresh_token}' ../credentials/config/credentials.token.refreshed.json > ../credentials/config/credentials.token.json

rm -f ../credentials/config/credentials.token.refreshed.json