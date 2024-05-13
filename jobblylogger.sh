#!/bin/bash

# Check if both date and comment are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <date> <comment>"
    exit 1
fi

# Extract date and comment from command line arguments
date="$1"
comment="$2"

# Format the date string to match SQLite's format (YYYY-MM-DD HH:MM:SS)
formatted_date=$(date -d "$date" +"%Y-%m-%d %H:%M:%S")

# SQLite command to insert the record
sqlite3 ~/Documents/Notes/jobblylogger.db "INSERT INTO jobbies (date, comments) VALUES ('$formatted_date', '$comment');"

# Check if the insertion was successful
if [ $? -eq 0 ]; then
    echo "Record inserted successfully."
else
    echo "Failed to insert record."
fi

