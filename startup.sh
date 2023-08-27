#!/bin/bash
set -ex

URL = "https://huggingface.co/TheBloke/WizardCoder-Python-13B-V1.0-GGUF/resolve/main/wizardcoder-python-13b-v1.0.Q8_0.gguf"
MODEL = "wizardcoder-python-13b-v1.0.Q8_0.gguf"

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..
if [ ! -f /app/models/$MODEL ]; then
    pushd /app/models
    wget $URL
fi

cp /app/models/$MODEL /app/$MODEL
server -m /app/$MODEL --host "0.0.0.0"
