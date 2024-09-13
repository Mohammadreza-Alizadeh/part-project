#!/bin/bash

setup_cron(){

    # needs extra attention
    local tmp_addr="/tmp/mycron"
    local cron='*/2 * * * * /bin/bash /usr/local/share/part-tools/data-collector.sh'

    # Save the current crontab to a temporary file
    log "create a tmp of current crons"
    sudo crontab -l > "$tmp_addr"


    # Use double quotes inside sed to ensure $cron is expanded and properly escape characters
    sudo sed -i "\%\*/2 \* \* \* \* bash /usr/loacl/share/part-tools/data-collector.sh%d" "$tmp_addr"

    # Append the cron job to the crontab
    log "appending new cron to tmp file"
    echo "$cron" >> "$tmp_addr"

    # Install the new crontab
    log "replacing tmp file with old cron list"
    sudo crontab "$tmp_addr"

    # Remove the temporary file
    log "deleting tmp file"
    rm "$tmp_addr"
    log "Cron set succussfully" show
    return 0
}

setup_cron