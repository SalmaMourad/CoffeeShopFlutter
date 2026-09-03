import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderItemRecord {
  final String productName;
  final int quantity;
  final String size;
  final List<String> extras;
  final double unitPrice;
  final double subtotal;

  OrderItemRecord({
    required this.productName,
    required this.quantity,
    required this.size,
    required List<String> extras,
    required this.unitPrice,
    required this.subtotal,
  }) : extras = List.unmodifiable([...extras]..sort());

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'quantity': quantity,
        'size': size,
        'extras': extras,
        'unitPrice': unitPrice,
        'subtotal': subtotal,
      };

  factory OrderItemRecord.fromJson(Map<String, dynamic> json) {
    return OrderItemRecord(
      productName: json['productName'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      size: json['size'] as String? ?? '',
      extras: (json['extras'] as List?)?.cast<String>() ?? <String>[],
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OrderRecord {
  final String orderId;
  final DateTime date;
  final String orderMethod;
  final double deliveryFee;
  final double subtotal;
  final double total;
  final List<OrderItemRecord> items;

  OrderRecord({
    required this.orderId,
    required this.date,
    required this.orderMethod,
    required this.deliveryFee,
    required this.subtotal,
    required this.total,
    required List<OrderItemRecord> items,
  }) : items = List.unmodifiable(items);

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'date': date.toIso8601String(),
        'orderMethod': orderMethod,
        'deliveryFee': deliveryFee,
        'subtotal': subtotal,
        'total': total,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory OrderRecord.fromJson(Map<String, dynamic> json) {
    return OrderRecord(
      orderId: json['orderId'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      orderMethod: json['orderMethod'] as String? ?? '',
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItemRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderService {
  static const String key = "order_history";

  static Future<List<OrderRecord>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString(key);
    if (stored == null || stored.isEmpty) return [];

    try {
      final decoded = jsonDecode(stored) as List;
      final orders = decoded
          .map((e) => OrderRecord.fromJson(e as Map<String, dynamic>))
          .toList();
      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveOrder(OrderRecord order) async {
    final orders = await getOrders();
    orders.insert(0, order);
    await _persist(orders);
  }

  static Future<void> clear() async {
    await _persist([]);
  }

  static Future<void> _persist(List<OrderRecord> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(orders.map((o) => o.toJson()).toList());
    await prefs.setString(key, json);
  }
}
