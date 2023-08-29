#!/bin/bash
set -ex

URL="https://huggingface.co/TheBloke/CodeLlama-34B-Instruct-GGUF/resolve/main/codellama-34b-instruct.Q5_K_M.gguf"
MODEL="codellama-34b-instruct.Q5_K_M.gguf"

cd llama.cpp && make LLAMA_OPENBLAS=1 -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/$MODEL ]; then
    pushd /app/models
    wget $URL
fi

cp /app/models/$MODEL /app/$MODEL
server -m /app/$MODEL --host "0.0.0.0"
