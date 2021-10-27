#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--random]\n
[--folder <string>]\n
[--parent <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,random,parse,folder:,parent: -n 'create_folder.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false
PARENT_RANDOM=false

FOLDER_NAME="$(uuidgen | tr '[:upper:]' '[:lower:]')"
FOLDER_NAME=${FOLDER_NAME//[-._]/}
FOLDER_NAME=${FOLDER_NAME:0:8}

PARENT_ID="root"

echo -e '\n-------------------------\n'

echo "  HELP: $HELP"
echo "  VERBOSE: ${VERBOSE}"
echo "  PARSE: ${PARSE}"
echo "  PARENT_RANDOM: $PARENT_RANDOM"
echo "  PARENT_ID: ${PARENT_ID}"

echo -e '\n-------------------------\n'

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true; shift ;;
    --random )          PARENT_RANDOM=true; shift ;;
    --folder )          FOLDER_NAME="$2" ; shift; shift ;;
    --parent )          PARENT_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_springcm_token_parse.sh

if [[ ${VERBOSE} = true ]]
  then
    echo "  PROTOCOL: ${PROTOCOL}"
    echo "  API_HOSTNAME: ${API_HOSTNAME}"
    echo "  API_VERSION: ${API_VERSION}"
fi
PATHNAME="${API_VERSION}/folders"

PARENT_CURL_HREF=""
if [[ $PARENT_RANDOM = true ]]
  then
    FOLDER_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
    source helpers/set_folder_href.sh
    PARENT_CURL_HREF="\"${CURL_URL}\""
elif [[ "${PARENT_ID}" == "root" ]]
  then
    source ./curl/curl_get_root_folder.sh
    source ../../../shared/curl/curl_response.sh
    PARENT_CURL_HREF=$(echo "${HTTP_BODY}" | jq '.Href')
else
    FOLDER_ID="${PARENT_ID}"
    source helpers/set_folder_href.sh
    PARENT_CURL_HREF="\"${CURL_URL}\""
fi

source ./curl/curl_post_create_folder.sh
source ../../../shared/curl/curl_response.sh

if [[ ${PARSE} = true ]]
  then
	echo "${HTTP_BODY}" |
	    jq '. | {type, name, id, parent: .parent | {type, name, id}}'
else
     echo "${HTTP_BODY}" |
        jq '.'
fi

echo -e '\n-------------------------\n'
