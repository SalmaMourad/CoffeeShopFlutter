import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/cart_service.dart';
import 'package:flutter_project_1/Apis/favorite_service.dart';
import 'package:flutter_project_1/Model/model.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _quantity = 1;
  bool _isFav = false;
  String _size = 'Medium';
  final Set<String> _extras = {};
  final TextEditingController _notesController = TextEditingController();
  String _orderMethod = 'Delivery';

  double get _sizeAdjustedPrice =>
      widget.product.price + (CartService.sizeAdjustments[_size] ?? 0.0);

  double get _extrasTotal {
    double total = 0.0;
    for (final extra in _extras) {
      total += CartService.extrasPrices[extra] ?? 0.0;
    }
    return total;
  }

  double get _unitPrice => _sizeAdjustedPrice + _extrasTotal;

  double get _totalPrice => _unitPrice * _quantity;

  @override
  void initState() {
    super.initState();
    _loadFav();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadFav() async {
    final fav = await FavoriteService.isFavorite(widget.product.id);
    if (mounted) {
      setState(() {
        _isFav = fav;
      });
    }
  }

  void _toggleFav() async {
    await FavoriteService.toggleFavorite(widget.product.id);
    await _loadFav();
  }

  void _toggleExtra(String extra) {
    setState(() {
      if (!_extras.remove(extra)) {
        _extras.add(extra);
      }
    });
  }

  void _addToCart() async {
    final unitPrice = _unitPrice;
    await CartService.addItem(
      CartItem(
        productId: widget.product.id,
        size: _size,
        extras: _extras.toList(),
        unitPrice: unitPrice,
        quantity: _quantity,
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.brown.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopImageSection(
                      image: product.image,
                      isFav: _isFav,
                      onFavPressed: _toggleFav,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProductInfoSection(product: product),
                          const SizedBox(height: 24),
                          _PriceAndQuantitySection(
                            unitPrice: _unitPrice,
                            quantity: _quantity,
                            onDecrement: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                            onIncrement: () {
                              setState(() => _quantity++);
                            },
                          ),
                          const SizedBox(height: 28),
                          _SectionCard(
                            title: 'Customize Your Order',
                            icon: Icons.tune,
                            child: _SizeSelector(
                              selected: _size,
                              onSelected: (value) {
                                setState(() => _size = value);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Add Extras',
                            icon: Icons.add_circle_outline,
                            child: _ExtrasSelector(
                              selected: _extras,
                              onToggle: _toggleExtra,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Order Notes (Optional)',
                            icon: Icons.edit_note,
                            child: _NotesField(
                              controller: _notesController,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _SectionCard(
                            title: 'Delivery / Pickup',
                            icon: Icons.local_shipping_outlined,
                            child: _OrderMethodSelector(
                              selected: _orderMethod,
                              onSelected: (value) {
                                setState(() => _orderMethod = value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BottomBar(
              totalPrice: _totalPrice,
              onAddToCart: _addToCart,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopImageSection extends StatelessWidget {
  final String image;
  final bool isFav;
  final VoidCallback onFavPressed;

  const _TopImageSection({
    required this.image,
    required this.isFav,
    required this.onFavPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        color: Color(0xFFF5E8DD),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: _RoundIconButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: _RoundIconButton(
              icon: isFav ? Icons.favorite : Icons.favorite_border,
              iconColor: isFav ? Colors.red.shade400 : Colors.brown.shade600,
              onPressed: onFavPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;

  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: iconColor ?? Colors.brown.shade700,
          ),
        ),
      ),
    );
  }
}

class _ProductInfoSection extends StatelessWidget {
  final Product product;

  const _ProductInfoSection({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.shade100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 18),
                  const SizedBox(width: 3),
                  Text(
                    '${product.rating}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D4C41),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF795548),
          ),
        ),
      ],
    );
  }
}

class _PriceAndQuantitySection extends StatelessWidget {
  final double unitPrice;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _PriceAndQuantitySection({
    required this.unitPrice,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.brown.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${unitPrice.toStringAsFixed(1)} EGP',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
        ),
        _QuantitySelector(
          quantity: quantity,
          onDecrement: onDecrement,
          onIncrement: onIncrement,
        ),
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantitySelector({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.brown.shade200),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(icon: Icons.remove, onPressed: onDecrement),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
          ),
          _QuantityButton(icon: Icons.add, onPressed: onIncrement),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.brown.shade50,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.brown.shade700),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.brown.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.brown.shade600),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _SizeSelector({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SegmentedOption(
          label: 'Small',
          selected: selected == 'Small',
          onTap: () => onSelected('Small'),
        ),
        const SizedBox(width: 8),
        _SegmentedOption(
          label: 'Medium',
          selected: selected == 'Medium',
          onTap: () => onSelected('Medium'),
        ),
        const SizedBox(width: 8),
        _SegmentedOption(
          label: 'Large',
          selected: selected == 'Large',
          onTap: () => onSelected('Large'),
        ),
      ],
    );
  }
}

class _SegmentedOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentedOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? Colors.brown : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? Colors.brown : Colors.brown.shade200,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.brown.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExtrasSelector extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _ExtrasSelector({
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final extras = <String, double>{
      'Extra Shot': 10.0,
      'Lactose Free': 5.0,
      'Caramel Syrup': 10.0,
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: extras.entries.map((entry) {
        final isSelected = selected.contains(entry.key);
        return GestureDetector(
          onTap: () => onToggle(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.brown : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.brown : Colors.brown.shade200,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.brown.shade700,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '+${entry.value.toStringAsFixed(0)} EGP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.brown.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;

  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 3,
      style: const TextStyle(fontSize: 14, color: Color(0xFF3E2723)),
      decoration: InputDecoration(
        hintText: 'Write any special instructions...',
        hintStyle: TextStyle(color: Colors.brown.shade300),
        filled: true,
        fillColor: Colors.brown.shade50,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.brown.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.brown, width: 1.5),
        ),
      ),
    );
  }
}

class _OrderMethodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _OrderMethodSelector({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MethodCard(
          icon: Icons.local_shipping_outlined,
          title: 'Delivery',
          subtitle: 'We deliver to your door',
          selected: selected == 'Delivery',
          onTap: () => onSelected('Delivery'),
        ),
        const SizedBox(width: 12),
        _MethodCard(
          icon: Icons.storefront_outlined,
          title: 'Pickup',
          subtitle: 'Pick up from our store',
          selected: selected == 'Pickup',
          onTap: () => onSelected('Pickup'),
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? Colors.brown.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.brown : Colors.brown.shade200,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? Colors.brown : Colors.brown.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? Colors.brown.shade800
                      : Colors.brown.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.brown.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onAddToCart;

  const _BottomBar({required this.totalPrice, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton.icon(
          onPressed: onAddToCart,
          icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add To Cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${totalPrice.toStringAsFixed(1)} EGP',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
