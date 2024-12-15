import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/prediction_model.dart' as prediction_model;
import '../../../constant/variables.dart';
import '../../models/user_choice_model.dart';
import '../../datasource/local/auth_local_datasource.dart';
import '../../models/history_model.dart' as history_model;

class PredictionRemoteDataSource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();

  Future<prediction_model.Prediction> predict(
      String imagePath, String gender) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/predict/'));

      final imageFile = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(imageFile);
      request.fields['gender'] = gender;
      request.headers['Accept'] = 'application/json';

      // Add the token to the headers
      final authData = await _authLocalDatasource.getAuthData();
      if (authData != null && authData.data?.token != null) {
        request.headers['Authorization'] = 'Token ${authData.data!.token}';
      }

      print('Sending request to: ${request.url}');
      print('With gender: $gender');
      print('Image size: ${await File(imagePath).length()} bytes');

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseString');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseString);
        if (responseData == null) {
          throw Exception('Response data is null');
        }

        try {
          final prediction = prediction_model.Prediction.fromJson(responseData);
          // Validate critical fields
          if (prediction.data.faceShape.isEmpty) {
            throw Exception('No face shape detected in response');
          }
          return prediction;
        } catch (e) {
          print('Error parsing prediction: $e');
          throw Exception('Failed to parse prediction response: $e');
        }
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: $responseString');
      }
    } catch (e) {
      print('Prediction error: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(int imageId) async {
    try {
      final authData = await _authLocalDatasource.getAuthData();
      final response = await http.post(
        Uri.parse('$baseUrl/delete-image/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${authData?.data?.token}',
        },
        body: jsonEncode({'image_id': imageId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete image: ${response.body}');
      }
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }

  Future<void> saveUserSelection(UserSelection userSelection) async {
    try {
      final authData = await _authLocalDatasource.getAuthData();
      if (authData == null || authData.data?.token == null) {
        throw Exception('No authentication token found');
      }
      print('Using token: ${authData.data!.token}');
      final response = await http.post(
        Uri.parse('$baseUrl/save-record/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${authData.data!.token}',
        },
        body: jsonEncode(userSelection.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save user selection: ${response.body}');
      }
    } catch (e) {
      print('Error saving user selection: $e');
      rethrow;
    }
  }

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
}
