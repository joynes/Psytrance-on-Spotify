<?php 

include 'data.php';

include 'login.php';
mysql_connect($server, $database, $password);
@mysql_select_db("joynes_psytrance") or die( "Unable to select database");

foreach ($array as $value) {
	print "-------------------------------------------------------\n";
	$insert="INSERT INTO album (artist, title, style, releasedate, info, psyshop, spotify, image) VALUES('$value[0]', '$value[1]', '$value[2]', '$value[3]', '$value[4]', '$value[5]', '$value[6]', '$value[7]');";
	
	print "$insert\n";
	
	if (!mysql_query($insert))
	{
		$data = "Error insert: " . mysql_errno() . ": " . mysql_error() . "When executing: $insert";
		echo "$data\n";
		
		$update="UPDATE album set artist='$value[0]', title='$value[1]', style='$value[2]', releasedate='$value[3]', info='$value[4]', psyshop='$value[5]', spotify='$value[6]', image='$value[7]' WHERE spotify='$value[6]';";
		
		if (!mysql_query($update)) {
			$data = "Error update: " . mysql_errno() . ": " . mysql_error() . "When executing: $update";
			echo "$data\n";
			
		}
		else {
			print "Sucess update: $value[6]\n";
		}
	}
	else {
		print "Sucess insert: $value[6]\n";
	}
	
	print "-------------------------------------------------------\n";
}

?>