class PredictionModel {
  final String imagePath;
  final String faceShape;
  final List<String> hairStyles;
  final List<String> accessories;

  PredictionModel({
    required this.imagePath,
    required this.faceShape,
    required this.hairStyles,
    required this.accessories,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      imagePath: json['imagePath'],
      faceShape: json['faceShape'],
      hairStyles: List<String>.from(json['hairStyles']),
      accessories: List<String>.from(json['accessories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'faceShape': faceShape,
      'hairStyles': hairStyles,
      'accessories': accessories,
    };
  }
}