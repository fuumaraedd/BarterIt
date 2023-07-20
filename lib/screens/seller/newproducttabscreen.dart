import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barterit/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/appconfig/myconfig.dart';

class NewProductTabScreen extends StatefulWidget {
  final User user;
  const NewProductTabScreen({super.key, required this.user});

  @override
  State<NewProductTabScreen> createState() => _NewProductTabScreenState();
}

class _NewProductTabScreenState extends State<NewProductTabScreen> {
  final ImagePicker picker = ImagePicker();
  late int axiscount = 3;
  int _index = 0;
  List<File> _imageList = [];
  File? _image;
  double _value = 0.0;
  var pathAsset = "assets/images/camera.png";
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
  final TextEditingController _prconditionEditingController =
      TextEditingController();

  String selectedType = "Home & Living";

  List<String> productlist = [
    "Home & Living",
    "Health & Beauty",
    "Electronics",
    "Toys, Kids & Babies",
    "Men's Apparel",
    "Women's Apparel",
    "Hobbies & Sports",
    "Other",
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController sliderController = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: const Text("Insert New Product"), actions: []),
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
          const SizedBox(
            height: 5,
          ),
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
                                        color:
                                            Color.fromARGB(255, 210, 210, 210),
                                        blurRadius: 2.0,
                                        offset: Offset(2.0, 2.0))
                                  ]),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 2, 40, 2),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    itemHeight: 55,
                                    value: selectedType,
                                    dropdownColor: const Color.fromARGB(
                                        255, 237, 220, 255),
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
                              value: _value,
                              max: 10,
                              onChanged: (double value) {
                                setState(() => _value = value);
                              },
                            ),
                            Text("Condition ${_value.toInt()}/10",
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
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
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
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
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
                              insertDialog();
                            },
                            child: const Text("Insert Product")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Future<void> _selectFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image selected")));
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _imageList.add(_image!);
      setState(() {});
    }
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_imageList.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload 3 pictures")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your product?",
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
                insertProduct();
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

  void insertProduct() {
    String productname = _productnameEditingController.text;
    String productdesc = _productdescEditingController.text;
    String productqty = _productqtyEditingController.text;
    String productpr = _productprEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    String condition = _value.toString();
    String base64Image1 = base64Encode(_imageList[0].readAsBytesSync());
    String base64Image2 = base64Encode(_imageList[1].readAsBytesSync());
    String base64Image3 = base64Encode(_imageList[2].readAsBytesSync());

    http.post(
        Uri.parse("${MyConfig().server}/barteritV2/php/insert_product.php"),
        body: {
          "userid": widget.user.id.toString(),
          "productname": productname,
          "productdesc": productdesc,
          "productqty": productqty,
          "productpr": productpr,
          "type": selectedType,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "image1": base64Image1,
          "image2": base64Image2,
          "image3": base64Image3,
          "condition": condition,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location is not available")));
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }

  Widget image1() {
    return Transform.scale(
      scale: 1,
      child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.black,
          child: GestureDetector(
            onTap: _selectFromGallery,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _imageList.isNotEmpty
                    ? FileImage(_imageList[0]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }

  Widget image2() {
    return Transform.scale(
      scale: 1,
      child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            onTap: _selectFromGallery,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _imageList.length > 1
                    ? FileImage(_imageList[1]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }

  Widget image3() {
    return Transform.scale(
      scale: 1,
      child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            onTap: _selectFromGallery,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: _imageList.length > 2
                    ? FileImage(_imageList[2]) as ImageProvider
                    : AssetImage(pathAsset),
                fit: BoxFit.cover,
              )),
            ),
          )),
    );
  }
}
