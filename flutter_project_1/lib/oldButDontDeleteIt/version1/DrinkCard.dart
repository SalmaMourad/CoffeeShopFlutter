
// import 'package:flutter/material.dart';

// class DrinkCard extends StatelessWidget {
//   const DrinkCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 10), // ❗ removed left margin
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade400),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ✅ IMAGE (flexible)
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.asset(
//                   'images/hotCoco.png',
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),

//             SizedBox(height: 8),

//             // ✅ TEXT (safe)
//             Text(
//               'Hot Chocolate',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             SizedBox(height: 4),

//             Text(
//               '\$4.5',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';

// // class DrinkCard extends StatelessWidget {
// //   final double cardWidth;
// //   final double imgWidth;

// //   DrinkCard({required this.cardWidth, required this.imgWidth});
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.only(left:  18 , top: 10),
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
