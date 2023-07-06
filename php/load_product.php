<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 10;
if (isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;

if (isset($_POST['cartuserid'])){
	$cartuserid = $_POST['cartuserid'];
}else{
	$cartuserid = '0';
}

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloadproducts = "SELECT * FROM `tbl_products` WHERE user_id = '$userid'";
	$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$userid'";
}else if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloadproducts = "SELECT * FROM `tbl_products` WHERE product_name LIKE '%$search%'";
	$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}else{
	$sqlloadproducts = "SELECT * FROM `tbl_products`";
	$sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}

if (isset($sqlcart)){
	$resultcart = $conn->query($sqlcart);
	$number_of_result_cart = $resultcart->num_rows;
	if ($number_of_result_cart > 0) {
		$totalcart = 0;
		while ($rowcart = $resultcart->fetch_assoc()) {
			$totalcart = $totalcart+ $rowcart['cart_qty'];
		}
	}else{
		$totalcart = 0;
	}
}else{
	$totalcart = 0;
}
$result = $conn->query($sqlloadproducts);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproducts = $sqlloadproducts . " LIMIT $page_first_result , $results_per_page";
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
        $productlist['product_qty'] = $row['product_qty'];
	$productlist['product_pr'] = $row['product_pr'];
        $productlist['product_lat'] = $row['product_lat'];
        $productlist['product_long'] = $row['product_long'];
        $productlist['product_state'] = $row['product_state'];
        $productlist['product_locality'] = $row['product_locality'];
	$productlist['product_date'] = $row['product_date'];
	$productlist['product_condition'] = $row['product_condition'];
	$productlist['product_status'] = $row['product_status'];
        array_push($products["products"],$productlist);
    }
    $response = array('status' => 'success', 'data' => $products, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result", 'cartqty'=> $totalcart);
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