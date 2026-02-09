import 'package:dragon_ball_app/app/controllers/character_controller.dart';
import 'package:dragon_ball_app/app/features/characters/widgets/character_card.dart';
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
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (_, __) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 18,
                                width: double.infinity,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 14,
                                width: 120,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(controller.errorMessage!, textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          if (controller.characters.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Nenhum personagem encontrado'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.characters.length,
            itemBuilder: (context, index) {
              final character = controller.characters[index];

              return AnimatedSlide(
                duration: const Duration(milliseconds: 400),
                offset: Offset(0, index == 0 ? 0 : 0.05),
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: 1,
                  child: CharacterCard(character: character),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
