#!/usr/bin/env bash

DOCUSIGN_ACCOUNT_ID=`cat ../credentials/config/credentials.springcm.account.json | jq '.Id'`
DOCUSIGN_ACCOUNT_NAME=`cat ../credentials/config/credentials.springcm.account.json | jq '.Name'`

SPRINGCM_API_BASE_URL=`cat ../credentials/config/credentials.springcm.account.json | jq '.ApiBaseUrl'`
SPRINGCM_API_BASE_DOWNLOAD_URL=`cat ../credentials/config/credentials.springcm.account.json | jq '.ApiBaseDownloadUrl'`
SPRINGCM_API_BASE_UPLOAD_URL=`cat ../credentials/config/credentials.springcm.account.json | jq '.ApiBaseUploadUrl'`

SPRINGCM_SFTPURL_URL=`cat ../credentials/config/credentials.springcm.account.json | jq '.SftpUrl'`
SPRINGCM_WEB_LANDING_PAGE_URL=`cat ../credentials/config/credentials.springcm.account.json | jq '.WebLandingPageUrl'`

DOCUSIGN_ACCOUNT_ID=$(echo $(eval echo $DOCUSIGN_ACCOUNT_ID | tr -d \"))
DOCUSIGN_ACCOUNT_NAME=$(echo $(eval echo $DOCUSIGN_ACCOUNT_NAME | tr -d \"))

SPRINGCM_API_BASE_URL=$(echo $(eval echo $SPRINGCM_API_BASE_URL | tr -d \"))
SPRINGCM_API_BASE_DOWNLOAD_URL=$(echo $(eval echo $SPRINGCM_API_BASE_DOWNLOAD_URL | tr -d \"))
SPRINGCM_API_BASE_UPLOAD_URL=$(echo $(eval echo $SPRINGCM_API_BASE_UPLOAD_URL | tr -d \"))

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  DOCUSIGN_ACCOUNT_ID:                $DOCUSIGN_ACCOUNT_ID"
    echo "  DOCUSIGN_ACCOUNT_NAME:              $DOCUSIGN_ACCOUNT_NAME"

    echo "  SPRINGCM_API_BASE_URL:              $SPRINGCM_API_BASE_URL"
    echo "  SPRINGCM_API_BASE_DOWNLOAD_URL:     $SPRINGCM_API_BASE_DOWNLOAD_URL"
    echo "  SPRINGCM_API_BASE_UPLOAD_URL:       $SPRINGCM_API_BASE_UPLOAD_URL"

    echo -e '\n-------------------------\n'
fi