import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/history_model.dart' as history_model;
import '../../datasource/local/auth_local_datasource.dart';
import '../../../constant/variables.dart';

class HistoryRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();

  Future<List<history_model.History>> getHistory() async {
    try {
      final authData = await _authLocalDatasource.getAuthData();
      if (authData == null || authData.data?.token == null) {
        throw Exception('No authentication token found');
      }
      final response = await http.get(
        Uri.parse('$baseUrl/history/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${authData.data!.token}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((json) => history_model.History.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to fetch history: ${response.body}');
      }
    } catch (e) {
      print('Error fetching history: $e');
      rethrow;
    }
  }

  Future<void> saveHistoryNote(int historyId, String note) async {
  try {
    final authData = await _authLocalDatasource.getAuthData();
    if (authData == null || authData.data?.token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/history/$historyId/note/'), // Added trailing slash
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${authData.data!.token}',
      },
      body: jsonEncode({'note': note}),
    );

    print('Response status: ${response.statusCode}'); // Debug response
    print('Response body: ${response.body}'); // Debug response body

    if (response.statusCode != 200) {
      throw Exception('Failed to save note: ${response.body}');
    }
  } catch (e) {
    print('Detailed error in saveHistoryNote: $e');
    throw Exception('Failed to save note: $e');
  }
}
}
