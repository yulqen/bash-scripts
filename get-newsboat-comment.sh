#!/usr/bin/bash

# 01/11/2022
# Get the user to type something
# for use in newsboat config.
# This is triggered by browser macro hack (,y) - you type a comment
# then this script pipes it to _tj
echo "Enter a comment: "
read -r comment
echo -e "$comment": "$1"|_tj # I can't be bothered checking whether `_tj` exists...

