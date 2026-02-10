import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStorage {
  static const _key = 'favorite_characters';

  /// Retorna a lista de IDs salvos
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Salva a lista de IDs
  Future<void> saveFavorites(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids);
  }
}
