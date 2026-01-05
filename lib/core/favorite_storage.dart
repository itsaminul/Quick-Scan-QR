import 'package:shared_preferences/shared_preferences.dart';

class FavoriteStorage {
  static const _key = 'favorites';

  // Get all favorites
  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Add a favorite
  static Future<void> addFavorite(String item) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (!favorites.contains(item)) {
      favorites.add(item);
      await prefs.setStringList(_key, favorites);
    }
  }

  // Clear all favorites
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
