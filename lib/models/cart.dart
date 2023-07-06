class Cart {
  String? cartId;
  String? productId;
  String? productName;
  String? productStatus;
  String? productType;
  String? productDesc;
  String? productQty;
  String? productPrice;
  String? cartQty;
  String? cartPrice;
  String? userId;
  String? sellerId;
  String? cartDate;

  Cart(
      {this.cartId,
      this.productId,
      this.productName,
      this.productStatus,
      this.productType,
      this.productDesc,
      this.productQty,
      this.productPrice,
      this.cartQty,
      this.cartPrice,
      this.userId,
      this.sellerId,
      this.cartDate});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productStatus = json['product_status'];
    productType = json['product_type'];
    productDesc = json['product_desc'];
    productQty = json['product_qty'];
    productPrice = json['product_price'];
    cartQty = json['cart_qty'];
    cartPrice = json['cart_price'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    cartDate = json['cart_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_status'] = productStatus;
    data['product_type'] = productType;
    data['product_desc'] = productDesc;
    data['product_qty'] = productQty;
    data['product_price'] = productPrice;
    data['cart_qty'] = cartQty;
    data['cart_price'] = cartPrice;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['cart_date'] = cartDate;
    return data;
  }
}
