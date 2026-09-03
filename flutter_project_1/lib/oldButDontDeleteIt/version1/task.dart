// import 'package:flutter/material.dart';
// import 'package:flutter_project_1/Widgets/DrinkCard.dart';
// import 'package:flutter_project_1/Widgets/OffersCard.dart';
// import 'package:flutter_project_1/version1/cont.dart';
// import 'package:flutter_project_1/version1/detailsPage.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       initialRoute: '/',
//       routes: {
//         '/': (context) => MyHomePage(),
//         '/DetailsScreen': (context) => DetailsScreen(),
//       },
//       // routes: {},
//       // home: ProductsScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//     // return MaterialApp(home: MyHomePage(), debugShowCheckedModeBanner: false);
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

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

// newContainer(),
// newContainer(),
// newContainer(),
// newContainer(),
// newContainer(),


//             SizedBox(height: 20),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 // spacing: 20,
//                 children: [
//                   OffersCard(),
//                   OffersCard(),
//                   OffersCard(),
//                   OffersCard(),
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
//                 spacing: 20,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,

//                 children: [
//                   DrinkCard(cardWidth: 155, imgWidth: 100),
//                   DrinkCard(cardWidth: 155, imgWidth: 100),
//                   DrinkCard(cardWidth: 155, imgWidth: 100),
//                   DrinkCard(cardWidth: 155, imgWidth: 100),
//                   DrinkCard(cardWidth: 155, imgWidth: 100),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 DrinkCard(cardWidth: 200, imgWidth: 150),
//                 DrinkCard(cardWidth: 200, imgWidth: 150),
//               ],
//             ),
//             SizedBox(height: 20),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 DrinkCard(cardWidth: 200, imgWidth: 150),
//                 DrinkCard(cardWidth: 200, imgWidth: 150),
//               ],
//             ),
//             SizedBox(height: 30,),
//             TextButton(
//               style: ButtonStyle(
//                 padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.only(left: 50,right: 50,top: 20,bottom: 20)),
//                 backgroundColor: WidgetStateProperty.all<Color>(Colors.brown.shade400),
//                 foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
//                 overlayColor: WidgetStateProperty.resolveWith<Color?>((
//                   Set<WidgetState> states,
//                 ) {
//                   if (states.contains(WidgetState.hovered))
//                     return Colors.brown.shade200;
//                   if (states.contains(WidgetState.focused) ||
//                       states.contains(WidgetState.pressed)) {
//                     return Colors.brown;
//                   }
//                   return Colors.brown; // Defer to the widget's default.
//                 }),
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/DetailsScreen');
//               },
//               child: Text('TextButton'),
//             ),
//             SizedBox(height: 30,),

//             // Image.asset('images/cake.webp'),

//             // Card(color: Colors.amber, child: Image.asset('images/cake.webp')),
//             // Container(child: Text('hello')),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // class newContainer extends StatelessWidget {
// //   const newContainer({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(child: Row(
// //       children: [
// //          Image.asset('images/hotCoco.png', width: 150),
// //          SizedBox(width: 20,),  
// //         Text('Hello, Salma!'),
// //       ],
// //     ),);
// //   }
// // }

// // class OffersCard extends StatelessWidget {
// //   const OffersCard({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.only(left: 20),
// //       width: 325,
// //       height: 170,
// //       decoration: BoxDecoration(
// //         color: Colors.brown.shade100,

// //         border: Border.all(color: Colors.grey),
// //         borderRadius: BorderRadius.circular(20),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //         children: [
// //           Expanded(
// //             child: Text(
// //               'GET YOUR COFFEE AT 30% OFF TODAY',
// //               textAlign: TextAlign.center,
// //             ),
// //           ),
// //           Expanded(child: Image.asset('images/hotCoco.png', width: 150)),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class DrinkCard extends StatelessWidget {
// //   final double cardWidth;
// //   final double imgWidth;

// //   DrinkCard({required this.cardWidth, required this.imgWidth});
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.grey.shade400),
// //         // color: Colors.brown.shade100,
// //       ),
// //       width: cardWidth,
// //       child: Column(
// //         children: [
// //           Image.asset('images/hotCoco.png', width: 150),
// //           SizedBox(height: 10),
// //           Text(
// //             'Hot Choclate',
// //             style: TextStyle(
// //               inherit: false,
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           SizedBox(height: 20),
// //         ],
// //       ),
// //     );
// //   }
// // }
