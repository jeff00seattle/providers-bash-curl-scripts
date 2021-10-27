#!/usr/bin/env bash

source ../../../shared/helpers/url_decode.sh

url_parse_query_string() {
    AUTH_CODE_URL="${1}"

    URL_PATH=`echo $AUTH_CODE_URL | cut -d'?' -f1 | tr -d \\`
    URL_QUERY=`echo $AUTH_CODE_URL | cut -d'?' -f2 | tr -d \\`

    URL_PROTO="$(echo $URL_PATH | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    # remove the protocol
    URL_HOST="$(echo ${URL_PATH/$proto/})"

    JSON_QUERY_PARTS="{"

    URL_QUERY=${URL_QUERY//&/$'\n'}  # change the '&' to white space
    for query_part in $URL_QUERY
    do
        JSON_QUERY_PARTS=`echo -e $JSON_QUERY_PARTS '\n'`

        key="$(echo $query_part | cut -d"=" -f1)"
        value="$(echo $query_part | cut -d"=" -f2)"
        value=`url_decode "$value"`
        JSON_QUERY_PARTS=`echo -e $JSON_QUERY_PARTS \"${key}\": \"${value}\",`
    done

    JSON_QUERY_PARTS=`echo $JSON_QUERY_PARTS | sed 's/.$//'`
    JSON_QUERY_PARTS=`echo -e $JSON_QUERY_PARTS '\n'`
    JSON_QUERY_PARTS=`echo $JSON_QUERY_PARTS '}'`

    echo $JSON_QUERY_PARTS
}