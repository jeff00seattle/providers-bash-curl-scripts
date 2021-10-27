#!/usr/bin/env bash

source ../../../shared/helpers/url_encode.sh
source ../../../shared/helpers/uuid_lowercase.sh

# Parse configuration file 'credentials.docusign.json'

APP_NAME=`cat ../credentials/config/credentials.docusign.json | jq '.app_name'`
INTEGRATION_KEY=`cat ../credentials/config/credentials.docusign.json | jq '.integration_key'`

ACCOUNT_NAME=`cat ../credentials/config/credentials.docusign.json | jq '.account_name'`
ACCOUNT_EMAIL=`cat ../credentials/config/credentials.docusign.json | jq '.account_email'`
ACCOUNT_PASSWORD=`cat ../credentials/config/credentials.docusign.json | jq '.account_password'`
ACCOUNT_ID=`cat ../credentials/config/credentials.docusign.json | jq '.account_id'`

TEMPLATE_ID=`cat ../credentials/config/credentials.docusign.json | jq '.template_id'`

USER_NAME=`cat ../credentials/config/credentials.docusign.json | jq '.user_name'`
USER_ID=`cat ../credentials/config/credentials.docusign.json | jq '.user_id'`

REDIRECT_URI=`cat ../credentials/config/credentials.docusign.json | jq '.redirect_uri'`

PROTOCOL=`cat ../credentials/config/credentials.docusign.json | jq '.protocol'`

AUTH_ACCOUNT_ENV_HQTEST=`cat ../credentials/config/credentials.docusign.json | jq '.auth_account_env_hqtest'`
AUTH_ACCOUNT_ENV_STAGE=`cat ../credentials/config/credentials.docusign.json | jq '.auth_account_env_stage'`
AUTH_ACCOUNT_ENV_DEMO=`cat ../credentials/config/credentials.docusign.json | jq '.auth_account_env_demo'`
AUTH_ACCOUNT_ENV_PROD=`cat ../credentials/config/credentials.docusign.json | jq '.auth_account_env_prod'`

