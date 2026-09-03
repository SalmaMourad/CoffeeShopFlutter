import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final int productId;
  final String size;
  final List<String> extras;
  final double unitPrice;
  int quantity;

  CartItem({
    required this.productId,
    required this.size,
    required List<String> extras,
    required this.unitPrice,
    required this.quantity,
  }) : extras = List.unmodifiable([...extras]..sort());

  String get key {
    final sorted = [...extras]..sort();
    return sorted.isEmpty
        ? '$productId|$size|'
        : '$productId|$size|${sorted.join(',')}';
  }
}

class CartService {
  static const String key = "cart";
  static const double deliveryFee = 20.0;

  static const String defaultSize = 'Medium';
  static const Map<String, double> sizeAdjustments = {
    'Small': -15.0,
    'Medium': 0.0,
    'Large': 15.0,
  };
  static const Map<String, double> extrasPrices = {
    'Extra Shot': 10.0,
    'Lactose Free': 5.0,
    'Caramel Syrup': 10.0,
  };

  static final ValueNotifier<int> itemCount = ValueNotifier<int>(0);
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static double priceFor({
    required double basePrice,
    required String size,
    required List<String> extras,
  }) {
    double price = basePrice + (sizeAdjustments[size] ?? 0.0);
    for (final extra in extras) {
      price += extrasPrices[extra] ?? 0.0;
    }
    return price;
  }

  static Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(key);
    if (stored == null) return [];

    final items = <CartItem>[];
    for (final entry in stored) {
      final parts = entry.split('|');
      if (parts.length != 5) continue;
      final id = int.tryParse(parts[0]);
      final qty = int.tryParse(parts[4]);
      final unit = double.tryParse(parts[3]);
      final size = parts[1];
      final extras = parts[2].isEmpty ? <String>[] : parts[2].split(',');
      if (id != null && qty != null && unit != null && qty > 0) {
        items.add(
          CartItem(
            productId: id,
            size: size,
            extras: extras,
            unitPrice: unit,
            quantity: qty,
          ),
        );
      }
    }
    return items;
  }

  static Future<void> addItem(CartItem item) async {
    final items = await getCart();
    bool merged = false;
    for (var i = 0; i < items.length; i++) {
      if (items[i].key == item.key) {
        items[i].quantity += item.quantity;
        merged = true;
        break;
      }
    }
    if (!merged) {
      items.add(item);
    }
    await _save(items);
  }

  static Future<void> setQuantity(CartItem item, int quantity) async {
    final items = await getCart();
    for (var i = 0; i < items.length; i++) {
      if (items[i].key == item.key) {
        if (quantity <= 0) {
          items.removeAt(i);
        } else {
          items[i].quantity = quantity;
        }
        break;
      }
    }
    await _save(items);
  }

  static Future<void> removeItem(CartItem item) async {
    final items = await getCart();
    items.removeWhere((e) => e.key == item.key);
    await _save(items);
  }

  static Future<void> clear() async {
    await _save([]);
  }

  static Future<void> refreshItemCount() async {
    final count = await getItemCount();
    itemCount.value = count;
  }

  static Future<int> getItemCount() async {
    final items = await getCart();
    int count = 0;
    for (final item in items) {
      count += item.quantity;
    }
    return count;
  }

  static Future<int> getDefaultQuantity(int productId) async {
    final items = await getCart();
    for (final item in items) {
      if (item.productId == productId &&
          item.size == defaultSize &&
          item.extras.isEmpty) {
        return item.quantity;
      }
    }
    return 0;
  }

  static Future<void> _save(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = items
        .map(
          (item) =>
              '${item.productId}|${item.size}|${item.extras.join(',')}|'
              '${item.unitPrice}|${item.quantity}',
        )
        .toList();
    await prefs.setStringList(key, stored);

    itemCount.value = items.fold(0, (sum, item) => sum + item.quantity);
    revision.value++;
  }
}
