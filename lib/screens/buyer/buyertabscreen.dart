import 'package:barterit/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:barterit/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/appconfig/myconfig.dart';

import 'buyercartscreen.dart';
import 'buyerdetailscreen.dart';
import 'buyerorderscreen.dart';

class BuyerTabScreen extends StatefulWidget {
  final User user;
  const BuyerTabScreen({super.key, required this.user});

  @override
  State<BuyerTabScreen> createState() => _BuyerTabScreenState();
}

class _BuyerTabScreenState extends State<BuyerTabScreen> {
  String maintitle = "Buyer";
  List<Product> productList = <Product>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var colour;
  int cartqty = 0;
  TextEditingController searchController = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    loadProducts(1);
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
      appBar: AppBar(
        title: const Text(
          "   Available Products",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
          TextButton.icon(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            label: Text(cartqty.toString()),
            onPressed: () {
              if (cartqty > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => BuyerCartScreen(
                              user: widget.user,
                            )));
              } else {
                if (widget.user.id == "na") {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Please login/register an account to add into cart")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No item in cart")));
                }
              }
            },
          ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("My Order"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("New"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (widget.user.id.toString() == "na") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => BuyerOrderScreen(
                            user: widget.user,
                          )));
            } else if (value == 1) {
            } else if (value == 2) {}
          }),
        ],
      ),
      body: productList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: Column(children: [
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
                                  color:
                                      const Color.fromARGB(255, 225, 251, 255),
                                  elevation: 8,
                                  child: InkWell(
                                    onTap: () async {
                                      if (widget.user.id == "na") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Please login/register an account to a view product details")));
                                      } else {
                                        Product userproduct = Product.fromJson(
                                            productList[index].toJson());
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (content) =>
                                                    BuyerDetailsScreen(
                                                      user: widget.user,
                                                      userproduct: userproduct,
                                                    )));
                                        loadProducts(1);
                                      }
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
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "RM ${double.parse(productList[index].productPrice.toString()).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                "${productList[index].productQty} available",
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
                            )))),
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
                            loadProducts(index + 1);
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
    );
  }

  void loadProducts(int pg) {
    if (widget.user.id == "na") {
      cartqty = 0;
    }
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_product.php"),
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

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Enter keywords',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchProducts(search);
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 40, 13, 77)),
                ),
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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

  void searchProducts(String search) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/load_product.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
      log(response.body);
      productList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
          //print(productList[0].productName);
        }
        setState(() {});
      }
    });
  }

  Future<void> refreshList() async {
    return Future.delayed(Duration(seconds: 2));
  }
}
