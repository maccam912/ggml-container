#!/bin/bash
set -ex

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/codellama-34b-instruct.Q5_K_M.gguf ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/CodeLlama-34B-Instruct-GGUF/resolve/main/codellama-34b-instruct.Q5_K_M.gguf
    popd
fi

server -m /app/models/codellama-34b-instruct.Q5_K_M.gguf --host "0.0.0.0"
