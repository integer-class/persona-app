class Hairstyle {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String name;
    String image;
    String description;
    Gender gender;

    Hairstyle({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.name,
        required this.image,
        required this.description,
        required this.gender,
    });

    factory Hairstyle.fromJson(Map<String, dynamic> json) => Hairstyle(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        image: json["image"],
        description: json["description"],
        gender: genderValues.map[json["gender"]]!,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "image": image,
        "description": description,
        "gender": genderValues.reverse[gender],
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