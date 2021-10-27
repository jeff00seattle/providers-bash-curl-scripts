#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.json'

CLIENT_ID=`cat ../credentials/config/credentials.json | jq '.client_id'`
CLIENT_SECRET=`cat ../credentials/config/credentials.json | jq '.client_secret'`

PROTOCOL=`cat ../credentials/config/credentials.json | jq '.protocol'`

AUTH_HOSTNAME=`cat ../credentials/config/credentials.json | jq '.auth_hostname'`
AUTH_VERSION=`cat ../credentials/config/credentials.json | jq '.auth_version'`

AUTH_URL=`cat ../credentials/config/credentials.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.json | jq '.auth_token_url'`
AUTH_USER_URL=`cat ../credentials/config/credentials.json | jq '.auth_user_url'`

AUTH_SCOPE=`cat ../credentials/config/credentials.json | jq '.auth_scope'`

API_HOSTNAME=`cat ../credentials/config/credentials.json | jq '.api_hostname'`
API_VERSION=`cat ../credentials/config/credentials.json | jq '.api_version'`
API_BASE_URL=`cat ../credentials/config/credentials.json | jq '.api_base_url'`

# Cleanup configuration values

CLIENT_ID=`echo ${CLIENT_ID} | tr -d \"`
CLIENT_SECRET=`echo ${CLIENT_SECRET} | tr -d \"`

PROTOCOL=$(echo $(eval echo ${PROTOCOL} | tr -d \"))

AUTH_URL=$(echo $(eval echo ${AUTH_URL} | tr -d \"))
AUTH_TOKEN_URL=$(echo $(eval echo ${AUTH_TOKEN_URL} | tr -d \"))
AUTH_USER_URL=$(echo $(eval echo ${AUTH_USER_URL} | tr -d \"))

AUTH_SCOPE=`echo ${AUTH_SCOPE} | tr -d \"`
AUTH_SCOPE=`url_encode "${AUTH_SCOPE}"`

API_HOSTNAME=`echo ${API_HOSTNAME} | tr -d \"`
API_VERSION=`echo ${API_VERSION} | tr -d \"`
API_BASE_URL=$(echo $(eval echo ${API_BASE_URL} | tr -d \"))

SECURITY_TOKEN=`uuid_lowercase`
DOCUSIGN_ID=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CLIENT_ID:          ${CLIENT_ID}"
    echo "  CLIENT_SECRET:      ${CLIENT_SECRET}"
	
    echo "  PROTOCOL:           ${PROTOCOL}"

    echo "  AUTH_URL:           ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL:     ${AUTH_TOKEN_URL}"
    echo "  AUTH_USER_URL:      ${AUTH_USER_URL}"

    echo "  AUTH_SCOPE:         ${AUTH_SCOPE}"

    echo "  API_HOSTNAME:       ${API_HOSTNAME}"
    echo "  API_VERSION:        ${API_VERSION}"
    echo "  API_BASE_URL:       ${API_BASE_URL}"

    echo -e '\n-------------------------\n'
fi