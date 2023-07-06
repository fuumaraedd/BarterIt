<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
//SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate FROM Orders INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;


if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlcart = "SELECT * FROM `tbl_carts` INNER JOIN `tbl_products` ON tbl_carts.product_id = tbl_products.product_id WHERE tbl_carts.user_id = '$userid'";
}

$result = $conn->query($sqlcart);
if ($result->num_rows > 0) {
    $cartitems["carts"] = array();
	while ($row = $result->fetch_assoc()) {
        $cartlist = array();
        $cartlist['cart_id'] = $row['cart_id'];
        $cartlist['product_id'] = $row['product_id'];
        $cartlist['product_name'] = $row['product_name'];
        $cartlist['product_status'] = $row['product_status'];
        $cartlist['product_type'] = $row['product_type'];
        $cartlist['product_desc'] = $row['product_desc'];
        $cartlist['product_qty'] = $row['product_qty'];
        $cartlist['product_price'] = $row['product_pr'];
        $cartlist['cart_qty'] = $row['cart_qty'];
        $cartlist['cart_price'] = $row['cart_pr'];
        $cartlist['user_id'] = $row['user_id'];
        $cartlist['seller_id'] = $row['seller_id'];
        $cartlist['cart_date'] = $row['cart_date'];
        array_push($cartitems["carts"] ,$cartlist);
    }
    $response = array('status' => 'success', 'data' => $cartitems);
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