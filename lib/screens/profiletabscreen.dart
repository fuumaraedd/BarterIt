import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  String maintitle = "Profile";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Card(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  width: screenWidth * 0.4,
                  child: Image.asset(
                    "assets/images/profile.png",
                  ),
                ),
                Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 22, 20, 124),
                          ),
                        ),
                        Text(widget.user.email.toString()),
                        Text(widget.user.phone.toString()),
                      ],
                    )),
              ]),
            ),
          ),
          Container(
            height: 250,
          ),
          Expanded(
              child: ListView(
            children: [
              ElevatedButton(
                onPressed: _updateNameDialog,
                child: const Text("EDIT NAME"),
              ),
              ElevatedButton(
                onPressed: _updatePhoneDialog,
                child: const Text("EDIT PHONE NUMBER"),
              ),
              ElevatedButton(
                onPressed: _updateEmailDialog,
                child: const Text("EDIT E-MAIL"),
              ),
              ElevatedButton(
                onPressed: onLogoutDialog,
                child: const Text("LOGOUT"),
              ),
            ],
          )),
        ]),
      ),
    );
  }

  void onLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Logout", style: TextStyle()),
          content: const Text("Confirm logout?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
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

  Future<void> logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Logging Out..."),
        );
      },
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    late User user;
    if (email.length > 1 && password.length > 1) {
      http.post(Uri.parse("${MyConfig().server}/barterit/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) async {
        if (response.statusCode == 200 && response.body != "failed") {
          prefs = await SharedPreferences.getInstance();
          await prefs.remove('email');
          await prefs.remove('pass');
        }
      });
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Logged Out")));
  }

  void _updateNameDialog() {
    TextEditingController _nameeditingController = TextEditingController();
    _nameeditingController.text = widget.user.name.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Name",
            style: TextStyle(),
          ),
          content: TextField(
            controller: _nameeditingController,
            keyboardType: TextInputType.name,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                try {
                  http.post(
                      Uri.parse(
                          "${MyConfig().server}/barterit/php/update_profile.php"),
                      body: {
                        "newname": _nameeditingController.text,
                        "userid": widget.user.id
                      }).then((response) {
                    String jsonsDataString = response.body.toString();
                    var data = json.decode(jsonsDataString);
                    if (response.statusCode == 200 &&
                        data['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Edit Success")));
                      setState(() {
                        widget.user.name = _nameeditingController.text;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Edit Failed")));
                    }
                  });
                } on TimeoutException catch (_) {
                  print("Time out");
                }
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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

  void _updatePhoneDialog() {
    TextEditingController _phoneeditingController = TextEditingController();
    _phoneeditingController.text = widget.user.phone.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Phone Number",
            style: TextStyle(),
          ),
          content: TextField(
              controller: _phoneeditingController,
              keyboardType: TextInputType.phone),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                try {
                  http.post(
                      Uri.parse(
                          "${MyConfig().server}/barterit/php/update_profile.php"),
                      body: {
                        "newphone": _phoneeditingController.text,
                        "userid": widget.user.id
                      }).then((response) {
                    String jsonsDataString = response.body.toString();
                    var data = json.decode(jsonsDataString);
                    if (response.statusCode == 200 &&
                        data['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Edit Success")));
                      setState(() {
                        widget.user.phone = _phoneeditingController.text;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Edit Failed")));
                    }
                  });
                } on TimeoutException catch (_) {
                  print("Time out");
                }
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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

  void _updateEmailDialog() {
    TextEditingController _emaileditingController = TextEditingController();
    _emaileditingController.text = widget.user.email.toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Email",
            style: TextStyle(),
          ),
          content: TextField(
              controller: _emaileditingController,
              keyboardType: TextInputType.phone),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                try {
                  http.post(
                      Uri.parse(
                          "${MyConfig().server}/barterit/php/update_profile.php"),
                      body: {
                        "newemail": _emaileditingController.text,
                        "userid": widget.user.id
                      }).then((response) {
                    String jsonsDataString = response.body.toString();
                    var data = json.decode(jsonsDataString);
                    if (response.statusCode == 200 &&
                        data['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Edit Success")));
                      setState(() {
                        widget.user.phone = _emaileditingController.text;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Edit Failed")));
                    }
                  });
                } on TimeoutException catch (_) {
                  print("Time out");
                }
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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
}
