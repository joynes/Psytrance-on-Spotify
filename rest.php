<?php
	header('Content-type: application/json');
	header('Access-Control-Allow-Origin: *');

	$style = $_GET["style"];
	$page = $_GET["page"];
	$uid = $_GET["uid"];
	$filter = $_GET["filter"];
	$pageSize = $_GET["pageSize"];
	
	include 'login.php';
	mysql_connect($server, $database, $password);
	
	@mysql_select_db("joynes_psytrance") or die( "Unable to select database");

	//if ($style == 'Progressive') $style = "Progressive Trance";
	if ($style != 'All')
		$sqlStyle = "and style = '$style'";

	$join = "left outer join played on";
	$where = "where";
	$hide = "";
	if ($filter == 'hide') {
		$hide =  " and uid is null ";
	}
	else if ($filter == 'played') {
		$join = ", played where";
		$where = "and";
	}
	$order = "order by releasedate desc limit " . ($page * $pageSize) . ", " . $pageSize;
	
	$query = "select * from album $join album.spotify = played.spotify and played.uid = '$uid' $where 1 $sqlStyle $hide";
	//echo $query;
	$result = mysql_query("$query $order");
	$num=mysql_numrows($result);
	
	$countResult = mysql_query($query);
	$totalCount = mysql_numrows($countResult);

	mysql_close();
	
	for ($i = 0; $i < $num; $i++) {
		$albums[$i]['title'] = mysql_result($result,$i,"title");
		$albums[$i]['artist'] = mysql_result($result,$i,"artist");
		$albums[$i]['style'] = mysql_result($result,$i,"style");
		$albums[$i]['releasedate'] = mysql_result($result,$i,"releasedate");
		$albums[$i]['spotify'] = mysql_result($result,$i,"spotify");
		$albums[$i]['image'] = mysql_result($result,$i,"image");
		$albums[$i]['psyshop'] = mysql_result($result,$i,"psyshop");
		$albums[$i]['uid'] = mysql_result($result,$i,"uid");
		$albums[$i]['info'] = mysql_result($result,$i,"info");
	}

	// albums is a list of associative arrays. Need another level.

	$data['size'] = $totalCount;
	$data['albums'] = $albums;
	echo json_encode($data);
	
?>
