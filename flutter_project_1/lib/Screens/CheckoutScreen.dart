import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/cart_service.dart';
import 'package:flutter_project_1/Apis/order_service.dart';
import 'package:flutter_project_1/Model/model.dart';
import 'package:flutter_project_1/Screens/OrderSuccessScreen.dart';

class OrderLine {
  final Product product;
  final CartItem item;

  OrderLine({required this.product, required this.item});

  double get subtotal => item.unitPrice * item.quantity;
}

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cart;
  final List<Product> products;
  final String orderMethod;
  final double deliveryFee;

  const CheckoutScreen({
    super.key,
    required this.cart,
    required this.products,
    required this.orderMethod,
    required this.deliveryFee,
  });

  List<OrderLine> get _lines {
    final result = <OrderLine>[];
    for (final item in cart) {
      final product = _findProduct(item.productId);
      if (product != null) {
        result.add(OrderLine(product: product, item: item));
      }
    }
    return result;
  }

  Product? _findProduct(int id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  double get _subtotal =>
      _lines.fold(0.0, (sum, line) => sum + line.subtotal);

  double get _total => _subtotal + deliveryFee;

  Future<void> _placeOrder(BuildContext context) async {
    final orderNumber =
        'COF-${DateTime.now().millisecondsSinceEpoch % 10000}';

    final now = DateTime.now();
    final items = _lines
        .map(
          (line) => OrderItemRecord(
            productName: line.product.name,
            quantity: line.item.quantity,
            size: line.item.size,
            extras: line.item.extras,
            unitPrice: line.item.unitPrice,
            subtotal: line.subtotal,
          ),
        )
        .toList();

    await OrderService.saveOrder(
      OrderRecord(
        orderId: orderNumber,
        date: now,
        orderMethod: orderMethod,
        deliveryFee: deliveryFee,
        subtotal: _subtotal,
        total: _total,
        items: items,
      ),
    );

    await CartService.clear();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(orderNumber: orderNumber),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lines = _lines;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F7),
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF3E2723)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  Container(
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
                        for (final line in lines)
                          _LineRow(line: line),
                        const Divider(height: 24, color: Color(0xFFEFEBE9)),
                        _SummaryRow(
                          label: 'Subtotal',
                          value: '${_subtotal.toStringAsFixed(1)} EGP',
                        ),
                        const SizedBox(height: 6),
                        _SummaryRow(
                          label: 'Delivery',
                          value: deliveryFee == 0
                              ? 'Free'
                              : '${deliveryFee.toStringAsFixed(1)} EGP',
                        ),
                        const SizedBox(height: 8),
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
                              '${_total.toStringAsFixed(1)} EGP',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5D4037),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.brown.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          orderMethod == 'Delivery'
                              ? Icons.local_shipping_outlined
                              : Icons.storefront_outlined,
                          color: Colors.brown.shade600,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Order Method:  $orderMethod',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This is a simulated local checkout. No real payment '
                    'is processed and no order is sent to a server.',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.brown.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
            onPressed: () => _placeOrder(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  final OrderLine line;

  const _LineRow({required this.line});

  @override
  Widget build(BuildContext context) {
    final configParts = <String>[line.item.size];
    if (line.item.extras.isNotEmpty) {
      configParts.addAll(line.item.extras);
    }
    final configText = configParts.join(' • ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${line.subtotal.toStringAsFixed(1)} EGP',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$configText  x${line.item.quantity}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.brown.shade500,
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
