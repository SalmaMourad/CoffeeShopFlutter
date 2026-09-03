import 'package:flutter/material.dart';
import 'package:flutter_project_1/Widgets/CustomElevatedButtonTwo.dart';
import 'package:flutter_project_1/Widgets/NameAndReviewsDetailsScreen.dart';
import 'package:flutter_project_1/Widgets/PriceAndAddProductDetailsScreen.dart';
import 'package:flutter_project_1/Widgets/ProductImgDetailsScreen.dart';
import 'package:flutter_project_1/Widgets/RadioCardDetailsScreen.dart';
import 'package:flutter_project_1/Model/model.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown.shade100),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImgDetailsScreen(product: product),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NameAndReviewsDetailsScreen(product: product),
                  PriceAndAddProductDetailsScreen(product: product),
                  RadioCardDetailsScreen(),
                  CustomElevatedButtonTwo(TextButton: 'Add To Cart'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
