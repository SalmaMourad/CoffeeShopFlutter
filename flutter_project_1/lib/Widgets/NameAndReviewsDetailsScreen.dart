import 'package:flutter/material.dart';
import 'package:flutter_project_1/Model/model.dart';

class NameAndReviewsDetailsScreen extends StatelessWidget {
  const NameAndReviewsDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text("${product.rating}"),
                  SizedBox(width: 5),
                  Text("(120 reviews)", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(product.description),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

