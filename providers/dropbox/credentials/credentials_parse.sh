#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.json'

CLIENT_ID=`cat ../credentials/config/credentials.json | jq '.client_id'`
CLIENT_SECRET=`cat ../credentials/config/credentials.json | jq '.client_secret'`

REDIRECT_URI=`cat ../credentials/config/credentials.json | jq '.redirect_uri'`

AUTH_URL=`cat ../credentials/config/credentials.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.json | jq '.auth_token_url'`
AUTH_USER_URL=`cat ../credentials/config/credentials.json | jq '.auth_user_url'`

# Cleanup configuration values

CLIENT_ID=`echo ${CLIENT_ID} | tr -d \"`
CLIENT_SECRET=`echo ${CLIENT_SECRET} | tr -d \"`

REDIRECT_URI=`echo ${REDIRECT_URI} | tr -d \"`

AUTH_URL=$(echo $(eval echo ${AUTH_URL} | tr -d \"))
AUTH_TOKEN_URL=$(echo $(eval echo ${AUTH_TOKEN_URL} | tr -d \"))
AUTH_USER_URL=$(echo $(eval echo ${AUTH_USER_URL} | tr -d \"))

SECURITY_TOKEN=`uuid_lowercase`
DOCUSIGN_ID=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CLIENT_ID:      ${CLIENT_ID}"
    echo "  CLIENT_SECRET:  ${CLIENT_SECRET}"
    echo "  REDIRECT_URI:   ${REDIRECT_URI}"
    echo ""
    echo "  AUTH_URL:       ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL: ${AUTH_TOKEN_URL}"
    echo "  AUTH_USER_URL:  ${AUTH_USER_URL}"
    echo ""
    echo "  SECURITY_TOKEN: ${SECURITY_TOKEN}"
    echo "  DOCUSIGN_ID:    ${DOCUSIGN_ID}"

    echo -e '\n-------------------------\n'
fi
