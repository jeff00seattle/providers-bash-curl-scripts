#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.springcm.json'

CLIENT_ID=`cat ../credentials/config/credentials.springcm.json | jq '.client_id'`
CLIENT_SECRET=`cat ../credentials/config/credentials.springcm.json | jq '.client_secret'`

REDIRECT_URI=`cat ../credentials/config/credentials.springcm.json | jq '.redirect_uri'`

PROTOCOL=`cat ../credentials/config/credentials.springcm.json | jq '.protocol'`

DATACENTER_ENV=`cat ../credentials/config/credentials.springcm.json | jq '.datacenter_env'`
DATACENTER_LOC=`cat ../credentials/config/credentials.springcm.json | jq '.datacenter_loc'`

AUTH_DOMAIN=`cat ../credentials/config/credentials.springcm.json | jq '.auth_domain'`

AUTH_HOSTNAME=`cat ../credentials/config/credentials.springcm.json | jq '.auth_hostname'`
AUTH_VERSION=`cat ../credentials/config/credentials.springcm.json | jq '.auth_version'`

AUTH_URL=`cat ../credentials/config/credentials.springcm.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.springcm.json | jq '.auth_token_url'`
AUTH_USER_URL=`cat ../credentials/config/credentials.springcm.json | jq '.auth_user_url'`

API_DOMAIN=`cat ../credentials/config/credentials.springcm.json | jq '.api_domain'`
API_DATA_CENTER=`cat ../credentials/config/credentials.springcm.json | jq '.api_data_center'`
API_VERSION=`cat ../credentials/config/credentials.springcm.json | jq '.api_version'`

#API_BASE_URL=`cat ../credentials/config/credentials.springcm.json | jq '.api_base_url'`
#API_UPLOAD_URL=`cat ../credentials/config/credentials.springcm.json | jq '.api_upload_url'`
API_AUTH_URL=`cat ../credentials/config/credentials.springcm.json | jq '.api_auth_url'`

# Cleanup configuration values

CLIENT_ID=`echo ${CLIENT_ID} | tr -d \"`
CLIENT_SECRET=`echo ${CLIENT_SECRET} | tr -d \"`

REDIRECT_URI=`echo ${REDIRECT_URI} | tr -d \"`

PROTOCOL=$(echo $(eval echo ${PROTOCOL} | tr -d \"))

AUTH_DOMAIN=$(echo $(eval echo ${AUTH_DOMAIN} | tr -d \"))
AUTH_VERSION=`echo $AUTH_VERSION | tr -d \"`
AUTH_HOSTNAME=$(echo $(eval echo $AUTH_HOSTNAME | tr -d \"))

AUTH_URL=$(echo $(eval echo ${AUTH_URL} | tr -d \"))
AUTH_TOKEN_URL=$(echo $(eval echo ${AUTH_TOKEN_URL} | tr -d \"))
AUTH_USER_URL=$(echo $(eval echo ${AUTH_USER_URL} | tr -d \"))

API_DOMAIN=`echo ${API_DOMAIN} | tr -d \"`
API_DATA_CENTER=$(echo $(eval echo ${API_DATA_CENTER} | tr -d \"))
API_VERSION=`echo ${API_VERSION} | tr -d \"`
API_DATA_CENTER=`echo ${API_DATA_CENTER} | tr -d \"`

#API_BASE_URL=$(echo $(eval echo ${API_BASE_URL} | tr -d \"))
#API_UPLOAD_URL=$(echo $(eval echo ${API_UPLOAD_URL} | tr -d \"))
API_AUTH_URL=$(echo $(eval echo ${API_AUTH_URL} | tr -d \"))

SECURITY_TOKEN='e7d42b7974be9f075fb585d56bf1398bbdb7ea85eb09f3208cd202fdda2badbcc5d612896eb8ff3b3b9364dc1a5d68e9018c4cc7bf890cc0dbbc97d7548950b2dcbbc42f215dfcbbffe8f298293713e1c3153e8e1bdc6be897b1e45abf1dc825c802c6a80d4de828e6d1ef3c5978ab2a005976874db788f4ed966f57662f5096c08d604a65a3cc72b5b9761b040f428618a422730584696dfe21353b9c82945324da41e0c8e0aca96a76dc174954d657e1c3153e8e1bdc6be897b1e45abf1dc825c802c6a80d4de828e6d1ef3c5978ab2a005976874db788f4ed966f57662f5096c08d604a65a3cc72b5b9761b040f428618a42273052945324d'
DOCUSIGN_ID=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  CLIENT_ID: ${CLIENT_ID}"
    echo "  CLIENT_SECRET: ${CLIENT_SECRET}"
    echo "  REDIRECT_URI: ${REDIRECT_URI}"

    echo "  PROTOCOL: ${PROTOCOL}"
    echo "  DATACENTER_ENV: ${DATACENTER_ENV}"
    echo "  DATACENTER_LOC: ${DATACENTER_LOC}"

    echo "  AUTH_DOMAIN: ${AUTH_DOMAIN}"
    echo "  AUTH_URL: ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL: ${AUTH_TOKEN_URL}"
    echo "  AUTH_USER_URL: ${AUTH_USER_URL}"

    echo "  API_DOMAIN: ${API_DOMAIN}"
    echo "  API_DATA_CENTER: ${API_DATA_CENTER}"
    echo "  API_VERSION: ${API_VERSION}"

#    echo "  API_BASE_URL: ${API_BASE_URL}"
#    echo "  API_UPLOAD_URL: ${API_UPLOAD_URL}"
    echo "  API_AUTH_URL: ${API_AUTH_URL}"

    echo "  SECURITY_TOKEN: ${SECURITY_TOKEN}"
    echo "  DOCUSIGN_ID: ${DOCUSIGN_ID}"

    echo -e '\n-------------------------\n'
fi