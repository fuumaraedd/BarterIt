import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/product.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

class EditProductScreen extends StatefulWidget {
  final User user;
  final Product userproduct;

  const EditProductScreen(
      {super.key, required this.user, required this.userproduct});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _productnameEditingController =
      TextEditingController();
  final TextEditingController _productdescEditingController =
      TextEditingController();
  final TextEditingController _productqtyEditingController =
      TextEditingController();
  final TextEditingController _productprEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  String selectedType = "Home & Living";
  String condition = "";
  double currentCondition = 0;
  List<String> productlist = [
    "Home & Living",
    "Health & Beauty",
    "Electronics",
    "Toys, Kids & Babies",
    "Men's Apparel",
    "Women's Apparel",
    "Food & Drinks",
    "Hobbies & Sports",
    "Other",
  ];

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _productnameEditingController.text =
        widget.userproduct.productName.toString();
    _productdescEditingController.text =
        widget.userproduct.productDesc.toString();
    _productqtyEditingController.text =
        widget.userproduct.productQty.toString();
    _prstateEditingController.text = widget.userproduct.productState.toString();
    _prlocalEditingController.text =
        widget.userproduct.productLocality.toString();
    _productprEditingController.text =
        double.parse(widget.userproduct.productPrice.toString())
            .toStringAsFixed(2);
    selectedType = widget.userproduct.productType.toString();
    condition = widget.userproduct.productCondition.toString();
    currentCondition = double.parse('$condition');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Product"),
      ),
      body: Column(children: [
        Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: SizedBox(
                  width: screenWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${MyConfig().server}/barterit/assets/products/${widget.userproduct.productId}a.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            )),
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 55,
                            width: screenWidth,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.purple.shade100,
                                  Colors.purple.shade50,
                                  Colors.purple.shade100,
                                ]),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 210, 210, 210),
                                      blurRadius: 2.0,
                                      offset: Offset(2.0, 2.0))
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 2, 40, 2),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  itemHeight: 55,
                                  value: selectedType,
                                  dropdownColor:
                                      const Color.fromARGB(255, 237, 220, 255),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedType = newValue!;
                                    });
                                  },
                                  items: productlist.map((selectedType) {
                                    return DropdownMenuItem(
                                      alignment: AlignmentDirectional.center,
                                      value: selectedType,
                                      child: Text(
                                        selectedType,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ]),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Product name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _productnameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Product Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.type_specimen),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Product description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _productdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Product Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty ? "Invalid quantity" : null,
                            controller: _productqtyEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Product quantity',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.numbers),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty ? "Invalid price" : null,
                            onFieldSubmitted: (v) {},
                            controller: _productprEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Product Price',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.attach_money),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    StatefulBuilder(
                      builder: (context, state) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Product Condition",
                              style: TextStyle(fontSize: 16)),
                          Slider(
                            divisions: 10,
                            value: currentCondition,
                            max: 10,
                            onChanged: (double value) {
                              setState(() => currentCondition = value);
                            },
                          ),
                          Text("Condition ${currentCondition.toInt()}/10",
                              style: const TextStyle(
                                  fontSize: 14, fontStyle: FontStyle.italic)),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State unavailable"
                                : null,
                            enabled: false,
                            controller: _prstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality unavailable"
                                : null,
                            controller: _prlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.place),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            updateDialog();
                          },
                          child: const Text("Update Product")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void updateDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update your product?",
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
                updateProduct();
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

  void updateProduct() {
    String productname = _productnameEditingController.text;
    String productdesc = _productdescEditingController.text;
    String productqty = _productqtyEditingController.text;
    String productpr = _productprEditingController.text;
    String productcondition = currentCondition.toString();

    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_product.php"),
        body: {
          "productid": widget.userproduct.productId,
          "productname": productname,
          "productdesc": productdesc,
          "productqty": productqty,
          "productpr": productpr,
          "productcondition": productcondition,
          "type": selectedType,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}
