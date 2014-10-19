# !/bin/bash

WEEKS=44 # Nr of weeks to grab, starting from 0
MAX_WEEK_SIZE=10000 # Nr of albums/week to parse

[ ! $1 ] && { echo "Usage: $0 <year>"; exit 1; }
year=$1
#------------------------------------------------------
# All the steps
#------------------------------------------------------
echo -------------------------------------------
echo Download all the search pages
echo -------------------------------------------

mkdir -p pages
cd pages
mkdir -p $year
cd $year
i=1; while [ $i -le $WEEKS ]; do nr=$i; [ $nr -lt 10 ] && nr=0$nr; [ -e $i.html ] && echo "Psyshop file $i.html already exists" || { \
curl -s -H 'Referer: http://www.psyshop.com/' -d 'boolean=AND&case=INSENSITIVE&other=TRUE&cd=TRUE&dw=TRUE&terms='$year'%2F'$nr 'http://www.psyshop.com/psyfctn/psysrch' > $i.html;
}; let i=i+1; done

echo -------------------------------------------
echo Get all individual links from theese pages
echo -------------------------------------------

grep '<DIV CLASS="n"><A HREF="/shop/' *.html | sed 's/.*<A HREF="\([^"]*\).*/http:\/\/www.psyshop.com\1/' > links.txt

echo "Found " `cat links.txt | wc | awk '{print $1}'` albums
mkdir -p albums
cd albums

echo -------------------------------------------
echo Get all individual pages.. and parse
echo -------------------------------------------

rm inserts.txt
cat ../links.txt | \
while read in; do
	md5=`echo $in | /sbin/md5`
	[ -e $md5 ] && echo "Individual album page $md5 exists..." || curl -s $in > $md5.html
	echo -e "\e[34m---------------------------------------"
	echo "parser.sh pages/$year/albums/$md5.html $in"
	echo -e "---------------------------------------\e[0m"
	bash ../../../parser.sh  $md5.html $in
done

rm data.php
echo '<?php $array = array(' >> data.php
cat inserts.txt | grep "^array(" >> data.php
echo '); ?>' >> data.php
. ../../../passwords/ftp_uri.sh
ftp "$ftp_uri" <<EOF
put data.php psytrance.se/data.php
EOF
curl "http://psytrance.se/export.php" | tee result.log

echo "inserted " `cat result.log | grep "Sucess insert" | wc | awk '{print $1}'` " albums"

#------------------------------------------------------
#------------------------------------------------------
