import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/favorite_service.dart';
import 'package:flutter_project_1/Model/model.dart';
import 'package:flutter_project_1/Widgets/CoffeeCard.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Product> allProducts;

  const FavoritesScreen({super.key, required this.allProducts});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Product> favProducts = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  void loadFavorites() async {
    final favIds = await FavoriteService.getFavorites();

    favProducts = widget.allProducts
        .where((p) => favIds.contains(p.id))
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 247),
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Favorites",
            style: TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pacifico',
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 249, 247),
      ),
      body: favProducts.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Center(child: Text("No favorites yet"))],
            )
          : GridView.builder(
              itemCount: favProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.90, //0.75,
              ),
              itemBuilder: (context, index) {
                return CoffeeCard(product: favProducts[index]);
              },
            ),
    );
  }
}
