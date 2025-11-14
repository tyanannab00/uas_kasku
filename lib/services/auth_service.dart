import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyLogin = 'is_logged_in';
  static const String _keyUsername = 'username';

  static Future<bool> login(String username, String password) async {
    
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyLogin, true);
      await prefs.setString(_keyUsername, username);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogin);
    await prefs.remove(_keyUsername);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLogin) ?? false;
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }
}
