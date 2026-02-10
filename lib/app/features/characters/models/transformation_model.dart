class TransformationModel {
  final int id;
  final String name;
  final String image;
  final String ki;

  TransformationModel({
    required this.id,
    required this.name,
    required this.image,
    required this.ki,
  });

  factory TransformationModel.fromMap(Map<String, dynamic> map) {
    return TransformationModel(
      id: (map['id'] as num).toInt(),
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      ki: map['ki']?.toString() ?? '',
    );
  }
}
