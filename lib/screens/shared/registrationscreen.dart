import 'dart:convert';
import 'package:barterit/appconfig/myconfig.dart';
import 'package:barterit/screens/shared/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late double screenWidth;
  late double screenHeight;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _pass1EditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();
  bool _obscurePass = true;
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          title: const Text(
            "User Registration",
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
                height: screenHeight * 0.3,
                width: screenWidth,
                color: Colors.cyan,
                child: Image.asset('assets/images/register.png',
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
                      const Text("Registration Form",
                          style: TextStyle(
                              fontFamily: 'SourceSansPro', fontSize: 20)),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: _nameEditingController,
                                  validator: (value) =>
                                      value!.isEmpty || (value.length < 5)
                                          ? "Name must be at least 5 characters"
                                          : null,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Name',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.person),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                              TextFormField(
                                  controller: _phoneEditingController,
                                  validator: (value) => value!.isEmpty ||
                                          (value.length < 10)
                                      ? "Phone number must be at least 10 characters"
                                      : null,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                      labelText: 'Phone',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.phone),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
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
                              TextFormField(
                                  controller: _pass1EditingController,
                                  validator: (value) => value!.isEmpty ||
                                          (value.length < 5)
                                      ? "Password must be longer than 5 characters"
                                      : null,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(),
                                      icon: const Icon(Icons.lock),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscurePass = !_obscurePass;
                                          });
                                        },
                                        child: Icon(_obscurePass
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      )),
                                  obscureText: _obscurePass),
                              TextFormField(
                                  controller: _pass2EditingController,
                                  validator: (value) => value!.isEmpty ||
                                          (value.length < 5)
                                      ? "Password must be longer than 5 characters"
                                      : null,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: const TextStyle(),
                                      icon: const Icon(Icons.lock),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _obscurePass = !_obscurePass;
                                          });
                                        },
                                        child: Icon(_obscurePass
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      )),
                                  obscureText: _obscurePass),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: null,
                                      child: const Text('Agree with terms',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
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
                                    onPressed: onRegisterDialog,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    textColor:
                                        Theme.of(context).colorScheme.onError,
                                    child: const Text('Register'),
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

  void onRegisterDialog() {
    String pass1 = _pass1EditingController.text;
    String pass2 = _pass2EditingController.text;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your input"),
      ));
      return;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please accept the terms and conditions"),
      ));
      return;
    }
    if (pass1 != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your password"),
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Register new account?", style: TextStyle()),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                registerUser();
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

  void registerUser() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String password = _pass1EditingController.text;

    http.post(Uri.parse("${MyConfig().server}/barterit/php/register_user.php"),
        body: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }
    });
  }
}
