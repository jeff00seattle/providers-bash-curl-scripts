#!/usr/bin/env bash

USAGE="\nUsage: $0\n
[-h|--help]\n
[-v|--verbose]\n
--parent <string>\n
--file <string>\n
"

usage() { echo -e ${USAGE} 1>&2; exit 1; }

# read the options
OPTS=`getopt -o hvp --long help,verbose,parent:,file: -n 'upload_file.sh' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; usage ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

HELP=false
VERBOSE=false
PARENT_ID=""
FILE_PATH=""

# extract options and their arguments into variables.
while true; do
  case "$1" in
    -h | --help )       usage ;;
    -v | --verbose )    VERBOSE=true; shift ;;
    --parent )          PARENT_ID="$2" ; shift; shift ;;
    --file )            FILE_PATH="$2" ; shift; shift ;;
    -- )                shift; break ;;
    * )                 break ;;
  esac
done

if [ -z "${PARENT_ID}" ]
  then
    echo "Missing PARENT_ID" ; usage ; exit 1
fi

if [ -z "${FILE_PATH}" ]
  then
    echo "Missing FILE_PATH" ; usage ; exit 1
fi

source ../credentials/credentials_springcm_parse.sh
source ../credentials/credentials_docusign_account_parse.sh
source ../credentials/credentials_springcm_account_parse.sh

source ../credentials/credentials_docusign_token_parse.sh

FILE_BASENAME=$(echo ${FILE_PATH##*/})
FILE_MEME_TYPE=$(echo $(file -b --mime-type ${FILE_PATH}))


if [ -z "${DOCUSIGN_ACCOUNT_ID}" ]
  then
    echo "Missing DOCUSIGN_ACCOUNT_ID" ; usage ; exit 1
fi

UPLOAD_HREF="${SPRINGCM_API_BASE_UPLOAD_URL}/${SPRINGCM_API_VERSION}/${DOCUSIGN_ACCOUNT_ID}/folders/${PARENT_ID}/documents?name=${FILE_BASENAME}"

echo "  FILE_BASENAME: $FILE_BASENAME"
echo "  FILE_MEME_TYPE: ${FILE_MEME_TYPE}"
echo "  UPLOAD_HREF: $UPLOAD_HREF"

source ./curl/curl_post_upload_file.sh

source ../../../shared/curl/curl_response.sh

echo "${HTTP_BODY}" |
    jq '.'

echo -e '\n-------------------------\n'
