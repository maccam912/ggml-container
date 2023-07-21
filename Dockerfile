FROM ubuntu as build

WORKDIR /app
RUN apt-get update && apt-get install wget build-essential git ninja-build cmake pkg-config -y
RUN git clone https://github.com/ggerganov/llama.cpp --recursive
WORKDIR /app/llama.cpp
RUN make -j

FROM ubuntu as deploy
WORKDIR /app
COPY --from=build /app/llama.cpp/main /usr/local/bin/
COPY startup.sh .
RUN apt-get update && apt-get install wget python3 python3-pip -y
RUN pip install -U litestar uvicorn pydantic
COPY server.py .
CMD bash startup.sh