case ${ACCOUNT_ENV} in
  HQTEST)
    AUTH_ACCOUNT_ENV=$(echo $(eval echo $AUTH_ACCOUNT_ENV_HQTEST | tr -d \"))
    ;;
  STAGE)
    AUTH_ACCOUNT_ENV=$(echo $(eval echo $AUTH_ACCOUNT_ENV_STAGE | tr -d \"))
    ;;
  DEMO)
    AUTH_ACCOUNT_ENV=$(echo $(eval echo $AUTH_ACCOUNT_ENV_DEMO | tr -d \"))
    ;;
  PROD)
    AUTH_ACCOUNT_ENV=$(echo $(eval echo $AUTH_ACCOUNT_ENV_PROD | tr -d \"))
    ;;
  *)
    AUTH_ACCOUNT_ENV=$(echo $(eval echo $AUTH_ACCOUNT_ENV_PROD | tr -d \"))
    ;;
esac

AUTH_DOMAIN_HQTEST=`cat ../credentials/config/credentials.docusign.json | jq '.auth_domain_hqtest'`
AUTH_DOMAIN_DEFAULT=`cat ../credentials/config/credentials.docusign.json | jq '.auth_domain_default'`

case ${ACCOUNT_ENV} in
  HQTEST)
    AUTH_DOMAIN=$(echo $(eval echo $AUTH_DOMAIN_HQTEST | tr -d \"))
    ;;
  *)
    AUTH_DOMAIN=$(echo $(eval echo $AUTH_DOMAIN_DEFAULT | tr -d \"))
    ;;
esac

AUTH_URL=`cat ../credentials/config/credentials.docusign.json | jq '.auth_url'`
AUTH_TOKEN_URL=`cat ../credentials/config/credentials.docusign.json | jq '.auth_token_url'`
AUTH_USER_URL=`cat ../credentials/config/credentials.docusign.json | jq '.auth_user_url'`

AUTH_SCOPE=`cat ../credentials/config/credentials.docusign.json | jq '.auth_scope'`

DOCUSIGN_API_VERSION=`cat ../credentials/config/credentials.docusign.json | jq '.docusign_api_version'`

ESIGN_API_ENV_HQTEST=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_env_hqtest'`
ESIGN_API_ENV_STAGE=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_env_stage'`
ESIGN_API_ENV_DEMO=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_env_demo'`
ESIGN_API_ENV_PROD=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_env_prod'`

case ${ACCOUNT_ENV} in
  HQTEST)
    ESIGN_API_ENV=$(echo $(eval echo $ESIGN_API_ENV_HQTEST | tr -d \"))
    ;;
  STAGE)
    ESIGN_API_ENV=$(echo $(eval echo $ESIGN_API_ENV_STAGE | tr -d \"))
    ;;
  DEMO)
    ESIGN_API_ENV=$(echo $(eval echo $ESIGN_API_ENV_DEMO | tr -d \"))
    ;;
  PROD)
    ESIGN_API_ENV=$(echo $(eval echo $ESIGN_API_ENV_PROD | tr -d \"))
    ;;
  *)
    ESIGN_API_ENV=$(echo $(eval echo $ESIGN_API_ENV_PROD | tr -d \"))
    ;;
esac

ESIGN_API_DOMAIN=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_domain'`
ESIGN_API_URL=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_url'`
ESIGN_API_VERSION=`cat ../credentials/config/credentials.docusign.json | jq '.esign_api_version'`

JWT_ASSERTION=`cat ../credentials/config/credentials.docusign.json | jq '.jwt_assertion'`

# Cleanup configuration values

APP_NAME=`echo ${APP_NAME} | tr -d \"`
INTEGRATION_KEY=`echo ${INTEGRATION_KEY} | tr -d \"`
CLIENT_ID=`echo ${INTEGRATION_KEY} | tr -d \"`

ACCOUNT_NAME=`echo ${ACCOUNT_NAME} | tr -d \"`
ACCOUNT_EMAIL=`echo ${ACCOUNT_EMAIL} | tr -d \"`
ACCOUNT_PASSWORD=`echo ${ACCOUNT_PASSWORD} | tr -d \"`
ACCOUNT_ID=`echo ${ACCOUNT_ID} | tr -d \"`
TEMPLATE_ID=`echo ${TEMPLATE_ID} | tr -d \"`

USER_NAME=`echo ${USER_NAME} | tr -d \"`
USER_ID=`echo ${USER_ID} | tr -d \"`

REDIRECT_URI=`echo ${REDIRECT_URI} | tr -d \"`
REDIRECT_URI=`url_encode "${REDIRECT_URI}"`

PROTOCOL=$(echo $(eval echo ${PROTOCOL} | tr -d \"))

AUTH_DOMAIN=$(echo $(eval echo ${AUTH_DOMAIN} | tr -d \"))

AUTH_URL=$(echo $(eval echo ${AUTH_URL} | tr -d \"))
AUTH_TOKEN_URL=$(echo $(eval echo ${AUTH_TOKEN_URL} | tr -d \"))
AUTH_USER_URL=$(echo $(eval echo ${AUTH_USER_URL} | tr -d \"))

AUTH_SCOPE=`echo ${AUTH_SCOPE} | tr -d \"`
AUTH_SCOPE=`url_encode "${AUTH_SCOPE}"`

AUTH_BASE64=`echo "${CLIENT_ID}:${CLIENT_SECRET}" | base64 | sed 's/.\{2\}$//' | sed 's/$/==/'`

DOCUSIGN_API_VERSION=`echo ${DOCUSIGN_API_VERSION} | tr -d \"`

ESIGN_API_DOMAIN=$(echo $(eval echo ${ESIGN_API_DOMAIN} | tr -d \"))
ESIGN_API_URL=$(echo $(eval echo ${ESIGN_API_URL} | tr -d \"))
ESIGN_API_VERSION=$(echo $(eval echo ${ESIGN_API_VERSION} | tr -d \"))

JWT_ASSERTION=$(echo $(eval echo ${JWT_ASSERTION} | tr -d \"))

SECURITY_TOKEN=`uuid_lowercase`
DOCUSIGN_ID=`uuid_lowercase`

# Display configuration values if verbose requested

if [ ${VERBOSE} = true ]
  then
    echo -e '\n-------------------------\n'
    echo "  APP_NAME:               ${APP_NAME}"
    echo "  INTEGRATION_KEY:        ${INTEGRATION_KEY}"
    echo "  CLIENT_ID:              ${CLIENT_ID}"

    echo "  ACCOUNT_NAME:           ${ACCOUNT_NAME}"
    echo "  ACCOUNT_EMAIL:          ${ACCOUNT_EMAIL}"
    echo "  ACCOUNT_PASSWORD:       ${ACCOUNT_PASSWORD}"
    echo "  ACCOUNT_ID:             ${ACCOUNT_ID}"

    echo "  USER_NAME:              ${USER_NAME}"
    echo "  USER_ID:                ${USER_ID}"

    echo "  TEMPLATE_ID:            ${TEMPLATE_ID}"

    echo "  CLIENT_ID:              ${CLIENT_ID}"
    echo "  REDIRECT_URI:           ${REDIRECT_URI}"

    echo "  PROTOCOL:               ${PROTOCOL}"

    echo "  AUTH_DOMAIN:            ${AUTH_DOMAIN}"
    echo "  AUTH_ACCOUNT_ENV:       ${AUTH_ACCOUNT_ENV}"

    echo "  AUTH_URL:               ${AUTH_URL}"
    echo "  AUTH_TOKEN_URL:         ${AUTH_TOKEN_URL}"
    echo "  AUTH_USER_URL:          ${AUTH_USER_URL}"

    echo "  AUTH_SCOPE:             ${AUTH_SCOPE}"
    echo "  AUTH_BASE64:            ${AUTH_BASE64}"

    echo "  DOCUSIGN_API_VERSION:   ${DOCUSIGN_API_VERSION}"

    echo "  ESIGN_API_DOMAIN:       ${ESIGN_API_DOMAIN}"
    echo "  ESIGN_API_ENV:          ${ESIGN_API_ENV}"

    echo "  ESIGN_API_URL:          ${ESIGN_API_URL}"
    echo "  ESIGN_API_VERSION:      ${ESIGN_API_VERSION}"

    echo "  SECURITY_TOKEN:         ${SECURITY_TOKEN}"
    echo "  DOCUSIGN_ID:            ${DOCUSIGN_ID}"

    echo "  JWT_ASSERTION:          ${JWT_ASSERTION}"

    echo -e '\n-------------------------\n'
fi
