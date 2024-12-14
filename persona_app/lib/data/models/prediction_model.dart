class Prediction {
  String status;
  Data data;

  Prediction({
    required this.status,
    required this.data,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        status: json["status"] ?? '',
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int predictionId;
  String imageUrl;
  String faceShape;
  List<int> recommendationsId;
  Tions recommendations;
  Tions otherOptions;

  Data({
    required this.predictionId,
    required this.imageUrl,
    required this.faceShape,
    required this.recommendationsId,
    required this.recommendations,
    required this.otherOptions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        predictionId: json["prediction_id"] ?? 0,
        imageUrl: json["image_url"] ?? '',
        faceShape: json["face_shape"] ?? '',
        recommendationsId: List<int>.from(json["recommendations_id"]?.map((x) => x) ?? []),
        recommendations: Tions.fromJson(json["recommendations"] ?? {}),
        otherOptions: Tions.fromJson(json["other_options"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "prediction_id": predictionId,
        "image_url": imageUrl,
        "face_shape": faceShape,
        "recommendations_id": List<dynamic>.from(recommendationsId.map((x) => x)),
        "recommendations": recommendations.toJson(),
        "other_options": otherOptions.toJson(),
      };
}

class Tions {
  List<Accessory> hairStyles;
  List<Accessory> accessories;

  Tions({
    required this.hairStyles,
    required this.accessories,
  });

  factory Tions.fromJson(Map<String, dynamic> json) => Tions(
        hairStyles: List<Accessory>.from(json["hair_styles"]?.map((x) => Accessory.fromJson(x)) ?? []),
        accessories: List<Accessory>.from(json["accessories"]?.map((x) => Accessory.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "hair_styles": List<dynamic>.from(hairStyles.map((x) => x.toJson())),
        "accessories": List<dynamic>.from(accessories.map((x) => x.toJson())),
      };
}

class Accessory {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String image;
  String description;
  Category? category;
  Gender? gender;

  Accessory({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.image,
    required this.description,
    this.category,
    this.gender,
  });

  factory Accessory.fromJson(Map<String, dynamic> json) => Accessory(
        id: json["id"] ?? 0,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        description: json["description"] ?? '',
        category: categoryValues.map[json["category"]],
        gender: genderValues.map[json["gender"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "image": image,
        "description": description,
        "category": categoryValues.reverse[category],
        "gender": genderValues.reverse[gender],
      };
}

enum Category { EARRINGS, GLASSES }

final categoryValues = EnumValues({
  "earrings": Category.EARRINGS,
  "glasses": Category.GLASSES,
});

enum Gender { FEMALE }

final genderValues = EnumValues({
  "female": Gender.FEMALE,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}