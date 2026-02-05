import 'package:dragon_ball_app/app/controllers/character_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Chama a API assim que a tela abre
    Future.microtask(() {
      context.read<CharacterController>().fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CharacterController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dragon Ball')),
      body: Builder(
        builder: (_) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.characters.isEmpty) {
            return const Center(child: Text('Nenhum personagem encontrado'));
          }

          return ListView.builder(
            itemCount: controller.characters.length,
            itemBuilder: (context, index) {
              final character = controller.characters[index];

              return ListTile(title: Text(character.name));
            },
          );
        },
      ),
    );
  }
}
