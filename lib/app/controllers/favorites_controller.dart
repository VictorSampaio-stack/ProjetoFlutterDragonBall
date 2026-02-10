import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/characters/models/character_model.dart';

class FavoritesController extends ChangeNotifier {
  static const _storageKey = 'favorite_characters';

  final List<CharacterModel> _favorites = [];

  List<CharacterModel> get favorites => _favorites;

  /// Verifica se o personagem é favorito
  bool isFavorite(CharacterModel character) {
    return _favorites.any((item) => item.id == character.id);
  }

  /// Alterna favorito (add/remove)
  Future<void> toggleFavorite(CharacterModel character) async {
    if (isFavorite(character)) {
      _favorites.removeWhere((item) => item.id == character.id);
    } else {
      _favorites.add(character);
    }

    await _saveFavorites();
    notifyListeners();
  }

  /// Carrega favoritos salvos (recebe lista da API)
  Future<void> loadFavorites(List<CharacterModel> allCharacters) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_storageKey) ?? [];

    _favorites
      ..clear()
      ..addAll(
        allCharacters.where(
          (character) => savedIds.contains(character.id.toString()),
        ),
      );

    notifyListeners();
  }

  /// Salva apenas os IDs dos favoritos
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final ids = _favorites.map((e) => e.id.toString()).toList();

    await prefs.setStringList(_storageKey, ids);
  }
}
