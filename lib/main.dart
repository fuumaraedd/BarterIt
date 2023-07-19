import 'package:barterit/screens/shared/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIt',
      theme: ThemeData(
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 30, 13, 62), // background (button) color
            foregroundColor: Colors.white, // foreground (text) color
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
