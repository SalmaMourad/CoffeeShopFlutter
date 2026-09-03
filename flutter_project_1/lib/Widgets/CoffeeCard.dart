import 'package:flutter/material.dart';
import 'package:flutter_project_1/main.dart';
import 'package:flutter_project_1/Apis/cart_service.dart';
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
  int cardQty = 0;

  @override
  void initState() {
    super.initState();
    loadFav();
    loadCartQty();
    CartService.revision.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    CartService.revision.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    loadCartQty();
  }

  void loadFav() async {
    isFav = await FavoriteService.isFavorite(widget.product.id);
    if (mounted) setState(() {});
  }

  void toggleFav() async {
    await FavoriteService.toggleFavorite(widget.product.id);
    loadFav();
  }

  Future<void> loadCartQty() async {
    final qty = await CartService.getDefaultQuantity(widget.product.id);
    if (mounted && qty != cardQty) {
      setState(() => cardQty = qty);
    }
  }

  Future<void> increment() async {
    if (cardQty == 0) {
      await CartService.addItem(
        CartItem(
          productId: widget.product.id,
          size: CartService.defaultSize,
          extras: const [],
          unitPrice: CartService.priceFor(
            basePrice: widget.product.price,
            size: CartService.defaultSize,
            extras: const [],
          ),
          quantity: 1,
        ),
      );
    } else {
      await CartService.setQuantity(
        CartItem(
          productId: widget.product.id,
          size: CartService.defaultSize,
          extras: const [],
          unitPrice: CartService.priceFor(
            basePrice: widget.product.price,
            size: CartService.defaultSize,
            extras: const [],
          ),
          quantity: cardQty,
        ),
        cardQty + 1,
      );
    }
    await loadCartQty();
  }

  Future<void> decrement() async {
    if (cardQty <= 0) return;
    await CartService.setQuantity(
      CartItem(
        productId: widget.product.id,
        size: CartService.defaultSize,
        extras: const [],
        unitPrice: CartService.priceFor(
          basePrice: widget.product.price,
          size: CartService.defaultSize,
          extras: const [],
        ),
        quantity: cardQty,
      ),
      cardQty - 1,
    );
    await loadCartQty();
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
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.brown.shade100,
              width: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Favorite button (top-left)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, top: 6),
                    child: Material(
                      color: Colors.grey.shade100.withValues(alpha: 0.85),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: toggleFav,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isFav
                                ? Colors.red.shade400
                                : Colors.brown.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),
                // Product image (flexible so it adapts to available height)
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                // Info + controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.brown.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${product.price} EGP",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating + quantity controls
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber.shade600,
                            size: 17,
                          ),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              "${product.rating}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.brown.shade600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.brown.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _QtyButton(
                                  icon: Icons.remove,
                                  color: Colors.brown.shade600,
                                  onPressed: () {
                                    decrement();
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    '$cardQty',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade700,
                                    ),
                                  ),
                                ),
                                _QtyButton(
                                  icon: Icons.add,
                                  color: Colors.brown.shade700,
                                  onPressed: () {
                                    increment();
                                  },
                                ),
                              ],
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

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
