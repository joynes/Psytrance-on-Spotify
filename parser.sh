#!/bin/bash
header=`grep '^<TITLE>' $1 | sed 's/<TITLE>\(.*\) (.*/\1/' | sed 's/EP//'`
artist=${header%:*}
title=${header#*:}
echo "Artist: $artist, Title: $title"
track1=`grep '<B>1\. ' $1 | sed 's/.*<B>1\. \([^<]*\).*/\1/'`
echo "Track1: $track1"

style=`grep 'Style:' $1  | sed 's/.*Style:[^m]*m">\([^<]*\).*/\1/'`
echo "Style: $style"
time=`grep 'Released' $1 | sed 's/.*Released[^m]*m">\([^<]*\).*/\1/'`
month=${time%.*}
year=${time%/*}
year=${year#*. }
day=${time#*/}
declare -A montharr
montharr=([Jan]=1 [Feb]=2 [Mar]=3 [Apr]=4 [May]=5 [Jun]=6 [Jul]=7 [Aug]=8 [Sep]=9 [Okt]=10 [Nov]=11 [Dec]=12)
monthday=${montharr[Jan]}
echo "Time: $time"
echo "Year: $year"
echo "Month: $month -> $monthday"
echo "Day: $day"


result=`curl "$(echo http://ws.spotify.com/search/1/track?q=$artist $title $track1 | sed 's/ /%20/g')"`
album=`echo "$result" | grep '<album' | sed 's/[^"]*"\([^"]*\).*/\1/'`
echo "Album: $album"
