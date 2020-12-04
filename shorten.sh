#!/bin/sh

# check out https://github.com/chubin/awesome-console-services

if [ "$#" -ne 1 ] ; then
    echo "Please provide a single URL parameter to shorten."
    exit 1 
fi

result=$(curl -s tinyurl.com/api-create.php?url="$1")
echo "$result"
