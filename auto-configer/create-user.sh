#!/bin/bash

create_user() {
    
    if [[ -z $username ]]; then
        read -p "Please enter username (default is part): " username
        if [[ -z $username ]]; then
            username="part"
        fi
    fi

    # Create the user
    sudo useradd -m -G "sudo" -s "/bin/bash" "$username"

    # Check if the user was successfully created
    if [[ $? -eq 0 ]]; then
        log "User '$username' created successfully and added to sudo group" show

        # Prompt for a password
        echo "Please enter a password for the user '$username'"
        sudo passwd "$username" 

        # Check if the password was successfully set
        if [[ $? -eq 0 ]]; then
            log "Password set successfully for user '$username'"
        else
            log "Failed to set password for user '$username'" show
            return 2
        fi
    else
        log "Failed to create user '$username'" show
        return 1
    fi
    return 0
}

create_user 