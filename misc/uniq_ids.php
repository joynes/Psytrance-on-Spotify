<?php

include 'login.php';
mysql_connect($server, $database, $password);
@mysql_select_db("joynes_psytrance") or die( "Unable to select database");

$query = "SELECT uid, count(uid) as my_count FROM `played` group by uid";
$result = mysql_query("$query $order");
$num=mysql_numrows($result);

mysql_close();

for ($i = 0; $i < $num; $i++) {
	echo mysql_result($result, $i, "uid") . ": " .  mysql_result($result, $i, "my_count") . "<br>";
}
?>