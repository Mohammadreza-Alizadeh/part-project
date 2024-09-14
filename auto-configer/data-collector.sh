#!/bin/bash

main(){
    mkdir -p /data/opt
    
    # Find child-proccesses of root
    root_processes=$(sudo ps -u root | wc -l) 
    prefix=$(date +'%b %d %T')
    echo "$prefix : $root_processes" >> "/data/opt/part_root_processes.log"
    
    # Find open and listening ports  
    listening_ports=$(sudo ss -tuln | grep LISTEN | awk '{print $5}' | awk -F ':' '{print $NF}')
    echo -e "$prefix\n$listening_ports" >> "/data/opt/part_listen_ports.log"

    # Find uids below 1000  
    users=$(cat /etc/passwd | awk -F ':' '$3 < 1000 {print $1}') 
    echo -e "$prefix\n$users" >> "/data/opt/part_uid_below_1000.log"
    exit 0
}

main $@