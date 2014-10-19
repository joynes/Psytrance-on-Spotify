#! /bin/bash

header=`grep '^<TITLE>' $1 | sed 's/<TITLE>\(.*\) (.*/\1/' | sed 's/EP//'`
artist=`echo ${header%:*} | xargs`
title=`echo ${header#*:} | xargs`
echo "Artist: $artist, Title: $title"
track1=`grep '<B>1\. ' $1 | sed 's/.*<B>1\. \([^<]*\).*/\1/'`
echo "Track1: $track1"

style=`grep 'Style:' $1  | sed 's/.*Style:[^m]*m">\([^<]*\).*/\1/'`
style=`echo "$style" | sed 's/Ambient, Chillout/Chillout/' | sed 's/Psychedelic Trance/Psytrance/' | sed 's/Progressive Trance/Progressive/' | sed 's/Psytrance, Psytrance/Psytrance/' | sed 's/Trance/Psytrance/'`
echo "Style: $style"
time=`grep 'Released' $1 | sed 's/.*Released[^m]*m">\([^<]*\).*/\1/'`
month=${time%.*}
year=${time%/*}
year=${year#*. }
week=${time#*/}
week=${week#0}
timestamp=`python -c "from isoweek import Weekprint Week($year,$week).monday()"`

echo "Time: $time -> $timestamp"

url=`echo "https://api.spotify.com/v1/search?q=$artist $title $track1&type=track" | sed 's/ /%20/g'`
md5=`echo "$url" | /sbin/md5`
[ ! -f ${md5}.spotify_search ] && curl  "$url" --silent --output ${md5}.spotify_search || echo -e "\e[32mUsing cached search\e[0m"
result=`cat ${md5}.spotify_search`

echo "Search: ${md5}.spotify_search"
album=`echo "$result" | grep 'spotify:album' | head -n 1 | sed 's/.* : "\(.*\)"/\1/'`
# If album was not found then remove the cache since it might get available later in spotify
[ "$album" ] || { echo -e "\e[31mNO RESULTS FOR $artist $title $track1\e[0m"; [ -f ${md5}.spotify_search ] && rm ${md5}.spotify_search && echo "Removed cache ${md5}.spotify_search"; exit 0; }
echo "Album: $album"
#echo "$result"
# Get # of tracks
tracks_count=`curl --silent "http://ws.spotify.com/lookup/1/?uri=$album&extras=track" | grep 'spotify:track' | wc -l | awk '{print $1}'`
echo "Tracks count: $tracks_count"

coverart=`echo "$result" | grep 'url".*image' | head -n 1 | sed 's/.* : "\(.*\)",/\1/'`

echo "Coverart: $coverart"

artist=${artist//\'/\"}
title=${title//\'/\"}

echo "array('$artist', '$title', '$style', '$timestamp', '$tracks_count', '$2', '$album', '$coverart')," >> inserts.txt
