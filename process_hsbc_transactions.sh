#!/bin/bash

tf="TransactionHistory.csv"

trap 'rm -f "$tmpfile"' EXIT
tmpfile=$(mktemp) || exit 1
echo "Our main tempfile is $tmpfile"

trap 'rm -f "$ledgertmp"' EXIT
ledgertmp=$(mktemp) || exit
echo "Our ledger formatted tempfile is $ledgertmp"

if [[ -a "~/Downloads/$tf" ]]; then tpath="~/Downloads/$tf"
elif [[ -a "$(pwd)/$tf" ]]; then tpath="$(pwd)/$tf"
else "Cannot find $tf. Expecting it either in ~/Downloads or in current folder."
fi

echo -e "Transaction File: $tpath"

# create the file if it doesn't exist
# ! [[ -a $tr_rev ]] && touch $tf_rev
# echo "" |> $tf_rev

# remove the BOM (https://stackoverflow.com/questions/45240387/how-can-i-remove-the-bom-from-a-utf-8-file)
sed -i $'1s/^\uFEFF//' $tpath

while read line; do
    line=${line/"-"/"£"}
    echo -e "$line\n$(cat $tmpfile)" > $tmpfile
done < $tpath

# how to append to a text file in bash
echo -e "Date,Description,Amount\n$(cat $tmpfile)" > $tmpfile

echo "Sorted transaction file: $tmpfile"

$(ledger convert --input-date-format "%d/%m/%Y" $tmpfile > $ledgertmp)

# Remove the erroneous Equity lines
sed -i '/Equity:Unknown/d' $ledgertmp
cat $ledgertmp
