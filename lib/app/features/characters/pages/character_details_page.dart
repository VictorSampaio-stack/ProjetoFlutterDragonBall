import 'package:dragon_ball_app/app/controllers/character_controller.dart';
import 'package:dragon_ball_app/app/features/characters/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterDetailsPage extends StatefulWidget {
  final CharacterModel character;

  const CharacterDetailsPage({super.key, required this.character});

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  int currentPage = 0;
  late Future<CharacterModel> _futureCharacter;

  @override
  void initState() {
    super.initState();

    _futureCharacter = context.read<CharacterController>().fetchCharacterById(
      widget.character.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CharacterModel>(
      future: _futureCharacter,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Erro ao carregar personagem')),
          );
        }

        final character = snapshot.data!;

        /// 🔥 KI DINÂMICO
        final String displayedKi = currentPage == 0
            ? character.ki
            : character.transformations[currentPage - 1].ki;

        return Scaffold(
          appBar: AppBar(
            title: Text(character.name),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 22, 0, 133),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 IMAGEM / TRANSFORMAÇÕES
                  _buildCharacterImage(character),

                  const SizedBox(height: 24),

                  /// 🔥 CARD DE INFORMAÇÕES
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFFF9800),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informações',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _infoRow('Raça', character.race),
                          _infoRow('Gênero', character.gender),
                          _infoRow('Afiliação', character.affiliation),
                          _infoRow('Ki', displayedKi), // 🔥 AQUI
                          _infoRow('Ki Máximo', character.maxKi),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔥 AGORA DENTRO DO STATE
  Widget _buildCharacterImage(CharacterModel character) {
    final hasTransformations = character.transformations.isNotEmpty;

    return SizedBox(
      height: 260,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        itemCount: hasTransformations
            ? character.transformations.length + 1
            : 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: Hero(
                tag: character.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 220,
                    color: const Color(0xFFF2F2F2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.network(
                            character.image,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          character.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          final transformation = character.transformations[index - 1];

          return Center(
            child: Hero(
              tag: '${character.id}-${transformation.name}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 220,
                  color: const Color(0xFFF2F2F2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.network(
                          transformation.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transformation.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 🔥 FUNÇÃO AUXILIAR (inalterada)
Widget _infoRow(String label, String? value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
        ),
        Expanded(child: Text(value?.isNotEmpty == true ? value! : '-')),
      ],
    ),
  );
}
