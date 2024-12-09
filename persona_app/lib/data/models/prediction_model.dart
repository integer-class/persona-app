class Prediction {
  String status;
  Data data;

  Prediction({
    required this.status,
    required this.data,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  String imageUrl;
  String faceShape;
  Tions recommendations;
  Tions otherOptions;

  Data({
    required this.imageUrl,
    required this.faceShape,
    required this.recommendations,
    required this.otherOptions,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    try {
      return Data(
        imageUrl: json["image_url"] ?? '',
        faceShape: json["face_shape"] ?? '',
        recommendations: Tions.fromJson(json["recommendations"] ?? {"hair_styles": [], "accessories": []}),
        otherOptions: Tions.fromJson(json["other_options"] ?? {"hair_styles": [], "accessories": []}),
      );
    } catch (e) {
      print('Error parsing Data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "face_shape": faceShape,
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
        hairStyles: List<Accessory>.from(
            json["hair_styles"].map((x) => Accessory.fromJson(x))),
        accessories: List<Accessory>.from(
            json["accessories"].map((x) => Accessory.fromJson(x))),
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
        createdAt: DateTime.parse(
            json["created_at"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updated_at"] ?? DateTime.now().toIso8601String()),
        name: json["name"] ?? '',
        image: json["image"] ?? '',
        description: json["description"] ?? '',
        category: json["category"] != null
            ? categoryValues.map[json["category"]]
            : null,
        gender:
            json["gender"] != null ? genderValues.map[json["gender"]] : null,
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

final categoryValues =
    EnumValues({"earrings": Category.EARRINGS, "glasses": Category.GLASSES});

enum Gender { FEMALE }

final genderValues = EnumValues({"female": Gender.FEMALE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
