import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/prediction_model.dart';
import '../../../constant/variables.dart';

class PredictionRemoteDataSource {
  Future<Prediction> predict(String imagePath, String gender) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/predict/'));
      
      final imageFile = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(imageFile);
      request.fields['gender'] = gender;
      request.headers['Accept'] = 'application/json';

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
          final prediction = Prediction.fromJson(responseData);
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
        throw Exception('Server returned ${response.statusCode}: $responseString');
      }
    } catch (e) {
      print('Prediction error: $e');
      rethrow;
    }
  }

  Future<void> deleteImage(int imageId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete-image/'),
        headers: {'Content-Type': 'application/json'},
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
}