#!/bin/bash

curdir=~/Documents/Notes/current/
file=$(find $curdir -type l |fzf)

if [[ -d $curdir ]]; then
    unlink "$file"
    echo "Deleted symbolic link for $file in $curdir."
else
    echo "The ~/Documents/Notes/current directory does not exist. Please create it to proceed."
    exit 1
fi
