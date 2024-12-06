import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/prediction_model.dart';

class PredictionLocalDataSource {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> savePrediction(PredictionModel prediction) async {
    final predictions = await getPredictions();
    predictions.add(prediction);
    await _secureStorage.write(
      key: 'predictions',
      value: jsonEncode(predictions.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<PredictionModel>> getPredictions() async {
    final predictionsJson = await _secureStorage.read(key: 'predictions');
    if (predictionsJson != null) {
      final List<dynamic> predictionsList = jsonDecode(predictionsJson);
      return predictionsList.map((e) => PredictionModel.fromJson(e)).toList();
    }
    return [];
  }
}