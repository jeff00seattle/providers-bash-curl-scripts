#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[hqtest]\n
[stage]\n
[demo]\n
[prod]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,hqtest,stage,demo,prod -n 'oauth2_deploy_login.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi
eval set -- "$OPTS"

HELP=false
VERBOSE=false
DEPLOY=''

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --hqtest )          DEPLOY='hqtest'; shift ;;
    --stage )           DEPLOY='stage'; shift ;;
    --demo )            DEPLOY='demo'; shift ;;
    --prod )            DEPLOY='prod'; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_deploy_parse.sh
source ../../../shared/helpers/url_parse_query_string.sh

case "${DEPLOY}" in
  'hqtest' )
    CLIENT_ID=$HQTEST_CLIENT_ID
    REDIRECT_URI=$HQTEST_REDIRECT_URI
    ;;
  'stage' )
    CLIENT_ID=$STAGE_CLIENT_ID
    REDIRECT_URI=$STAGE_REDIRECT_URI
    ;;
  'demo' )
    CLIENT_ID=$DEMO_CLIENT_ID
    REDIRECT_URI=$DEMO_REDIRECT_URI
    ;;
  'prod' )
    CLIENT_ID=$PROD_CLIENT_ID
    REDIRECT_URI=$PROD_REDIRECT_URI
    ;;
esac

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "    CLIENT_ID:    \"${CLIENT_ID}\""
    echo "    REDIRECT_URI: \"${REDIRECT_URI}\""

    echo -e '\n-------------------------\n'
fi

if [ "${CLIENT_ID}" == "[** CLIENT_ID **]" ]
  then
    echo "Provide 'CLIENT_ID' for Deploy '${DEPLOY}'" ; exit 1
fi

SECURITY_TOKEN=$(uuidgen)

LOGIN_URL="${AUTH_URL}?response_type=code&client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&state=${SECURITY_TOKEN}"

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