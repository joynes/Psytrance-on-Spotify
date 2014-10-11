source passwords/ftp_uri.sh
ftp "$ftp_uri" <<EOF
put  main.js psytrance.se/main.js
put  albumClicked.php psytrance.se/albumClicked.php
put  rest.php psytrance.se/rest.php
put  latestpsy.html psytrance.se/index.html
put  login.php psytrance.se/login.php
put  bg.png psytrance.se/bg.png
put  export.php psytrance.se/export.php
put  misc/uniq_ids.php psytrance.se/uniq_ids.php
EOF
