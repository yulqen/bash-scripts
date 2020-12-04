#!/bin/sh

# concatenates two history files from fish usage and runs through fzf

cat ~/Nextcloud/archive/fish-history-dec2020 ~/Nextcloud/archive/fish-history-july2018|fzf
