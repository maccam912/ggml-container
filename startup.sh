#!/bin/bash
set -ex

cd llama.cpp && make main -j && cp main /usr/local/bin/ && cd ..
if [ ! -f /app/models/nous-hermes-llama2-13b.ggmlv3.q8_0.bin ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/Nous-Hermes-Llama2-GGML/resolve/main/nous-hermes-llama2-13b.ggmlv3.q8_0.bin
    popd
fi

uvicorn server:app --host=0.0.0.0 --log-level info