#!/bin/bash
set -ex

cd llama.cpp && make main -j && cp main /usr/local/bin/ && cd ..
if [ ! -f /app/models/llama-2-13b-guanaco-qlora.ggmlv3.q5_K_M.bin ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/llama-2-13B-Guanaco-QLoRA-GGML/resolve/main/llama-2-13b-guanaco-qlora.ggmlv3.q5_K_M.bin
    popd
fi

uvicorn server:app --host=0.0.0.0 --log-level info