import '../datasource/local/prediction_local_datasource.dart';
import '../datasource/remote/prediction_remote_datasource.dart';
import '../models/prediction_model.dart';

class PredictionRepository {
  final PredictionLocalDataSource localDataSource;
  final PredictionRemoteDataSource remoteDataSource;

  PredictionRepository(this.localDataSource, this.remoteDataSource);

  Future<Prediction> predict(String imagePath, String gender) async {
    final prediction = await remoteDataSource.predict(imagePath, gender);
    await localDataSource.savePrediction(prediction);
    return prediction;
  }

  Future<List<Prediction>> getPredictionHistory() async {
    return await localDataSource.getPredictions();
  }

  Future<Prediction?> getLatestPrediction() async {
    return await localDataSource.getLatestPrediction();
  }

  // Helper method to get recommendations
  Future<Tions?> getLatestRecommendations() async {
    final prediction = await getLatestPrediction();
    return prediction?.data.recommendations;
  }

  // Helper method to get other options
  Future<Tions?> getLatestOtherOptions() async {
    final prediction = await getLatestPrediction();
    return prediction?.data.otherOptions;
  }
}