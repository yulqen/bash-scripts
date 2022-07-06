#!/bin/ksh

# Bookmark a web page by send the contents in text format by email to 'bookmark@matthewlemon.com'
# for future indexing and searching by notmuch, etc.

OUT_FILE=/tmp/out1.txt
OUT_FILE_P=/tmp/outpanddoc
EMAIL=bookmark@matthewlemon.com

USAGE="f:[format]t:[title]u:[url]"
while getopts "$USAGE" optchar
do
  case $optchar in
    f)  OUTFORMAT=$OPTARG ;;
    u)  URL=$OPTARG ;;
    t)  TITLE=$OPTARG ;;
    ?)  echo $USAGE; exit 2 ;;
  esac
done
shift $(($OPTIND - 1)) # not sure we need this

if ! [[ $OUTFORMAT == "md" || $OUTFORMAT == "markdown" || $OUTFORMAT == "plain" ]]
then
  echo "Format must be 'md', 'markdown' or 'plain'."; exit 1;
fi

# if [ ${#@} -gt 0 ]
# then
#   echo "Non-option arguments: " "$@"
#   exit 1
# fi

echo "$OUTFORMAT" "$URL" "$TITLE";

echo "$URL" > $OUT_FILE

pandoc -f html "$URL" -t "$OUTFORMAT" -o $OUT_FILE_P

# neomutt -s "$TITLE" -i "$(cat $OUT_FILE $OUT_FILE_P)" $EMAIL 

cat $OUT_FILE $OUT_FILE_P | mail -v -s "$TITLE" $EMAIL
rm $OUT_FILE $OUT_FILE_P
