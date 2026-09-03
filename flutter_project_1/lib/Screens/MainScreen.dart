import 'package:flutter/material.dart';
import 'package:flutter_project_1/Widgets/FavoritesDataGetter.dart';
import 'package:flutter_project_1/Screens/ProfileScreen.dart';
import 'package:flutter_project_1/Screens/HomePageCoffee.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    CoffeeScreen(),
    FavoritesDataGetter(),
    // CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.brown,
        // unselectedItemColor: Colors.brown[100],
        // unselectedLabelStyle: const TextStyle(color: Colors.brown),
        backgroundColor: const Color.fromARGB(255, 255, 249, 247),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_2), label: "Profile"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.card_travel_outlined),
          //   label: "Cart",
          // ),
        ],
      ),
    );
  }
}
