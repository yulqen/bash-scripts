#!/bin/bash

# Define the source and destination directories
SRC_DIR=/home/$USER/Documents
DST_HOST=bach:/mnt/encrypted/matt_backups/

# Run rsync command using ssh for encryption
rsync -avz --delete "$SRC_DIR" "$DST_HOST"
