#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE=$1

if [ ! -f "$LOG_FILE" ]; then
    echo "ERROR: Log file not found: $LOG_FILE"
    exit 1
fi

echo
echo "Total Requests:"
wc -l < "$LOG_FILE"

echo
echo "Number of 404 Errors:"
grep ' 404 ' "$LOG_FILE" | wc -l

echo
echo "Top 10 Requested Pages:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10

echo
echo "Top 10 IP Addresses:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -10

echo
echo "Top 10 URLs Returning 404:"
grep ' 404 ' "$LOG_FILE" | awk '{print $7}' | sort | uniq -c | sort -rn | head -10

