import 'package:dragon_ball_app/app/features/characters/models/character_model.dart';
import 'package:dragon_ball_app/app/features/characters/services/dragonball_character_service.dart';
import 'package:flutter/material.dart';
import 'favorites_controller.dart';

class CharacterController extends ChangeNotifier {
  final FavoritesController favoritesController;

  CharacterController(this.favoritesController);

  bool isLoading = false;
  String? errorMessage;
  List<CharacterModel> characters = [];
  final CharacterService service = CharacterService();

  Future<void> fetchCharacters() async {
    isLoading = true;
    notifyListeners();

    try {
      characters = await service.getCharacters();
      errorMessage = null;

      // 🔥 REIDRATA FAVORITOS AQUI
      await favoritesController.loadFavorites(characters);
    } catch (e) {
      errorMessage = 'Erro ao buscar personagens';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<CharacterModel> fetchCharacterById(int id) async {
    try {
      return await service.fetchCharacterById(id);
    } catch (e) {
      throw Exception('Erro ao buscar personagem por id');
    }
  }
}
