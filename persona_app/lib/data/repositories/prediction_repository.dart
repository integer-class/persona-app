import '../datasource/local/prediction_local_datasource.dart';
import '../models/prediction_model.dart';

class PredictionRepository {
  final PredictionLocalDataSource predictionLocalDataSource;

  PredictionRepository(this.predictionLocalDataSource);

  Future<void> savePrediction(PredictionModel prediction) async {
    await predictionLocalDataSource.savePrediction(prediction);
  }

  Future<List<PredictionModel>> getPredictions() async {
    return await predictionLocalDataSource.getPredictions();
  }
}