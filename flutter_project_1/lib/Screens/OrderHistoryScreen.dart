import 'package:flutter/material.dart';
import 'package:flutter_project_1/Apis/order_service.dart';
import 'package:flutter_project_1/Screens/MainScreen.dart';

const Color _brown = Color(0xFF5D4037);
const Color _darkBrown = Color(0xFF3E2723);
const Color _softBrown = Color(0xFF795548);

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final amPm = date.hour >= 12 ? 'PM' : 'AM';
  var hour = date.hour % 12;
  if (hour == 0) hour = 12;
  final minute = date.minute.toString().padLeft(2, '0');
  return '${months[date.month - 1]} ${date.day}, ${date.year}  •  '
      '$hour:$minute $amPm';
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<OrderRecord>? _orders;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final orders = await OrderService.getOrders();
    if (mounted) {
      setState(() => _orders = orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F7),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: _darkBrown),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _darkBrown,
          ),
        ),
      ),
      body: _orders == null
          ? const Center(child: CircularProgressIndicator())
          : _orders!.isEmpty
              ? _EmptyOrdersState(
                  onStartShopping: () {
                    MainScreen.switchToTab.value = 0;
                    Navigator.of(context).pop();
                  },
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: _orders!.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = _orders![index];
                    return _OrderCard(order: order);
                  },
                ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderRecord order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final previewLines = order.items.length > 2
        ? order.items.take(2).toList()
        : order.items;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(order: order),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.orderId,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _darkBrown,
                    ),
                  ),
                ),
                Icon(
                  order.orderMethod == 'Delivery'
                      ? Icons.local_shipping_outlined
                      : Icons.storefront_outlined,
                  size: 18,
                  color: _softBrown,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              _formatDate(order.date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.brown.shade400,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in previewLines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.productName} ×${item.quantity}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: _brown,
                        ),
                      ),
                    ),
                    Text(
                      '${item.subtotal.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _brown,
                      ),
                    ),
                  ],
                ),
              ),
            if (order.items.length > previewLines.length)
              Text(
                '+${order.items.length - previewLines.length} more item(s)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.brown.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const Divider(height: 24, color: Color(0xFFEFEBE9)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderMethod,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.brown.shade500,
                  ),
                ),
                Text(
                  'Total  ${order.total.toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _darkBrown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _brown,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final OrderRecord order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F7),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: _darkBrown),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _darkBrown,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order ID',
                        style: TextStyle(fontSize: 13, color: _softBrown),
                      ),
                      Text(
                        order.orderId,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _darkBrown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(fontSize: 13, color: _softBrown),
                      ),
                      Text(
                        _formatDate(order.date),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Method',
                        style: TextStyle(fontSize: 13, color: _softBrown),
                      ),
                      Text(
                        order.orderMethod,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _brown,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _darkBrown,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final item in order.items)
                    _DetailItemRow(item: item),
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
              child: Column(
                children: [
                  _SummaryLine(
                    label: 'Subtotal',
                    value: '${order.subtotal.toStringAsFixed(1)} EGP',
                  ),
                  const SizedBox(height: 8),
                  _SummaryLine(
                    label: 'Delivery',
                    value: order.deliveryFee == 0
                        ? 'Free'
                        : '${order.deliveryFee.toStringAsFixed(1)} EGP',
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
                          color: _darkBrown,
                        ),
                      ),
                      Text(
                        '${order.total.toStringAsFixed(1)} EGP',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: _brown,
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
    );
  }
}

class _DetailItemRow extends StatelessWidget {
  final OrderItemRecord item;

  const _DetailItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final configParts = <String>[item.size];
    if (item.extras.isNotEmpty) {
      configParts.addAll(item.extras);
    }
    final configText = configParts.join(' • ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _darkBrown,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${item.unitPrice.toStringAsFixed(1)} EGP',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$configText  ×${item.quantity}',
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

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryLine({required this.label, required this.value});

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
            color: _brown,
          ),
        ),
      ],
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  final VoidCallback onStartShopping;

  const _EmptyOrdersState({required this.onStartShopping});

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
                Icons.local_cafe_outlined,
                size: 56,
                color: Colors.brown.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _darkBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your completed coffee orders\nwill appear here.',
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
