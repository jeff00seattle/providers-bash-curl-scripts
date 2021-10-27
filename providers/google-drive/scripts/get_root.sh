#!/usr/bin/env bash

# https://developers.google.com/drive/api/v2/reference/children/list#examples

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose -n 'get_root.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false

source ../../../shared/credentials/credentials_token_parse.sh

if [ -z "${ACCESS_TOKEN}" ]
  then
    echo "Missing ACCESS_TOKEN"; exit 1
fi

CURL_CMD="curl \"https://www.googleapis.com/drive/v2/files/root/children?access_token=${ACCESS_TOKEN}\"
  --request GET
  --verbose
  --connect-timeout 60
  --write-out 'HTTPSTATUS:%{http_code}'
  --silent
"

source ../../../shared/curl/curl_http_response.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'
