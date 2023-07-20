import 'dart:async';
import 'dart:convert';
import 'package:barterit/models/user.dart';
import 'package:barterit/appconfig/myconfig.dart';
import 'package:barterit/screens/shared/mainscreen.dart';
import 'package:barterit/screens/shared/registrationscreen.dart';
import 'package:barterit/screens/shared/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double screenWidth;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _pass1EditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool _obscurePass = true;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          title: const Text(
            "Welcome to BarterIt",
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
                child:
                    Image.asset('assets/images/welcome.png', fit: BoxFit.cover),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: screenWidth * 0.9,
                alignment: Alignment.center,
                child: const Text("LOGIN",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Column(children: [
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                              controller: _emailEditingController,
                              validator: (val) => val!.isEmpty ||
                                      !val.contains("@") ||
                                      !val.contains(".")
                                  ? "Please enter a valid email"
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.email),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                          TextFormField(
                              controller: _pass1EditingController,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 5)
                                      ? "Password must be longer than 5"
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
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  saveremovepref(value!);
                                  setState(() {
                                    _isChecked = value;
                                  });
                                },
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: null,
                                  child: const Text('Remember Me',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                minWidth: screenWidth / 3,
                                height: 50,
                                elevation: 10,
                                onPressed: onLogin,
                                color: Theme.of(context).colorScheme.primary,
                                textColor:
                                    Theme.of(context).colorScheme.onError,
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ]),
                      )
                    ]),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: _forgotDialog,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Color.fromARGB(255, 37, 84, 255),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _guestDialog,
                    child: const Text(
                      "Join as Guest",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 56, 56),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minWidth: screenWidth * 0.95,
                padding: const EdgeInsets.all(10),
                height: 50,
                elevation: 10,
                onPressed: _goToRegister,
                color: const Color.fromARGB(255, 33, 20, 53),
                textColor: Theme.of(context).colorScheme.onError,
                child: const Text(
                  "Don't have an account? Register now!",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ));
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    String email = _emailEditingController.text;
    String pass = _pass1EditingController.text;
    try {
      http.post(Uri.parse("${MyConfig().server}/barteritV2/php/login_user.php"),
          body: {
            "email": email,
            "password": pass,
          }).then((response) {
        if (response.statusCode == 200) {
          var jsondata = json.decode(response.body);
          if (jsondata['status'] == 'success') {
            User user = User.fromJson(jsondata['data']);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(
                          user: user,
                        )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login Failed. Invalid E-mail or Password")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {});
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }

  void saveremovepref(bool value) async {
    FocusScope.of(context).requestFocus(FocusNode());
    String email = _emailEditingController.text;
    String password = _pass1EditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      if (!_formKey.currentState!.validate()) {
        _isChecked = false;
        return;
      }
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      await prefs.setBool("checkbox", value);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Stored")));
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      await prefs.setBool('checkbox', false);
      setState(() {
        _emailEditingController.text = '';
        _pass1EditingController.text = '';
        _isChecked = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Preferences Removed")));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    _isChecked = (prefs.getBool('checkbox')) ?? false;
    if (_isChecked) {
      setState(() {
        _emailEditingController.text = email;
        _pass1EditingController.text = password;
      });
    }
  }

  void _forgotDialog() {}

  void _goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void _guestDialog() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const SplashScreen()));
  }
}
