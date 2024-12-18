import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constant/variables.dart';
import '../../models/feedback_model.dart';
import '../local/auth_local_datasource.dart';

class FeedbackRemoteDataSource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();

  Future<void> submitFeedback(FeedbackModel feedback) async {
    try {
      final authData = await _authLocalDatasource.getAuthData();
      if (authData == null || authData.data?.token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/feedback/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${authData.data!.token}',
        },
        body: jsonEncode(feedback.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to submit feedback: ${response.body}');
      }
    } catch (e) {
      print('Error submitting feedback: $e');
      rethrow;
    }
  }
}