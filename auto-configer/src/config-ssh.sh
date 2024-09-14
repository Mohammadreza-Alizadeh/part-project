#!/bin/bash 

config_ssh(){
    
    
    local config_addr="/etc/ssh/sshd_config"
    local backups_dir="/etc/part-backups/ssh.d"

    # Check if ssh is installed or not
    if apt-cache policy openssh-server | grep -q "Installed: (none)"; then
        log "openssh-server is not installed."
        read -p "openssh-server is not installed. do you want to download it automaticly? (Y/n)" user_input
        if [[ $user_input != "Y" && ! -z $user_input ]]; then
            echo "in order to use this tool you need to install openssh-server"
            echo "use this tool after you installed ssh"
            log "user refused to install openssh-server"
            return 2 # didn't want to install  
        fi
        sudo apt install -y openssh-server &>/dev/null

        if [[ $? -ne 0 ]]; then
            log "unable to install openssh via apt"
            echo "unable to install openssh via apt at this point. please install it manually"
            return 3 # apt error
        fi

        log "openssh is installed succussfully" show  
    else
        log "openssh is already installded"
    fi
    
    if [[ ! -f "$config_addr" ]]; then
        log "Unable to find sshd_config file" show 
        return 4 # config file existence
    fi

    # Create a backup of current config
    local suffix=$( date +%F_%R_%S_%N )
    sudo mkdir -p $backups_dir && sudo cp "$config_addr" "$backups_dir/config.bak.$suffix"
    
    # Find and replace port   
    sudo sed -i "s/^#\?Port [1-9]*/Port $port/" $config_addr
    if [[ $? ]]; then
        log "SSH Port configured succussfully" show
    else
        log "SSH Port configuration failed" show 
    fi

    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' $config_addr
    if [[ $? ]]; then
        log "SSH Root login limitation configured succussfully" show
    else
        log "SSH Root login limitation configuration failed" show
    fi
    change_motd
    sudo systemctl restart ssh
    return 0
}

change_motd(){


    # Create a backup of current config
    local suffix=$( date +%F_%R_%S_%N )
    sudo mkdir -p /etc/part-backups/motd.d
    sudo cp "/etc/motd" "/etc/part-backups/motd.d/motd.bak.$suffix"
    sudo cat << EOF > "/etc/motd"  
        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠸⠀⠀⠀⣀⣠⡄⠀⠀⠀⠁⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⡶⠛⠛⠛⠟⢂⣶⣆⡀⠀⠇⠀⠀⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠆⠀⠀⠀⠀⠀⢀⣴⣿⠛⠛⢩⠇⠀⠀⠀⠀⠾⡇⠈⠻⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⢰⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⣠⠞⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠈⠀⠈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⡆⠀⠀        Hello from Emperor Penguin 3
    ⠀⠀⠀⠀⠀⠀⠀⡉⠁⠀⣰⡟⣣⠶⠛⠙⢻⣦⠀⠀⠀⠀⠀⢀⣴⠶⠚⠳⣾⣿⡀⢠⠒⠲⡄⢀⣀⠀⠀⠇⢰⠀⠀		Welcome to Alizadeh Computer 
    ⠀⠀⠀⠀⠀⠀⠄⢡⠀⢠⡿⣿⠋⠀⠀⠀⠀⠹⣧⠀⠀⠀⠀⢸⠃⠀⠀⠀⠈⣿⣇⢸⡀⠀⠙⠉⠀⢹⠀⠰⠈⠀⠀
    ⠀⠀⠀⠀⠀⠀⢠⠀⠀⣼⣼⠇⠀⣰⣾⣶⠀⢀⣿⢂⣠⣄⣀⣼⡄⢰⣿⣶⡄⠸⣿⡀⢣⡀⠀⢀⣠⠎⠀⠒⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⡆⢠⣿⡿⠀⠀⢿⣿⠟⠀⢸⣿⡏⠁⠀⢙⣿⡇⠈⢿⣿⠇⠀⢻⣧⠀⠳⠖⠋⠀⠀⠀⠀⠀⠰⠀
    ⡴⠉⠉⠓⠒⠒⠤⣄⡸⣿⣧⠀⠀⠀⣤⡄⠀⠀⠙⠿⠿⠿⠿⠋⠁⠀⠀⣤⡀⠀⣸⣿⣀⡤⠔⠒⠚⠉⠉⠳⡀⠀⠃
    ⢧⠀⠀⠀⠀⠀⠀⠀⠉⣻⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⠋⠁⠀⠀⠀⠀⠀⠀⢰⠃⠀⠀
    ⠘⢆⠀⠀⠀⠀⠀⠀⠈⣟⠙⠛⠷⣦⣄⣀⡀⠀⠀⢀⣀⠴⣲⢤⣀⣀⣠⣴⠾⠻⣿⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⠀⠀
    ⠀⠈⢦⡀⠀⠀⠀⠀⠀⠈⢧⠀⠀⠈⠉⠋⠉⠉⠉⠉⠀⠀⠀⠀⣿⠉⠀⠀⠀⣸⢿⠀⠀⠀⠀⠀⠀⣠⠏⠀⠀⠀⠀
    ⠀⠀⠀⠳⣄⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠈⢧⠀⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠈⠙⣲⠒⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⡒⠊⠉⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⢠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣳⡀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⡀⠀⡴⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⡇⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⡜⢀⡇⠀⠀⠀⠀⢠⠴⢤⣠⠴⠶⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠖⢻⣀⣀⣒⡇⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⡜⠀⠀⡇⠀⠀⠀⢠⠃⠀⡆⠀⠀⠀⠉⠉⣷⠀⠀⠀⠀⠀⠀⠀⢀⡎⠀⢀⠀⠀⠀⠿⣧⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⣧⠀⠀⠹⡄⠀⠀⢸⠀⠀⡇⠀⠀⠀⠀⢀⠇⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⢸⠀⠀⠀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠘⠳⠤⠤⣹⣦⡀⠸⡄⠀⠹⡄⠀⠀⠀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠸⡆⠀⠸⠀⢀⠼⠁⠀⢱⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠦⣄⣁⣀⣤⠾⠓⠒⠉⠉⠀⠀⠀⠉⠉⠑⠛⠢⠤⠴⠋⠀⠀⠠⠘⠀⠀
EOF
    if [[ $? ]]; then
        log "MOTD configured succussfully" show
    else
        log "MOTD configuration failed" show
        return 1
    fi
    return 0
}

config_ssh