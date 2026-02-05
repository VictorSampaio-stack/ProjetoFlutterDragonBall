import 'package:dragon_ball_app/app/features/characters/models/character_model.dart';
import 'package:dragon_ball_app/app/features/characters/services/dragonball_character_service.dart';
import 'package:flutter/material.dart';

class CharacterController extends ChangeNotifier {
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
    } catch (e) {
      errorMessage = 'Erro ao buscar personagens';
    }

    isLoading = false;
    notifyListeners();
  }
}
