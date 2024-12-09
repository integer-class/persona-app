class History {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String image;
    int recommendation;
    int user;

    History({
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.image,
        required this.recommendation,
        required this.user,
    });

    factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        recommendation: json["recommendation"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "recommendation": recommendation,
        "user": user,
    };
}