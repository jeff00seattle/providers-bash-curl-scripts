#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,parent: -n 'list_files.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

# echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false
OBJECTS_TYPE="documents"
OBJECTS_ID=""

while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true ; shift ;;
    -p | --parse )      PARSE=true ; shift ;;
    --parent)           OBJECTS_ID=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_docusign_account_parse.sh
source ../credentials/credentials_springcm_account_parse.sh

source ../credentials/credentials_docusign_token_parse.sh

source ./curl/curl_get_list_objects.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
    echo "${HTTP_BODY}" |
        jq '{Items: [.Items[] | {Name: .Name, ParentFolder: .ParentFolder}], Total: .Total}'
else
    echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
