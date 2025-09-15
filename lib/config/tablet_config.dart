import 'package:shared_preferences/shared_preferences.dart';

class TabletConfig {
  static const String _tableNumberKey = 'tablet_table_number';
  static const String _isConfiguredKey = 'tablet_is_configured';
  static const String restaurantId = 'default_restaurant';

  static Future<int?> getTableNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_tableNumberKey);
  }

  static Future<void> setTableNumber(int tableNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tableNumberKey, tableNumber);
    await prefs.setBool(_isConfiguredKey, true);
  }

  static Future<bool> isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isConfiguredKey) ?? false;
  }

  static Future<void> clearConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tableNumberKey);
    await prefs.remove(_isConfiguredKey);
  }
}