<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$productid = $_POST['productid'];
$product_name = $_POST['productname'];
$product_desc = addslashes($_POST['productdesc']);
$product_qty = $_POST['productqty'];
$product_pr = $_POST['productpr'];
$product_type = $_POST['type'];
$product_condition = $_POST['productcondition'];


$sqlupdate = "UPDATE `tbl_products` SET `product_name`='$product_name',`product_type`='$product_type',`product_desc`='$product_desc',`product_qty`='$product_qty',`product_pr`='$product_pr',`product_condition`='$product_condition' WHERE `product_id` = '$productid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
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