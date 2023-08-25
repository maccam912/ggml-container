#!/bin/bash
set -ex

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/codellama-34b-instruct.Q8_0.gguf ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/CodeLlama-34B-Instruct-GGUF/resolve/main/codellama-34b-instruct.Q8_0.gguf
fi

cp /app/models/codellama-34b-instruct.Q8_0.gguf /app/codellama-34b-instruct.Q8_0.gguf
server -m /app/codellama-34b-instruct.Q8_0.gguf --host "0.0.0.0"
