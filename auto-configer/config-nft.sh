#!/bin/bash


config_nft(){

    # Create bacup if config file if it exist
    if [[ -f "/etc/nftables.conf" ]]; then
        log "config file is exists." 
        log "creating a backup for config file." 
        local suffix=$( date +%F_%R_%S_%N )
        sudo mkdir -p /etc/part-backups/nft.d
        sudo cp "/etc/nftables.conf" "/etc/part-backups/nft.d/nftables.conf.bak.$suffix"
    fi

    if [[ -f "/etc/ssh/sshd_config"  ]]; then
        grep -wq "Port" "/etc/ssh/sshd_config" 
        if [[ $? -ne 0 ]]; then
            log "couldn't find the ssh port in sshd_config file" show 
            return 1
        fi
        local ssh_port=$(grep -w "Port" "/etc/ssh/sshd_config" | cut -d " " -f 2)
        log "ssh port found in sshd_config file"
        log "current ssh port is $ssh_port"
    else
        log "couldn't find sshd_config file" show 
        return 1
    fi

    log "adjusting rules to nftables.conf"
    sudo tee "/etc/nftables.conf" &>/dev/null << EOF
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    
    chain input {
        type filter hook input priority 0; policy drop;  

        iif "lo" accept                                
        ct state established,related accept
        tcp dport $ssh_port accept                         

    }

    chain output {
        type filter hook output priority 0; policy accept
        ip daddr deb.debian.org counter
    }
}

EOF

    if [[ $? ]]; then
        log "NFTables configured succussfully" show
        sudo systemctl enable nftables.service
        sudo systemctl restart nftables
        return 0
    else
        log "NFTables configuration failed" show
        return 1
    fi
    
    

}

config_nft