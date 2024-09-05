#!/bin/bash

# Check if file was provided as argument
if [ -z "$1" ]; then
  echo "Error: No file specified."
  exit
fi

# Display file in pager (less)
less "$1"

# Ask user if they want to import the file
echo "Import this file? (y/n)"
read -r IMPORT_RESPONSE

if [ "${IMPORT_RESPONSE,,}" = "n" ]; then
  # Ask user if they want to delete the file
  echo "Delete this file instead? (y/n)"
  read -r DELETE_RESPONSE

  case ${DELETE_RESPONSE,,} in
    y) rm "$1"; exit ;;
    n) exit ;;
  esac

else
  # Append contents of file to scratchpad.txt
  NOTE=$(basename -s .md -- "$1")
  cat >> ~/Documents/Notes/Scratch/scratchpad.txt <<EOF
NOTE: $NOTE {{{
$(cat "$1") }}}
EOF
  rm "$1"; exit
  exit
fi
