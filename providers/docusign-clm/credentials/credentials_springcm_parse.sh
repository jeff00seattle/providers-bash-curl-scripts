#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.springcm.json'

PROTOCOL=`cat ../credentials/config/credentials.springcm.json | jq '.protocol'`

DATACENTER_ENV=`cat ../credentials/config/credentials.springcm.json | jq '.datacenter_env'`
DATACENTER_LOC=`cat ../credentials/config/credentials.springcm.json | jq '.datacenter_loc'`

AUTH_DOMAIN=`cat ../credentials/config/credentials.springcm.json | jq '.auth_domain'`

API_DOMAIN=`cat ../credentials/config/credentials.springcm.json | jq '.api_domain'`
API_DATA_CENTER=`cat ../credentials/config/credentials.springcm.json | jq '.api_data_center'`
SPRINGCM_API_VERSION=`cat ../credentials/config/credentials.springcm.json | jq '.api_version'`

SPRINGCM_API_BASE_URL=`cat ../credentials/config/credentials.springcm.json | jq '.api_base_url'`
SPRINGCM_API_UPLOAD_URL=`cat ../credentials/config/credentials.springcm.json | jq '.api_upload_url'`
SPRINGCM_API_AUTH_URL=`cat ../credentials/config/credentials.springcm.json | jq '.api_auth_url'`

# Cleanup configuration values

PROTOCOL=$(echo $(eval echo ${PROTOCOL} | tr -d \"))

API_DOMAIN=`echo ${API_DOMAIN} | tr -d \"`
API_DATA_CENTER=$(echo $(eval echo $API_DATA_CENTER | tr -d \"))
SPRINGCM_API_VERSION=`echo ${SPRINGCM_API_VERSION} | tr -d \"`
API_DATA_CENTER=`echo ${API_DATA_CENTER} | tr -d \"`

SPRINGCM_API_BASE_URL=$(echo $(eval echo ${SPRINGCM_API_BASE_URL} | tr -d \"))
SPRINGCM_API_UPLOAD_URL=$(echo $(eval echo ${SPRINGCM_API_UPLOAD_URL} | tr -d \"))
SPRINGCM_API_AUTH_URL=$(echo $(eval echo ${SPRINGCM_API_AUTH_URL} | tr -d \"))

SECURITY_TOKEN=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'

    echo "  PROTOCOL:                   ${PROTOCOL}"

    echo "  DATACENTER_ENV:             ${DATACENTER_ENV}"
    echo "  DATACENTER_LOC:             ${DATACENTER_LOC}"

    echo "  API_DOMAIN:                 ${API_DOMAIN}"
    echo "  API_DATA_CENTER:            ${API_DATA_CENTER}"

    echo "  SPRINGCM_API_VERSION:       ${SPRINGCM_API_VERSION}"

    echo "  SPRINGCM_API_BASE_URL:      ${SPRINGCM_API_BASE_URL}"
    echo "  SPRINGCM_API_UPLOAD_URL:    ${SPRINGCM_API_UPLOAD_URL}"
    echo "  SPRINGCM_API_AUTH_URL:      ${SPRINGCM_API_AUTH_URL}"

    echo "  SECURITY_TOKEN:             ${SECURITY_TOKEN}"

    echo -e '\n-------------------------\n'
fi