import 'package:flutter/material.dart';
import 'package:flutter_project_1/oldButDontDeleteIt/version1/HomePage.dart';
import 'package:flutter_project_1/Screens/SignUpPage.dart';
import 'package:flutter_project_1/Screens/MainScreen.dart';
import 'Screens/HomePageCoffee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      initialRoute: '/MainScreen',
      routes: {
        '/MainScreen': (context) => MainScreen(),
        '/CoffeeScreen': (context) => CoffeeScreen(),
        '/SignUpPage': (context) => SignUpPage(),
        // '/HomePage': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
