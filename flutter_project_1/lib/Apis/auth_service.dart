import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String sessionKey = "logged_in";

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sessionKey) ?? false;
  }

  static Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sessionKey, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sessionKey, false);
  }
}
