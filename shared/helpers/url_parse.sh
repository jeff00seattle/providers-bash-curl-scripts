#!/usr/bin/env bash

function url_parse() {
    # remove quotes
    HREF=$(echo $1 | tr -d '"')

    # extract the PROTOCOL
    URL_PROTOCOL=$(echo $HREF | grep :// | sed -e's,^\(.*://\).*,\1,g')

    # extract the PROTOCOL SCHEME
    URL_SCHEME=`echo ${URL_PROTOCOL::-3}`

    # remove the PROTOCOL -- updated
    URL=$(echo $HREF | sed -e s,$URL_PROTOCOL,,g)

    # extract the host and port -- updated
    URL_HOSTPORT=$(echo $URL | sed -e s,$user@,,g | cut -d/ -f1)

    # by request host without port
    URL_HOST=${URL_HOST_PORT%:*}

    # by request - try to extract the port
    URL_PORT="$(echo $URL_HOSTPORT | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

    # Extract the path
    URL_PATH="$(echo $URL | grep / | cut -d/ -f2-)"

    # Extract the path parts
    IFS='/' read -ra URL_PATH_PARTS <<< "$URL_PATH"

    PP=
        for P1 in "${URL_PATH_PARTS[@]}" ; do
          # Add ',' unless this is first item
          [ "$PP" ] && PP="$PP, "
          PP=$PP\"$P1\"
        done

    URL_COMPONENTS="{ \
        \"protocol\": \"$URL_PROTOCOL\", \
        \"scheme\": \"$URL_SCHEME\", \
        \"url\": \"$HREF\", \
        \"host\": \"$URL_HOST\", \
        \"path\": \"$URL_PATH\", \
        \"parts\": [ $PP ] \
    }"
}