import 'package:flutter/material.dart';
import '../features/characters/models/character_model.dart';

class FavoritesController extends ChangeNotifier {
  final List<CharacterModel> _favorites = [];

  List<CharacterModel> get favorites => _favorites;

  bool isFavorite(CharacterModel character) {
    return _favorites.any((item) => item.id == character.id);
  }

  void toggleFavorite(CharacterModel character) {
    if (isFavorite(character)) {
      _favorites.removeWhere((item) => item.id == character.id);
    } else {
      _favorites.add(character);
    }

    notifyListeners();
  }
}
