import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/product.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/newproducttabscreen.dart';

class SellerTabScreen extends StatefulWidget {
  final User user;
  const SellerTabScreen({super.key, required this.user});

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Seller";
  List<Product> productList = <Product>[];
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    loadsellerProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      body: productList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: Column(children: [
                Container(
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(
                    "${productList.length} product(s) found",
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: GridView.count(
                      childAspectRatio: (1 / 1.2),
                      crossAxisCount: axiscount,
                      children: List.generate(
                        productList.length,
                        (index) {
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().server}/barterit/assets/products/${productList[index].productId}a.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          productList[index]
                                              .productName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Text(
                                          "${productList[index].productQty} left",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red.shade400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      )),
                ))
              ]),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewProductTabScreen(
                            user: widget.user,
                          )));
              loadsellerProducts();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
  }

  void loadsellerProducts() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_product.php"),
        body: {"userid": widget.user.id}).then((response) {
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

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${productList[index].productName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteProduct(index);
                Navigator.of(context).pop();
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

  void deleteProduct(int index) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/delete_product.php"),
        body: {
          "userid": widget.user.id,
          "productid": productList[index].productId
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadsellerProducts();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  Future<void> refreshList() async {
    return Future.delayed(Duration(seconds: 2));
  }
}
