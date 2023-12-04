#!/bin/bash
set -ex

# Use environment variables if they are set, otherwise use default values
MODEL=${MODEL:-""}
URL=${URL:-""}
DEBUG=${DEBUG:-""}

cd llama.cpp && make LLAMA_OPENBLAS=1 -j && cp server /usr/local/bin/ && cd ..

# Only download the model if URL is set
if [ ! -z "$URL" ]; then
    if [ ! -f /app/models/$MODEL ]; then
        pushd /app/models
        
        # Only sleep if DEBUG is set
        if [ ! -z "$DEBUG" ]; then
            sleep 3600
        fi

        wget $URL
        popd
    fi
fi

cp /app/models/$MODEL /app/$MODEL
server -m /app/$MODEL --host "0.0.0.0"
