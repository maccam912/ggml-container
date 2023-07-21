FROM ubuntu
WORKDIR /app
# COPY --from=build /app/llama.cpp/main /usr/local/bin/
RUN apt-get update && apt-get install wget python3 python3-pip build-essential git -y
RUN git clone https://github.com/ggerganov/llama.cpp --recursive
RUN cd llama.cpp && make main -j && cp main /usr/local/bin/
RUN pip install -U litestar uvicorn pydantic
COPY startup.sh .
COPY server.py .
CMD bash startup.sh