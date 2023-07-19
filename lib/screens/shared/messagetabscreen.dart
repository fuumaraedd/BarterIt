import 'package:barterit/models/user.dart';
import 'package:flutter/material.dart';

class MessageTabScreen extends StatefulWidget {
  final User user;
  const MessageTabScreen({super.key, required this.user});

  @override
  State<MessageTabScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  String maintitle = "Buyer";

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
    return const Scaffold();
  }
}
