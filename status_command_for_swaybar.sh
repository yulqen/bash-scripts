#/bin/sh
 
net="$(ip a|grep "inet 192"|cut -d' ' -f6|cut -d'/' -f1)"
packages="$(dpkg --get-selections|wc -l)"
weather="$(ansiweather -l Berwick-upon-Tweed,GB -f 1 -a false -s true -w true -d true)"
batt="$(cat /sys/class/power_supply/BAT0/capacity)"

echo "$weather | dpkg: $packages | bat: $batt | $net | $(date +"%Y-%m-%d %I:%M:%S %p")"
