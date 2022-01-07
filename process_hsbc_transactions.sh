#!/bin/bash

tf="TransactionHistory.csv"

trap 'rm -f "$tmpfile"' EXIT
tmpfile=$(mktemp) || exit 1
echo "Our tempfile is $tmpfile"

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
    echo -e "$line\n$(cat $tmpfile)" > $tmpfile
done < $tpath

echo -e "Date,Description,Amount\n$(cat $tmpfile)" > $tmpfile
echo "Sorted transaction file: $tmpfile"

$(ledger convert --input-date-format "%d/%m/%Y" $tmpfile > toss)
