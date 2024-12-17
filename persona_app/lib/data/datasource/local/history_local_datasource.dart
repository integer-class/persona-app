import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/history_model.dart' as history_model;

class HistoryLocalDatasource {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _historyKey = 'user_history';

  Future<void> saveHistory(List<history_model.History> history) async {
    try {
      final String historyJson = jsonEncode(
        history.map((h) => h.toJson()).toList(),
      );
      await _secureStorage.write(key: _historyKey, value: historyJson);
    } catch (e) {
      print('Error saving history locally: $e');
      rethrow;
    }
  }

  Future<List<history_model.History>> getHistory() async {
    try {
      final String? historyJson = await _secureStorage.read(key: _historyKey);
      if (historyJson != null) {
        final List<dynamic> historyList = jsonDecode(historyJson);
        return historyList
            .map((json) => history_model.History.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting history from local storage: $e');
      return [];
    }
  }

  Future<void> clearHistory() async {
    try {
      await _secureStorage.delete(key: _historyKey);
    } catch (e) {
      print('Error clearing history from local storage: $e');
      rethrow;
    }
  }

  Future<void> updateHistoryNote(int historyId, String note) async {
    try {
      final histories = await getHistory();
      final index = histories.indexWhere((h) => h.id == historyId);
      if (index != -1) {
        // Update the note in local storage
        // Note: This requires adding note field to History model
        await saveHistory(histories);
      }
    } catch (e) {
      print('Error updating history note locally: $e');
      rethrow;
    }
  }
}