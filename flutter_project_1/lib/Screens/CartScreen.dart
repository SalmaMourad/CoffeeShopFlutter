import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/apiService.dart';
import 'package:flutter_project_1/Apis/cart_service.dart';
import 'package:flutter_project_1/Model/model.dart';
import 'package:flutter_project_1/Screens/CheckoutScreen.dart';
import 'package:flutter_project_1/Screens/MainScreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cart = [];
  List<Product> _products = [];
  bool _loading = true;
  String _orderMethod = 'Delivery';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final results = await Future.wait([
      fetchCoffeeData(),
      CartService.getCart(),
    ]);
    if (!mounted) return;
    setState(() {
      _products = (results[0] as CoffeeModel).products;
      _cart = results[1] as List<CartItem>;
      _loading = false;
    });
  }

  Future<void> _reloadCart() async {
    final cart = await CartService.getCart();
    if (mounted) {
      setState(() => _cart = cart);
    }
  }

  Future<void> _changeQuantity(CartItem item, int delta) async {
    await CartService.setQuantity(item, item.quantity + delta);
    await _reloadCart();
  }

  Future<void> _remove(CartItem item) async {
    await CartService.removeItem(item);
    await _reloadCart();
  }

  Product? _findProduct(int id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  double get _subtotal =>
      _cart.fold(0.0, (sum, item) => sum + item.unitPrice * item.quantity);

  int get _itemCount =>
      _cart.fold(0, (sum, item) => sum + item.quantity);

  double get _deliveryFee =>
      _orderMethod == 'Delivery' ? CartService.deliveryFee : 0.0;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF9F7),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_cart.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF9F7),
        body: SafeArea(
          child: _EmptyCartState(
            onStartShopping: () {
              MainScreen.switchToTab.value = 0;
            },
          ),
        ),
      );
    }

    final total = _subtotal + _deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F7),
      body: SafeArea(
        child: Column(
          children: [
            _Header(itemCount: _itemCount),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  for (final item in _cart)
                    _CartItemCard(
                      product: _findProduct(item.productId),
                      item: item,
                      onIncrement: () => _changeQuantity(item, 1),
                      onDecrement: () => _changeQuantity(item, -1),
                      onRemove: () => _remove(item),
                    ),
                  const SizedBox(height: 8),
                  _OrderSummary(
                    subtotal: _subtotal,
                    deliveryFee: _deliveryFee,
                  ),
                  const SizedBox(height: 16),
                  _OrderMethodSelector(
                    selected: _orderMethod,
                    onSelected: (value) {
                      setState(() => _orderMethod = value);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _CheckoutBar(
        total: total,
        onCheckout: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CheckoutScreen(
                cart: _cart,
                products: _products,
                orderMethod: _orderMethod,
                deliveryFee: _deliveryFee,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int itemCount;

  const _Header({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your Cart',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
          Text(
            itemCount == 1 ? '1 item' : '$itemCount items',
            style: TextStyle(
              fontSize: 15,
              color: Colors.brown.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final Product? product;
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.product,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const SizedBox.shrink();
    }
    final p = product!;

    final configParts = <String>[item.size];
    if (item.extras.isNotEmpty) {
      configParts.addAll(item.extras);
    }
    final configText = configParts.join(' • ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(6),
            child: Image.asset(p.image, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  configText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.brown.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.unitPrice.toStringAsFixed(1)} EGP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _CartQtyButton(
                      icon: Icons.remove,
                      onPressed: onDecrement,
                      enabled: item.quantity > 0,
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ),
                    _CartQtyButton(
                      icon: Icons.add,
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(item.unitPrice * item.quantity).toStringAsFixed(1)} EGP',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 4),
              IconButton(
                onPressed: onRemove,
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red.shade300,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartQtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const _CartQtyButton({
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? Colors.brown.shade50 : Colors.grey.shade200,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 16,
            color: enabled ? Colors.brown.shade700 : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;

  const _OrderSummary({
    required this.subtotal,
    required this.deliveryFee,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + deliveryFee;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Subtotal',
            value: '${subtotal.toStringAsFixed(1)} EGP',
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Delivery',
            value: deliveryFee == 0
                ? 'Free'
                : '${deliveryFee.toStringAsFixed(1)} EGP',
          ),
          const Divider(height: 24, color: Color(0xFFEFEBE9)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
              Text(
                '${total.toStringAsFixed(1)} EGP',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Local demo checkout — no real payment.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.brown.shade400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.brown.shade500),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D4037),
          ),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery / Pickup',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _MethodCard(
              icon: Icons.local_shipping_outlined,
              title: 'Delivery',
              subtitle: 'To your door',
              selected: selected == 'Delivery',
              onTap: () => onSelected('Delivery'),
            ),
            const SizedBox(width: 12),
            _MethodCard(
              icon: Icons.storefront_outlined,
              title: 'Pickup',
              subtitle: 'From our store',
              selected: selected == 'Pickup',
              onTap: () => onSelected('Pickup'),
            ),
          ],
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
            color: selected ? Colors.brown.shade50 : Colors.white,
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
                style: TextStyle(fontSize: 11, color: Colors.brown.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;

  const _CheckoutBar({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
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
        child: ElevatedButton(
          onPressed: onCheckout,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Proceed to Checkout   ${total.toStringAsFixed(1)} EGP',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCartState extends StatelessWidget {
  final VoidCallback onStartShopping;

  const _EmptyCartState({required this.onStartShopping});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: Colors.brown.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Cart Is Empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your favorite coffee drinks\nand they\'ll appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.brown.shade400),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onStartShopping,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start Shopping',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
