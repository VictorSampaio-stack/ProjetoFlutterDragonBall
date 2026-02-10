import 'transformation_model.dart';

class CharacterModel {
  final int id;
  final String name;
  final String ki;
  final String maxKi;
  final String race;
  final String gender;
  final String description;
  final String image;
  final String affiliation;
  final List<TransformationModel> transformations;

  CharacterModel({
    required this.id,
    required this.name,
    required this.ki,
    required this.maxKi,
    required this.race,
    required this.gender,
    required this.description,
    required this.image,
    required this.affiliation,
    required this.transformations,
  });

  factory CharacterModel.fromMap(Map<String, dynamic> map) {
    return CharacterModel(
      id: map['id'],
      name: map['name'],
      ki: map['ki'],
      maxKi: map['maxKi'],
      race: map['race'],
      gender: map['gender'],
      description: map['description'],
      image: map['image'],
      affiliation: map['affiliation'],
      transformations:
          (map['transformations'] as List<dynamic>?)
              ?.map((e) => TransformationModel.fromMap(e))
              .toList() ??
          [],
    );
  }
}
