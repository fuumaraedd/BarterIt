<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$productid = $_POST['product_id'];
$cartqty = $_POST['cart_qty'];
$cartprice = $_POST['cart_pr'];
$userid = $_POST['userid'];
$sellerid = $_POST['sellerid'];

$checkproductid = "SELECT * FROM `tbl_carts` WHERE `user_id` = '$userid' AND  `product_id` = '$productid'";
$resultqty = $conn->query($checkproductid);
$numresult = $resultqty->num_rows;
if ($numresult > 0) {
	$sql = "UPDATE `tbl_carts` SET `cart_qty`= (cart_qty + $cartqty),`cart_pr`= (cart_pr+$cartprice) WHERE `user_id` = '$userid' AND  `product_id` = '$productid'";
}else{
	$sql = "INSERT INTO `tbl_carts`(`product_id`, `cart_qty`, `cart_pr`, `user_id`, `seller_id`) VALUES ('$productid','$cartqty','$cartprice','$userid','$sellerid')";
}

if ($conn->query($sql) === TRUE) {
		$response = array('status' => 'success', 'data' => $sql);
		sendJsonResponse($response);
	}else{
		$response = array('status' => 'ohno here', 'data' => $sql);
		sendJsonResponse($response);
	}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>