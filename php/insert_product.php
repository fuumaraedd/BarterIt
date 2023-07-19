<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$product_name = $_POST['productname'];
$product_desc = $_POST['productdesc'];
$product_qty = $_POST['productqty'];
$product_pr = $_POST['productpr'];
$product_type = $_POST['type'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];
$condition = $_POST['condition'];

$sqlinsert = "INSERT INTO `tbl_products`(`user_id`,`product_name`, `product_desc`, `product_type`, `product_qty`, `product_pr`,`product_lat`, `product_long`, `product_state`, `product_locality`,  `product_condition`) VALUES ('$userid','$product_name','$product_desc','$product_type','$product_qty','$product_pr','$latitude','$longitude','$state','$locality','$condition')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);
	$decoded_string1 = base64_decode($image1);
	$decoded_string2 = base64_decode($image2);
	$decoded_string3 = base64_decode($image3);
	$path1 = '../assets/products/'.$filename.'a.png';
	$path2 = '../assets/products/'.$filename.'b.png';
	$path3 = '../assets/products/'.$filename.'c.png';
	file_put_contents($path1, $decoded_string1);
	file_put_contents($path2, $decoded_string2);
	file_put_contents($path3, $decoded_string3);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>