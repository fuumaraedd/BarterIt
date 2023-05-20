import 'dart:async';
import 'dart:convert';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/passwordverif.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          title: const Text(
            "Reset Password",
            style: TextStyle(fontSize: 22),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.cyan,
                child: Image.asset('assets/images/resetpassword.png',
                    fit: BoxFit.cover),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: 8,
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Text("Get Verification E-mail",
                          style: TextStyle(
                              fontFamily: 'SourceSansPro', fontSize: 20)),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: _emailEditingController,
                                  validator: (value) => value!.isEmpty ||
                                          (!value.contains("@") ||
                                              !value.contains("."))
                                      ? "Please enter a valid email"
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      labelText: 'E-mail',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.mail),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    minWidth: screenWidth / 3,
                                    height: 50,
                                    elevation: 10,
                                    onPressed: onVerificationDialog,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    textColor:
                                        Theme.of(context).colorScheme.onError,
                                    child: const Text('Next'),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void onVerificationDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your input"),
      ));
      return;
    }
    String email = _emailEditingController.text;
    try {
      http.post(Uri.parse("${MyConfig().server}/barterit/php/reset_pass.php"),
          body: {
            "email": email,
          }).then((response) {
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print(jsondata['status']);
          if (jsondata['status'] == 'success') {
            print("here");
            User user = User.fromJson(jsondata['data']);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => PasswordVerifScreen(
                          user: user,
                        )));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Invalid E-mail")));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Invalid E-mail")));
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {});
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }
}
