import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/prediction_model.dart';

class PredictionLocalDataSource {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> savePrediction(Prediction prediction) async {
    try {
      await _secureStorage.write(
        key: 'latest_prediction',
        value: jsonEncode(prediction.toJson()),
      );

      // Save to history
      final predictions = await getPredictions();
      predictions.add(prediction);
      await _secureStorage.write(
        key: 'predictions_history',
        value: jsonEncode(predictions.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      print('Error saving prediction: $e');
      rethrow;
    }
  }

  Future<List<Prediction>> getPredictions() async {
    try {
      final predictionsJson = await _secureStorage.read(key: 'predictions_history');
      if (predictionsJson != null) {
        final List<dynamic> predictionsList = jsonDecode(predictionsJson);
        return predictionsList.map((e) => Prediction.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting predictions: $e');
      return [];
    }
  }

  Future<Prediction?> getLatestPrediction() async {
    try {
      final predictionJson = await _secureStorage.read(key: 'latest_prediction');
      if (predictionJson != null) {
        return Prediction.fromJson(jsonDecode(predictionJson));
      }
      return null;
    } catch (e) {
      print('Error getting latest prediction: $e');
      return null;
    }
  }
}