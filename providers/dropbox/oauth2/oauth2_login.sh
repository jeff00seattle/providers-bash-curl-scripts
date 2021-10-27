#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[--cid]\n
[--csec]\n
[--env DEV, RADMIN, HQTEST, STAGE, DEMO, PROD]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,cid:,csec:,env: -n 'oauth2_login.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false

ARG_CLIENT_ID=""
ARG_CLIENT_SECRET=""
ACCOUNT_ENV=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --cid )             ARG_CLIENT_ID="$2" ; shift; shift ;;
    --csec )            ARG_CLIENT_SECRET="$2" ; shift; shift ;;
    --env )             ACCOUNT_ENV="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_client.sh

source ../credentials/credentials_parse.sh
source ../../../shared/helpers/url_parse_query_string.sh

source ../../../shared/credentials/credentials_redirect.sh
source ../../../shared/helpers/get_auth_state.sh

LOGIN_URL="${AUTH_URL}?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&disable_signup=true&force_reapprove=true&force_reauthentication=true&state=${AUTH_STATE}"

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  LOGIN_URL:  ${LOGIN_URL}"

    echo -e '\n-------------------------\n'

    JSON_QUERY_PARTS=`url_parse_query_string ${LOGIN_URL}`
    echo "${JSON_QUERY_PARTS}" |
        jq '.'
fi

open -na "Google Chrome" --args --incognito "${LOGIN_URL}"
