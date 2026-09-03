import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/auth_service.dart';
import 'package:flutter_project_1/Screens/LoginScreen.dart';
import 'package:flutter_project_1/Screens/MainScreen.dart';
import 'package:flutter_project_1/Screens/SignUpPage.dart';
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
      home: const StartupGate(),
      routes: {
        '/MainScreen': (context) => const MainScreen(),
        '/CoffeeScreen': (context) => const CoffeeScreen(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/SignUpPage': (context) => const SignUpPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartupGate extends StatelessWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!
            ? const MainScreen()
            : const LoginScreen();
      },
    );
  }
}
