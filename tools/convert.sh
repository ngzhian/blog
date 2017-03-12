# get all files that starts with *.html
# get parse the date out from the html and the remaining file name

# call pandoc to convert into mdown


convert() {
    FILENAME="$1"

    D=$(echo $FILENAME | cut -c 1-10)
    N=$(echo $FILENAME | cut -c 12- | cut -d . -f 1)

    cat $FILENAME | node index.js | pandoc -r html -w markdown -o $N.mdown.temp

    # now add the Title and Date
    TITLE=$(head -n 1 $N.mdown.temp)

    echo "Title: $TITLE" > $N.mdown
    echo "Date: $D 18:00" >> $N.mdown
    echo "" >> $N.mdown
    cat $N.mdown.temp >> $N.mdown
    rm $N.mdown.temp
}

for f in *.html; do convert "$f" ; done
