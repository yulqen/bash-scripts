#!/usr/local/bin/bash

url=$1
echo "Searching URL: $1"

webpage_title (){
	curl -s "$url" |grep "<title>"|sed -e 's/title//g' | sed -e 's/<>//g' | sed -e 's/<\/>//g'| sed -e 's/^[[:space:]]*//g'
}

url_title="$(webpage_title)"

# ref: https://stackoverflow.com/questions/18544359/how-do-i-read-user-input-into-a-variable-in-bash
if [[ -z $url_title ]]; then
	read -p "There is no title tag. Do you want to add one? (y/n)" confirm && \
	       	[[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
	read -p "Enter a nice title: " title
	descr="\"Read and review: $title\""
	id=$(task add pro:h.reading "$descr" | sed -n 's/Created task \(.*\)./\1/p')
	task "$id" annotate "$url"
fi
