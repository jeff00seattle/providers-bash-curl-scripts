#!/usr/bin/env bash
USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--account\n
--user\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hv --long help,verbose,account:,user: -n 'get_docusign_account_user.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
ACCOUNT_ID=""
USER_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --account )         ACCOUNT_ID=$2 ; shift; shift ;;
    --user )            USER_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_docusign_parse.sh
source ../credentials/credentials_docusign_token_parse.sh
source ../credentials/credentials_docusign_userinfo_parse.sh

if [ -n "$ACCOUNT_ID" ]
  then
    DOCUSIGN_ACCOUNT_ID=$ACCOUNT_ID
fi

if [ -z "$USER_ID" ]
  then
    echo "Provide --user" ; usage ; exit 1
fi

source ./curl/curl_get_docusign_account_user.sh
source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
  jq '.'

echo -e '\n-------------------------\n'