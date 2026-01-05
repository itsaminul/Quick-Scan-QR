import 'package:shared_preferences/shared_preferences.dart';

class HistoryStorage {
  static const String _key = "scan_history";

  // Save new scan
  static Future<void> saveScan(String data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];
    history.insert(0, data); // latest first
    await prefs.setStringList(_key, history);
  }

  // Get all scans
  static Future<List<String>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Delete one item
  static Future<void> deleteItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_key) ?? [];
    history.removeAt(index);
    await prefs.setStringList(_key, history);
  }

  // Clear all
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
