import BeautifulSoup2
from BeautifulSoup2 import BeautifulSoup
import sys
import pprint

soup = BeautifulSoup(open(sys.argv[1]).read())

try:
	style = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[1].td.table.tr.contents[1].center.table.contents[2].td.table.tr.contents[1].small.string
	date = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[1].td.table.tr.contents[1].center.table.contents[2].td.table.contents[1].contents[1].small.string;
except IndexError:
	style = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[0].td.contents[1].contents[3].contents[1].contents[1].contents[3].table.contents[2].td.table.tr.contents[1].small.string

	date = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[0].td.contents[1].contents[3].contents[1].contents[1].contents[3].table.contents[2].td.table.contents[1].contents[1].small.string
	
resStyle = style.replace("Ambient, Chillout", "Chillout").replace("Psytrance, Psychedelic Trance", "Psytrance").replace("Progressive Trance", "Progressive")

dateArray = date.split(". ");
# The dateArray can be delimited by a space instead
if (len(dateArray) == 1):
	dateArray = date.split(" ");

month = dateArray[0];
dateArray = dateArray[1].split("/");
year = dateArray[0];
week = dateArray[1];
day = str(((int(week) - 1) % 4) * 7)
if day == "0": day = "01"
if day == "7": day = "07"

dateDict = {'Jan': '01', 'Feb': '02', 'Mar': '03', 'March': '03', 'Apr': '04', 'April': '04', 'May': '05', 'Jun': '06', 'June' : '06', 'Jul': '07', 'July' : '07', 'Aug': '08', 'August': '08', 'Sep': '09', 'Sept': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'}

resDate = year + "-" + dateDict[month] + "-" + day

resArtist = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.tr.td.form.table.contents[2].contents[1].span.b.text.strip(":")
resAlbum = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.tr.td.form.table.contents[2].contents[1].contents[1].string.replace(" EP", "")

try:
	result = pprint.pformat(soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[1].tr.td.span.b).replace('<b>1. ', '').replace('<br /></b>', '').replace('1. ', '').replace(' </b>', '')
	
	if result == "None":
		result = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[0].contents[0].contents[1].contents[3].contents[2].table.contents[1].contents[0].contents[0].contents[0]
	
except IndexError:
	result = soup.html.body.center.contents[3].tr.td.table.tr.contents[1].table.contents[0].contents[0].contents[1].contents[3].contents[2].td.table.tr.td.span.b.string;

textArray = soup.findAll(align="JUSTIFY");
firstSong = pprint.pformat(result).replace('<b>1. ', '').replace('<br /></b>', '').replace('1. ', '').replace(' </b>', '').strip("'").replace('</b>', '')

resInfo = ''
for test in textArray: 
	resInfo += test.renderContents()


import urllib2

url = "http://ws.spotify.com/search/1/track?q=" + (resArtist + " " + resAlbum + " " + firstSong).replace(" ", "%20")
print >> sys.stderr, ("Spotify request: gets 502 error sometimes but seem to be random.." + url)
req = urllib2.Request(url)
# The 502 error can be tested with: python ../../../parser.py 39.html 23.link
response = urllib2.urlopen(req)
the_page = response.read()
soup = BeautifulSoup(the_page)
albums = soup('album');
if len(albums) == 0 : 
	print >> sys.stderr, "Found Nothing"
	sys.exit()

# get the album
resSpotify = albums[0]['href']

# get the image

spotifyHttpUrl = "http://open.spotify.com/album/" +  resSpotify.split(":")[2]
req = urllib2.Request(spotifyHttpUrl)
response = urllib2.urlopen(req)
the_page = response.read()
soup = BeautifulSoup(the_page)
resImage = soup('img', id="big-cover")[0]['src']

def encode(value):
	return value.replace("'", "\\\\\\\'").replace("\n", "")


print "array('" + encode(resArtist) + "', '" + encode(resAlbum) + "', '" + resStyle + "', '" + resDate + "', '" + encode(resInfo) + "', '" + sys.argv[2] + "', '" + resSpotify + "', '" + resImage + "'),";
