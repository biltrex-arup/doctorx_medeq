import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPrefs {
  // Secure storage instance
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Keys
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userIdKey = "user_id";
  static const String _isLoginKey = "is_login";

  // -------------------- TOKEN HANDLING --------------------

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // -------------------- USER ID --------------------

  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  // -------------------- LOGIN STATE --------------------

  static Future<void> setLogin(bool value) async {
    await _storage.write(key: _isLoginKey, value: value.toString());
  }

  static Future<bool> isLoggedIn() async {
    final val = await _storage.read(key: _isLoginKey);
    return val == "true";
  }

  // -------------------- CLEAR EVERYTHING --------------------

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
