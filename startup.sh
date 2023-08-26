#!/bin/bash
set -ex

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/llama2-70b-oasst-sft-v10.Q5_K_M.gguf ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/Llama2-70B-OASST-SFT-v10-GGUF/resolve/main/llama2-70b-oasst-sft-v10.Q5_K_M.gguf
fi

cp /app/models/llama2-70b-oasst-sft-v10.Q5_K_M.gguf /app/llama2-70b-oasst-sft-v10.Q5_K_M.gguf
server -m /app/llama2-70b-oasst-sft-v10.Q5_K_M.gguf --host "0.0.0.0"
