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

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_springcm_token_parse.sh

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
    --header \"Content-Type: application/json; charset=utf-8\"
    --header \"Accept: application/json\"
    --data '{
    \"client_id\":\"${CLIENT_ID}\",
    \"client_secret\":\"${CLIENT_SECRET}\",
    \"refresh_token\":\"${REFRESH_TOKEN}\",
    \"grant_type\":\"refresh_token\"
    }'
"

source ../../../shared/curl/curl_http_response.sh
source ../../../shared/curl/curl_response.sh

echo -e '\n-------------------------\n'

echo "${HTTP_BODY}" |
  jq '.'

echo -e '\n-------------------------\n'

REFRESH_BODY=$(echo "${HTTP_BODY}" | jq --arg refresh_token ${REFRESH_TOKEN} '. + {refresh_token: $refresh_token}')

echo "$REFRESH_BODY" |
  jq '.'

echo -e '\n-------------------------\n'

rm -fR ../credentials/config/credentials.token.json

echo "$REFRESH_BODY" |
  jq '.' > ../credentials/config/credentials.token.json
