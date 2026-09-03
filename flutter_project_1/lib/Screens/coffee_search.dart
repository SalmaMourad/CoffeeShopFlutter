import 'package:flutter/material.dart';
import 'package:flutter_project_1/Screens/DetailsScreen.dart';
import '../Model/model.dart';

class CoffeeSearchDelegate extends SearchDelegate {
  final List<Product> products;

  CoffeeSearchDelegate({required this.products});
  @override
  InputDecorationTheme? get searchFieldDecorationTheme {
    return InputDecorationTheme(
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 255, 249, 247),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          // borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }

  @override
  String get searchFieldLabel => "Search your coffee ☕";
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildList(suggestions);
  }

  Widget _buildList(List<Product> list) {
    if (list.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 249, 247),
        body: const Center(child: Text("No results found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 247),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final product = list[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset(
                    product.image,
                    width: 50,
                    fit: BoxFit.fitHeight,
                  ),
                  title: Text(product.name),
                  subtitle: Text("${product.price} EGP"),
                  onTap: () {
                    close(context, null);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(product: product),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
