import 'dart:convert';
import 'dart:developer';
import 'package:barterit/screens/seller/editproductscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/product.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/appconfig/myconfig.dart';
import 'package:barterit/screens/seller/newproducttabscreen.dart';

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
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var colour;
  int cartqty = 0;
  List<Product> productList = <Product>[];
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    loadSellerProducts(1);
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
                              onTap: () async {
                                Product currentProduct = Product.fromJson(
                                    productList[index].toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditProductScreen(
                                              user: widget.user,
                                              userproduct: currentProduct,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().server}/barteritV2/assets/products/${productList[index].productId}a.png",
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
                                              fontSize: 18,
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
                )),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        colour = Colors.red;
                      } else {
                        colour = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            loadSellerProducts(index + 1);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: colour, fontSize: 18),
                          ));
                    },
                  ),
                ),
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Please login/register an account to start selling")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    );
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
    http.post(
        Uri.parse("${MyConfig().server}/barteritV2/php/delete_product.php"),
        body: {
          "userid": widget.user.id,
          "productid": productList[index].productId
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  void loadProducts(int pg) {
    if (widget.user.id == "na") {
      setState(() {});
      return;
    }
    http.post(Uri.parse("${MyConfig().server}/barteritV2/php/load_product.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
      log(response.body);
      productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractdata = jsondata['data'];
          cartqty = int.parse(jsondata['cartqty'].toString());
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  Future<void> refreshList() async {
    return Future.delayed(Duration(seconds: 2));
  }

  void loadSellerProducts(int pg) {
    if (widget.user.id == "na") {
      setState(() {});
      return;
    }

    http.post(Uri.parse("${MyConfig().server}/barteritV2/php/load_product.php"),
        body: {
          "userid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
      log(response.body);
      productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
          var extractdata = jsondata['data'];
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
          print(productList[0].productName);
        } else {
          setState(() {});
        }
        setState(() {});
      }
    });
  }
}
