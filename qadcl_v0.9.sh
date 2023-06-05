#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo 'Usage: qadcl.sh input_file output_file'
    exit 1
fi

c=1
n=$(wc -l $1)

while IFS= read -r line; do

    country=`whois $line | awk -F':[ \t]+' 'tolower($1) ~ /^country$/ { print toupper($2); exit}'`
   
    if [ "$country" = "" ];
    then
        country=`whois $line | awk -F':[ \t]+' 'tolower($1) ~ /^registrant country$/ { print toupper($2); exit}'`

        if [ "$country" = "" ];
        then
            country=`whois $line | awk -F':[ \t]+' 'tolower($1) ~ /^phone$/ { print toupper($2); exit}'`
        fi
    fi
    
    echo $line, >> $2
    echo $country >> $2

    echo $c /$n
    ((c=c+1))

done < "$1"
