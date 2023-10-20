#!/bin/bash

curdir=~/Documents/Notes/current/

if [[ -d $curdir ]]; then
    ls -1 "$curdir/"
else
    echo "The ~/Documents/Notes/current directory does not exist. Please create it to proceed."
    exit 1
fi
