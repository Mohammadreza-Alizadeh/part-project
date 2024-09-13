#!/bin/bash

change_sources(){

    local backups_dir="/etc/part-backups/apt.d/"

    # Create a backup of current sources.list
    local suffix=$( date +%F_%R_%S_%N )
    sudo mkdir -p "$backups_dir" && sudo cp "/etc/apt/sources.list" "$backups_dir/sources.list.$suffix"
    if [[ $? -ne 0 ]]; then
        log "Couldn't create a backup file"
        read -p "Couldn't create a backup file of sources.list. do you want to continue? (Y/n)" user_choice
        if [[ -z $user_choice || "$user_choice" == "Y" ]]; then
            log "user agreed to continue setup apt repositories without backup"
        else
            log "user didn't agree to continue setup apt repositories without backup. exiting chane_sources"
            return 1
        fi
    fi

    # Copy tmp to original sources.list file
    sudo cp "$sources_sample_file_addr" "/etc/apt/sources.list"
    if [[ ! $? ]]; then
        log "Failed to set apt repositories - " show
        return 1
    fi

    log "Repositories set succussfully" show
    if [[ $disable != "true" ]]; then
        log "-d flag is not specified. apt update will be trigred"
        sudo apt update
    else
        log "-d flag is specified. apt update will not be trigred"
    fi
    return 0
}

change_sources