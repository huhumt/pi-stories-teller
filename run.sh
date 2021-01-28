#!/usr/bin/bash

create_config_file()
{
    local root_directory=$(eval echo ~${SUDO_USER})
    local config_json_filename="$root_directory/.podfox.json"
    local path_filename="$root_directory/Music/podcast"

    if [[ ! -f "$config_json_filename" ]]
    then
        printf "{\n    \"podcast-directory\" : \""%s"\",\n    \"maxnum\"            : 5\n}" "$path_filename" > "$config_json_filename"
    fi

    if [[ ! -d "path_filename" ]]
    then
        mkdir -p "$path_filename"
    fi
}

download_podcast()
{
    python ./src/main.py import "$1"
    python ./src/main.py update
    python ./src/main.py download
}

create_config_file
download_podcast "$1"
