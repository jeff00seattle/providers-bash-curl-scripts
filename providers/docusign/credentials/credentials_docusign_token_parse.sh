#!/usr/bin/env bash

DOCUSIGN_ACCESS_TOKEN=`cat ../credentials/config/credentials.token.json | jq '.access_token'`
TOKEN_TYPE=`cat ../credentials/config/credentials.token.json | jq '.token_type'`
EXPIRES_IN=`cat ../credentials/config/credentials.token.json | jq '.expires_in'`
DOCUSIGN_REFRESH_TOKEN=`cat ../credentials/config/credentials.token.json | jq '.refresh_token'`

DOCUSIGN_ACCESS_TOKEN=`echo ${DOCUSIGN_ACCESS_TOKEN} | tr -d \"`
DOCUSIGN_REFRESH_TOKEN=`echo ${DOCUSIGN_REFRESH_TOKEN} | tr -d \"`
TOKEN_TYPE=`echo ${TOKEN_TYPE} | tr -d \"`

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  DOCUSIGN_ACCESS_TOKEN:  ${DOCUSIGN_ACCESS_TOKEN}"
    echo "  TOKEN_TYPE:             ${TOKEN_TYPE}"
    echo "  EXPIRES_IN:             ${EXPIRES_IN}"
    echo "  DOCUSIGN_REFRESH_TOKEN: ${DOCUSIGN_REFRESH_TOKEN}"

    echo -e '\n-------------------------\n'
fi