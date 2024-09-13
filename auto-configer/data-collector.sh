#!/bin/bash

main(){
    mkdir -p /data/opt
    root_processes=$(sudo ps -u root | wc -l) 
    prefix=$(date +'%b %d %T')
    echo "$prefix : $root_processes" >> "/data/opt/part_root_processes.log"

    listening_ports=$(sudo ss -tuplen | grep LISTEN | awk '{print $5}' | awk -F ':' '{print $NF}')
    echo -e "$prefix\n$listening_ports" >> "/data/opt/part_listen_ports.log"

    users=$(cat /etc/passwd | awk -F ':' '$3 < 1000 {print $1}') 
    echo -e "$prefix\n$users" >> "/data/opt/part_uid_below_1000.log"
    exit 0
}

main $@