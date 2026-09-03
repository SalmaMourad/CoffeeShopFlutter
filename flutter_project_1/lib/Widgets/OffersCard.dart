import 'package:flutter/material.dart';
import 'package:flutter_project_1/Widgets/new.dart';

class OffersCard extends StatelessWidget {
  final String offerText;
  final String imgPath;
  const OffersCard({super.key, required this.offerText, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      width: 325,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.brown.shade100,

        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              offerText,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Image.asset(imgPath, width: 150)),
        ],
      ),
    );
  }
}