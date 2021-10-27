#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.json'

CLIENT_ID=`cat ../credentials/config/credentials.json | jq '.client_id'`
CLIENT_SECRET=`cat ../credentials/config/credentials.json | jq '.client_secret'`

REDIRECT_URI=`cat ../credentials/config/credentials.json | jq '.redirect_uri'`

AUTH_URL=`cat ../credentials/config/credentials.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.json | jq '.auth_token_url'`

AUTH_SCOPE=`cat ../credentials/config/credentials.json | jq '.auth_scope'`

AUTH_TOKEN_INFO_URL=`cat ../credentials/config/credentials.json | jq '.auth_token_info_url'`

# Cleanup configuration values

CLIENT_ID=`echo ${CLIENT_ID} | tr -d \"`
CLIENT_SECRET=`echo ${CLIENT_SECRET} | tr -d \"`

REDIRECT_URI=`echo ${REDIRECT_URI} | tr -d \"`

AUTH_URL=`echo ${AUTH_URL} | tr -d \"`
AUTH_TOKEN_URL=`echo ${AUTH_TOKEN_URL} | tr -d \"`

AUTH_SCOPE=`echo ${AUTH_SCOPE} | tr -d \"`
AUTH_SCOPE=`url_encode "${AUTH_SCOPE}"`
# AUTH_SCOPE=`echo ${AUTH_SCOPE// /+}`

AUTH_TOKEN_INFO_URL=`echo ${AUTH_TOKEN_INFO_URL} | tr -d \"`

SECURITY_TOKEN=`uuid_lowercase`
DOCUSIGN_ID=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CLIENT_ID:              ${CLIENT_ID}"
    echo "  CLIENT_SECRET:          ${CLIENT_SECRET}"
    echo ""
    echo "  REDIRECT_URI:           ${REDIRECT_URI}"
    echo "  AUTH_URL:               ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL:         ${AUTH_TOKEN_URL}"
    echo ""
    echo "  AUTH_SCOPE:             ${AUTH_SCOPE}"
    echo ""
    echo "  AUTH_TOKEN_INFO_URL:    ${AUTH_TOKEN_INFO_URL}"
    echo ""
    echo "  SECURITY_TOKEN:         ${SECURITY_TOKEN}"
    echo "  DOCUSIGN_ID:            ${DOCUSIGN_ID}"

    echo -e '\n-------------------------\n'
fi
