#!/bin/bash

# IPMI details
HOST="192.168.68.104"
USER="USERID"
PASSWORD="PASSW0RD"
INTERVAL=1 # Interval in seconds between each full cycle of commands

# Temperature thresholds
LOWER_THRESHOLD=50
UPPER_THRESHOLD=80
MIDPOINT=65

while true; do
    # Get the temperature of the GPU
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

    # Apply stepped approach for fan speed based on GPU temperature
    if [ "$GPU_TEMP" -le "$LOWER_THRESHOLD" ]; then
        FAN_SPEED_HEX="50" # Minimum fan speed in hex
    elif [ "$GPU_TEMP" -le "$MIDPOINT" ]; then
        # Increment fan speed linearly in hexadecimal from 51°C to 65°C
        # 60°C corresponds to 0x60, using a simple mapping for this range
        FAN_SPEED_HEX=$(printf '%x\n' $((0x50 + GPU_TEMP - $LOWER_THRESHOLD)))
    else
        # For temperatures above 65°C, scale linearly to a max of 0x80 at 80°C
        if [ "$GPU_TEMP" -ge "$UPPER_THRESHOLD" ]; then
            FAN_SPEED_HEX="80" # Maximum fan speed in hex
        else
            # Calculate fan speed between 65°C and 80°C
            FAN_SPEED=$(($((100 * (GPU_TEMP - $MIDPOINT) / ($UPPER_THRESHOLD - $MIDPOINT))) * 0x20 / 100 + 0x60))
            FAN_SPEED_HEX=$(printf '%x\n' $FAN_SPEED)
        fi
    fi

    # Print the current GPU temperature and the calculated fan speed in hexadecimal
    echo "GPU Temperature: $GPU_TEMP°C, Fan Speed: $FAN_SPEED_HEX (hex)"

     ipmitool -I lanplus -U "$USER" -P "$PASSWORD" -H "$HOST" raw 0x3a 0x07 0xff $FAN_SPEED_HEX 0x00
     ipmitool -I lanplus -U "$USER" -P "$PASSWORD" -H "$HOST" raw 0x3a 0x07 0xff $FAN_SPEED_HEX 0x01

    sleep "$INTERVAL" # Wait for the defined interval before starting the cycle over
done
