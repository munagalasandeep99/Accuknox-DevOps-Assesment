#!/bin/bash

LOG_FILE="backup.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

if [ $# -ne 2 ]; then
    log "BACKUP FAILED - Invalid arguments. Usage: $0 <ssh-key.pem> <user@host>"
    exit 1
fi

SSH_KEY=$1
REMOTE_HOST=$2

SOURCE_DIR="/home/sandeep/Documents"
REMOTE_DIR="/backup"

if [ ! -f "$SSH_KEY" ]; then
    log "BACKUP FAILED - SSH key file not found: $SSH_KEY"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    log "BACKUP FAILED - Source directory not found: $SOURCE_DIR"
    exit 1
fi

log "Starting backup of $SOURCE_DIR to $REMOTE_HOST:$REMOTE_DIR"

scp -i "$SSH_KEY" -r "$SOURCE_DIR" "${REMOTE_HOST}:${REMOTE_DIR}"

if [ $? -eq 0 ]; then
    log "BACKUP SUCCESSFUL"
else
    log "BACKUP FAILED"
fi