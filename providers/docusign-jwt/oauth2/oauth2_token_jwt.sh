#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--env HQTEST, STAGE, DEMO, PROD]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,env: -n 'oauth2_token.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ACCOUNT_ENV=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --env )             ACCOUNT_ENV="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_docusign_parse.sh

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
    --data 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${JWT_ASSERTION}'
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

