import 'package:provider/provider.dart';
import 'package:dragon_ball_app/app/controllers/favorites_controller.dart';
import 'package:dragon_ball_app/app/controllers/character_controller.dart';
import 'package:dragon_ball_app/app/features/characters/models/character_model.dart';
import 'package:dragon_ball_app/app/shared/translations/pt_br_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterDetailsPage extends StatefulWidget {
  final CharacterModel character;

  const CharacterDetailsPage({super.key, required this.character});

  // Removido: o estado de favorito deve ficar no State
  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  int currentPage = 0;
  late Future<CharacterModel> _futureCharacter;
  // Removido: favoritos agora via controller

  @override
  void initState() {
    super.initState();
    _futureCharacter = context.read<CharacterController>().fetchCharacterById(
      widget.character.id,
    );
  }

  String _getCurrentFavoriteId(CharacterModel character) {
    if (currentPage == 0) {
      return 'base_${character.id}';
    } else {
      return 'evo_${character.id}_${character.transformations[currentPage - 1].name}';
    }
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

        // Tradução para evoluções
        final String displayedKiPtBr = currentPage == 0
            ? character.kiPtBr
            : PtBrTranslations.translateNumberPtBr(
                character.transformations[currentPage - 1].ki,
              );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              character.name,
              style: const TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 22, 0, 133),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 IMAGEM / TRANSFORMAÇÕES
                  _buildCharacterImage(character),
                  const SizedBox(height: 12),
                  Center(
                    child: Consumer<FavoritesController>(
                      builder: (context, favoritesController, _) {
                        final isFavorite = currentPage == 0
                            ? favoritesController.isFavorite(
                                character,
                                onlyBase: true,
                              )
                            : favoritesController.isFavorite(
                                CharacterModel(
                                  id: character.id,
                                  name: character
                                      .transformations[currentPage - 1]
                                      .name,
                                  image: character
                                      .transformations[currentPage - 1]
                                      .image,
                                  race: character.race,
                                  gender: character.gender,
                                  affiliation: character.affiliation,
                                  ki: character
                                      .transformations[currentPage - 1]
                                      .ki,
                                  maxKi: character.maxKi,
                                  description: character.description,
                                  transformations: [],
                                ),
                              );
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFavorite
                                ? Colors.redAccent
                                : Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white,
                            size: 28,
                          ),
                          label: Text(
                            isFavorite ? 'Desfavoritar' : 'Favoritar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            if (currentPage == 0) {
                              favoritesController.toggleFavorite(
                                character,
                                onlyBase: true,
                              );
                            } else {
                              final evo =
                                  character.transformations[currentPage - 1];
                              final evoCharacter = CharacterModel(
                                id: character.id,
                                name: evo.name,
                                image: evo.image,
                                race: character.race,
                                gender: character.gender,
                                affiliation: character.affiliation,
                                ki: evo.ki,
                                maxKi: character.maxKi,
                                description: character.description,
                                transformations: [],
                              );
                              favoritesController.toggleFavorite(evoCharacter);
                            }
                          },
                        );
                      },
                    ),
                  ),
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
                          _infoRow('Raça', character.racePtBr),
                          _infoRow('Gênero', character.genderPtBr),
                          _infoRow('Afiliação', character.affiliationPtBr),
                          _infoRow('Ki', displayedKiPtBr),
                          _infoRow('Ki Máximo', character.maxKiPtBr),
                          const SizedBox(height: 8),
                          // Descrição com limite de 10 linhas e botão para expandir
                          _buildDescription(character.description),
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
                child: Container(
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      width: 3,
                    ),
                    color: const Color(0xFFF2F2F2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
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
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    width: 3,
                  ),
                  color: const Color(0xFFF2F2F2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
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

  // Estado para controlar exibição da descrição
  bool _showFullDescription = false;

  bool _isDescriptionLong(String description) {
    final lineCount = description.split('\n').length;
    // Reduz limite de caracteres para 300 para garantir botão em textos longos
    return lineCount > 7 || description.length > 300;
  }

  Widget _buildDescription(String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              'Descrição:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final span = TextSpan(
                  text: description.isNotEmpty ? description : '-',
                  style: DefaultTextStyle.of(context).style,
                );
                final tp = TextPainter(
                  text: span,
                  maxLines: _showFullDescription ? null : 7,
                  textDirection: TextDirection.ltr,
                )..layout(maxWidth: constraints.maxWidth);
                final isOverflowing = tp.didExceedMaxLines;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description.isNotEmpty ? description : '-',
                      maxLines: _showFullDescription ? null : 7,
                      overflow: _showFullDescription
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    if (isOverflowing || _showFullDescription)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showFullDescription = !_showFullDescription;
                          });
                        },
                        child: Text(
                          _showFullDescription ? 'Exibir menos' : 'Exibir mais',
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
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
