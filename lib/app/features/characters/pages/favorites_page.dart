import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/favorites_controller.dart';
import '../widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = context.watch<FavoritesController>();
    final favorites = favoritesController.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favorites.isEmpty
          ? const Center(child: Text('Nenhum personagem favoritado'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final character = favorites[index];
                return CharacterCard(character: character);
              },
            ),
    );
  }
}
