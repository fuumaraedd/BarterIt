<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloadproducts = "SELECT * FROM `tbl_products` WHERE user_id = '$userid'";
}if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloadproducts = "SELECT * FROM `tbl_products` WHERE products_name LIKE '%$search%'";
}else{
	$sqlloadproducts = "SELECT * FROM `tbl_products`";
}



$result = $conn->query($sqlloadproducts);
if ($result->num_rows > 0) {
    $products["products"] = array();
	while ($row = $result->fetch_assoc()) {
        $productlist = array();
        $productlist['product_id'] = $row['product_id'];
        $productlist['user_id'] = $row['user_id'];
        $productlist['product_name'] = $row['product_name'];
        $productlist['product_type'] = $row['product_type'];
        $productlist['product_desc'] = $row['product_desc'];
        $productlist['product_price'] = $row['product_price'];
        $productlist['product_qty'] = $row['product_qty'];
        $productlist['product_lat'] = $row['product_lat'];
        $productlist['product_long'] = $row['product_long'];
        $productlist['product_state'] = $row['product_state'];
        $productlist['product_locality'] = $row['product_locality'];
	$productlist['product_date'] = $row['product_date'];
        array_push($products["products"],$productlist);
    }
    $response = array('status' => 'success', 'data' => $products);
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