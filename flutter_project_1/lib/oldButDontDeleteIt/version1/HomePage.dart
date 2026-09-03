// import 'package:flutter/material.dart';
// import 'package:flutter_project_1/Widgets/DrinkCard.dart';
// import 'package:flutter_project_1/Widgets/OffersCard.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Colors.brown.shade100,
//         title: Text('Good Morning, Salma'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 // spacing: 20,
//                 children: [
//                   OffersCard(
//                     offerText: 'GET YOUR COFFEE AT 30% OFF TODAY',
//                     imgPath: 'images/hotCoco.png',
//                   ),
//                   OffersCard(
//                     offerText: 'BUY 2 GET 1 FOR FREE',
//                     imgPath: 'images/coffee3.png',
//                   ),
//                   OffersCard(
//                     offerText: 'ALL BASTERY AT 10% OFF TODAY',
//                     imgPath: 'images/croi4.jpg',
//                   ),
//                   OffersCard(
//                     offerText: 'FREE DELIVERY TODAY',
//                     imgPath: 'images/Matcha.jpg',
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'Best Sellers',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 20),

//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 // spacing: 20,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,

//                 children: [
//                   // DrinkCard(cardWidth: 140, imgWidth: 90),
//                   // DrinkCard(cardWidth: 140, imgWidth: 90),
//                   // DrinkCard(cardWidth: 140, imgWidth: 90),
//                   // DrinkCard(cardWidth: 140, imgWidth: 90),
//                   // DrinkCard(cardWidth: 140, imgWidth: 90),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             // GridView.builder(
//             //    shrinkWrap: true, 
//             //   physics: NeverScrollableScrollPhysics(), // ✅ IMPORTANT
//             //   itemCount: 10,
//             //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //     crossAxisCount: 2, // number of columns
//             //     crossAxisSpacing: 10,
//             //     mainAxisSpacing: 10,
//             //     childAspectRatio: 1,
//             //   ),
//             //   itemBuilder: (context, index) {
//             //     return DrinkCard(cardWidth: 200, imgWidth: 150);
//             //   },
//             // ),
//             GridView.builder(
//   shrinkWrap: true,
//   physics: NeverScrollableScrollPhysics(),
//   padding: EdgeInsets.symmetric(horizontal: 16), // 👈 ADD THIS
//   itemCount: 10,
//   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     crossAxisSpacing: 12,
//     mainAxisSpacing: 12,
//     childAspectRatio: 1, // 👈 better for cards
//   ),
//   itemBuilder: (context, index) {
//     return DrinkCard(
//       // cardWidth: double.infinity, // 👈 IMPORTANT
//       // imgWidth: 120,
//     );
//   },
// ),
//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }
