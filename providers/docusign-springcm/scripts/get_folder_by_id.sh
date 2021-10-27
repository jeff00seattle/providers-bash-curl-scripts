#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--random]\n
[--id <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,random,id: -n 'get_folder_by_id.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false
PARENT_RANDOM=false
FOLDER_ID=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    -p | --parse )      PARSE=true ; shift ;;
    --random )          PARENT_RANDOM=true; shift ;;
    --id )              FOLDER_ID="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [[ ${PARENT_RANDOM} = true ]];
  then
    FOLDER_ID="$(uuidgen | tr '[:upper:]' '[:lower:]')"
fi

if [ -z "${FOLDER_ID}" ]
  then
    echo "Provide --id" ; usage ; exit 1
fi

CURL_REQUEST="GET"

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_springcm_token_parse.sh

CURL_URL="${API_BASE_URL}/${API_VERSION}/folders/${FOLDER_ID}?expand=path,lock,parentfolder,attributegroups"

source ./curl/curl_get_folder_by_id.sh
source ../../../shared/curl/curl_response.sh

source ../../../shared/helpers/url_parse.sh

if [ ${PARSE} = true ]
  then
    parseURL $(echo ${HTTP_BODY} | jq '.Documents.Href')
    DOCUMENTS_ID=$(echo ${URL_COMPONENTS} | jq '. | .path' | cut -d/ -f3 | tr -d '"')

    parseURL $(echo ${HTTP_BODY} | jq '.Folders.Href')
    FOLDERS_ID=$(echo ${URL_COMPONENTS} | jq '. | .path' | cut -d/ -f3 | tr -d '"')

    parseURL $(echo ${HTTP_BODY} | jq '.Href')
    FOLDER_ID=$(echo ${URL_COMPONENTS} | jq '. | .path' | cut -d/ -f3 | tr -d '"')

    ROOT_FOLDER=$(echo ${HTTP_BODY} |
        jq
        --arg parent_id "${PARENT_ID}"
        --arg documents_id "${DOCUMENTS_ID}"
        --arg folders_id "${FOLDERS_ID}"
        --arg folder_id "${FOLDER_ID}" '.
            | {Name,
            ParentFolder: .ParentFolder | {href: .Href, id: $parent_id},
            Documents: .Documents | {href: .Href, id: $documents_id},
            Folders: .Folders | {href: .Href, id: $folders_id},
            CreateDocument: {href: .CreateDocumentHref},
            href: .Href,
            id: $folder_id}')

     echo "${ROOT_FOLDER}" |
        jq '.'
else
     echo "${HTTP_BODY}" |
        jq '.'
fi
