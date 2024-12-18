class FeedbackModel {
  final int recommendationId;
  final String comment;
  final int rating;

  FeedbackModel({
    required this.recommendationId,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
    "recommendation": recommendationId,
    "comment": comment,
    "rating": rating,
  };
}