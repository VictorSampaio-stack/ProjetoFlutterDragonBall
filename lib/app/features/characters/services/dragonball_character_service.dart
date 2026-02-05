import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class CharacterService {
  static const String _baseUrl = 'https://dragonball-api.com/api/characters';

  Future<List<CharacterModel>> getCharacters() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      final List items = decoded['items'];

      return items.map((item) => CharacterModel.fromMap(item)).toList();
    } else {
      throw Exception('Erro ao buscar personagens');
    }
  }
}
