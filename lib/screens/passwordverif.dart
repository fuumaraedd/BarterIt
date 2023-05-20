import 'package:barterit/models/user.dart';
import 'package:flutter/material.dart';

class PasswordVerifScreen extends StatefulWidget {
  final User user;
  const PasswordVerifScreen({super.key, required this.user});

  @override
  State<PasswordVerifScreen> createState() => _PasswordVerifScreenState();
}

class _PasswordVerifScreenState extends State<PasswordVerifScreen> {
  final TextEditingController _codeEditingController = TextEditingController();
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
                      Text(
                          "A verification code has been sent to ${widget.user.email}",
                          style: const TextStyle(
                              fontFamily: 'SourceSansPro', fontSize: 20)),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: _codeEditingController,
                                  validator: (value) => value!.isEmpty ||
                                          (!value.contains("@") ||
                                              !value.contains("."))
                                      ? "Please enter a valid email"
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                      labelText: 'Verification Code',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.password),
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

  void onVerificationDialog() {}
}
