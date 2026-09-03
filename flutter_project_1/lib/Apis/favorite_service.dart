import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String key = "favorites";

  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favs = prefs.getStringList(key);

    if (favs == null) return [];

    return favs.map((e) => int.parse(e)).toList();
  }

  static Future<void> toggleFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favs = prefs.getStringList(key) ?? [];

    if (favs.contains(productId.toString())) {
      favs.remove(productId.toString());
    } else {
      favs.add(productId.toString());
    }

    await prefs.setStringList(key, favs);
  }

  static Future<bool> isFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favs = prefs.getStringList(key) ?? [];

    return favs.contains(productId.toString());
  }
}
