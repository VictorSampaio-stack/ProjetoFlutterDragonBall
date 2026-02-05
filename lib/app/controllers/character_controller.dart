import 'package:dragon_ball_app/app/features/characters/models/character_model.dart';
import 'package:dragon_ball_app/app/features/characters/services/dragonball_character_service.dart';
import 'package:flutter/material.dart';

class CharacterController extends ChangeNotifier {
  final CharacterService _service = CharacterService();
  List<CharacterModel> _characters = [];
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> fetchCharacters() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _characters = await _service.getCharacters();
    } catch (e) {
      _errorMessage = 'Erro ao carregar personagens: $e';
    }
    _isLoading = false;
    notifyListeners();
  }
}
