#!/bin/bash

config_ntp(){

    local config_addr="/etc/ntpsec/ntp.conf"
    local backups_dir="/etc/part-backups/ntp.d/"
    # Check if ntp is installed
    if apt-cache policy ntp | grep -q "Installed: (none)"; then
        log "ntp is not installed."
        read -p "ntp is not installed. do you want to download it automaticly? (Y/n)" user_input
        if [[ $user_input != "Y" && ! -z $user_input ]]; then
            log "user didn't agree to install ntp"
            echo "in order to use this tool you need to install ntp"
            echo "please use this tool after you installed ntp"
            return 2 # didn't want to install  
        fi
        log "starting to install ntp usings apt ..." show
        sudo apt install -y ntp &>/dev/null

        if [[ $? -ne 0 ]]; then
            log "unable to install ntp via apt" show
            return 3 # apt error
        fi
        log "ntp is installed succussfully" show 
    else
        log "ntp is already installded"
    fi
    

    if [[ ! -f "$config_addr" ]]; then
        log "Unable to find ntp.conf file" show
        return 4 # config file existence
    fi

    # Create a backup of config file
    local suffix=$( date +%F_%R_%S_%N )
    sudo mkdir -p $backups_dir && sudo cp "$config_addr" "$backups_dir/config.bak.$suffix"
    
    sudo sed -i '/^pool.*/d' $config_addr 
    echo 'pool org.ntp.pool iburst' | sudo tee -a $config_addr &>/dev/null
    
    log "restarting ntp service using systemctl" 
    sudo systemctl restart ntp
    if [[ $? ]]; then
        log "ntp service restarted"
    else 
        log "falied to restart ntp service using systemctl" show
    fi

    log "NTP configured to use org.ntp.pool" show
    return 0

}

config_ntp