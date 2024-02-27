#/bin/sh
 
net="$(ip a|grep "inet 192"|cut -d' ' -f6|cut -d'/' -f1)"
toss="Toss!"
packages="$(dpkg --get-selections|wc -l)"
weather="$(ansiweather -l Berwick-upon-Tweed,GB -f 1 -a false -s true -w true -d true)"

echo "$weather | dpkg: $packages | $net | $(date +"%Y-%m-%d %I:%M:%S %p")"
