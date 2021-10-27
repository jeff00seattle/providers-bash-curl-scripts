#!/usr/bin/env bash

USER_NAME=`cat ../credentials/config/credentials.docusign.account.json | jq '.name'`
USER_ACCOUNTS=`cat ../credentials/config/credentials.docusign.account.json | jq '.accounts'`
USER_ACCOUNT_DEFAULT=`echo "${USER_ACCOUNTS}" | jq -c '.[] | select(.is_default == true)'`

DOCUSIGN_API_BASE_URL=`echo "${USER_ACCOUNT_DEFAULT}" | jq .base_uri`
DOCUSIGN_ACCOUNT_ID=`echo "${USER_ACCOUNT_DEFAULT}" | jq .account_id`
DOCUSIGN_ACCOUNT_NAME=`echo "${USER_ACCOUNT_DEFAULT}" | jq .account_name`

DOCUSIGN_API_BASE_URL=$(echo $(eval echo $DOCUSIGN_API_BASE_URL | tr -d \"))
DOCUSIGN_ACCOUNT_ID=$(echo $(eval echo $DOCUSIGN_ACCOUNT_ID | tr -d \"))
DOCUSIGN_ACCOUNT_NAME=$(echo $(eval echo $DOCUSIGN_ACCOUNT_NAME | tr -d \"))

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  DOCUSIGN_API_BASE_URL:  $DOCUSIGN_API_BASE_URL"
    echo "  DOCUSIGN_ACCOUNT_ID:    $DOCUSIGN_ACCOUNT_ID"
    echo "  DOCUSIGN_ACCOUNT_NAME:  $DOCUSIGN_ACCOUNT_NAME"

    echo -e '\n-------------------------\n'
fi
