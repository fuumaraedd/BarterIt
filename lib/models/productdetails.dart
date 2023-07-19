class OrderDetails {
  String? orderdetailId;
  String? orderBill;
  String? productId;
  String? productName;
  String? orderdetailQty;
  String? orderdetailPaid;
  String? buyerId;
  String? sellerId;
  String? orderdetailDate;

  OrderDetails(
      {this.orderdetailId,
      this.orderBill,
      this.productId,
      this.productName,
      this.orderdetailQty,
      this.orderdetailPaid,
      this.buyerId,
      this.sellerId,
      this.orderdetailDate});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    orderBill = json['order_bill'];
    productId = json['product_id'];
    productName = json['product_name'];
    orderdetailQty = json['orderdetail_qty'];
    orderdetailPaid = json['orderdetail_paid'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    orderdetailDate = json['orderdetail_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderdetail_id'] = orderdetailId;
    data['order_bill'] = orderBill;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['orderdetail_qty'] = orderdetailQty;
    data['orderdetail_paid'] = orderdetailPaid;
    data['buyer_id'] = buyerId;
    data['seller_id'] = sellerId;
    data['orderdetail_date'] = orderdetailDate;
    return data;
  }
}
