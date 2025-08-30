#!/bin/bash
# This script monitors CPU utilization and temperature in real-time,
# printing values every 5 seconds to the console.

# Check if 'sensors' is installed
if ! command -v sensors &> /dev/null; then
    echo "Error: 'sensors' is not installed. Please install it (e.g., sudo apt install lm-sensors) and try again."
    exit 1
fi

while true; do
    cpu_util=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat) <(sleep 5;grep 'cpu ' /proc/stat))
    cpu_temp=$(sensors | grep 'Tctl' | awk '{print $2}')
    echo "$(date): CPU Utilization = $cpu_util, CPU Temperature = $cpu_temp"
done
