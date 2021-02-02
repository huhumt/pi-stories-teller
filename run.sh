#!/bin/bash

root_directory=$(eval echo ~${SUDO_USER})
config_json_filename="$root_directory/.podfox.json"
path_filename="$root_directory/Music/podcast"

create_config_file()
{
    if [[ ! -f "$config_json_filename" ]]
    then
        printf "{\n    \"podcast-directory\" : \""%s"\",\n    \"maxnum\"            : 5\n}" "$path_filename" > "$config_json_filename"
    fi

    if [[ ! -d "path_filename" ]]
    then
        mkdir -p "$path_filename"
    fi
}

check_time()
{
    local hour=$(date +%H)
    local int_hour=$(echo "$hour" | sed 's/^0*//')

    if [[ "$int_hour" -lt 10 ]]
    then
        echo "in the morning"
    elif [[ "$int_hour" -lt 15 ]]
    then
        echo "at noon"
    elif [[ "int_hour" -lt 19 ]]
    then
        echo "in the afternoon"
    else
        echo "at night"
    fi
}

play_audio_file()
{
    local audio_file_type=( "*.mp3" "*.ogg" "*.wav" "*.m4a" )
    local audio_file_string=""
    local audio_file_array=()
    local audio_file

    for audio_file in ${audio_file_type[@]}
    do
        audio_file_string+=$(find "$path_filename" -name "$audio_file")
    done

    audio_file_array=($audio_file_string)
    audio_file_array=( $(shuf -e "${audio_file_array[@]}") )

    for audio_file in ${audio_file_array[@]}
    do
        mplayer "$audio_file"
    done
}

remove_audio_file()
{
    local audio_file_type=( "*.mp3" "*.ogg" "*.wav" "*.m4a" )
    local audio_file

    for audio_file in ${audio_file_type[@]}
    do
        find "$path_filename" -name "$audio_file" -exec rm -fr {} \;
    done
}

download_podcast()
{
    local podcast_url_list=(
        "http://www.ximalaya.com/album/257813.xml"
        #"https://news.un.org/feed/subscribe/zh/audio-product/all/audio-rss.xml"
        "https://open.firstory.me/rss/user/ckgvv1m2ah8re0903njm7tcun"
        "https://api.soundon.fm/v2/podcasts/38cf0c12-46f7-4012-bcfb-34d85c98ab77/feed.xml"
        "https://open.firstory.me/rss/user/ckesn2sbvx5060839umop16go"
        "http://www.ximalaya.com/album/9329526.xml"
        "https://api.soundon.fm/v2/podcasts/0cb16276-249c-4d9d-834a-bbbaf7a51cc7/feed.xml"
    )
    local i

    for i in $(seq 1 ${#podcast_url_list[@]})
    do
        python3 ./src/main.py import "${podcast_url_list[i-1]}" "podcast_00$i"
        python3 ./src/main.py update "podcast_00$i"
    done

    python3 ./src/main.py download --how-many=1
}

create_task()
{
    local cur_time=$(check_time)

    play_audio_file

    if [ "$cur_time" == "at night" ]
    then
        remove_audio_file
        download_podcast
    fi
}

create_config_file
create_task
