import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zenova/pages/analytics/analytics_model.dart';

class HiveStorageHelper {
  static const String _userBox = 'userBox';
  static const String _userEmailKey = 'userEmail';
  static const String _userNameKey = 'userName';
  static const String _userIdKey = 'userId';
  static const String _loggedInKey = 'loggedIn';
  static const String _analyticsDataKey = 'analyticsData';
  static const String _themeModeKey = 'isDarkMode';

  static late final Box _box;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(AnalyticsDataAdapter());
    Hive.registerAdapter(DailyAnalyticsAdapter());

    _box = await Hive.openBox(_userBox);
  }

  /// Saves the user's theme preference (true for dark, false for light).
  static Future<void> setThemeMode(bool isDark) async {
    await _box.put(_themeModeKey, isDark);
  }

  /// Retrieves the user's theme preference.
  /// Returns null if no preference has been set yet.
  static bool? getThemeMode() {
    return _box.get(_themeModeKey);
  }

  // Analytics data methods
  static Future<void> saveAnalyticsData(AnalyticsData data) async {
    await _box.put(_analyticsDataKey, data);
    debugPrint('Analytics data saved for user: ${data.userId}');
  }

  static AnalyticsData? getAnalyticsData() {
    return _box.get(_analyticsDataKey);
  }

  static Future<void> clearAnalyticsData() async {
    await _box.delete(_analyticsDataKey);
  }

  static Future<void> setUserEmail(String email) async {
    await _box.put(_userEmailKey, email);
    debugPrint('Email saved: $email');
  }

  static String? getUserEmail() {
    return _box.get(_userEmailKey);
  }

  static Future<void> setUserName(String name) async {
    await _box.put(_userNameKey, name);
  }

  static String? getUserName() {
    return _box.get(_userNameKey);
  }

  static Future<void> setUserId(String userId) async {
    await _box.put(_userIdKey, userId);
  }

  static String? getUserId() {
    return _box.get(_userIdKey);
  }

  static Future<void> setLoggedIn(bool loggedIn) async {
    await _box.put(_loggedInKey, loggedIn);
  }

  static bool isLoggedIn() {
    return _box.get(_loggedInKey, defaultValue: false);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }

  /// Clears the saved theme preference, reverting to system default
  static Future<void> clearThemeMode() async {
    await _box.delete(_themeModeKey);
  }
}
