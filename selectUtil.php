<?php
ob_start("ob_gzhandler");
include('config.php');

	$sql = "SELECT * FROM disease";
	$result = $conn->query($sql);
	header('Content-Type: application/json; charset=utf-8');
	//create an array
	$emparray = array();
	while($row=mysqli_fetch_assoc($result))
	{
		$emparray[] = $row;
	}
	echo json_encode($emparray);
?>