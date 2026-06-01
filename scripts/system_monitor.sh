#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROC_THRESHOLD=400

LOG_FILE="./system_health.log"

# Create log file if it doesn't exist
touch "$LOG_FILE"

timestamp=$(date "+%Y-%m-%d %H:%M:%S")

# CPU Usage
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
CPU=${CPU%.*}

# Memory Usage
MEM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

# Disk Usage
DISK=$(df / | awk 'END {print $5}' | tr -d '%')

# Running Processes
PROC_COUNT=$(ps -e --no-headers | wc -l)


alert() {
    echo "[$timestamp] ALERT: $1" | tee -a "$LOG_FILE"
}

# CPU Alert
if [ "$CPU" -gt "$CPU_THRESHOLD" ]; then
    alert "CPU usage is ${CPU}% (Threshold: ${CPU_THRESHOLD}%)"


fi

# Memory Alert
if [ "$MEM" -gt "$MEM_THRESHOLD" ]; then
    alert "Memory usage is ${MEM}% (Threshold: ${MEM_THRESHOLD}%)"

fi

# Disk Alert
if [ "$DISK" -gt "$DISK_THRESHOLD" ]; then
    alert "Disk usage is ${DISK}% (Threshold: ${DISK_THRESHOLD}%)"
fi

# Process Count Alert
if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
    alert "Running processes count is ${PROC_COUNT} (Threshold: ${PROC_THRESHOLD})"
fi


echo "Logs stored in: $LOG_FILE"