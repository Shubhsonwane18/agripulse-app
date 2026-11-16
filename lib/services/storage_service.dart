import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String _keyToken = 'kisanmitra_auth_token';
  static const String _keyProfile = 'kisanmitra_user_profile';
  static const String _keyLocale = 'kisanmitra_locale';
  static const String _keyLanguageSelected = 'kisanmitra_lang_selected_flag';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Language Selected Flag
  static Future<void> setLanguageSelected(bool val) async {
    await init();
    await _prefs!.setBool(_keyLanguageSelected, val);
  }

  static bool hasSelectedLanguage() {
    return _prefs?.getBool(_keyLanguageSelected) ?? false;
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    await init();
    await _prefs!.setString(_keyToken, token);
  }

  static String? getToken() {
    return _prefs?.getString(_keyToken);
  }

  static Future<void> clearToken() async {
    await init();
    await _prefs!.remove(_keyToken);
  }

  // User Profile
  static Future<void> saveProfile(UserProfile profile) async {
    await init();
    final jsonStr = jsonEncode(profile.toJson());
    await _prefs!.setString(_keyProfile, jsonStr);
  }

  static UserProfile? getProfile() {
    final str = _prefs?.getString(_keyProfile);
    if (str == null || str.isEmpty) return null;
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearProfile() async {
    await init();
    await _prefs!.remove(_keyProfile);
  }

  // Language / Locale
  static Future<void> saveLocale(String locale) async {
    await init();
    await _prefs!.setString(_keyLocale, locale);
    await setLanguageSelected(true);
  }

  static String getLocale() {
    return _prefs?.getString(_keyLocale) ?? 'mr'; // Default Marathi
  }

  // Clear all for logout
  static Future<void> clearAll() async {
    await init();
    await _prefs!.remove(_keyToken);
    await _prefs!.remove(_keyProfile);
  }
}
