#!/bin/bash

setup_cron(){

    local tmp_addr="/tmp/mycron"
    local cron='*/2 * * * * /bin/bash /usr/local/share/part-tools/data-collector.sh'

    log "create a tmp of current crons"
    sudo crontab -l > "$tmp_addr"

    # Prevent duplication
    sudo sed -i "\%\*/2 \* \* \* \* bash /usr/loacl/share/part-tools/data-collector.sh%d" "$tmp_addr"

    log "appending new cron to tmp file"
    echo "$cron" >> "$tmp_addr"

    log "replacing tmp file with old cron list"
    sudo crontab "$tmp_addr"

    log "deleting tmp file"
    rm "$tmp_addr"
    log "Cron set succussfully" show
    return 0
}

setup_cron