import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barterit/models/product.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/appconfig/myconfig.dart';
import 'package:http/http.dart' as http;

class BuyerDetailsScreen extends StatefulWidget {
  final Product userproduct;
  final User user;
  const BuyerDetailsScreen(
      {super.key,
      required this.userproduct,
      required this.user,
      required int page});

  @override
  State<BuyerDetailsScreen> createState() => _BuyerDetailsScreenState();
}

class _BuyerDetailsScreenState extends State<BuyerDetailsScreen> {
  int qty = 0;
  int userqty = 1;
  double totalprice = 0.0;
  double singleprice = 0.0;
  int _index = 0;
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.userproduct.productQty.toString());
    totalprice = double.parse(widget.userproduct.productPrice.toString());
    singleprice = double.parse(widget.userproduct.productPrice.toString());
    _value = double.parse(widget.userproduct.productCondition.toString());
  }

  final df = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Column(children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
              itemCount: 3,
              controller: PageController(viewportFraction: 0.6),
              onPageChanged: (int index) => setState(() {
                    _index = index;
                  }),
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return image1();
                } else if (index == 1) {
                  return image2();
                } else if (index == 2) {
                  return image3();
                }
              }),
        ),
        Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.userproduct.productName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  "RM ${double.parse(widget.userproduct.productPrice.toString()).toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  "${widget.userproduct.productQty.toString()} available",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                )),
          ],
        ),
        StatefulBuilder(
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text("Product Condition",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Slider(
                  divisions: 10,
                  value: _value,
                  max: 10,
                  onChanged: (double _value) {}),
              Text("Condition ${_value.toInt()}/10",
                  style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(6),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.userproduct.productDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Product Type",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.userproduct.productType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.userproduct.productLocality}/${widget.userproduct.productState}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      df.format(DateTime.parse(
                          widget.userproduct.productDate.toString())),
                    ),
                  )
                ]),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: () {
                  if (userqty <= 1) {
                    userqty = 1;
                    totalprice = singleprice * userqty;
                  } else {
                    userqty = userqty - 1;
                    totalprice = singleprice * userqty;
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.remove)),
            Text(
              userqty.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                onPressed: () {
                  if (userqty >= qty) {
                    userqty = qty;
                    totalprice = singleprice * userqty;
                  } else {
                    userqty = userqty + 1;
                    totalprice = singleprice * userqty;
                  }
                  setState(() {});
                },
                icon: const Icon(Icons.add)),
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "Total",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "RM ${totalprice.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  contactsellerdialog();
                },
                icon: const Icon(
                  Icons.phone_iphone,
                  size: 24.0,
                ),
                label: const Text('Contact seller'),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.blueGrey,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(150, 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  addtocartdialog();
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 24.0,
                ),
                label: const Text('Add to cart'),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.blueGrey,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(150, 50),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void addtocartdialog() {
    if (widget.user.id.toString() == widget.userproduct.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User cannot add own item")));
      return;
    }
    if (widget.user.id == "na") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please login/register an account to add into cart")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add to cart?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addtocart();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addtocart() {
    http.post(Uri.parse("${MyConfig().server}/barteritV2/php/add_to_cart.php"),
        body: {
          "product_id": widget.userproduct.productId.toString(),
          "cart_qty": userqty.toString(),
          "cart_pr": totalprice.toString(),
          "userid": widget.user.id,
          "sellerid": widget.userproduct.productId,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfully added to cart")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed adding to cart")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed")));
        Navigator.pop(context);
      }
    });
  }

  Widget image1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: GestureDetector(
        onTap: _showImage1,
        child: Card(
          child: SizedBox(
            width: screenWidth,
            child: CachedNetworkImage(
              width: screenWidth,
              fit: BoxFit.fitWidth,
              imageUrl:
                  "${MyConfig().server}/barteritV2/assets/products/${widget.userproduct.productId}a.png",
              placeholder: (context, url) => const LinearProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget image2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: GestureDetector(
        onTap: _showImage2,
        child: Card(
          child: SizedBox(
            width: screenWidth,
            child: CachedNetworkImage(
              width: screenWidth,
              fit: BoxFit.fitWidth,
              imageUrl:
                  "${MyConfig().server}/barteritV2/assets/products/${widget.userproduct.productId}b.png",
              placeholder: (context, url) => const LinearProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget image3() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: GestureDetector(
        onTap: _showImage3,
        child: Card(
          child: SizedBox(
            width: screenWidth,
            child: CachedNetworkImage(
              width: screenWidth,
              fit: BoxFit.fitWidth,
              imageUrl:
                  "${MyConfig().server}/barteritV2/assets/products/${widget.userproduct.productId}c.png",
              placeholder: (context, url) => const LinearProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }

  void _showImage3() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CachedNetworkImage(
                width: screenWidth,
                fit: BoxFit.fitWidth,
                imageUrl:
                    "${MyConfig().server}/barteritV2/assets/products/${widget.userproduct.productId}c.png"),
          );
        });
  }

  void _showImage2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CachedNetworkImage(
                width: screenWidth,
                fit: BoxFit.fitWidth,
                imageUrl:
                    "${MyConfig().server}/barteritV2/assets/products/${widget.userproduct.productId}b.png"),
          );
        });
  }

  void _showImage1() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CachedNetworkImage(
                width: screenWidth,
                fit: BoxFit.fitWidth,
                imageUrl:
                    "${MyConfig().server}/barteritV2/assets/products/${widget.userproduct.productId}a.png"),
          );
        });
  }

  void contactsellerdialog() {
    if (widget.user.id == "na") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please login/register an account to contact seller")));
      return;
    }
  }
}
