import 'package:flutter/material.dart';
import 'package:flutter_project_1/main.dart';
import 'package:flutter_project_1/Apis/favorite_service.dart';
import 'package:flutter_project_1/Model/model.dart';
import 'package:flutter_project_1/Screens/DetailsScreen.dart';

class CoffeeCard extends StatefulWidget {
  final Product product;

  const CoffeeCard({super.key, required this.product});

  @override
  State<CoffeeCard> createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    loadFav();
  }

  void loadFav() async {
    isFav = await FavoriteService.isFavorite(widget.product.id);
    setState(() {});
  }

  void toggleFav() async {
    await FavoriteService.toggleFavorite(widget.product.id);
    loadFav();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, "/DetailsScreen",arguments: product);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(product: product)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red.shade300,
                      ),
                      onPressed: toggleFav,
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    product.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text("${product.price} EGP"),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Text(
                            " ${product.rating}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              color: Colors.brown,
                              size: 18,
                            ),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.remove,
                              color: Colors.brown,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}







// class CoffeeCard extends StatelessWidget {
//   final Product product;

//   const CoffeeCard({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigator.pushNamed(context, "/DetailsScreen",arguments: product);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => DetailsScreen(product: product)),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Card(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset(
//                     product.image,
//                     height: 130,
//                     width: double.infinity,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 5),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               product.name,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Text("${product.price} EGP"),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.star_border,
//                             color: Colors.amber,
//                             size: 18,
//                           ),
//                           Text(
//                             "${product.rating}",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           Spacer(),
//                           IconButton(onPressed: (){}, icon: Icon(Icons.add)),
//                           Text('1'),
//                           // IconButton(onPressed: (){}, icon: Icon(Icons.)),
//                           GestureDetector(onTap: (){}, child: Text('--'),),
//                            IconButton(
                // icon: Icon(
                  // isFav ? Icons.favorite : Icons.favorite_border,
                  // color: Colors.red,
                // ),
                // onPressed: toggleFav,
              // ),
//                           // Text("${product.price} EGP"),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

