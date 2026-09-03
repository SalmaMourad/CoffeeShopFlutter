
import 'package:flutter/material.dart';
import 'package:flutter_project_1/Model/model.dart';

class PriceAndAddProductDetailsScreen extends StatelessWidget {
  const PriceAndAddProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.brown, width: 1.5),
                ),
                child: Text("Price : ${product.price} EGP"),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.brown, width: 1.5),
                ),
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                    Text(
                      '1',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

