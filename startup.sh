#!/bin/bash
set -e

# Use environment variables if they are set, otherwise use default values
MODEL=${MODEL:-""}
URL=${URL:-""}
DEBUG=${DEBUG:-""}
PARTS=${PARTS:-1} # Indicates the number of parts. Default is 1 for a single part.

cd llama.cpp && make -j && cp server /usr/local/bin/ && cd ..

download_and_verify() {
    local url=$1
    local target_path=$2

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

            download_and_verify "$URL" "$filename"

            popd
        fi
    else
        # Generate suffixes 'a' to 'z' as needed
        declare -a suffixes=({a..z})
        for part in $(seq 1 $PARTS); do
            part_index=$((part - 1)) # Adjust index for 0-based array indexing
            part_suffix=${suffixes[$part_index]}
            filename="/app/models/${MODEL}-split-$part_suffix"
            if [ ! -f "$filename" ]; then
                pushd /app/models

                if [ ! -z "$DEBUG" ]; then
                    sleep 3600
                fi

                part_url="${URL}-split-$part_suffix"
                download_and_verify "$part_url" "$filename"

                popd
            fi
        done

        # Combine parts if necessary and clean up
        pushd /app/models
        cat ${MODEL}-split-* > "$MODEL"
        rm ${MODEL}-split-*
        popd
    fi
fi

# Start server with the (potentially reassembled) model
server -m /app/models/$MODEL --host "0.0.0.0" --no-mmap -c 32768 -b 32768 -cb
