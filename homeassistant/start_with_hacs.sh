# Source: https://github.com/serratoredavide/home-assistant-with-hacs/blob/main/start_with_hacs.sh
#!/bin/bash

# Home Assistant Config folder
CONFIG_DIR="/config"
HACS_DIR="$CONFIG_DIR/custom_components/hacs"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "ERROR: Folder /config doesn't exist!"
    exit 1
fi

# Start HomeAssistant
python3 -m homeassistant --config /config &
sleep 30

# Check for HACS
if [ ! -d "$HACS_DIR" ]; then
    echo "INFO: HACS not found. Installing..."
    cd $CONFIG_DIR
    wget -O - https://get.hacs.xyz | bash -

    # Need a restart
    echo "INFO: Restarting Home Assitant"
    pkill -f 'python3 -m homeassistant'
else
    echo "INFO: HACS already installed. No action needed"
fi

wait
