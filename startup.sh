#!/bin/bash
set -e

# Use environment variables if they are set, otherwise use default values
MODEL=${MODEL:-""}
URL=${URL:-""}
DEBUG=${DEBUG:-""}
PARTS=${PARTS:-1} # Indicates the number of parts. Default is 1 for a single part.

cd llama.cpp && make -j LLAMA_OPENBLAS=1 && cp server /usr/local/bin/ && cd ..

download_and_verify() {
    local url=$1
    local target_path=$2

    echo "Attempting to download from URL: $url" # Log the URL being attempted
    wget -O "$target_path" "$url" || { echo "Download failed, deleting partial file."; rm -f "$target_path"; exit 1; }

    # Placeholder for actual verification logic, such as checksum verification
}

# Only download the model if URL is set
if [ ! -z "$URL" ]; then
    if [ "$PARTS" -eq 1 ]; then
        filename="/app/models/$MODEL"
        if [ ! -f "$filename" ]; then
            pushd /app/models

            if [ ! -z "$DEBUG" ]; then
                sleep 3600
            fi

            echo "Initial URL to be downloaded: $URL" # Log the initial URL
            download_and_verify "$URL" "$filename"

            popd
        fi
    else
        echo "Initial list of URLs to be downloaded:" # Log the initial list of URLs
        for part in $(seq 1 $PARTS); do
            formatted_part=$(printf "%05d" $part)
            total_parts=$(printf "%05d" $PARTS)
            part_url="${URL}-${formatted_part}-of-${total_parts}.gguf"
            echo "$part_url"
        done

        for part in $(seq 1 $PARTS); do
            formatted_part=$(printf "%05d" $part)
            total_parts=$(printf "%05d" $PARTS)
            filename="/app/models/${MODEL}-${formatted_part}-of-${total_parts}.gguf"
            if [ ! -f "$filename" ]; then
                pushd /app/models

                if [ ! -z "$DEBUG" ]; then
                    sleep 3600
                fi

                part_url="${URL}-${formatted_part}-of-${total_parts}.gguf"
                download_and_verify "$part_url" "$filename"

                popd
            fi
        done

        # Combine parts if necessary and clean up
        # pushd /app/models
        # echo "Combining parts into a single model file: $MODEL"
        # cat ${MODEL}-*-of-*.gguf > "$MODEL"
        # echo "Cleaning up individual parts"
        # rm ${MODEL}-*-of-*.gguf
        # popd
    fi
fi

# Start server with the (potentially reassembled) model
echo "Starting server with model: /app/models/$MODEL"
server -m /app/models/$MODEL --host "0.0.0.0" --no-mmap -c 32768 -b 32768 -cb
