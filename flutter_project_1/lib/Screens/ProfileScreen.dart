import 'package:flutter/material.dart';
import 'package:flutter_project_1/Widgets/CustomElevatedButtonTwo.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 247),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 250, 223, 213),
              radius: 50,
              backgroundImage: AssetImage('images/delivery.png'),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: const Color.fromARGB(255, 236, 227, 223),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Salma Mourad',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: const Color.fromARGB(255, 236, 227, 223),

                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'salmamouradd992@gmail.com',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: const Color.fromARGB(255, 236, 227, 223),

                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          '01112345678',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  CustomElevatedButtonTwo(TextButton: 'Edit Profile'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
