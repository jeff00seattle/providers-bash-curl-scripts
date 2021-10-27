#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.docusign.json'

CLIENT_ID=`cat ../credentials/config/credentials.docusign.json | jq '.client_id'`
CLIENT_SECRET=`cat ../credentials/config/credentials.docusign.json | jq '.client_secret'`

REDIRECT_URI=`cat ../credentials/config/credentials.docusign.json | jq '.redirect_uri'`

PROTOCOL=`cat ../credentials/config/credentials.docusign.json | jq '.protocol'`

AUTH_DOMAIN=`cat ../credentials/config/credentials.docusign.json | jq '.auth_domain'`
AUTH_DOMAIN_ENV=`cat ../credentials/config/credentials.docusign.json | jq '.auth_domain_env'`

AUTH_URL=`cat ../credentials/config/credentials.docusign.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.docusign.json | jq '.auth_token_url'`
AUTH_USER_URL=`cat ../credentials/config/credentials.docusign.json | jq '.auth_user_url'`

AUTH_SCOPE=`cat ../credentials/config/credentials.docusign.json | jq '.auth_scope'`

DOCUSIGN_API_VERSION=`cat ../credentials/config/credentials.docusign.json | jq '.docusign_api_version'`

# Cleanup configuration values

CLIENT_ID=`echo ${CLIENT_ID} | tr -d \"`
CLIENT_SECRET=`echo ${CLIENT_SECRET} | tr -d \"`

REDIRECT_URI=`echo ${REDIRECT_URI} | tr -d \"`
REDIRECT_URI=`url_encode "${REDIRECT_URI}"`

PROTOCOL=$(echo $(eval echo ${PROTOCOL} | tr -d \"))

AUTH_DOMAIN=$(echo $(eval echo ${AUTH_DOMAIN} | tr -d \"))
AUTH_ACCOUNT_ENV=$(echo $(eval echo ${AUTH_ACCOUNT_ENV} | tr -d \"))

AUTH_URL=$(echo $(eval echo ${AUTH_URL} | tr -d \"))
AUTH_TOKEN_URL=$(echo $(eval echo ${AUTH_TOKEN_URL} | tr -d \"))
AUTH_USER_URL=$(echo $(eval echo ${AUTH_USER_URL} | tr -d \"))

AUTH_SCOPE=`echo ${AUTH_SCOPE} | tr -d \"`
AUTH_SCOPE=`url_encode "${AUTH_SCOPE}"`
# AUTH_SCOPE=`echo ${AUTH_SCOPE// /+}`

AUTH_BASE64=`echo "${CLIENT_ID}:${CLIENT_SECRET}" | base64 | sed 's/.\{2\}$//' | sed 's/$/==/'`

DOCUSIGN_API_VERSION=`echo ${DOCUSIGN_API_VERSION} | tr -d \"`

SECURITY_TOKEN=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CLIENT_ID:              ${CLIENT_ID}"
    echo "  CLIENT_SECRET:          ${CLIENT_SECRET}"
    echo "  REDIRECT_URI:           ${REDIRECT_URI}"

    echo "  PROTOCOL:               ${PROTOCOL}"

    echo "  ACCOUNT_ENV:            ${ACCOUNT_ENV}"
    echo "  AUTH_DOMAIN:            ${AUTH_DOMAIN}"
    echo "  AUTH_ACCOUNT_ENV:       ${AUTH_ACCOUNT_ENV}"

    echo "  AUTH_URL:               ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL:         ${AUTH_TOKEN_URL}"
    echo "  AUTH_USER_URL:          ${AUTH_USER_URL}"

    echo "  AUTH_SCOPE:             ${AUTH_SCOPE}"
    echo "  AUTH_BASE64:            ${AUTH_BASE64}"

    echo "  DOCUSIGN_API_VERSION:   ${DOCUSIGN_API_VERSION}"

    echo "  SECURITY_TOKEN:         ${SECURITY_TOKEN}"

    echo -e '\n-------------------------\n'
fi
