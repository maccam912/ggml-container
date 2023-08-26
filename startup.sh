#!/bin/bash
set -ex

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/phind-codellama-34b-v1.Q5_K_M.gguf ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/Phind-CodeLlama-34B-v1-GGUF/resolve/main/phind-codellama-34b-v1.Q5_K_M.gguf
fi

cp /app/models/phind-codellama-34b-v1.Q5_K_M.gguf /app/phind-codellama-34b-v1.Q5_K_M.gguf
server -m /app/phind-codellama-34b-v1.Q5_K_M.gguf --host "0.0.0.0"
