class Recommendation {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    Gender gender;
    int faceShape;
    List<int> hairStyles;
    List<int> accessories;

    Recommendation({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.gender,
        required this.faceShape,
        required this.hairStyles,
        required this.accessories,
    });

    factory Recommendation.fromJson(Map<String, dynamic> json) => Recommendation(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        gender: genderValues.map[json["gender"]]!,
        faceShape: json["face_shape"],
        hairStyles: List<int>.from(json["hair_styles"].map((x) => x)),
        accessories: List<int>.from(json["accessories"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "gender": genderValues.reverse[gender],
        "face_shape": faceShape,
        "hair_styles": List<dynamic>.from(hairStyles.map((x) => x)),
        "accessories": List<dynamic>.from(accessories.map((x) => x)),
    };
}

enum Gender {
    FEMALE,
    MALE
}

final genderValues = EnumValues({
    "female": Gender.FEMALE,
    "male": Gender.MALE
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