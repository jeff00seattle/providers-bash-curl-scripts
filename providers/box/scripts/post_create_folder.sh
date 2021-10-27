#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--folder <string>]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,folder:,parent: -n 'create_folder.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false

FOLDER="$(uuidgen | tr '[:upper:]' '[:lower:]')"
PARENT="0"

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --folder )          FOLDER="$2" ; shift; shift ;;
    --parent )          PARENT="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_parse.sh
source ../../../shared/credentials/credentials_token_parse.sh

PATHNAME="${API_VERSION}/folders"

source ./curl/curl_post_create_folder.sh
source ../../../shared/curl/curl_response.sh

if [ ${PARSE} = true ]
  then
	echo "${HTTP_BODY}" |
	    jq '. | {type, name, id, parent: .parent | {type, name, id}}'
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
