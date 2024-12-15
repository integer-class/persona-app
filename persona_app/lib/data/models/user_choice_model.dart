class UserSelection {
  int predictionId;
  int recommendationId;
  int selectedHairStyleId;
  List<int> selectedAccessoriesIds;

  UserSelection({
    required this.predictionId,
    required this.recommendationId,
    required this.selectedHairStyleId,
    required this.selectedAccessoriesIds,
  });

  factory UserSelection.fromJson(Map<String, dynamic> json) => UserSelection(
        predictionId: json["prediction_id"],
        recommendationId: json["recommendation_id"],
        selectedHairStyleId: json["selected_hair_style_id"],
        selectedAccessoriesIds:
            List<int>.from(json["selected_accessories_ids"]),
      );

  Map<String, dynamic> toJson() => {
        "prediction_id": predictionId,
        "recommendation_id": recommendationId,
        "selected_hair_style_id": selectedHairStyleId,
        "selected_accessories_ids": selectedAccessoriesIds,
      };
}
