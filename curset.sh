#!/bin/bash

file=$(find ~/Documents/Notes -type f|fzf)
curdir=~/Documents/Notes/current/

if [[ -d $curdir ]]; then
    ln -s "$file" "$curdir"
    echo "Created symbolic link for $file in $curdir."
else
    echo "The ~/Documents/Notes/current directory does not exist. Please create it to proceed."
    exit 1
fi

