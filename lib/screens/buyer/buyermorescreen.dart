import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/appconfig/myconfig.dart';
import 'package:barterit/models/product.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;

import 'buyerdetailscreen.dart';

class BuyerMoreScreen extends StatefulWidget {
  final Product userproduct;
  final User user;
  const BuyerMoreScreen(
      {super.key, required this.userproduct, required this.user});

  @override
  State<BuyerMoreScreen> createState() => _BuyerMoreScreenState();
}

class _BuyerMoreScreenState extends State<BuyerMoreScreen> {
  List<Product> productList = <Product>[];
  int numberofresult = 0;
  late double screenHeight, screenWidth, cardwitdh;
  late User user = User(
      id: "na",
      name: "na",
      email: "na",
      phone: "na",
      password: "na",
      otp: "na");

  @override
  void initState() {
    super.initState();
    loadSellerItems();
    loadSeller();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("More from ")),
      body: Column(
        children: [
          Container(
              height: screenHeight / 8,
              width: screenWidth,
              child: Card(
                  child: user == "na"
                      ? const Center(child: Text("Loading..."))
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Store Owner\n" + user.name.toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))),
          const Divider(),
          productList.isEmpty
              ? Container()
              : Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(productList.length, (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Product userproduct =
                                  Product.fromJson(productList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => BuyerDetailsScreen(
                                            user: widget.user,
                                            userproduct: userproduct,
                                          )));
                            },
                            child: Column(children: [
                              CachedNetworkImage(
                                width: screenWidth,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${MyConfig().server}/barterit/assets/products/${productList[index].productId}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Text(
                                productList[index].productName.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${productList[index].productQty} available",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ]),
                          ),
                        );
                      })))
        ],
      ),
    );
  }

  void loadSellerItems() {
    http.post(
        Uri.parse("${MyConfig().server}/barterit/php/load_singleseller.php"),
        body: {
          "sellerid": widget.userproduct.userId,
        }).then((response) {
      productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  void loadSeller() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_user.php"),
        body: {
          "userid": widget.userproduct.userId,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          user = User.fromJson(jsondata['data']);
        }
      }
      setState(() {});
    });
  }
}
