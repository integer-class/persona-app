import '../models/history_model.dart' as history_model;
import '../datasource/local/history_local_datasource.dart';
import '../datasource/remote/history_remote_datasource.dart';

class HistoryRepository {
  final HistoryLocalDatasource localDatasource;
  final HistoryRemoteDatasource remoteDatasource;

  HistoryRepository(this.localDatasource, this.remoteDatasource);

  // Get history from remote and cache locally
  Future<List<history_model.History>> getHistory() async {
    try {
      final histories = await remoteDatasource.getHistory();
      await localDatasource.saveHistory(histories);
      return histories;
    } catch (e) {
      // Fallback to local cache if remote fails
      print('Error fetching remote history: $e');
      return await localDatasource.getHistory();
    }
  }

  // Clear history from local storage
  Future<void> clearHistory() async {
    await localDatasource.clearHistory();
  }

  // Update note for a history item
  Future<void> updateHistoryNote(int historyId, String note) async {
    await remoteDatasource.saveHistoryNote(historyId, note);
    await localDatasource.updateHistoryNote(historyId, note);
  }
}
