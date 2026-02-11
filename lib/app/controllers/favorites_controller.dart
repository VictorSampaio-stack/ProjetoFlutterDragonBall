import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/characters/models/character_model.dart';

class FavoritesController extends ChangeNotifier {
  static const _storageKey = 'favorite_characters';

  final List<CharacterModel> _favorites = [];
  // Favoritos salvos por chave composta: id+nome
  String _favoriteKey(CharacterModel character) => '${character.id}_${character.name}';

  List<CharacterModel> get favorites => _favorites;

  /// Verifica se o personagem base é favorito
  bool isFavorite(CharacterModel character, {bool onlyBase = false}) {
    if (onlyBase) {
      return _favorites.any((item) => item.id == character.id && item.name == character.name);
    }
    return _favorites.any((item) => _favoriteKey(item) == _favoriteKey(character));
  }

  /// Alterna favorito (add/remove)
  Future<void> toggleFavorite(CharacterModel character, {bool onlyBase = false}) async {
    if (isFavorite(character, onlyBase: onlyBase)) {
      _favorites.removeWhere((item) => onlyBase
        ? item.id == character.id && item.name == character.name
        : _favoriteKey(item) == _favoriteKey(character));
    } else {
      _favorites.add(character);
    }
    await _saveFavorites();
    notifyListeners();
  }

  /// Carrega favoritos salvos (recebe lista da API)
  Future<void> loadFavorites(List<CharacterModel> allCharacters) async {
    final prefs = await SharedPreferences.getInstance();
    final savedKeys = prefs.getStringList(_storageKey) ?? [];
    _favorites
      ..clear()
      ..addAll(
        allCharacters.where(
          (character) => savedKeys.contains(_favoriteKey(character)),
        ),
      );
    notifyListeners();
  }

  /// Salva apenas as chaves dos favoritos
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = _favorites.map(_favoriteKey).toList();
    await prefs.setStringList(_storageKey, keys);
  }
}
