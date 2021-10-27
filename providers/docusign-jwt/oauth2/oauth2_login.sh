#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--env HQTEST, STAGE, DEMO, PROD]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,env: -n 'oauth2_login.sh' -- "$@"`
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
source ../../../shared/helpers/url_parse_query_string.sh

SECURITY_TOKEN=$(uuidgen)

AUTH_LOGIN_URL="${AUTH_URL}?response_type=code&scope=${AUTH_SCOPE}&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&state=${SECURITY_TOKEN}"

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    JSON_QUERY_PARTS=`url_parse_query_string ${AUTH_LOGIN_URL}`
    echo "${JSON_QUERY_PARTS}" |
        jq '.'

    echo -e '\n-------------------------\n'

    echo "    AUTH_LOGIN_URL: \"${AUTH_LOGIN_URL}\""

    echo -e '\n-------------------------\n'
fi

open -na "Google Chrome" --args --incognito "${AUTH_LOGIN_URL}"
