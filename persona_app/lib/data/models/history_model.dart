class History {
  int id;
  Prediction prediction;
  UserSelection userSelection;
  DateTime createdAt;
  DateTime updatedAt;
  int user;
  String? note;

  History({
    required this.id,
    required this.prediction,
    required this.userSelection,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.note,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json["id"],
        prediction: Prediction.fromJson(json["prediction"]),
        userSelection: UserSelection.fromJson(json["user_selection"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prediction": prediction.toJson(),
        "user_selection": userSelection.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user,
        "note": note,
      };
}

class Prediction {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  dynamic user;
  int faceShape;

  Prediction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.user,
    required this.faceShape,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        user: json["user"],
        faceShape: json["face_shape"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "user": user,
        "face_shape": faceShape,
      };
}

class UserSelection {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  int user;
  int recommendation;
  int selectedHairStyle;
  List<int> selectedAccessories;

  UserSelection({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.recommendation,
    required this.selectedHairStyle,
    required this.selectedAccessories,
  });

  factory UserSelection.fromJson(Map<String, dynamic> json) => UserSelection(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: json["user"],
        recommendation: json["recommendation"],
        selectedHairStyle: json["selected_hair_style"],
        selectedAccessories:
            List<int>.from(json["selected_accessories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user,
        "recommendation": recommendation,
        "selected_hair_style": selectedHairStyle,
        "selected_accessories":
            List<dynamic>.from(selectedAccessories.map((x) => x)),
      };
}
