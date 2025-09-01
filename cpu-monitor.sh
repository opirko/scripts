#!/bin/bash
# This script monitors CPU utilization and temperature in real-time, printing values at specified intervals to the console.

INTERVAL=5
LIMIT=0

show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -i, --dump-interval N    Number of seconds between dumps (default 5)"
    echo "  -l, --limit N           Quit after dumping N lines, default forever"
    echo "  -h, --help              Show this help message"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--dump-interval)
            INTERVAL="$2"
            if ! [[ "$INTERVAL" =~ ^[0-9]+$ ]] || [ "$INTERVAL" -le 0 ]; then
                echo "Error: Interval must be a positive integer"
                exit 1
            fi
            shift 2
            ;;
        -l|--limit)
            LIMIT="$2"
            if ! [[ "$LIMIT" =~ ^[0-9]+$ ]] || [ "$LIMIT" -le 0 ]; then
                echo "Error: Limit must be a positive integer"
                exit 1
            fi
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

if ! command -v sensors &> /dev/null; then
    echo "Error: 'sensors' is not installed. Please install it (e.g., sudo apt install lm-sensors) and try again."
    exit 1
fi

COUNT=0
while true; do
    cpu_util=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat) <(sleep $INTERVAL;grep 'cpu ' /proc/stat))
    cpu_temp=$(sensors | grep 'Tctl' | awk '{print $2}')
    echo "$(date): CPU Utilization = $cpu_util, CPU Temperature = $cpu_temp"

    COUNT=$((COUNT + 1))
    if [ "$LIMIT" -gt 0 ] && [ "$COUNT" -ge "$LIMIT" ]; then
        break
    fi
done
