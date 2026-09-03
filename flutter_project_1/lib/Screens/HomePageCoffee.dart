import 'package:flutter/material.dart';
import 'package:flutter_project_1/Widgets/OffersCard.dart';
import 'package:flutter_project_1/Apis/apiService.dart';
import 'package:flutter_project_1/Screens/SearchScreen.dart';
import 'package:flutter_project_1/Widgets/CoffeeCard.dart';
import '../Model/model.dart';

class CoffeeScreen extends StatefulWidget {
  const CoffeeScreen({super.key});

  @override
  State<CoffeeScreen> createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen> {
  late Future<CoffeeModel> coffeeFuture;

  @override
  void initState() {
    super.initState();
    coffeeFuture = fetchCoffeeData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoffeeModel>(
      future: coffeeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("No coffee data available")),
          );
        }

        final coffee = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 249, 247),

          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 255, 249, 247),
            title: const Text(
              "Salma 's Coffee Shop   ☕",
              style: TextStyle(fontFamily: 'Pacifico'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          SearchScreen(products: coffee.products),
                    ),
                  );
                },
              ),
            ],
          ),

          body: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverToBoxAdapter(
                child: Column(
                  children: const [
                    Text(
                      "Limited Offers",
                      style: TextStyle(fontFamily: 'Pacifico', fontSize: 24),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      OffersCard(
                        offerText: 'GET YOUR COFFEE AT 10% OFF TODAY',
                        imgPath: 'images/hotlatte.png',
                      ),
                      OffersCard(
                        offerText: 'HOT PRICE FOR MATCHA 70% OFF',
                        imgPath: 'images/matcha3.png',
                      ),
                      OffersCard(
                        offerText: 'BUY 2 ESPERSSO AND GET 1 FOR FREE',
                        imgPath: 'images/coffee3.png',
                      ),
                      // OffersCard(
                      //   offerText: 'FREE DELIVERY TODAY',
                      //   imgPath: 'images/delivery.png',
                      // ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverToBoxAdapter(
                child: Column(
                  children: const [
                    Text(
                      "Menu",
                      style: TextStyle(fontFamily: 'Pacifico', fontSize: 24),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return CoffeeCard(product: coffee.products[index]);
                }, childCount: coffee.products.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}