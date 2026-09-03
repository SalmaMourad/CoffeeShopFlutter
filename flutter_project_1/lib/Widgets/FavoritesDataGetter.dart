import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/apiService.dart';
import 'package:flutter_project_1/Screens/favScreen.dart';

class FavoritesDataGetter extends StatelessWidget {
  const FavoritesDataGetter({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCoffeeData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final coffee = snapshot.data!;
        return FavoritesScreen(allProducts: coffee.products);
      },
    );
  }
}
