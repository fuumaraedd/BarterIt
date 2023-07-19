import 'package:barterit/models/user.dart';
import 'package:barterit/screens/buyer/buyertabscreen.dart';
import 'package:barterit/screens/shared/messagetabscreen.dart';
import 'package:barterit/screens/shared/profiletabscreen.dart';
import 'package:barterit/screens/seller/sellertabscreen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Buyer";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      BuyerTabScreen(
        user: widget.user,
      ),
      SellerTabScreen(
        user: widget.user,
      ),
      ProfileTabScreen(
        user: widget.user,
      ),
      MessageTabScreen(
        user: widget.user,
      )
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: Text(
          maintitle,
          style: const TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconSize: 26,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.attach_money,
              ),
              label: "BUYER"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.store_mall_directory,
              ),
              label: "SELLER"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "PROFILE"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              label: "MESSAGE")
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Buyer";
      }
      if (_currentIndex == 1) {
        maintitle = "Seller";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
      if (_currentIndex == 3) {
        maintitle = "Message";
      }
    });
  }
}
