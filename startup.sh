#!/bin/bash
set -ex

URL="https://huggingface.co/TheBloke/Phind-CodeLlama-34B-v1-GGUF/resolve/main/phind-codellama-34b-v1.Q8_0.gguf"
MODEL="phind-codellama-34b-v1.Q8_0.gguf"

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/$MODEL ]; then
    pushd /app/models
    wget $URL
fi

cp /app/models/$MODEL /app/$MODEL
server -m /app/$MODEL --host "0.0.0.0"
