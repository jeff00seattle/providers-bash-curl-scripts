#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
[-p|--parse]\n
[--name <string>]\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parse,folder: -n 'get_folder_by_name.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARSE=false
FOLDER_NAME=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true ; shift ;;
    -p | --parse )      PARSE=true ; shift ;;
    --folder )          FOLDER_NAME=$2 ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

CURL_REQUEST="GET"

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_springcm_token_parse.sh

CURL_URL="${API_BASE_URL}/${API_VERSION}/folders?search=${FOLDER_NAME}&expand=path,lock,parentfolder,attributegroups"

source ./curl/curl_get_search_folders_by_name.sh

source ../../../shared/curl/curl_response.sh
source ../../../shared/helpers/url_parse.sh

if [ ${PARSE} = true ]
  then
    parseURL $(echo ${HTTP_BODY} | jq '.Documents.Href')
    DOCUMENTS_ID=$(echo ${URL_COMPONENTS} | jq '. | .path' | cut -d/ -f3 | tr -d '"')

    parseURL $(echo ${HTTP_BODY} | jq '.Folders.Href')
    FOLDERS_ID=$(echo ${URL_COMPONENTS} | jq '. | .path' | cut -d/ -f3 | tr -d '"')

    parseURL $(echo ${HTTP_BODY} | jq '.Href')
    FOLDER_NAME=$(echo ${URL_COMPONENTS} | jq '. | .path' | cut -d/ -f3 | tr -d '"')

    ROOT_FOLDER=$(echo ${HTTP_BODY} |
        jq
        --arg parent_id "${PARENT_ID}"
        --arg documents_id "${DOCUMENTS_ID}"
        --arg folders_id "${FOLDERS_ID}"
        --arg folder_id "${FOLDER_NAME}" '.
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
