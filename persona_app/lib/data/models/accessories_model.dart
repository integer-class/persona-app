class Accesories {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String name;
    String image;
    String description;
    Category category;

    Accesories({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.name,
        required this.image,
        required this.description,
        required this.category,
    });

    factory Accesories.fromJson(Map<String, dynamic> json) => Accesories(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        image: json["image"],
        description: json["description"],
        category: categoryValues.map[json["category"]]!,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "image": image,
        "description": description,
        "category": categoryValues.reverse[category],
    };
}

enum Category {
    EARRINGS,
    GLASSES
}

final categoryValues = EnumValues({
    "earrings": Category.EARRINGS,
    "glasses": Category.GLASSES
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
