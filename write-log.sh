#!/bin/bash
# This script counts the words of all the markdown files in a given directory
# on a given day. Should run from the directory invoked.

# initialize
path="$src"logs/
toDate=$(date +"%Y%m%d")

# grab the last date
lastDate=$(tail -1 $path/log.txt | cut -f 3 -d ' ')

# if the same day, delete the last entry
if [ "$toDate" -eq "$lastDate" ];
then
    # cut the last entry
    tail -n 1 $path/log.txt | wc -c | xargs -I {} truncate $path/log.txt -s -{}
fi

# grab old total word count from log
oldTotal=$(tail -1 $path/log.txt | cut -f 1 -d ' ')

# grab new total word count
# wc output is messy, tail and sed to cut the number
newTotal=$(wc -w $src*md | tail -n 1 | sed 's/[a-z ]//g')

# calculate number of new words written today
newToday=$((newTotal - oldTotal))

# display a message
if [ "$newToday" -eq 0 ]
then
    echo "You lost nothing. You gained nothing. $newToday today for a total of $newTotal"
elif [ "$newToday" -gt 0 ]
then
    echo "You wrote $newToday words since yesterday, for a total of $newTotal."
elif [ "$newToday" -lt 0 ]
then
    echo "You made your argument $newToday sharper since yesterday. Your total now is $newTotal. "
fi

# write to log if not zero
if [ "$newToday" -ne 0 ]
    then
        echo "$newTotal $newToday $toDate" >> $path/log.txt
fi
