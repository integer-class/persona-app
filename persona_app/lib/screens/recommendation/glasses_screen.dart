import 'package:flutter/material.dart';
import '../../data/models/prediction_model.dart';
import 'package:go_router/go_router.dart';
import 'recommendation_screen.dart';

class GlassesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>;

    return RecommendationScreen(
      recommendations: args['recommendations'] ?? [],
      otherOptions: args['otherOptions'] ?? [],
      title: args['title'] ?? 'Glasses',
      gender: args['gender'] ?? '',
      prediction: args['prediction'],
      imageFile: args['imageFile'],
    );
  }
}
