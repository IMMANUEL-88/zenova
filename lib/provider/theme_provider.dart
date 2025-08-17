import 'package:flutter/material.dart';
import 'package:zenova/utils/local_storage/hive_storage_helper.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoading = true;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  Future<void> _loadTheme() async {
    try {
      final isDarkMode = HiveStorageHelper.getThemeMode();
      _themeMode = isDarkMode == null 
          ? ThemeMode.system 
          : (isDarkMode ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      // Fallback to system theme if there's an error
      _themeMode = ThemeMode.system;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      await HiveStorageHelper.setThemeMode(isDark);
    } catch (e) {
      // Revert changes if storage fails
      _themeMode = ThemeMode.system;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // Optional: Add method to toggle between all three theme modes
  Future<void> cycleTheme() async {
    try {
      _themeMode = ThemeMode.values[(_themeMode.index + 1) % ThemeMode.values.length];
      if (_themeMode != ThemeMode.system) {
        await HiveStorageHelper.setThemeMode(_themeMode == ThemeMode.dark);
      } else {
        await HiveStorageHelper.clearThemeMode();
      }
    } catch (e) {
      // Revert changes if storage fails
      _themeMode = ThemeMode.system;
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}