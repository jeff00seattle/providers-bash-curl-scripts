#!/usr/bin/env bash

uuid_lowercase() {
    echo "$(uuidgen | tr '[:upper:]' '[:lower:]')"
}
