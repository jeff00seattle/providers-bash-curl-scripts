#!/usr/bin/env bash

source ../../../shared/helpers/url_parse_query_string.sh

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--url\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,url: -n 'oauth2_code.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
AUTH_CODE_URL=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --url )             AUTH_CODE_URL="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "$AUTH_CODE_URL" ]
  then
    echo "Provide --url" ; usage ; exit 1
fi

JSON_QUERY_PARTS=`url_parse_query_string $AUTH_CODE_URL`

echo -e '\n-------------------------\n'

echo "${JSON_QUERY_PARTS}" |
  jq '.'

echo -e '\n-------------------------\n'

rm -f ../credentials/config/credentials.code.json

echo ${JSON_QUERY_PARTS} |
  jq '.' > ../credentials/config/credentials.code.json
