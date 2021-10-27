#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.json'

CLIENT_ID=`cat ../credentials/config/credentials.json | jq '.client_id'`
CLIENT_SECRET=`cat ../credentials/config/credentials.json | jq '.client_secret'`

REDIRECT_URI=`cat ../credentials/config/credentials.json | jq '.redirect_uri'`

PROTOCOL=`cat ../credentials/config/credentials.json | jq '.protocol'`
API_VERSION=`cat ../credentials/config/credentials.json | jq '.api_version'`

API_HOSTNAME=`cat ../credentials/config/credentials.json | jq '.api_hostname'`
API_UPLOAD_HOSTNAME=`cat ../credentials/config/credentials.json | jq '.api_upload_hostname'`

API_BASE=`cat ../credentials/config/credentials.json | jq '.api_base'`
API_UPLOAD_BASE=`cat ../credentials/config/credentials.json | jq '.api_upload_base'`
API_OAUTH2_BASE=`cat ../credentials/config/credentials.json | jq '.api_oauth2_base'`

AUTH_URL=`cat ../credentials/config/credentials.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.json | jq '.auth_token_url'`
AUTH_REFRESH_URL=`cat ../credentials/config/credentials.json | jq '.auth_refresh_url'`
AUTH_REVOKE_URL=`cat ../credentials/config/credentials.json | jq '.auth_revoke_url'`

AUTH_USER_URL=`cat ../credentials/config/credentials.json | jq '.auth_user_url'`

# Cleanup configuration values

CLIENT_ID=`echo ${CLIENT_ID} | tr -d \"`
CLIENT_SECRET=`echo ${CLIENT_SECRET} | tr -d \"`

REDIRECT_URI=`echo ${REDIRECT_URI} | tr -d \"`
REDIRECT_URI=`url_encode "${REDIRECT_URI}"`

PROTOCOL=$(echo $(eval echo ${PROTOCOL} | tr -d \"))
API_VERSION=`echo ${API_VERSION} | tr -d \"`
API_HOSTNAME=`echo ${API_HOSTNAME} | tr -d \"`
API_UPLOAD_HOSTNAME=`echo ${API_UPLOAD_HOSTNAME} | tr -d \"`

API_BASE=$(echo $(eval echo ${API_BASE} | tr -d \"))
API_UPLOAD_BASE=$(echo $(eval echo ${API_UPLOAD_BASE} | tr -d \"))

API_OAUTH2_BASE=$(echo $(eval echo ${API_OAUTH2_BASE} | tr -d \"))

AUTH_URL=$(echo $(eval echo ${AUTH_URL} | tr -d \"))
AUTH_TOKEN_URL=$(echo $(eval echo ${AUTH_TOKEN_URL} | tr -d \"))
AUTH_REFRESH_URL=$(echo $(eval echo ${AUTH_REFRESH_URL} | tr -d \"))
AUTH_REVOKE_URL=$(echo $(eval echo ${AUTH_REVOKE_URL} | tr -d \"))

AUTH_USER_URL=$(echo $(eval echo ${AUTH_USER_URL} | tr -d \"))

SECURITY_TOKEN='e7d42b7974be9f075fb585d56bf1398bbdb7ea85eb09f3208cd202fdda2badbcc5d612896eb8ff3b3b9364dc1a5d68e9018c4cc7bf890cc0dbbc97d7548950b2dcbbc42f215dfcbbffe8f298293713e1c3153e8e1bdc6be897b1e45abf1dc825c802c6a80d4de828e6d1ef3c5978ab2a005976874db788f4ed966f57662f5096c08d604a65a3cc72b5b9761b040f428618a422730584696dfe21353b9c82945324da41e0c8e0aca96a76dc174954d657e1c3153e8e1bdc6be897b1e45abf1dc825c802c6a80d4de828e6d1ef3c5978ab2a005976874db788f4ed966f57662f5096c08d604a65a3cc72b5b9761b040f428618a42273052945324d'
DOCUSIGN_ID=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CLIENT_ID:          ${CLIENT_ID}"
    echo "  CLIENT_SECRET:      ${CLIENT_SECRET}"
    echo "  REDIRECT_URI:       ${REDIRECT_URI}"
    echo ""
    echo "  API_BASE:           ${API_BASE}"
    echo "  API_VERSION:        ${API_VERSION}"
    echo ""
    echo "  API_OAUTH2_BASE:    ${API_OAUTH2_BASE}"
    echo ""
    echo "  AUTH_URL:           ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL:     ${AUTH_TOKEN_URL}"
    echo "  AUTH_REFRESH_URL:   ${AUTH_REFRESH_URL}"
    echo "  AUTH_REVOKE_URL:    ${AUTH_REVOKE_URL}"
    echo ""
    echo "  AUTH_USER_URL:      ${AUTH_USER_URL}"
    echo ""
    echo "  SECURITY_TOKEN:     ${SECURITY_TOKEN}"
    echo "  DOCUSIGN_ID:        ${DOCUSIGN_ID}"

    echo -e '\n-------------------------\n'
fi
