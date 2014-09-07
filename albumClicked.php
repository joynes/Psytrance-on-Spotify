<?php
	header('Content-type: application/json');
	header('Access-Control-Allow-Origin: *');

	$uid = $_GET["uid"];
	$url = $_GET["url"];
	
	include 'login.php';
	mysql_connect($server, $database, $password);
	@mysql_select_db("joynes_psytrance") or die( "Unable to select database");

	$query = "INSERT INTO played (uid, spotify) VALUES ('" . $uid . "', '" . $url . "');";
	
	if (!mysql_query($query))
	{
		$data = "Error: " . mysql_errno() . ": " . mysql_error() . "When executing: $query";
	}
	else 
		$data = 'ok';
	
	echo $data;
	
?>
