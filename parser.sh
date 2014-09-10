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

url=`echo "https://api.spotify.com/v1/search?q=$artist $title $track1&type=track" | sed 's/ /%20/g'`
result=`curl "$url"`

album=`echo "$result" | grep 'spotify:album' | sed 's/.* : "\(.*\)"/\1/'`
echo "Album: $album"
coverart=`echo "$result" | fgrep -A 1 '"height" : 640' | tail -n 1 | sed 's/.* : "\(.*\)",/\1/'`
echo "Coverart: $coverart"
