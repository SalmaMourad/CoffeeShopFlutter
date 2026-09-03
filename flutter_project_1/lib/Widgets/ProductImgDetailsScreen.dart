import 'package:flutter/material.dart';
import 'package:flutter_project_1/Model/model.dart';

class ProductImgDetailsScreen extends StatelessWidget {
  const ProductImgDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.brown.shade100,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Image.asset(product.image, height: 400),
          ),
        ),
      ],
    );
  }
}